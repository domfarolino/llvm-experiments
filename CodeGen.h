#include <map>
#include <stack>
#include <utility> // for std::pair.

#include "llvm/IR/Verifier.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Support/raw_os_ostream.h"

using namespace llvm;

enum AbstractType {
  Integer,
  Float,
  Bool,
  Char,
  String,
  Void,
};

static LLVMContext TheContext;
static IRBuilder<> Builder(TheContext);
static std::unique_ptr<Module> TheModule;

// These two are essentially mimicing our abstract symbol table.
static std::map<std::string, Value*> LocalVariables;
static std::map<std::string, Function*> FunctionTable;
static std::stack<BasicBlock*> BasicBlockStack;

static struct IfBlock {
  Value* condition;
  BasicBlock *ThenBB, *ElseBB, *MergeBB;
  IfBlock(Value* inCondition,
          BasicBlock* inThenBB,
          BasicBlock* inElseBB,
          BasicBlock* inMergeBB): condition(inCondition),
                                  ThenBB(inThenBB),
                                  ElseBB(inElseBB),
                                  MergeBB(inMergeBB) {}
  IfBlock() {}
} CurrentIfBlock;

class CodeGen {
private:
  // Disallow creating an instance of this class.
  CodeGen() {}

  static void DeclarePrintf() {
    // Set up printf argument(s).
    std::vector<Type*> arguments(1, Type::getInt8Ty(TheContext)->getPointerTo());
    FunctionType* printfFunctionType = FunctionType::get(Type::getInt32Ty(TheContext), arguments, true);
    Function* printfFunction = Function::Create(printfFunctionType, Function::ExternalLinkage, "printf", TheModule.get());
    FunctionTable["printf"] = printfFunction;
  }

  // Used as a helper.
  static Type* AbstractTypeToLLVMType(AbstractType abstractType) {
    if (abstractType == AbstractType::Integer)
      return Type::getInt32Ty(TheContext);
    else if (abstractType == AbstractType::Float)
      return Type::getDoubleTy(TheContext);
    else if (abstractType == AbstractType::Bool)
      return Type::getInt1Ty(TheContext);
    else if (abstractType == AbstractType::Char)
      return Type::getInt8Ty(TheContext);
    else if (abstractType == AbstractType::String)
      return Type::getInt8Ty(TheContext)->getPointerTo();
    else if (abstractType == AbstractType::Void)
      return Type::getVoidTy(TheContext);

    // Assert: This is never reached.
    return Type::getDoubleTy(TheContext);
  }

public:
  static void Setup() {
    TheModule = make_unique<Module>("Dom Sample", TheContext);
    DeclarePrintf();
  }

  static void PrintBitCode() {
    TheModule->print(errs(), nullptr);
  }

  static Value* ProduceFloat(double val) {
    return ConstantFP::get(TheContext, APFloat(val));
  }

  static Value* ProduceInteger(int val) {
    return ConstantInt::get(TheContext, APInt(/* nbits */ 32, /* value */ val, /* is signed */ true));
  }

  static Value* ProduceBool(bool val) {
    return Builder.CreateFCmpONE(ProduceFloat(val), ProduceFloat(0));
  }

  static Value* ProduceString(const std::string& str) {
    return Builder.CreateGlobalStringPtr(str);
  }

  // Arithmetic operators.
  static Value* AddFloats(Value* lhs, Value* rhs, const std::string& regName = "") {
    return Builder.CreateFAdd(lhs, rhs, regName);
  }
  static Value* AddIntegers(Value* lhs, Value* rhs, const std::string& regName = "") {
    return Builder.CreateAdd(lhs, rhs, regName);
  }
  static Value* SubtractFloats(Value* lhs, Value* rhs, const std::string& regName = "") {
    return Builder.CreateFSub(lhs, rhs, regName);
  }
  static Value* SubtractIntegers(Value* lhs, Value* rhs, const std::string& regName = "") {
    return Builder.CreateSub(lhs, rhs, regName);
  }
  static Value* MultiplyFloats(Value* lhs, Value* rhs, const std::string& regName = "") {
    return Builder.CreateFMul(lhs, rhs, regName);
  }
  static Value* MultiplyIntegers(Value* lhs, Value* rhs, const std::string& regName = "") {
    return Builder.CreateMul(lhs, rhs, regName);
  }
  static Value* DivideFloats(Value* lhs, Value* rhs, const std::string& regName = "") {
    return Builder.CreateFDiv(lhs, rhs, regName);
  }
  static Value* DivideIntegers(Value* lhs, Value* rhs, const std::string& regName = "") {
    return Builder.CreateSDiv(lhs, rhs, regName);
  }

