#include <iostream>
#include <vector>

#include "CodeGen.h"

int main() {
  CodeGen::Setup();

  //////// MAIN.
  std::vector<std::pair<std::string, AbstractType>> mainArguments;
  CodeGen::CreateFunction("main", AbstractType::Integer, mainArguments);

        //////// FloatAdder.
        std::vector<std::pair<std::string, AbstractType>> floatArguments = {
          std::make_pair("floatLeft", AbstractType::Float),
          std::make_pair("floatRight", AbstractType::Float)
        };
        CodeGen::CreateFunction("FloatAdder", AbstractType::Float, floatArguments);
        Value* returnValue = CodeGen::DivideFloats(CodeGen::GetVariable("floatLeft"), CodeGen::GetVariable("floatRight"), "floatAddUltimateReturn");

        /////// CALL printf from FloatAdder.
        std::vector<Value*> tmpArgs = { CodeGen::ProduceString("FloatAdder returning: %f\n"), returnValue };
        CodeGen::CallFunction("printf", tmpArgs, "callprintf");
        CodeGen::ReturnFrom("FloatAdder", returnValue);
        //////// END FloatAdder.

        //////// IntegerAdder.
        std::vector<std::pair<std::string, AbstractType>> integerArguments = {
          std::make_pair("integerLeft", AbstractType::Integer),
          std::make_pair("integerRight", AbstractType::Integer)
        };
        CodeGen::CreateFunction("IntegerAdder", AbstractType::Integer, integerArguments );
        returnValue = CodeGen::DivideIntegers(CodeGen::GetVariable("integerLeft"), CodeGen::GetVariable("integerRight"), "integerAddUltimateReturn");

        /////// CALL printf from AdderFunction.
        tmpArgs = { CodeGen::ProduceString("IntegerAdder returning: %d\n"), returnValue };
        CodeGen::CallFunction("printf", tmpArgs, "callprintf");
        CodeGen::ReturnFrom("IntegerAdder", returnValue);
        //////// END FloatAdder.

  /////// Function takes a integer.
  CodeGen::CreateFunction("integerFunction", AbstractType::Void, { std::make_pair("integerArgument", AbstractType::Integer) });
  CodeGen::ReturnFrom("integerFunction", nullptr);

  /////// Function takes a float.
  CodeGen::CreateFunction("floatFunction", AbstractType::Void, { std::make_pair("floatArgument", AbstractType::Float) });
  CodeGen::ReturnFrom("floatFunction", nullptr);

  /////// Function takes a bool.
  CodeGen::CreateFunction("boolFunction", AbstractType::Void, { std::make_pair("boolArgument", AbstractType::Bool) });
  CodeGen::CallFunction("printf", { CodeGen::ProduceString("boolArgument: %d\n"), CodeGen::GetVariable("boolArgument") });
  CodeGen::IfThen(CodeGen::GetVariable("boolArgument"));
    CodeGen::CallFunction("printf", { CodeGen::ProduceString("if -> then was executed!\n") });
  CodeGen::Else();
    CodeGen::CallFunction("printf", { CodeGen::ProduceString("if -> else was executed!\n") });
  CodeGen::EndIf();
  CodeGen::ReturnFrom("boolFunction", nullptr);

  /////// Function takes a char.
  CodeGen::CreateFunction("charFunction", AbstractType::Void, { std::make_pair("charArgument", AbstractType::Char) });
  CodeGen::ReturnFrom("charFunction", nullptr);

  /////// Function takes a string.
  CodeGen::CreateFunction("stringFunction", AbstractType::Void, { std::make_pair("stringArgument", AbstractType::String) });
  CodeGen::ReturnFrom("stringFunction", nullptr);

  Value* floatAdderReturn = CodeGen::CallFunction("FloatAdder", {CodeGen::ProduceFloat(42), CodeGen::ProduceFloat(38)}, "calladder");
  Value* integerAdderReturn = CodeGen::CallFunction("IntegerAdder", {CodeGen::ProduceInteger(42), CodeGen::ProduceInteger(38)}, "calladder");

  /////// CALL printf for {float, integer}AdderReturn values.
  std::vector<Value*> printfArguments = { CodeGen::ProduceString("FloatAdderResult(from main): %f\n"), floatAdderReturn };
  CodeGen::CallFunction("printf", printfArguments, "callprintfFloatAdder");
  CodeGen::CallFunction("printf", { CodeGen::ProduceString("IntegerAdderResult(from main): %d\n"), integerAdderReturn }, "callprintfIntegerAdder");

  /////// Use relational operators.
  Value* relResult = CodeGen::NotEqualFloats(CodeGen::ProduceFloat(3), CodeGen::ProduceFloat(3));
  CodeGen::CallFunction("printf", { CodeGen::ProduceString("relResult: %d\n"), relResult });

  /////// CALL boolFunction.
  Value* castToBool = CodeGen::CastFloatToBool(floatAdderReturn);
  CodeGen::CallFunction("boolFunction", { castToBool });

  CodeGen::ReturnFrom("main", integerAdderReturn);

  CodeGen::PrintBitCode();
  return 0;
}
