#include <iostream>
#include <vector>

#include "../CodeGen.h"

int main() {
  CodeGen::Setup();

  //////// MAIN.
  std::vector<std::tuple<std::string, AbstractType, int>> mainArguments;
  CodeGen::CreateFunction("main", AbstractType::Integer, mainArguments);

  // Body of main.
  // Create future argument variables.
  CodeGen::CreateVariable(AbstractType::Integer, "myInteger");
  CodeGen::CreateVariable(AbstractType::Float, "myFloat");
  CodeGen::CreateVariable(AbstractType::Bool, "myBool");
  CodeGen::CreateVariable(AbstractType::Char, "myChar");
  CodeGen::CreateVariable(AbstractType::String, "myString");

  // Give |myString| a longer value so we can dump more text into it.
  CodeGen::Assign("myString", CodeGen::ProduceString("my long string of 31 characters"));

  CodeGen::CallFunction("putString", { CodeGen::ProduceString("Enter an integer:") });
  CodeGen::CallFunction("getInteger",{ CodeGen::GetVariableReference("myInteger") });
  CodeGen::CallFunction("putString", { CodeGen::ProduceString("Enter a float:") });
  CodeGen::CallFunction("getFloat",  { CodeGen::GetVariableReference("myFloat") });
  CodeGen::CallFunction("putString", { CodeGen::ProduceString("Enter a bool:") });
  CodeGen::CallFunction("getBool",   { CodeGen::GetVariableReference("myBool") });
  CodeGen::CallFunction("putString", { CodeGen::ProduceString("Enter a char:") });
  CodeGen::CallFunction("getChar",   { CodeGen::GetVariableReference("myChar") });
  CodeGen::CallFunction("putString", { CodeGen::ProduceString("Enter a string:") });
  CodeGen::CallFunction("getString", { CodeGen::GetVariableReference("myString") });

  // Print out the variables.
  CodeGen::CallFunction("putString", { CodeGen::ProduceString("Results:") });
  CodeGen::CallFunction("putInteger", { CodeGen::GetVariable("myInteger") });
  CodeGen::CallFunction("putFloat", { CodeGen::GetVariable("myFloat") });
  CodeGen::CallFunction("putBool", { CodeGen::GetVariable("myBool") });
  CodeGen::CallFunction("putChar", { CodeGen::GetVariable("myChar") });
  CodeGen::CallFunction("putString", { CodeGen::GetVariable("myString") });

  CodeGen::Return(CodeGen::ProduceInteger(0));
  CodeGen::EndFunction();

  CodeGen::PrintBitCode("getX");
  return 0;
}
