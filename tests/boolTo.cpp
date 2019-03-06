#include <iostream>
#include <vector>

#include "../CodeGen.h"

int main() {
  CodeGen::Setup();

  //////// MAIN.
  std::vector<std::tuple<std::string, AbstractType, int>> mainArguments;
  CodeGen::CreateFunction("main", AbstractType::Integer, mainArguments);

  CodeGen::CreateVariable(AbstractType::Bool, "boolVariable");
  CodeGen::CreateVariable(AbstractType::Integer, "integerVariable");
  CodeGen::CreateVariable(AbstractType::Float, "floatVariable");

  CodeGen::Assign("boolVariable", CodeGen::ProduceBool(true));
  CodeGen::Assign("integerVariable",
                  CodeGen::CastBoolToInteger(CodeGen::GetVariable("boolVariable")));
  CodeGen::Assign("floatVariable",
                  CodeGen::CastBoolToFloat(CodeGen::GetVariable("boolVariable")));

  CodeGen::CallFunction("putInteger", { CodeGen::GetVariable("integerVariable") });
  CodeGen::CallFunction("putFloat", { CodeGen::GetVariable("floatVariable") });

  CodeGen::Assign("boolVariable", CodeGen::ProduceBool(false));
  CodeGen::Assign("integerVariable",
                  CodeGen::CastBoolToInteger(CodeGen::GetVariable("boolVariable")));
  CodeGen::Assign("floatVariable",
                  CodeGen::CastBoolToFloat(CodeGen::GetVariable("boolVariable")));

  CodeGen::CallFunction("putInteger", { CodeGen::GetVariable("integerVariable") });
  CodeGen::CallFunction("putFloat", { CodeGen::GetVariable("floatVariable") });


  CodeGen::Return(CodeGen::ProduceInteger(0));
  CodeGen::EndFunction();

  CodeGen::PrintBitCode();
  return 0;
}