  // Creates an LLVM Function* prototype, generates an IR declaration for it,
  // and adds it to the FunctionTable.
  static Function* CreateFunction(const std::string& name,
                           AbstractType abstractReturnType,
                           std::vector<std::pair<std::string, AbstractType>> arguments,
                           bool variadic = false) {
    // Create arguments prototype vector.
    std::vector<Type*> argumentTypes;
    for (auto argumentPair: arguments) {
      argumentTypes.push_back(AbstractTypeToLLVMType(argumentPair.second));
    }

    // Create function prototype.
    Type* returnType = AbstractTypeToLLVMType(abstractReturnType);

    // Make Function.
    FunctionType* functionType = FunctionType::get(returnType, argumentTypes, variadic);
    Function* function = Function::Create(functionType, Function::ExternalLinkage, name, TheModule.get());

    // Name arguments.
    int i = 0;
    for (auto& arg: function->args()) {
      arg.setName(arguments[i++].first);
    }

    // Add arguments to local variables.
    // Now that we're "inside" the function, we want to have access to the
    // function arguments via local variables.
    for (auto& arg: function->args()) {
      LocalVariables[arg.getName()] = &arg; // Values[argumentName] = Value*.
    }

    // Create BasicBlock to start inserting function body IR into; the BasicBlock
    // is inserted into the Function.
    BasicBlock* BB = BasicBlock::Create(TheContext, "entry", function);
    Builder.SetInsertPoint(BB); // New instructions should be inserted into the BasicBlock.

    FunctionTable[name] = function;
    BasicBlockStack.push(BB);
    return function;
  }

  static void ReturnFrom(const std::string& name, Value* returnValue = nullptr) {
    if (FunctionTable.find(name) == FunctionTable.end()) {
      std::cout << "The given function name " << name << " has not been declared" << std::endl;
      return;
    }

    Function* function = FunctionTable[name];
    // Assert !BasicBlockStack.empty().
    Builder.SetInsertPoint(BasicBlockStack.top());
    if (function->getReturnType() == Type::getVoidTy(TheContext))
      Builder.CreateRetVoid();
    else
      Builder.CreateRet(returnValue);

    verifyFunction(*function);

    BasicBlockStack.pop();
    BasicBlock* nextBlock = BasicBlockStack.empty() ? nullptr : BasicBlockStack.top();
    Builder.SetInsertPoint(nextBlock);
  }

  static void IfThen(Value* inCondition) {
    inCondition = ToBool(inCondition);
    Function* currentFunction = Builder.GetInsertBlock()->getParent();

    // Add |ThenBB| to |currentFunction| right now.
    BasicBlock *ThenBB = BasicBlock::Create(TheContext, "then", currentFunction),
               *ElseBB = BasicBlock::Create(TheContext, "else"),
               *MergeBB = BasicBlock::Create(TheContext, "ifmerge");
    CurrentIfBlock = IfBlock(inCondition, ThenBB, ElseBB, MergeBB);
    Builder.CreateCondBr(inCondition, ThenBB, ElseBB);

    // Start generating code into |ThenBB|.
    BasicBlockStack.pop();
    BasicBlockStack.push(ThenBB);
    Builder.SetInsertPoint(ThenBB);
  }

