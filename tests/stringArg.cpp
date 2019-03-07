#include <iostream>
#include <vector>

#include "../CodeGen.h"

int main() {
  CodeGen::Setup();

  //////// MAIN.
  std::vector<std::tuple<std::string, AbstractType, int>> mainArguments;
  CodeGen::CreateFunction("main", AbstractType::Integer, mainArguments);

  std::vector<std::tuple<std::string, AbstractType, int>> modifyArgsArguments =
    { std::make_tuple("stringArg", AbstractType::String, 0) };

  // Create |stringFunc| that.
  CodeGen::CreateFunction("stringFunc", AbstractType::Void, modifyArgsArguments);
    // Print the given string argument.
    CodeGen::CallFunction("putString", { CodeGen::ProduceString("stringArg (pre-modification):") });
    CodeGen::CallFunction("putString", { CodeGen::GetVariable("stringArg") });

    // Assign the given non-reference string argument to something else.
    CodeGen::Assign("stringArg", CodeGen::ProduceString("farolino"));

    CodeGen::CallFunction("putString", { CodeGen::ProduceString("stringArg (post-modification):") });
    CodeGen::CallFunction("putString", { CodeGen::GetVariable("stringArg") });
  CodeGen::EndFunction();

  // Body of main.
  // Create future argument variable.
  CodeGen::CreateVariable(AbstractType::String, "myString", false, false, 0, CodeGen::ProduceString("dominic"));

  // Print "before" value.
  CodeGen::CallFunction("putString", { CodeGen::ProduceString("myString (pre-modification call):") });
  CodeGen::CallFunction("putString", { CodeGen::GetVariable("myString") });

  // Call |modifyArgs|.
  CodeGen::CallFunction("stringFunc", { CodeGen::GetVariable("myString") });

  // Print "after" values.
  CodeGen::CallFunction("putString", { CodeGen::ProduceString("myString (post-modification call):") });
  CodeGen::CallFunction("putString", { CodeGen::GetVariable("myString") });

  CodeGen::Return(CodeGen::ProduceInteger(0));
  CodeGen::EndFunction();

  CodeGen::PrintBitCode("stringArg");
  return 0;
}
