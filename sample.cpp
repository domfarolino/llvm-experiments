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

        /////// CALL printf from AdderFunction.
        std::vector<Value*> tmpArgs = { CodeGen::ProduceString("Adder returning: %f\n"), returnValue };
        CodeGen::CallFunction("printf", tmpArgs, "callprintf");

        CodeGen::ReturnFrom("AdderFunction", returnValue);
        //////// END ADDER.

  /////// VOIDFN.
  CodeGen::CreateFunction("comparisonFunction", AbstractType::Void, { std::make_pair("value", AbstractType::Double) });

  CodeGen::ReturnFrom("comparisonFunction", nullptr);
  /////// END VOIDFN.

  Value* adderReturn = CodeGen::CallFunction("AdderFunction", {CodeGen::ProduceNumber(38), CodeGen::ProduceNumber(42)}, "calladder");
  CodeGen::CallFunction("comparisonFunction", { adderReturn });
  Value* castToInt = CodeGen::CastFloatToInt(adderReturn, "main", "fpToIntegerConv");

  /////// CALL printf.
  std::vector<Value*> printfArguments = { CodeGen::ProduceString("dominicfarolino!!%d"), castToInt };
  CodeGen::CallFunction("printf", printfArguments, "callprintf");

  CodeGen::ReturnFrom("main", castToInt);

  CodeGen::PrintBitCode();
  return 0;
}
