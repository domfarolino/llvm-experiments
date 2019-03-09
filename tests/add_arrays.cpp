#include <iostream>
#include <vector>

#include "../CodeGen.h"

int main() {
  CodeGen::Setup();

  //////// MAIN.
  std::vector<std::tuple<std::string, AbstractType, int>> mainArguments;
  CodeGen::CreateFunction("main", AbstractType::Integer, mainArguments);

  // Body of main.
  // Create future argument variable.
  CodeGen::CreateVariable(AbstractType::IntegerArray, "first_int_array", false, true, 6);
  CodeGen::CreateVariable(AbstractType::IntegerArray, "second_int_array", false, true, 6);

  CodeGen::CreateVariable(AbstractType::FloatArray, "first_float_array", false, true, 6);
  CodeGen::CreateVariable(AbstractType::FloatArray, "second_float_array", false, true, 6);
  // Assign all array elements.
  CodeGen::CreateVariable(AbstractType::Integer, "i");
  CodeGen::For();
  CodeGen::ForCondition(CodeGen::LessThanIntegers(CodeGen::GetVariable("i"), CodeGen::ProduceInteger(6)));
    // Assign elements.
    CodeGen::CallFunction("putString", { CodeGen::ProduceString("Top-level assigning array element") });
    CodeGen::Assign(CodeGen::IndexArray(CodeGen::GetVariableReference("first_int_array"), CodeGen::GetVariable("i")), CodeGen::ProduceInteger(2));
    CodeGen::Assign(CodeGen::IndexArray(CodeGen::GetVariableReference("second_int_array"), CodeGen::GetVariable("i")), CodeGen::ProduceInteger(3));

    CodeGen::Assign(CodeGen::IndexArray(CodeGen::GetVariableReference("first_float_array"), CodeGen::GetVariable("i")), CodeGen::ProduceFloat(1.8));
    CodeGen::Assign(CodeGen::IndexArray(CodeGen::GetVariableReference("second_float_array"), CodeGen::GetVariable("i")), CodeGen::ProduceFloat(3.4));

    CodeGen::Assign("i", CodeGen::AddIntegers(CodeGen::GetVariable("i"), CodeGen::ProduceInteger(1)));
  CodeGen::EndFor();

  // Reset i = 0, for next loop.
  CodeGen::Assign("i", CodeGen::ProduceInteger(0));

  // Print all array elements.
  CodeGen::CallFunction("putString", { CodeGen::ProduceString("Top-level printing given array values") });
  CodeGen::For();
  CodeGen::ForCondition(CodeGen::LessThanIntegers(CodeGen::GetVariable("i"), CodeGen::ProduceInteger(6)));
    CodeGen::CallFunction("putInteger", {  CodeGen::Load(CodeGen::IndexArray(CodeGen::GetVariableReference("first_int_array"), CodeGen::GetVariable("i")))   });
    CodeGen::CallFunction("putInteger", {  CodeGen::Load(CodeGen::IndexArray(CodeGen::GetVariableReference("second_int_array"), CodeGen::GetVariable("i")))   });

    CodeGen::CallFunction("putFloat", {  CodeGen::Load(CodeGen::IndexArray(CodeGen::GetVariableReference("first_float_array"), CodeGen::GetVariable("i")))   });
    CodeGen::CallFunction("putFloat", {  CodeGen::Load(CodeGen::IndexArray(CodeGen::GetVariableReference("second_float_array"), CodeGen::GetVariable("i")))   });
    CodeGen::Assign("i", CodeGen::AddIntegers(CodeGen::GetVariable("i"), CodeGen::ProduceInteger(1)));
  CodeGen::EndFor();

  CodeGen::Assign(CodeGen::GetVariableReference("first_int_array"),
                  CodeGen::AddIntegerArrays(
                    CodeGen::GetVariableReference("first_int_array"),
                    CodeGen::GetVariableReference("second_int_array"),
                    6)
                 );
  CodeGen::Assign(CodeGen::GetVariableReference("first_int_array"),
                  CodeGen::AddIntegerArrays(
                    CodeGen::GetVariableReference("first_int_array"),
                    CodeGen::GetVariableReference("second_int_array"),
                    6)
                 );
  CodeGen::Assign(CodeGen::GetVariableReference("first_float_array"),
                  CodeGen::AddFloatArrays(
                    CodeGen::GetVariableReference("first_float_array"),
                    CodeGen::GetVariableReference("second_float_array"),
                    6)
                 );
  CodeGen::Assign(CodeGen::GetVariableReference("first_float_array"),
                  CodeGen::AddFloatArrays(
                    CodeGen::GetVariableReference("first_float_array"),
                    CodeGen::GetVariableReference("second_float_array"),
                    6)
                 );

  // Reset i = 0, for next loop.
  CodeGen::Assign("i", CodeGen::ProduceInteger(0));

  // Print all array elements.
  CodeGen::CallFunction("putString", { CodeGen::ProduceString("Top-level printing given array values") });
  CodeGen::For();
  CodeGen::ForCondition(CodeGen::LessThanIntegers(CodeGen::GetVariable("i"), CodeGen::ProduceInteger(6)));
    CodeGen::CallFunction("putInteger", {  CodeGen::Load(CodeGen::IndexArray(CodeGen::GetVariableReference("first_int_array"), CodeGen::GetVariable("i")))   });
    CodeGen::CallFunction("putInteger", {  CodeGen::Load(CodeGen::IndexArray(CodeGen::GetVariableReference("second_int_array"), CodeGen::GetVariable("i")))   });

    CodeGen::CallFunction("putFloat", {  CodeGen::Load(CodeGen::IndexArray(CodeGen::GetVariableReference("first_float_array"), CodeGen::GetVariable("i")))   });
    CodeGen::CallFunction("putFloat", {  CodeGen::Load(CodeGen::IndexArray(CodeGen::GetVariableReference("second_float_array"), CodeGen::GetVariable("i")))   });

    CodeGen::Assign("i", CodeGen::AddIntegers(CodeGen::GetVariable("i"), CodeGen::ProduceInteger(1)));
  CodeGen::EndFor();

  CodeGen::Return(CodeGen::ProduceInteger(0));
  CodeGen::EndFunction();

  CodeGen::PrintBitCode("add_arrays");
  return 0;
}
