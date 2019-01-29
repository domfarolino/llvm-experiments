#include <iostream>
#include <vector>

#include "../CodeGen.h"

int main() {
  CodeGen::Setup();

  //////// MAIN.
  std::vector<std::pair<std::string, AbstractType>> mainArguments;
  CodeGen::CreateFunction("main", AbstractType::Integer, mainArguments);

  /////// Function takes a integer.
  CodeGen::CreateFunction("negateInteger", AbstractType::Void, { std::make_pair("integerArgument", AbstractType::Integer) });
  CodeGen::Assign("integerArgument", CodeGen::NegateInteger(CodeGen::GetVariable("integerArgument")));
  CodeGen::CallFunction("putString", { CodeGen::ProduceString("integerArgument:") });
  CodeGen::CallFunction("putInteger", { CodeGen::GetVariable("integerArgument") });
  CodeGen::EndFunction();

  /////// Function takes a float.
  CodeGen::CreateFunction("negateFloat", AbstractType::Void, { std::make_pair("floatArgument", AbstractType::Float) });
  CodeGen::Assign("floatArgument", CodeGen::NegateFloat(CodeGen::GetVariable("floatArgument")));
  CodeGen::CallFunction("putString", { CodeGen::ProduceString("floatArgument:") });
  CodeGen::CallFunction("putFloat", { CodeGen::GetVariable("floatArgument") });
  CodeGen::EndFunction();

  CodeGen::CallFunction("negateInteger", { CodeGen::ProduceInteger(234) });
  CodeGen::CallFunction("negateFloat", { CodeGen::ProduceFloat(10.8094) });
  CodeGen::Return(CodeGen::ProduceInteger(0));
  CodeGen::EndFunction();

  CodeGen::PrintBitCode();
  return 0;
}
