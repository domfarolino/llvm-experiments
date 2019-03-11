#include <iostream>
#include <vector>

#include "../CodeGen.h"

int main() {
  CodeGen::Setup();

  /////// MAIN.
  std::vector<std::tuple<std::string, AbstractType, int>> mainArguments;
  CodeGen::CreateFunction("main", AbstractType::Integer, mainArguments);

  // Body of main.
  // Create future argument variable.
  CodeGen::CreateVariable(AbstractType::IntegerArray, "first_int_array", false, true, 6);

  CodeGen::CreateVariable(AbstractType::FloatArray, "first_float_array", false, true, 6);
  CodeGen::CreateVariable(AbstractType::FloatArray, "final_float_array", false, true, 6);
  // Assign all array elements.
  CodeGen::CreateVariable(AbstractType::Integer, "i");
  CodeGen::CallFunction("putString", { CodeGen::ProduceString("Assigningn array elements") });
  CodeGen::For();
  CodeGen::ForCondition(CodeGen::LessThanIntegers(CodeGen::GetVariable("i"), CodeGen::ProduceInteger(6)));
    // Assign elements.
    CodeGen::Assign(CodeGen::IndexArray(CodeGen::GetVariableReference("first_int_array"), CodeGen::GetVariable("i")), CodeGen::GetVariable("i"));

    CodeGen::Assign(CodeGen::IndexArray(CodeGen::GetVariableReference("first_float_array"), CodeGen::GetVariable("i")), CodeGen::CastIntegerToFloat(CodeGen::GetVariable("i")));
    CodeGen::Assign("i", CodeGen::AddIntegers(CodeGen::GetVariable("i"), CodeGen::ProduceInteger(1)));
  CodeGen::EndFor();

  // Reset i = 0, for next loop.
  CodeGen::Assign("i", CodeGen::ProduceInteger(0));

  // Print all array elements.
  CodeGen::CallFunction("putString", { CodeGen::ProduceString("Top-level printing given array values") });
  CodeGen::For();
  CodeGen::ForCondition(CodeGen::LessThanIntegers(CodeGen::GetVariable("i"), CodeGen::ProduceInteger(6)));
    CodeGen::CallFunction("putInteger", {  CodeGen::Load(CodeGen::IndexArray(CodeGen::GetVariableReference("first_int_array"), CodeGen::GetVariable("i")))   });
    CodeGen::CallFunction("putFloat", {  CodeGen::Load(CodeGen::IndexArray(CodeGen::GetVariableReference("first_float_array"), CodeGen::GetVariable("i")))   });
    CodeGen::Assign("i", CodeGen::AddIntegers(CodeGen::GetVariable("i"), CodeGen::ProduceInteger(1)));
  CodeGen::EndFor();

  // This is testing |integer - float[]|.
  CodeGen::Assign(CodeGen::GetVariableReference("final_float_array"),
                  CodeGen::Load(CodeGen::SubtractArrays(
                    CodeGen::ProduceInteger(4),
                    CodeGen::GetVariableReference("first_float_array")))
                 );
  CodeGen::Assign(CodeGen::GetVariableReference("first_int_array"),
                  CodeGen::Load(CodeGen::SubtractArrays(
                    CodeGen::ProduceInteger(2),
                    CodeGen::GetVariableReference("first_int_array")))
                 );
  CodeGen::Assign(CodeGen::GetVariableReference("first_int_array"),
                  CodeGen::Load(CodeGen::SubtractArrays(
                    CodeGen::GetVariableReference("first_int_array"),
                    CodeGen::ProduceInteger(5)))
                 );
  CodeGen::Assign(CodeGen::GetVariableReference("first_float_array"),
                  CodeGen::Load(CodeGen::SubtractArrays(
                    CodeGen::ProduceFloat(2),
                    CodeGen::GetVariableReference("first_float_array")))
                 );
  CodeGen::Assign(CodeGen::GetVariableReference("first_float_array"),
                  CodeGen::Load(CodeGen::SubtractArrays(
                    CodeGen::GetVariableReference("first_float_array"),
                    CodeGen::ProduceFloat(5)))
                 );

  // Reset i = 0, for next loop.
  CodeGen::Assign("i", CodeGen::ProduceInteger(0));

  // Print all array elements.
  CodeGen::CallFunction("putString", { CodeGen::ProduceString("Printing the first and second integer and float arrays") });
  CodeGen::For();
  CodeGen::ForCondition(CodeGen::LessThanIntegers(CodeGen::GetVariable("i"), CodeGen::ProduceInteger(6)));
    CodeGen::CallFunction("putInteger", {  CodeGen::Load(CodeGen::IndexArray(CodeGen::GetVariableReference("first_int_array"), CodeGen::GetVariable("i")))   });
    CodeGen::CallFunction("putFloat", {  CodeGen::Load(CodeGen::IndexArray(CodeGen::GetVariableReference("first_float_array"), CodeGen::GetVariable("i")))   });

    CodeGen::Assign("i", CodeGen::AddIntegers(CodeGen::GetVariable("i"), CodeGen::ProduceInteger(1)));
  CodeGen::EndFor();

  // Reset i = 0, for next loop.
  CodeGen::Assign("i", CodeGen::ProduceInteger(0));

  // Print the |integer - float[]| array.
  CodeGen::CallFunction("putString", { CodeGen::ProduceString("Printing final_float_array (aka |integer - float[]|)") });
  CodeGen::For();
  CodeGen::ForCondition(CodeGen::LessThanIntegers(CodeGen::GetVariable("i"), CodeGen::ProduceInteger(6)));
    CodeGen::CallFunction("putFloat", {  CodeGen::Load(CodeGen::IndexArray(CodeGen::GetVariableReference("final_float_array"), CodeGen::GetVariable("i")))   });
    CodeGen::Assign("i", CodeGen::AddIntegers(CodeGen::GetVariable("i"), CodeGen::ProduceInteger(1)));
  CodeGen::EndFor();
  // Reset i = 0, for next loop.
  CodeGen::Assign("i", CodeGen::ProduceInteger(0));

  // This is testing |integer[] - float|.
  CodeGen::Assign(CodeGen::GetVariableReference("final_float_array"),
                  CodeGen::Load(CodeGen::SubtractArrays(
                    CodeGen::GetVariableReference("first_int_array"),
                    CodeGen::ProduceFloat(4)))
                 );

  // Print the |float + integer[]| array.
  CodeGen::CallFunction("putString", { CodeGen::ProduceString("Printing final_float_array (aka |integer[] - float|)") });
  CodeGen::For();
  CodeGen::ForCondition(CodeGen::LessThanIntegers(CodeGen::GetVariable("i"), CodeGen::ProduceInteger(6)));
    CodeGen::CallFunction("putFloat", {  CodeGen::Load(CodeGen::IndexArray(CodeGen::GetVariableReference("final_float_array"), CodeGen::GetVariable("i")))   });
    CodeGen::Assign("i", CodeGen::AddIntegers(CodeGen::GetVariable("i"), CodeGen::ProduceInteger(1)));
  CodeGen::EndFor();

  CodeGen::Return(CodeGen::ProduceInteger(0));
  CodeGen::EndFunction();

  CodeGen::PrintBitCode("subtract_array_scalar");
  return 0;
}
