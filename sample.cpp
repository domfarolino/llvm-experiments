#include <iostream>
#include <vector>

#include "CodeGen.h"

int main() {
  CodeGen::Setup();

  //////// ADDER.
  CodeGen::CreateFunction("AdderFunction", AbstractType::Double, AbstractType::Double, 2);
  Value* returnValue = CodeGen::Add(CodeGen::GetVariable("argument0"), CodeGen::GetVariable("argument1"), "addUltimateReturn");
  CodeGen::ReturnFrom("AdderFunction", returnValue);

  //////// MAIN.
  CodeGen::CreateFunction("main", AbstractType::Integer, AbstractType::Integer, 0);
  Value* adderReturn = CodeGen::CallFunction("AdderFunction", {CodeGen::ProduceNumber(38), CodeGen::ProduceNumber(42)}, "calladder");
  Value* castToInt = CodeGen::CastFloatToInt(adderReturn, "main", "fpToIntegerConv");

  /////// CALL printf.
  std::vector<Value*> printfArguments = { CodeGen::ProduceString("dominicfarolino!!%d"), CodeGen::ProduceInteger(40) };
  CodeGen::CallFunction("printf", printfArguments, "callprintf");

  CodeGen::ReturnFrom("main", castToInt);

  CodeGen::PrintBitCode();
  return 0;
}
