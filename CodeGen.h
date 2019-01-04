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
      return Type::getInt8Ty(TheContext);
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

  static Value* ProduceNumber(double val) {
    return ConstantFP::get(TheContext, APFloat(val));
  }

  static Value* ProduceInteger(int val) {
    return ConstantInt::get(TheContext, APInt(/* nbits 8 */ 32, /* value */ val, /* is signed */ true));
  }

  static Value* ProduceString(const std::string& str) {
    return Builder.CreateGlobalStringPtr(str);
  }

  static Value* Add(Value* lhs, Value* rhs, const std::string& regName = "") {
    return Builder.CreateFAdd(lhs, rhs, regName);
  }

  static Value* Subtract(Value* lhs, Value* rhs, const std::string& regName = "") {
    return Builder.CreateSub(lhs, rhs, regName);
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

    // Create BasicBlock to start inserting function body IR into; the BasicBlock
    // is inserted into the Function.
    BasicBlock* BB = BasicBlock::Create(TheContext, "entry", function);
    Builder.SetInsertPoint(BB); // New instructions should be inserted into the BasicBlock.

    // Add arguments to local variables.
    // Now that we're "inside" the function, we want to have access to the
    // function arguments via local variables.
    for (auto& arg: function->args()) {
      LocalVariables[arg.getName()] = &arg; // Values[argumentName] = Value*.
    }

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
    // Assert !BasicBlockStack.empty()
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

  static Value* CallFunction(const std::string& name, const std::vector<Value*>& args, const std::string& regName = "") {
    Function* function = FunctionTable[name];
    return Builder.CreateCall(function, args, regName);
  }

  static Value* CastFloatToInt(Value* input, const std::string& currentFunction, const std::string& regName) {
    BasicBlock* BB = BasicBlockStack.top();
    if (!BB) {
      std::cout << "BasicBlock not available for cast, something is wrong..." << std::endl;
      return nullptr;
    }

    return new FPToSIInst(input, Type::getInt32Ty(TheContext), regName, BB);
  }

  static Value* GetVariable(const std::string& name) {
    if (LocalVariables.find(name) == LocalVariables.end()) {
      std::cout << "Could not find variable with name: " << name << std::endl;
      return nullptr;
    }

    return LocalVariables[name];
  }
};
