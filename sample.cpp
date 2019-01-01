#include <iostream>
#include <vector>

#include "CodeGen.h"

int main() {
  CodeGen::Setup();

  //////// BEGIN ADDER.
  // Create a function and add it to the FunctionTable.
  Function* AdderFunction = CreateFunction("AdderFunction", AbstractType::Double, AbstractType::Double, 2);

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

  CodeGen::PrintBitCode();
  return 0;
}
