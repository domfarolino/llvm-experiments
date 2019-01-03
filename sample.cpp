#include <iostream>
#include <vector>

#include "CodeGen.h"

int main() {
  CodeGen::Setup();

  //////// MAIN.
  std::vector<std::pair<std::string, AbstractType>> mainArguments;
  CodeGen::CreateFunction("main", AbstractType::Integer, mainArguments);

        //////// ADDER.
        std::vector<std::pair<std::string, AbstractType>> adderArguments = {
          std::make_pair("left", AbstractType::Double),
          std::make_pair("right", AbstractType::Double)
        };
        CodeGen::CreateFunction("AdderFunction", AbstractType::Double, adderArguments);
        Value* returnValue = CodeGen::Add(CodeGen::GetVariable("left"), CodeGen::GetVariable("right"), "addUltimateReturn");

        /////// CALL printf.
        std::vector<Value*> tmpArgs = { CodeGen::ProduceString("Adder returning: %f\n"), returnValue };
        CodeGen::CallFunction("printf", tmpArgs, "callprintf");

        CodeGen::ReturnFrom("AdderFunction", returnValue);
        //////// END ADDER.

  Value* adderReturn = CodeGen::CallFunction("AdderFunction", {CodeGen::ProduceNumber(38), CodeGen::ProduceNumber(42)}, "calladder");
  Value* castToInt = CodeGen::CastFloatToInt(adderReturn, "main", "fpToIntegerConv");

  /////// CALL printf.
  std::vector<Value*> printfArguments = { CodeGen::ProduceString("dominicfarolino!!%d"), castToInt };
  CodeGen::CallFunction("printf", printfArguments, "callprintf");

  CodeGen::ReturnFrom("main", castToInt);

  CodeGen::PrintBitCode();
  return 0;
}
