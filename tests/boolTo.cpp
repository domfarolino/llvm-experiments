#include <iostream>
#include <vector>

#include "../CodeGen.h"

int main() {
  CodeGen::Setup();

  //////// MAIN.
  std::vector<std::pair<std::string, AbstractType>> mainArguments;
  CodeGen::CreateFunction("main", AbstractType::Integer, mainArguments);

  // TODO(domfarolino): In the morning when you wake up, you should write tests
  // for the bool => * conversions so we can commit the change and close #18.
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
