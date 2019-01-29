#include <iostream>
#include <vector>

#include "../CodeGen.h"

int main() {
  CodeGen::Setup();

  //////// MAIN.
  std::vector<std::pair<std::string, AbstractType>> mainArguments;
  CodeGen::CreateFunction("main", AbstractType::Integer, mainArguments);

  CodeGen::CallFunction("putBool", { CodeGen::ProduceBool(true) });
  CodeGen::CallFunction("putInteger", { CodeGen::ProduceInteger(234) });
  CodeGen::CallFunction("putFloat", { CodeGen::ProduceFloat(10.8094) });
  CodeGen::CallFunction("putChar", { CodeGen::ProduceChar('d') });
  CodeGen::CallFunction("putString", { CodeGen::ProduceString("This is a string test!") });
  CodeGen::Return(CodeGen::ProduceInteger(0));
  CodeGen::EndFunction();

  CodeGen::PrintBitCode();
  return 0;
}
