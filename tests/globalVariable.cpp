#include <iostream>
#include <vector>

#include "../CodeGen.h"

int main() {
  CodeGen::Setup();

  //////// MAIN.
  std::vector<std::pair<std::string, AbstractType>> mainArguments;
  CodeGen::CreateFunction("main", AbstractType::Integer, mainArguments);

  CodeGen::CreateFunction("mutateGlobal", AbstractType::Void, {});
  CodeGen::CreateVariable(AbstractType::Integer, "globalInteger", true);
  CodeGen::Assign("globalInteger", CodeGen::ProduceInteger(234));
  CodeGen::CreateVariable(AbstractType::Integer, "tmp", false, CodeGen::AddIntegers(CodeGen::ProduceInteger(10), CodeGen::GetVariable("globalInteger")));
  CodeGen::CallFunction("putString", { CodeGen::ProduceString("tmp:") });
  CodeGen::CallFunction("putInteger", { CodeGen::GetVariable("tmp") });
  CodeGen::EndFunction();

  CodeGen::CallFunction("mutateGlobal", {});
  CodeGen::CallFunction("putInteger", { CodeGen::GetVariable("globalInteger") });

  CodeGen::Return(CodeGen::ProduceInteger(0));
  CodeGen::EndFunction();

  CodeGen::PrintBitCode();
  return 0;
}
