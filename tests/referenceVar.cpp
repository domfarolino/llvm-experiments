#include <iostream>
#include <vector>

#include "../CodeGen.h"

int main() {
  CodeGen::Setup();

  //////// MAIN.
  std::vector<std::tuple<std::string, AbstractType, int>> mainArguments;
  CodeGen::CreateFunction("main", AbstractType::Integer, mainArguments);

  std::vector<std::tuple<std::string, AbstractType, int>> modifyArgsArguments =
    {
      std::make_tuple("outInteger", AbstractType::IntegerRef, 0),
      std::make_tuple("outFloat", AbstractType::FloatRef, 0),
      std::make_tuple("outBool", AbstractType::BoolRef, 0),
      std::make_tuple("outChar", AbstractType::CharRef, 0),
      std::make_tuple("outString", AbstractType::StringRef, 0),
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
  CodeGen::CreateVariable(AbstractType::Integer, "myInteger", false, false, 0, CodeGen::ProduceInteger(123));
  CodeGen::CreateVariable(AbstractType::Float, "myFloat", false, false, 0, CodeGen::ProduceFloat(123.03493));
  CodeGen::CreateVariable(AbstractType::Bool, "myBool", false, false, 0, CodeGen::ProduceBool(false));
  CodeGen::CreateVariable(AbstractType::Char, "myChar", false, false, 0, CodeGen::ProduceChar('a'));
  CodeGen::CreateVariable(AbstractType::String, "myString", false, false, 0, CodeGen::ProduceString("initial"));

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

  CodeGen::PrintBitCode("referenceVar");
  return 0;
}