  static void Else() {
    // When we're ready to generate into |ElseBB|, we have to have |ThenBB|
    // branch to |MergeBB|, update our reference to |ThenBB|, push |ElseBB| to
    // the current function's list of BasicBlocks, and start generating into
    // |ElseBB|.
    Builder.CreateBr(CurrentIfBlock.MergeBB);

    // This is subtle but necessary, as 'Then' codegen can change the current
    // block.
    CurrentIfBlock.ThenBB = Builder.GetInsertBlock();

    // Push |ElseBB| to |currentFunction|'s list of BasicBlocks, and start
    // generating into |ElseBB|.
    Function* currentFunction = Builder.GetInsertBlock()->getParent();
    currentFunction->getBasicBlockList().push_back(CurrentIfBlock.ElseBB);
    BasicBlockStack.pop();
    BasicBlockStack.push(CurrentIfBlock.ElseBB);
    Builder.SetInsertPoint(CurrentIfBlock.ElseBB);
  }

  static void EndIf() {
    // See Else().
    Builder.CreateBr(CurrentIfBlock.MergeBB);
    CurrentIfBlock.ElseBB = Builder.GetInsertBlock();

    // Deal with |MergeBB|.
    Function* currentFunction = Builder.GetInsertBlock()->getParent();
    currentFunction->getBasicBlockList().push_back(CurrentIfBlock.MergeBB);
    BasicBlockStack.pop();
    BasicBlockStack.push(CurrentIfBlock.MergeBB);
    Builder.SetInsertPoint(CurrentIfBlock.MergeBB);

    // Create PHI node.
    PHINode *PHN = Builder.CreatePHI(Type::getDoubleTy(TheContext), 2, "ifphi");
    PHN->addIncoming(ProduceFloat(1), CurrentIfBlock.ThenBB);
    PHN->addIncoming(ProduceFloat(2), CurrentIfBlock.ElseBB);
  }

  static Value* CallFunction(const std::string& name, const std::vector<Value*>& args, const std::string& regName = "") {
    Function* function = FunctionTable[name];
    return Builder.CreateCall(function, args, regName);
  }

  static Value* ToBool(Value* input) {
    if (input->getType()->isDoubleTy())
      return CastFloatToBool(input);
    else if (static_cast<IntegerType*>(input->getType())->getBitWidth() == 32)
      return CastIntegerToBool(input);

    // Assert: getBitWidth == 1 (already a bool).
    return input;
  }

  static Value* CastFloatToInteger(Value* input) {
    // TODO(domfarolino): Maybe replace this with Builder.GetInsertBlock().
    BasicBlock* BB = BasicBlockStack.top();
    if (!BB) {
      std::cout << "BasicBlock not available for cast, something is wrong..." << std::endl;
      return nullptr;
    }

    return new FPToSIInst(input, Type::getInt32Ty(TheContext), "float-to-integer", BB);
  }

  static Value* CastIntegerToFloat(Value* input) {
    // TODO(domfarolino): Maybe replace this with Builder.GetInsertBlock().
    BasicBlock* BB = BasicBlockStack.top();
    if (!BB) {
      std::cout << "BasicBlock not available for cast, something is wrong..." << std::endl;
      return nullptr;
    }

    return new SIToFPInst(input, Type::getDoubleTy(TheContext), "integer-to-float", BB);
  }

  static Value* CastFloatToBool(Value* input) {
    BasicBlock* BB = BasicBlockStack.top();
    if (!BB) {
      std::cout << "BasicBlock not available for cast, something is wrong..." << std::endl;
      return nullptr;
    }

    return Builder.CreateFCmpONE(input, ProduceFloat(0.0), "float-to-bool");
  }

  static Value* CastIntegerToBool(Value* input) {
    BasicBlock* BB = BasicBlockStack.top();
    if (!BB) {
      std::cout << "BasicBlock not available for cast, something is wrong..." << std::endl;
      return nullptr;
    }

    return Builder.CreateFCmpONE(CastIntegerToFloat(input), ProduceFloat(0), "integer-to-bool");
  }

  // This is probably going to be replaced by a call to ScopeManager::{lookup, getSymbol}.
  static Value* GetVariable(const std::string& name) {
    if (LocalVariables.find(name) == LocalVariables.end()) {
      std::cout << "Could not find variable with name: " << name << std::endl;
      return nullptr;
    }

    return LocalVariables[name];
  }
};
