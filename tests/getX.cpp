#include <iostream>
#include <vector>

#include "../CodeGen.h"

int main() {
  CodeGen::Setup();

  //////// MAIN.
  std::vector<std::pair<std::string, AbstractType>> mainArguments;
  CodeGen::CreateFunction("main", AbstractType::Integer, mainArguments);

  // Body of main.
  // Create future argument variables.
  CodeGen::CreateVariable(AbstractType::Integer, "myInteger");
  CodeGen::CreateVariable(AbstractType::Float, "myFloat");
  CodeGen::CreateVariable(AbstractType::Bool, "myBool");
  CodeGen::CreateVariable(AbstractType::Char, "myChar");

  CodeGen::CallFunction("putString", { CodeGen::ProduceString("Enter an integer:") });
  CodeGen::CallFunction("getInteger", { CodeGen::GetVariableReference("myInteger") });
  CodeGen::CallFunction("putString", { CodeGen::ProduceString("Enter a float:") });
  CodeGen::CallFunction("getFloat",   { CodeGen::GetVariableReference("myFloat") });
  CodeGen::CallFunction("putString", { CodeGen::ProduceString("Enter a bool:") });
  CodeGen::CallFunction("getBool",    { CodeGen::GetVariableReference("myBool") });
  CodeGen::CallFunction("putString", { CodeGen::ProduceString("Enter a char:") });
  CodeGen::CallFunction("getChar",    { CodeGen::GetVariableReference("myChar") });

  // Print out the variables.
  CodeGen::CallFunction("putString", { CodeGen::ProduceString("Results:") });
  CodeGen::CallFunction("putInteger", { CodeGen::GetVariable("myInteger") });
  CodeGen::CallFunction("putFloat", { CodeGen::GetVariable("myFloat") });
  CodeGen::CallFunction("putBool", { CodeGen::GetVariable("myBool") });
  CodeGen::CallFunction("putChar", { CodeGen::GetVariable("myChar") });

  CodeGen::Return(CodeGen::ProduceInteger(0));
  CodeGen::EndFunction();

  CodeGen::PrintBitCode();
  return 0;
}
