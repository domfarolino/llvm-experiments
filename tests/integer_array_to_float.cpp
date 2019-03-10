#include <iostream>
#include <vector>

#include "../CodeGen.h"

int main() {
  CodeGen::Setup();

  //////// MAIN.
  std::vector<std::tuple<std::string, AbstractType, int>> mainArguments;
  CodeGen::CreateFunction("main", AbstractType::Integer, mainArguments);

  CodeGen::CreateVariable(AbstractType::IntegerArray, "integer_array", false, true, 6);
  CodeGen::CreateVariable(AbstractType::FloatArray, "float_array", false, true, 6);

  // Assign all array elements.
  CodeGen::CreateVariable(AbstractType::Integer, "i");
  CodeGen::For();
  CodeGen::ForCondition(CodeGen::LessThanIntegers(CodeGen::GetVariable("i"), CodeGen::ProduceInteger(6)));
    // Assign elements.
    CodeGen::Assign(CodeGen::IndexArray(CodeGen::GetVariableReference("integer_array"), CodeGen::GetVariable("i")), CodeGen::ProduceInteger(2));
    CodeGen::Assign("i", CodeGen::AddIntegers(CodeGen::GetVariable("i"), CodeGen::ProduceInteger(1)));
  CodeGen::EndFor();

  CodeGen::Assign(CodeGen::GetVariableReference("float_array"),
                  CodeGen::Load(CodeGen::CastIntegerArrayToFloatArray(CodeGen::GetVariableReference("integer_array"))));

  // Reset i = 0, for next loop.
  CodeGen::Assign("i", CodeGen::ProduceInteger(0));

  // Print all array elements.
  CodeGen::CallFunction("putString", { CodeGen::ProduceString("Printing |float_array| after |CastIntegerArrayToFloatArray()|:") });
  CodeGen::For();
  CodeGen::ForCondition(CodeGen::LessThanIntegers(CodeGen::GetVariable("i"), CodeGen::ProduceInteger(6)));
    CodeGen::CallFunction("putFloat", {  CodeGen::Load(CodeGen::IndexArray(CodeGen::GetVariableReference("float_array"), CodeGen::GetVariable("i")))   });
    CodeGen::Assign("i", CodeGen::AddIntegers(CodeGen::GetVariable("i"), CodeGen::ProduceInteger(1)));
  CodeGen::EndFor();

  CodeGen::Return(CodeGen::ProduceInteger(0));
  CodeGen::EndFunction();

  CodeGen::PrintBitCode("integer_array_to_float");
  return 0;
}
