#include <map>
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
  Double,
};

class CodeGen {
private:
  static LLVMContext TheContext;
  static IRBuilder<> Builder(TheContext);
  static std::unique_ptr<Module> TheModule;

  // These two are essentially mimicing our abstract symbol table.
  static std::map<std::string, Value*> LocalVariables;
  static std::map<std::string, std::pair<Function*, BasicBlock*>> FunctionTable;

  // Disallow creating an instance of this class.
  CodeGen() {}

  void DeclarePrintf() {
    // Set up printf argument(s).
    std::vector<Type*> arguments(1, Type::getInt8Ty(TheContext)->getPointerTo());
    FunctionType* printfFunctionType = FunctionType::get(Type::getInt32Ty(TheContext), arguments, true);
    Function* printfFunction = Function::Create(printfFunctionType, Function::ExternalLinkage, "printf", TheModule.get());
    FunctionTable["printf"] = std::make_pair(printfFunction, nullptr);
  }

public:
  void Setup() {
    TheModule = make_unique<Module>("Dom Sample", TheContext);
    DeclarePrintf();
  }

  void PrintBitCode() {
    TheModule->print(errs(), nullptr);
  }

  Value* ProduceNumber(double val) {
    return ConstantFP::get(TheContext, APFloat(val));
  }

  Value* ProduceInteger(int val) {
    return ConstantInt::get(TheContext, APInt(/* nbits 8 */ 32, /* value */ val, /* is signed */ true));
  }

  // Creates an LLVM Function* prototype, generates an IR declaration for it,
  // and adds it to the FunctionTable.
  Function* CreateFunction(const std::string& name,
                           AbstractType abstractReturnType,
                           AbstractType abstractArgType, int argLength,
                           bool variadic = false) {
    // Create arguments prototype vector.
    if (abstractArgType == AbstractType::Integer)
      std::vector<Type*> arguments(argLength, Type::getInt32Ty(TheContext));
    else if (abstractArgType == AbstractType::Double)
      std::vector<Type*> arguments(argLength, Type::getDoubleTy(TheContext));

    // Create function prototype.
    Type* returnType;
    if (abstractReturnType == AbstractType::Integer)
      returnType = Type::getInt32Ty(TheContext);
    else if (abstractType == AbstractType::Double)
      returnType = Type::getDoubleTy(TheContext);

    // Make Function.
    FunctionType* functionType = FunctionType::get(returnType, arguments, variadic);
    Function* function = Function::Create(functionType, Function::ExternalLinkage, name, TheModule.get());

    // Create BasicBlock to start inserting function body IR into; the BasicBlock
    // is inserted into the Function.
    BasicBlock* BB = BasicBlock::Create(TheContext, "entry", function);
    Builder.SetInsertPoint(BB); // New instructions should be inserted into the BasicBlock.

    // Name arguments (optional, but easier for debugging).
    int i = 0;
    for (auto& arg: function->args()) {
      arg.setName("argument" + std::to_string(i++));
    }

    // Add arguments to local variables.
    // Now that we're "inside" the function, we want to have access to the
    // function arguments via local variables.
    for (auto& arg: function->args()) {
      LocalVariables[arg.getName()] = &arg; // Values[argumentName] = Value*.
    }

    FunctionTable[name] = std::make_pair(function, BB);
    return function;
  }
};
