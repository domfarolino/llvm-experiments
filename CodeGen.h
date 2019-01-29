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

struct IfBlocks {
  Value* Condition;
  BasicBlock *ThenBB, *ElseBB, *MergeBB;
  IfBlocks(Value* inCondition,
           BasicBlock* inThenBB,
           BasicBlock* inElseBB,
           BasicBlock* inMergeBB): Condition(inCondition),
                                   ThenBB(inThenBB),
                                   ElseBB(inElseBB),
                                   MergeBB(inMergeBB) {}
};

struct ForLoopBlocks {
  BasicBlock *CondEvalBB, *LoopBB, *PostLoopBB;
  ForLoopBlocks(BasicBlock* inCondEvalBB,
                BasicBlock* inLoopBB,
                BasicBlock* inPostLoopBB): CondEvalBB(inCondEvalBB),
                                           LoopBB(inLoopBB),
                                           PostLoopBB(inPostLoopBB) {}
};

// These two are essentially mimicing our abstract symbol table.
static std::map<std::string, AllocaInst*> LocalVariables;
static std::map<std::string, Function*> FunctionTable;

// These are kind of ugly...
static std::stack<BasicBlock*> BasicBlockStack;
static std::stack<IfBlocks> IfBlocksStack;
static std::stack<ForLoopBlocks> ForLoopBlocksStack;

bool PendingReturn = false;
bool ErrorState = false;

class CodeGen {
private:
  // Disallow creating an instance of this class.
  CodeGen() {}

  static bool ShouldGenerate() {
    return !ErrorState && !PendingReturn;
  }

  static void NextBlockForInsertion() {
    BasicBlockStack.pop();
    BasicBlock* nextBlock = BasicBlockStack.empty() ? nullptr : BasicBlockStack.top();
    Builder.SetInsertPoint(nextBlock);
    PendingReturn = false;
  }

  static void ReplaceInsertionBlock(BasicBlock* nextBlock) {
    BasicBlockStack.pop();
    BasicBlockStack.push(nextBlock);
    Builder.SetInsertPoint(nextBlock);
    PendingReturn = false;
  }

  static Value* CreateInitialValueGivenType(AbstractType abstractType) {
    if (abstractType == AbstractType::Integer)
      return ProduceInteger(0);
    else if (abstractType == AbstractType::Float)
      return ProduceFloat(0);
    else if (abstractType == AbstractType::Bool)
      return ProduceBool(false);
    else if (abstractType == AbstractType::Char)
      return ProduceChar(0);
    else if (abstractType == AbstractType::String)
      return ProduceString("");

    // Assert: unreached.
    return nullptr;
  }

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
  static void EnterErrorState() {
    ErrorState = true;
  }

  static void Setup() {
    TheModule = make_unique<Module>("Dom Sample", TheContext);
    DeclarePrintf();
  }

  static void PrintBitCode() {
    if (!ShouldGenerate()) return;
    TheModule->print(errs(), nullptr);
  }

  static Value* ProduceFloat(double val) {
    return ConstantFP::get(TheContext, APFloat(val));
  }

  static Value* ProduceInteger(int val) {
    return ConstantInt::get(TheContext, APInt(/* nbits */ 32, /* value */ val, /* is signed */ true));
  }

  static Value* ProduceChar(char val) {
    return ConstantInt::get(TheContext, APInt(/* nbits */ 8, /* value */ val, /* is signed */ true));
  }

  static Value* ProduceBool(bool val) {
    return Builder.CreateFCmpONE(ProduceFloat(val), ProduceFloat(0));
  }

  static Value* ProduceString(const std::string& str) {
    return Builder.CreateGlobalStringPtr(str);
  }

