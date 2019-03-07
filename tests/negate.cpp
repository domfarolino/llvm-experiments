#include <iostream>
#include <vector>

#include "../CodeGen.h"

int main() {
  CodeGen::Setup();

  //////// MAIN.
  std::vector<std::tuple<std::string, AbstractType, int>> mainArguments;
  CodeGen::CreateFunction("main", AbstractType::Integer, mainArguments);

  /////// Function takes a integer.
  CodeGen::CreateFunction("negateInteger", AbstractType::Void, { std::make_tuple("integerArgument", AbstractType::Integer, 0) });
  CodeGen::Assign("integerArgument", CodeGen::NegateInteger(CodeGen::GetVariable("integerArgument")));
  CodeGen::CallFunction("putString", { CodeGen::ProduceString("integerArgument:") });
  CodeGen::CallFunction("putInteger", { CodeGen::GetVariable("integerArgument") });
  CodeGen::EndFunction();

  /////// Function takes a float.
  CodeGen::CreateFunction("negateFloat", AbstractType::Void, { std::make_tuple("floatArgument", AbstractType::Float, 0) });
  CodeGen::Assign("floatArgument", CodeGen::NegateFloat(CodeGen::GetVariable("floatArgument")));
  CodeGen::CallFunction("putString", { CodeGen::ProduceString("floatArgument:") });
  CodeGen::CallFunction("putFloat", { CodeGen::GetVariable("floatArgument") });
  CodeGen::EndFunction();

  // Call the negate-and-print functions for testing.
  CodeGen::CallFunction("negateInteger", { CodeGen::ProduceInteger(234) });
  CodeGen::CallFunction("negateFloat", { CodeGen::ProduceFloat(10.8094) });

  // Return.
  CodeGen::Return(CodeGen::ProduceInteger(0));
  CodeGen::EndFunction();

  CodeGen::PrintBitCode("negate");
  return 0;
}
