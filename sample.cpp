#include <iostream>
#include <vector>

#include "CodeGen.h"

int main() {
  CodeGen::Setup();

  //////// MAIN.
  std::vector<std::tuple<std::string, AbstractType, int>> mainArguments;
  CodeGen::CreateFunction("main", AbstractType::Integer, mainArguments);

        //////// FloatAdder.
        std::vector<std::tuple<std::string, AbstractType, int>> floatArguments = {
          std::make_tuple("floatLeft", AbstractType::Float, 0),
          std::make_tuple("floatRight", AbstractType::Float, 0)
        };
        CodeGen::CreateFunction("FloatAdder", AbstractType::Float, floatArguments);
        Value* returnValue = CodeGen::DivideFloats(CodeGen::GetVariable("floatLeft"), CodeGen::GetVariable("floatRight"), "floatAddUltimateReturn");

        /////// CALL putFloat from FloatAdder.
        CodeGen::CallFunction("putString", { CodeGen::ProduceString("FloatAdder returning:") });
        CodeGen::CallFunction("putFloat", { returnValue });
        CodeGen::Return(returnValue);
        CodeGen::EndFunction();
        //////// END FloatAdder.

        //////// IntegerAdder.
        std::vector<std::tuple<std::string, AbstractType, int>> integerArguments = {
          std::make_tuple("integerLeft", AbstractType::Integer, 0),
          std::make_tuple("integerRight", AbstractType::Integer, 0)
        };
        CodeGen::CreateFunction("IntegerAdder", AbstractType::Integer, integerArguments );
        returnValue = CodeGen::DivideIntegers(CodeGen::GetVariable("integerLeft"), CodeGen::GetVariable("integerRight"), "integerAddUltimateReturn");

        /////// CALL putInteger from AdderFunction.
        CodeGen::CallFunction("putString", { CodeGen::ProduceString("IntegerAdder returning:") });
        CodeGen::CallFunction("putInteger", { returnValue });
        CodeGen::Return(returnValue);
        CodeGen::EndFunction();
        //////// END FloatAdder.

  /////// Function takes a integer.
  CodeGen::CreateFunction("integerFunction", AbstractType::Void, { std::make_tuple("integerArgument", AbstractType::Integer, 0) });
  CodeGen::IfThen(CodeGen::LessThanIntegers(CodeGen::GetVariable("integerArgument"), CodeGen::ProduceInteger(10)));               // if (integerArgument < 10) {
    CodeGen::IfThen(CodeGen::LessThanOrEqualIntegers(CodeGen::GetVariable("integerArgument"), CodeGen::ProduceInteger(5)));       //   if (integerArgument <= 5) {
      CodeGen::CallFunction("printf", { CodeGen::ProduceString("%d <= 5\n"), CodeGen::GetVariable("integerArgument")});           //     printf("%d <= 5\n", integerArgument);
      //CodeGen::Return();                                                                                                          //     return; // just for POC.
    CodeGen::Else();                                                                                                              //   } else {
      CodeGen::CallFunction("printf", { CodeGen::ProduceString("%d > 5\n"), CodeGen::GetVariable("integerArgument")});            //     printf("%d > 5\n", integerArgument);
      //CodeGen::Return();                                                                                                          //     return; // just for POC;
    CodeGen::EndIf();                                                                                                             //   }
    CodeGen::Assign("integerArgument", CodeGen::AddIntegers(CodeGen::GetVariable("integerArgument"), CodeGen::ProduceInteger(1)));//   integerArgument = integerArgument + 1;
    CodeGen::CallFunction("integerFunction", { CodeGen::GetVariable("integerArgument") });                                        //   integerFunction(integerArgument);
  CodeGen::Else();                                                                                                                // } else {
    CodeGen::CallFunction("printf", { CodeGen::ProduceString("All finished!!\n") });                                              //   printf("All finished!!\n");
  CodeGen::EndIf();

  CodeGen::EndFunction();

  /////// Function takes a float.
  CodeGen::CreateFunction("floatFunction", AbstractType::Void, { std::make_tuple("floatArgument", AbstractType::Float, 0) });
  CodeGen::EndFunction();

  /////// Factorial function.
  CodeGen::CreateFunction("fibonacci", AbstractType::Integer, { std::make_tuple("n", AbstractType::Integer, 0) });
  CodeGen::CreateVariable(AbstractType::Integer, "first");
  CodeGen::CreateVariable(AbstractType::Integer, "second");
  CodeGen::CreateVariable(AbstractType::Integer, "tmp");
  CodeGen::Assign("first", CodeGen::ProduceInteger(1));
  CodeGen::Assign("second", CodeGen::ProduceInteger(1));
  CodeGen::For();
  CodeGen::ForCondition(CodeGen::GreaterThanIntegers(CodeGen::GetVariable("n"), CodeGen::ProduceInteger(1)));
    CodeGen::Assign("tmp", CodeGen::GetVariable("first"));
    CodeGen::Assign("first", CodeGen::GetVariable("second"));
    CodeGen::Assign("second", CodeGen::AddIntegers(CodeGen::GetVariable("second"), CodeGen::GetVariable("tmp")));
    CodeGen::Assign("n", CodeGen::SubtractIntegers(CodeGen::GetVariable("n"), CodeGen::ProduceInteger(1)));
  CodeGen::EndFor();
  CodeGen::Return(CodeGen::GetVariable("first"));
  CodeGen::EndFunction();

  /////// Function nSquared
  CodeGen::CreateFunction("nSquared", AbstractType::Void, { std::make_tuple("k", AbstractType::Integer, 0) });
  CodeGen::CreateVariable(AbstractType::Integer, "i");
  CodeGen::CreateVariable(AbstractType::Integer, "j");

  CodeGen::Assign("i", CodeGen::ProduceInteger(0));
  CodeGen::For();
  CodeGen::ForCondition(CodeGen::LessThanIntegers(CodeGen::GetVariable("i"), CodeGen::GetVariable("k")));

    CodeGen::Assign("j", CodeGen::ProduceInteger(0));
    CodeGen::For();
    CodeGen::ForCondition(CodeGen::LessThanOrEqualIntegers(CodeGen::GetVariable("j"), CodeGen::GetVariable("i")));
      CodeGen::CallFunction("printf", { CodeGen::ProduceString("i: %d, j: %d\n"), CodeGen::GetVariable("i"), CodeGen::GetVariable("j") });
      CodeGen::Assign("j", CodeGen::AddIntegers(CodeGen::GetVariable("j"), CodeGen::ProduceInteger(1)));
    CodeGen::EndFor();

  CodeGen::Assign("i", CodeGen::AddIntegers(CodeGen::GetVariable("i"), CodeGen::ProduceInteger(1)));
  CodeGen::EndFor();
  CodeGen::EndFunction();

  /////// Function takes a char.
  CodeGen::CreateFunction("charFunction", AbstractType::Void, { std::make_tuple("charArgument", AbstractType::Char, 0) });
  CodeGen::EndFunction();

  /////// Function takes a string.
  CodeGen::CreateFunction("stringFunction", AbstractType::Void, { std::make_tuple("stringArgument", AbstractType::String, 0) });
  CodeGen::EndFunction();

  Value* floatAdderReturn = CodeGen::CallFunction("FloatAdder", {CodeGen::ProduceFloat(42), CodeGen::ProduceFloat(38)}, "calladder");
  Value* integerAdderReturn = CodeGen::CallFunction("IntegerAdder", {CodeGen::ProduceInteger(42), CodeGen::ProduceInteger(38)}, "calladder");

  /////// CALL printf for {float, integer}AdderReturn values.
  std::vector<Value*> printfArguments = { CodeGen::ProduceString("FloatAdderResult(from main): %f\n"), floatAdderReturn };
  CodeGen::CallFunction("printf", printfArguments, "callprintfFloatAdder");
  CodeGen::CallFunction("printf", { CodeGen::ProduceString("IntegerAdderResult(from main): %d\n"), integerAdderReturn }, "callprintfIntegerAdder");

  /////// CALL integerFunction.
  Value* castToBool = CodeGen::CastFloatToBool(floatAdderReturn);
  CodeGen::CallFunction("integerFunction", { CodeGen::ProduceInteger(0) });
  CodeGen::CallFunction("printf", { CodeGen::ProduceString("fibonacci: %d\n"), CodeGen::CallFunction("fibonacci", { CodeGen::ProduceInteger(6) }) });
  CodeGen::CallFunction("nSquared", { CodeGen::ProduceInteger(7) });
  CodeGen::Return(integerAdderReturn);
  CodeGen::EndFunction();

  CodeGen::PrintBitCode("sample");
  return 0;
}