  // Arithmetic operators.
  static Value* AddFloats(Value* lhs, Value* rhs, const std::string& regName = "") {
    if (!ShouldGenerate()) return nullptr;
    return Builder.CreateFAdd(lhs, rhs, regName);
  }
  static Value* AddIntegers(Value* lhs, Value* rhs, const std::string& regName = "") {
    if (!ShouldGenerate()) return nullptr;
    return Builder.CreateAdd(lhs, rhs, regName);
  }
  static Value* SubtractFloats(Value* lhs, Value* rhs, const std::string& regName = "") {
    if (!ShouldGenerate()) return nullptr;
    return Builder.CreateFSub(lhs, rhs, regName);
  }
  static Value* SubtractIntegers(Value* lhs, Value* rhs, const std::string& regName = "") {
    if (!ShouldGenerate()) return nullptr;
    return Builder.CreateSub(lhs, rhs, regName);
  }
  static Value* MultiplyFloats(Value* lhs, Value* rhs, const std::string& regName = "") {
    if (!ShouldGenerate()) return nullptr;
    return Builder.CreateFMul(lhs, rhs, regName);
  }
  static Value* MultiplyIntegers(Value* lhs, Value* rhs, const std::string& regName = "") {
    if (!ShouldGenerate()) return nullptr;
    return Builder.CreateMul(lhs, rhs, regName);
  }
  static Value* DivideFloats(Value* lhs, Value* rhs, const std::string& regName = "") {
    if (!ShouldGenerate()) return nullptr;
    return Builder.CreateFDiv(lhs, rhs, regName);
  }
  static Value* DivideIntegers(Value* lhs, Value* rhs, const std::string& regName = "") {
    if (!ShouldGenerate()) return nullptr;
    return Builder.CreateSDiv(lhs, rhs, regName);
  }

  // Relational operators.
  static Value* LessThanFloats(Value* lhs, Value* rhs, const std::string& regName = "") {
    if (!ShouldGenerate()) return nullptr;
    return Builder.CreateFCmpOLT(lhs, rhs, regName);
  }
  static Value* LessThanIntegers(Value* lhs, Value* rhs, const std::string& regName = "") {
    if (!ShouldGenerate()) return nullptr;
    return Builder.CreateICmpSLT(lhs, rhs, regName);
  }
  static Value* LessThanOrEqualFloats(Value* lhs, Value* rhs, const std::string& regName = "") {
    if (!ShouldGenerate()) return nullptr;
    return Builder.CreateFCmpOLE(lhs, rhs, regName);
  }
  static Value* LessThanOrEqualIntegers(Value* lhs, Value* rhs, const std::string& regName = "") {
    if (!ShouldGenerate()) return nullptr;
    return Builder.CreateICmpSLE(lhs, rhs, regName);
  }
  static Value* GreaterThanFloats(Value* lhs, Value* rhs, const std::string& regName = "") {
    if (!ShouldGenerate()) return nullptr;
    return Builder.CreateFCmpOGT(lhs, rhs, regName);
  }
  static Value* GreaterThanIntegers(Value* lhs, Value* rhs, const std::string& regName = "") {
    if (!ShouldGenerate()) return nullptr;
    return Builder.CreateICmpSGT(lhs, rhs, regName);
  }
  static Value* GreaterThanOrEqualFloats(Value* lhs, Value* rhs, const std::string& regName = "") {
    if (!ShouldGenerate()) return nullptr;
    return Builder.CreateFCmpOGE(lhs, rhs, regName);
  }
  static Value* GreaterThanOrEqualIntegers(Value* lhs, Value* rhs, const std::string& regName = "") {
    if (!ShouldGenerate()) return nullptr;
    return Builder.CreateICmpSGE(lhs, rhs, regName);
  }
  static Value* EqualFloats(Value* lhs, Value* rhs, const std::string& regName = "") {
    if (!ShouldGenerate()) return nullptr;
    return Builder.CreateFCmpOEQ(lhs, rhs, regName);
  }
  static Value* EqualIntegers(Value* lhs, Value* rhs, const std::string& regName = "") {
    if (!ShouldGenerate()) return nullptr;
    return Builder.CreateICmpEQ(lhs, rhs, regName);
  }
  static Value* NotEqualFloats(Value* lhs, Value* rhs, const std::string& regName = "") {
    if (!ShouldGenerate()) return nullptr;
    return Builder.CreateFCmpONE(lhs, rhs, regName);
  }
  static Value* NotEqualIntegers(Value* lhs, Value* rhs, const std::string& regName = "") {
    if (!ShouldGenerate()) return nullptr;
    return Builder.CreateICmpNE(lhs, rhs, regName);
  }

