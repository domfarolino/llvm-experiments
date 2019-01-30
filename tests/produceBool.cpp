#include <iostream>
#include <vector>

#include "../CodeGen.h"

int main() {
  CodeGen::Setup();

  //////// MAIN.
  std::vector<std::pair<std::string, AbstractType>> mainArguments;
  CodeGen::CreateFunction("main", AbstractType::Integer, mainArguments);

  CodeGen::CreateFunction("useIf", AbstractType::Void, {});
  CodeGen::IfThen(CodeGen::ProduceBool(false));
  CodeGen::CallFunction("putString", { CodeGen::ProduceString("it was true!") });
  CodeGen::Else();
  CodeGen::CallFunction("putString", { CodeGen::ProduceString("it was false!") });
  CodeGen::EndIf();
  CodeGen::EndFunction();

  CodeGen::CallFunction("useIf", {});
  CodeGen::Return(CodeGen::ProduceInteger(0));
  CodeGen::EndFunction();

  CodeGen::PrintBitCode();
  return 0;
}
