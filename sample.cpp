#include <iostream>
#include <vector>
#include <map>

#include "llvm/IR/Verifier.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Support/raw_os_ostream.h"

using namespace llvm;

static LLVMContext TheContext;
static IRBuilder<> Builder(TheContext);
static std::unique_ptr<Module> TheModule;

// These two are essentially mimicing our abstract symbol table.
static std::map<std::string, Value*> Values;
static std::map<std::string, Function*> FunctionTable;

Value* ProduceNumber(double val) {
  return ConstantFP::get(TheContext, APFloat(val));
}

Value* ProduceInteger(int val) {
  return ConstantInt::get(TheContext, APInt(/* nbits 8 */ 32, /* value */ val, /* is signed */ true));
}

enum AbstractType {
  Integer,
  Double,
};

// Creates an LLVM Function* prototype, generates an IR declaration for it, and
// adds it to the FunctionTable.
Function* CreateFunction(const std::string& name, AbstractType abstractType, int argLength, bool variadic = false) {
  // Create arguments prototype vector.
  std::vector<Type*> arguments(argLength, Type::getDoubleTy(TheContext));

  // Create function prototype.
  Type* returnType;
  if (abstractType == AbstractType::Integer)
    returnType = Type::getInt32Ty(TheContext);
  else if (abstractType == AbstractType::Double)
    returnType = Type::getDoubleTy(TheContext);

  FunctionType* functionType = FunctionType::get(returnType, arguments, variadic);
  Function* function = Function::Create(functionType, Function::ExternalLinkage, name, TheModule.get());
  FunctionTable[name] = function;

  // Name arguments (optional, but easier for debugging).
  int i = 0;
  for (auto& arg: function->args()) {
    arg.setName("argument" + std::to_string(i++));
  }

  return function;
}

int main() {
  TheModule = make_unique<Module>("Dom Sample", TheContext);

  /////// SETUP printf DECLARATION.
  std::vector<Type*> arguments(1, Type::getInt8Ty(TheContext)->getPointerTo());

  FunctionType* printfFunctionType = FunctionType::get(Type::getInt32Ty(TheContext), arguments, true);
  Function* printfFunction = Function::Create(printfFunctionType, Function::ExternalLinkage, "printf", TheModule.get());
  FunctionTable["printf"] = printfFunction;
  /////// END printf SETUP.

  //////// BEGIN ADDER.
  std::string functionName = "AdderFunction";
  // Create a function and add it to the FunctionTable.
  CreateFunction(functionName, AbstractType::Double, 2);

  // Get the function from the FunctionTable.
  Function* AdderFunction = FunctionTable[functionName];

  // Create BasicBlock to start inserting function body IR into; the BasicBlock
  // is inserted into the Function.
  BasicBlock* BB = BasicBlock::Create(TheContext, "entry", AdderFunction);
  Builder.SetInsertPoint(BB); // New instructions should be inserted into the BasicBlock.

  // Now that we're "inside" the function, we want to have access to the
  // function arguments via local variables.
  for (auto& arg: AdderFunction->args()) {
    Values[arg.getName()] = &arg; // Values[argumentName] = Value*.
  }

  //Values["argument0"] = Builder.CreateFMul(Values["argument0"], ProduceNumber(2));
  //Values["argument1"] = Builder.CreateFMul(Values["argument0"], ProduceNumber(2));
  Value* returnValue = Builder.CreateFAdd(Values["argument0"], Values["argument1"], "addUltimateReturn");

  // Delete this stuff.
  Builder.CreateRet(returnValue);
  verifyFunction(*AdderFunction);
  //////// END ADDER.

  //////// BEGIN MAIN.
  CreateFunction("main", AbstractType::Integer, 0);
  Function* Main = FunctionTable["main"];
  Function* AdderCallee = FunctionTable["AdderFunction"];

  BasicBlock* mainBB = BasicBlock::Create(TheContext, "entry", Main);
  Builder.SetInsertPoint(mainBB);

  // Main body.
  std::vector<Value*> adderArguments = {ProduceNumber(38), ProduceNumber(42)};
  Value* adderReturn = Builder.CreateCall(AdderCallee, adderArguments, "calladder");
  Value* mainReturn = new FPToSIInst(adderReturn, Type::getInt32Ty(TheContext), "fptointegerconv", mainBB);

  /////// CALL printf.
  Value* printfArgString = Builder.CreateGlobalStringPtr("dominic!!\n");
  std::vector<Value*> printfArguments = { printfArgString };
  Builder.CreateCall(printfFunction, printfArguments, "callprintf");
  /////// END CALL printf.
  Builder.CreateRet(mainReturn);

  // End main body.

  verifyFunction(*Main);
  //////// END MAIN.

  TheModule->print(errs(), nullptr);
  return 0;
}
