#include <iostream>
#include <vector>

#include "../CodeGen.h"

int main() {
  CodeGen::Setup();

  //////// MAIN.
  std::vector<std::pair<std::string, AbstractType>> mainArguments;
  CodeGen::CreateFunction("main", AbstractType::Integer, mainArguments);

  std::vector<std::pair<std::string, AbstractType>> modifyArgsArguments =
    {
      std::make_pair("outInteger", AbstractType::IntegerRef),
      std::make_pair("outFloat", AbstractType::FloatRef),
      std::make_pair("outBool", AbstractType::BoolRef),
      std::make_pair("outChar", AbstractType::CharRef),
      std::make_pair("outString", AbstractType::StringRef),
    };

  // Create a function that takes a bunch of reference variables.
  CodeGen::CreateFunction("modifyArgs", AbstractType::Void, modifyArgsArguments);

  // Modify all of the output reference variables.
  CodeGen::AssignReferenceVariable("outInteger", CodeGen::AddIntegers(CodeGen::GetReferenceVariableValue("outInteger"), CodeGen::ProduceInteger(234)));
  CodeGen::AssignReferenceVariable("outFloat", CodeGen::ProduceFloat(234.09324));
  CodeGen::AssignReferenceVariable("outBool", CodeGen::ProduceBool(true));
  CodeGen::AssignReferenceVariable("outChar", CodeGen::ProduceChar('d'));
  CodeGen::AssignReferenceVariable("outString", CodeGen::ProduceString("i have been modified!"));
  //CodeGen::CallFunction("putInteger", { CodeGen::GetReferenceVariableValue("input") });
  CodeGen::EndFunction();

  // Body of main.
  // Create future argument variables.
  CodeGen::CreateVariable(AbstractType::Integer, "myInteger", false, false, CodeGen::ProduceInteger(123));
  CodeGen::CreateVariable(AbstractType::Float, "myFloat", false, false, CodeGen::ProduceFloat(123.03493));
  CodeGen::CreateVariable(AbstractType::Bool, "myBool", false, false, CodeGen::ProduceBool(false));
  CodeGen::CreateVariable(AbstractType::Char, "myChar", false, false, CodeGen::ProduceChar('a'));
  CodeGen::CreateVariable(AbstractType::String, "myString", false, false, CodeGen::ProduceString("initial"));

  // Print "before" values.
  CodeGen::CallFunction("putString", { CodeGen::ProduceString("Before:") });
  CodeGen::CallFunction("putInteger", { CodeGen::GetVariable("myInteger") });
  CodeGen::CallFunction("putFloat", { CodeGen::GetVariable("myFloat") });
  CodeGen::CallFunction("putBool", { CodeGen::GetVariable("myBool") });
  CodeGen::CallFunction("putChar", { CodeGen::GetVariable("myChar") });
  CodeGen::CallFunction("putString", { CodeGen::GetVariable("myString") });

  // Call |modifyArgs|.
  CodeGen::CallFunction("modifyArgs",
    {
      CodeGen::GetVariableReference("myInteger"),
      CodeGen::GetVariableReference("myFloat"),
      CodeGen::GetVariableReference("myBool"),
      CodeGen::GetVariableReference("myChar"),
      CodeGen::GetVariableReference("myString"),
    });

  // Print "after" values.
  CodeGen::CallFunction("putString", { CodeGen::ProduceString("After:") });
  CodeGen::CallFunction("putInteger", { CodeGen::GetVariable("myInteger") });
  CodeGen::CallFunction("putFloat", { CodeGen::GetVariable("myFloat") });
  CodeGen::CallFunction("putBool", { CodeGen::GetVariable("myBool") });
  CodeGen::CallFunction("putChar", { CodeGen::GetVariable("myChar") });
  CodeGen::CallFunction("putString", { CodeGen::GetVariable("myString") });

  CodeGen::Return(CodeGen::ProduceInteger(0));
  CodeGen::EndFunction();

  CodeGen::PrintBitCode();
  return 0;
}