  // Creates an LLVM Function* prototype, generates an IR declaration for it,
  // and adds it to the FunctionTable.
  static void CreateFunction(const std::string& name,
                             AbstractType abstractReturnType,
                             std::vector<std::pair<std::string, AbstractType>> arguments,
                             bool variadic = false) {
    if (!ShouldGenerate()) return;

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

    // Create BasicBlock to start inserting function body IR into; the BasicBlock
    // is inserted into the Function.
    BasicBlock* BB = BasicBlock::Create(TheContext, "entry", function);
    Builder.SetInsertPoint(BB); // New instructions should be inserted into the BasicBlock.
    BasicBlockStack.push(BB);

    // Name arguments and add as local variables.
    // Now that we're "inside" the function, we want to have access to the
    // function arguments via local variables.
    int i = 0;
    for (auto& arg: function->args()) {
      arg.setName(arguments[i].first);
      CreateVariable(/* abstractType */ arguments[i++].second,
                     /* variableName */ arg.getName(),
                     /* initialValue */ &arg);
    }

    FunctionTable[name] = function;
  }

  static void Return() {
    if (!ShouldGenerate()) return;
    Builder.CreateRetVoid();
    PendingReturn = true;
  }

  static void Return(Value* returnValue) {
    if (!ShouldGenerate()) return;
    Builder.CreateRet(returnValue);
    PendingReturn = true;
  }

  static void EndFunction(Value* returnValue = nullptr) {
    // We shouldn't have the full-blown |ShouldGenerate| check here, or else
    // when we have a pending return out, we'll never be able to escape this
    // state. Instead, we just want an |ErrorState| check so that we can
    // "unflip" the |PendingReturn| state.
    if (ErrorState) return;
    Function* currentFunction = Builder.GetInsertBlock()->getParent();
    verifyFunction(*currentFunction);

    // TODO(domfarolino): Remove parameters from |LocalVariables| map
    // https://github.com/domfarolino/llvm-experiments/issues/13.

    Return();
    NextBlockForInsertion();
  }

  static void IfThen(Value* inCondition) {
    if (!ShouldGenerate()) return;
    inCondition = ToBool(inCondition);
    Function* currentFunction = Builder.GetInsertBlock()->getParent();

    // Add |ThenBB| to |currentFunction| right now.
    BasicBlock *ThenBB = BasicBlock::Create(TheContext, "then", currentFunction),
               *ElseBB = BasicBlock::Create(TheContext, "else"),
               *MergeBB = BasicBlock::Create(TheContext, "ifmerge");
    IfBlocksStack.push(IfBlocks(inCondition, ThenBB, ElseBB, MergeBB));
    Builder.CreateCondBr(inCondition, ThenBB, ElseBB);

    // Start generating code into |ThenBB|.
    ReplaceInsertionBlock(ThenBB);
  }

  static void Else() {
    if (ErrorState || IfBlocksStack.empty()) return;
    // When we're ready to generate into |ElseBB|, we have to have |ThenBB|
    // branch to |MergeBB|, update our reference to |ThenBB|, push |ElseBB| to
    // the current function's list of BasicBlocks, and start generating into
    // |ElseBB|.

    // Assert: !IfBlocksStack.empty().
    IfBlocks CurrentIfBlock = IfBlocksStack.top();
    if (!PendingReturn) Builder.CreateBr(CurrentIfBlock.MergeBB);

    // This is subtle but necessary, as 'Then' codegen can change the current
    // block.
    // TODO(domfarolino): Can I get rid of this now that we're not using a PHI
    // node?
    CurrentIfBlock.ThenBB = Builder.GetInsertBlock();

    // Push |ElseBB| to |currentFunction|'s list of BasicBlocks, and start
    // generating into |ElseBB|.
    Function* currentFunction = Builder.GetInsertBlock()->getParent();
    currentFunction->getBasicBlockList().push_back(CurrentIfBlock.ElseBB);
    ReplaceInsertionBlock(CurrentIfBlock.ElseBB);
  }

