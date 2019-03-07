#include <iostream>
#include <vector>

#include "../CodeGen.h"

int main() {
  CodeGen::Setup();

  //////// MAIN.
  std::vector<std::tuple<std::string, AbstractType, int>> mainArguments;
  CodeGen::CreateFunction("main", AbstractType::Integer, mainArguments);

  /////// Function takes a integer.
  CodeGen::CreateFunction("bitwiseAndInteger", AbstractType::Void, { std::make_tuple("arg1", AbstractType::Integer, 0), std::make_tuple("arg2", AbstractType::Integer, 0) });
  CodeGen::CreateVariable(AbstractType::Integer, "bitwiseResult");
  CodeGen::Assign("bitwiseResult", CodeGen::BitwiseAndIntegers(CodeGen::GetVariable("arg1"), CodeGen::GetVariable("arg2")));
  CodeGen::CallFunction("putString", { CodeGen::ProduceString("bitwise and result:") });
  CodeGen::CallFunction("putInteger", { CodeGen::GetVariable("bitwiseResult") });
  CodeGen::EndFunction();

  /////// Function takes a integer.
  CodeGen::CreateFunction("bitwiseOrInteger", AbstractType::Void, { std::make_tuple("arg1", AbstractType::Integer, 0), std::make_tuple("arg2", AbstractType::Integer, 0) });
  CodeGen::CreateVariable(AbstractType::Integer, "bitwiseResult");
  CodeGen::Assign("bitwiseResult", CodeGen::BitwiseOrIntegers(CodeGen::GetVariable("arg1"), CodeGen::GetVariable("arg2")));
  CodeGen::CallFunction("putString", { CodeGen::ProduceString("bitwise or result:") });
  CodeGen::CallFunction("putInteger", { CodeGen::GetVariable("bitwiseResult") });
  CodeGen::EndFunction();


  CodeGen::CallFunction("bitwiseAndInteger", { CodeGen::ProduceInteger(64), CodeGen::ProduceInteger(32) });
  CodeGen::CallFunction("bitwiseOrInteger", { CodeGen::ProduceInteger(64), CodeGen::ProduceInteger(32) });
  CodeGen::Return(CodeGen::ProduceInteger(0));
  CodeGen::EndFunction();

  CodeGen::PrintBitCode("bitwise");
  return 0;
}
