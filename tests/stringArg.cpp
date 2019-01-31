#include <iostream>
#include <vector>

#include "../CodeGen.h"

int main() {
  CodeGen::Setup();

  //////// MAIN.
  std::vector<std::pair<std::string, AbstractType>> mainArguments;
  CodeGen::CreateFunction("main", AbstractType::Integer, mainArguments);

  std::vector<std::pair<std::string, AbstractType>> modifyArgsArguments = 
    { std::make_pair("stringArg", AbstractType::String) };

  CodeGen::CreateFunction("stringFunc", AbstractType::Void, modifyArgsArguments);
  CodeGen::CallFunction("putString", { CodeGen::ProduceString("stringArg:") });
  CodeGen::CallFunction("putString", { CodeGen::GetVariable("stringArg") });

  CodeGen::Assign("stringArg", CodeGen::ProduceString("farolino"));

  CodeGen::CallFunction("putString", { CodeGen::ProduceString("stringArg:") });
  CodeGen::CallFunction("putString", { CodeGen::GetVariable("stringArg") });
  CodeGen::EndFunction();

  // Body of main.
  // Create future argument variables.
  CodeGen::CreateVariable(AbstractType::String, "myString", false, CodeGen::ProduceString("dominic"));

  // Print "before" value.
  CodeGen::CallFunction("putString", { CodeGen::ProduceString("myString:") });
  CodeGen::CallFunction("putString", { CodeGen::GetVariable("myString") });

  // Call |modifyArgs|.
  CodeGen::CallFunction("stringFunc", { CodeGen::GetVariable("myString") });

  // Print "after" values.
  CodeGen::CallFunction("putString", { CodeGen::ProduceString("myString:") });
  CodeGen::CallFunction("putString", { CodeGen::GetVariable("myString") });

  CodeGen::Return(CodeGen::ProduceInteger(0));
  CodeGen::EndFunction();

  CodeGen::PrintBitCode();
  return 0;
}