  static void EndIf() {
    if (ErrorState || IfBlocksStack.empty()) return;
    // Assert: !IfBlocksStack.empty().
    IfBlocks CurrentIfBlock = IfBlocksStack.top();
    // See Else().
    if (!PendingReturn) Builder.CreateBr(CurrentIfBlock.MergeBB);

    // Same subtle-but-necessary trick as in Else().
    CurrentIfBlock.ElseBB = Builder.GetInsertBlock();

    // Deal with |MergeBB|.
    Function* currentFunction = Builder.GetInsertBlock()->getParent();
    currentFunction->getBasicBlockList().push_back(CurrentIfBlock.MergeBB);
    ReplaceInsertionBlock(CurrentIfBlock.MergeBB);

    /*Shouldn't need this (also it is breaking in nested ifs).
    PHINode *PHN = Builder.CreatePHI(Type::getDoubleTy(TheContext), 2, "ifphi");
    PHN->addIncoming(ProduceFloat(1), CurrentIfBlock.ThenBB);
    PHN->addIncoming(ProduceFloat(2), CurrentIfBlock.ElseBB);*/

    IfBlocksStack.pop();
  }

  static Value* CallFunction(const std::string& name, const std::vector<Value*>& args, const std::string& regName = "") {
    if (!ShouldGenerate()) return nullptr;
    Function* function = FunctionTable[name];
    return Builder.CreateCall(function, args, regName);
  }

  static Value* ToBool(Value* input) {
    if (!ShouldGenerate()) return nullptr;
    if (input->getType()->isDoubleTy())
      return CastFloatToBool(input);
    else if (static_cast<IntegerType*>(input->getType())->getBitWidth() == 32)
      return CastIntegerToBool(input);

    // Assert: getBitWidth == 1 (already a bool).
    return input;
  }

  static Value* CastFloatToInteger(Value* input) {
    if (!ShouldGenerate()) return nullptr;
    // TODO(domfarolino): Maybe replace this with Builder.GetInsertBlock().
    BasicBlock* BB = Builder.GetInsertBlock();
    if (!BB) {
      std::cout << "BasicBlock not available for cast, something is wrong..." << std::endl;
      return nullptr;
    }

    return new FPToSIInst(input, Type::getInt32Ty(TheContext), "float-to-integer", BB);
  }

  static Value* CastIntegerToFloat(Value* input) {
    if (!ShouldGenerate()) return nullptr;
    // TODO(domfarolino): Maybe replace this with Builder.GetInsertBlock().
    BasicBlock* BB = Builder.GetInsertBlock();
    if (!BB) {
      std::cout << "BasicBlock not available for cast, something is wrong..." << std::endl;
      return nullptr;
    }

    return new SIToFPInst(input, Type::getDoubleTy(TheContext), "integer-to-float", BB);
  }

  static Value* CastFloatToBool(Value* input) {
    if (!ShouldGenerate()) return nullptr;
    BasicBlock* BB = Builder.GetInsertBlock();
    if (!BB) {
      std::cout << "BasicBlock not available for cast, something is wrong..." << std::endl;
      return nullptr;
    }

    return Builder.CreateFCmpONE(input, ProduceFloat(0.0), "float-to-bool");
  }

  static Value* CastIntegerToBool(Value* input) {
    if (!ShouldGenerate()) return nullptr;
    BasicBlock* BB = Builder.GetInsertBlock();
    if (!BB) {
      std::cout << "BasicBlock not available for cast, something is wrong..." << std::endl;
      return nullptr;
    }

    return Builder.CreateFCmpONE(CastIntegerToFloat(input), ProduceFloat(0), "integer-to-bool");
  }

