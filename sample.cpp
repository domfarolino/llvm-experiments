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
          std::make_pair("left", AbstractType::Float),
          std::make_pair("right", AbstractType::Float)
        };
        CodeGen::CreateFunction("AdderFunction", AbstractType::Float, adderArguments);
        Value* returnValue = CodeGen::Add(CodeGen::GetVariable("left"), CodeGen::GetVariable("right"), "addUltimateReturn");

        /////// CALL printf from AdderFunction.
        std::vector<Value*> tmpArgs = { CodeGen::ProduceString("Adder returning: %f\n"), returnValue };
        CodeGen::CallFunction("printf", tmpArgs, "callprintf");

        CodeGen::ReturnFrom("AdderFunction", returnValue);
        //////// END ADDER.

  /////// Function takes a Integer.
  CodeGen::CreateFunction("integerFunction", AbstractType::Void, { std::make_pair("integerArgument", AbstractType::Integer) });
  CodeGen::ReturnFrom("integerFunction", nullptr);

  /////// Function takes a float.
  CodeGen::CreateFunction("floatFunction", AbstractType::Void, { std::make_pair("floatArgument", AbstractType::Float) });
  CodeGen::ReturnFrom("floatFunction", nullptr);

  /////// Function takes a bool.
  CodeGen::CreateFunction("boolFunction", AbstractType::Void, { std::make_pair("boolArgument", AbstractType::Bool) });
  CodeGen::ReturnFrom("boolFunction", nullptr);

  /////// Function takes a char.
  CodeGen::CreateFunction("charFunction", AbstractType::Void, { std::make_pair("charArgument", AbstractType::Char) });
  CodeGen::ReturnFrom("charFunction", nullptr);

  /////// Function takes a string.
  CodeGen::CreateFunction("stringFunction", AbstractType::Void, { std::make_pair("stringArgument", AbstractType::String) });
  CodeGen::ReturnFrom("stringFunction", nullptr);

  Value* adderReturn = CodeGen::CallFunction("AdderFunction", {CodeGen::ProduceNumber(38), CodeGen::ProduceNumber(42)}, "calladder");
  //CodeGen::CallFunction("floatFunction", { adderReturn });
  Value* castToInt = CodeGen::CastFloatToInt(adderReturn, "main", "fpToIntegerConv");

  /////// CALL printf.
  std::vector<Value*> printfArguments = { CodeGen::ProduceString("dominicfarolino!!%d"), castToInt };
  CodeGen::CallFunction("printf", printfArguments, "callprintf");

  CodeGen::ReturnFrom("main", castToInt);

  CodeGen::PrintBitCode();
  return 0;
}