  // This is probably going to be replaced by a call to ScopeManager::{lookup, getSymbol}.
  static Value* GetVariable(const std::string& name) {
    if (!ShouldGenerate()) return nullptr;
    if (LocalVariables.find(name) == LocalVariables.end()) {
      std::cout << "Could not find variable with name: " << name << std::endl;
      return nullptr;
    }

    AllocaInst* variableAlloca = LocalVariables[name];
    return Builder.CreateLoad(variableAlloca, name.c_str());
  }

  // If we were to support chained assignments (x = y = 2), we may want this
  // implementation of assign to return the rhs value.
  static void Assign(const std::string& variableName, Value* rhs) {
    if (!ShouldGenerate()) return;
    AllocaInst* variable = LocalVariables[variableName];
    if (!variable) {
      std::cout << "Could not find local variable with name: '" << variableName << "'" << std::endl;
      return;
    }

    Builder.CreateStore(rhs, variable);
  }

  static void CreateVariable(AbstractType abstractType,
                             const std::string& variableName,
                             Value* initialValue = nullptr) {
    if (!ShouldGenerate()) return;
    // |initialValue| is not always nullptr, for example, in the case of
    // function parameters.
    if (!initialValue)
      initialValue = CreateInitialValueGivenType(abstractType);

    // Allocates a stack variable in the current function's |entry| block.
    Function* currentFunction = Builder.GetInsertBlock()->getParent();
    IRBuilder<> EntryBuilder(&currentFunction->getEntryBlock(),
                             currentFunction->getEntryBlock().begin());
    AllocaInst* argAlloca = EntryBuilder.CreateAlloca(
                                           AbstractTypeToLLVMType(abstractType),
                                           0, variableName.c_str());

    // Assert: |initialValue| is non-null.
    Builder.CreateStore(initialValue, argAlloca);
    LocalVariables[variableName] = argAlloca;
  }

  static void For() {
    if (!ShouldGenerate()) return;
    Function* currentFunction = Builder.GetInsertBlock()->getParent();

    BasicBlock *CondEvalBB = BasicBlock::Create(TheContext, "condeval", currentFunction),
               *LoopBB = BasicBlock::Create(TheContext, "loop"),
               *PostLoopBB = BasicBlock::Create(TheContext, "postloop");
    ForLoopBlocksStack.push(ForLoopBlocks(CondEvalBB, LoopBB, PostLoopBB));

    // Start generating code into |CondEvalBB|.
    Builder.CreateBr(CondEvalBB);
    ReplaceInsertionBlock(CondEvalBB);
  }

  static void ForCondition(Value* inCondition) {
    if (!ShouldGenerate()) return;
    inCondition = ToBool(inCondition);
    ForLoopBlocks CurrentForLoopBlock = ForLoopBlocksStack.top();
    Function* currentFunction = Builder.GetInsertBlock()->getParent();
    currentFunction->getBasicBlockList().push_back(CurrentForLoopBlock.LoopBB);

    // Start generating code into |LoopBB|.
    Builder.CreateCondBr(inCondition, CurrentForLoopBlock.LoopBB, CurrentForLoopBlock.PostLoopBB);
    ReplaceInsertionBlock(CurrentForLoopBlock.LoopBB);
  }

  static void EndFor() {
    if (ErrorState || ForLoopBlocksStack.empty()) return;
    ForLoopBlocks CurrentForLoopBlock = ForLoopBlocksStack.top();

    if (!PendingReturn) Builder.CreateBr(CurrentForLoopBlock.CondEvalBB);

    Function* currentFunction = Builder.GetInsertBlock()->getParent();
    currentFunction->getBasicBlockList().push_back(CurrentForLoopBlock.PostLoopBB);

    // Start generating post-loop code into |PostLoopBB|.
    ReplaceInsertionBlock(CurrentForLoopBlock.PostLoopBB);
    ForLoopBlocksStack.pop();
  }
};
