#include <iostream>
#include <vector>

#include "../CodeGen.h"

int main() {
  CodeGen::Setup();

  //////// MAIN.
  std::vector<std::tuple<std::string, AbstractType, int>> mainArguments;
  CodeGen::CreateFunction("main", AbstractType::Integer, mainArguments);

  CodeGen::CreateVariable(AbstractType::IntegerArray, "first_int_array", false, true, 6);
  CodeGen::CreateVariable(AbstractType::IntegerArray, "second_int_array", false, true, 6);
  CodeGen::CreateVariable(AbstractType::IntegerArray, "result_int_array", false, true, 6);

  CodeGen::CreateVariable(AbstractType::BoolArray, "first_bool_array", false, true, 6);
  CodeGen::CreateVariable(AbstractType::BoolArray, "second_bool_array", false, true, 6);
  CodeGen::CreateVariable(AbstractType::BoolArray, "result_bool_array", false, true, 6);

  // First testing `&`.

  // Assign all array elements.
  CodeGen::CreateVariable(AbstractType::Integer, "i");
  CodeGen::For();
  CodeGen::ForCondition(CodeGen::LessThanIntegers(CodeGen::GetVariable("i"), CodeGen::ProduceInteger(6)));
    // Assign elements.
    CodeGen::Assign(CodeGen::IndexArray(CodeGen::GetVariableReference("first_int_array"), CodeGen::GetVariable("i")), CodeGen::Load(CodeGen::GetVariableReference("i")));
    CodeGen::Assign(CodeGen::IndexArray(CodeGen::GetVariableReference("second_int_array"), CodeGen::GetVariable("i")), CodeGen::ProduceInteger(2));

    CodeGen::Assign(CodeGen::IndexArray(CodeGen::GetVariableReference("first_bool_array"), CodeGen::GetVariable("i")), CodeGen::ProduceBool(true));
    CodeGen::Assign(CodeGen::IndexArray(CodeGen::GetVariableReference("second_bool_array"), CodeGen::GetVariable("i")), CodeGen::ProduceBool(false));
    CodeGen::Assign("i", CodeGen::AddIntegers(CodeGen::GetVariable("i"), CodeGen::ProduceInteger(1)));
  CodeGen::EndFor();

  // result_int_array = first_int_array & second_int_array;
  CodeGen::Assign(CodeGen::GetVariableReference("result_int_array"),
                  CodeGen::Load(CodeGen::AndArrays(CodeGen::GetVariableReference("first_int_array"),
                                                   CodeGen::GetVariableReference("second_int_array"),
                                                   6, AbstractType::Integer)));
  // result_bool_array = first_bool_array & second_bool_array;
  CodeGen::Assign(CodeGen::GetVariableReference("result_bool_array"),
                  CodeGen::Load(CodeGen::AndArrays(CodeGen::GetVariableReference("first_bool_array"),
                                                   CodeGen::GetVariableReference("second_bool_array"),
                                                   6, AbstractType::Bool)));

  // Reset i = 0, for next loop.
  CodeGen::Assign("i", CodeGen::ProduceInteger(0));

  // Print all array elements.
  CodeGen::CallFunction("putString", { CodeGen::ProduceString("Printing |result_int_array| after |AndArrays()|:") });
  CodeGen::For();
  CodeGen::ForCondition(CodeGen::LessThanIntegers(CodeGen::GetVariable("i"), CodeGen::ProduceInteger(6)));
    CodeGen::CallFunction("putInteger", {  CodeGen::Load(CodeGen::IndexArray(CodeGen::GetVariableReference("result_int_array"), CodeGen::GetVariable("i")))   });
    CodeGen::Assign("i", CodeGen::AddIntegers(CodeGen::GetVariable("i"), CodeGen::ProduceInteger(1)));
  CodeGen::EndFor();

  // Reset i = 0, for next loop.
  CodeGen::Assign("i", CodeGen::ProduceInteger(0));

  // Print all array elements.
  CodeGen::CallFunction("putString", { CodeGen::ProduceString("Printing |result_bool_array| after |AndArrays()|:") });
  CodeGen::For();
  CodeGen::ForCondition(CodeGen::LessThanIntegers(CodeGen::GetVariable("i"), CodeGen::ProduceInteger(6)));
    CodeGen::CallFunction("putBool", {  CodeGen::Load(CodeGen::IndexArray(CodeGen::GetVariableReference("result_bool_array"), CodeGen::GetVariable("i")))   });
    CodeGen::Assign("i", CodeGen::AddIntegers(CodeGen::GetVariable("i"), CodeGen::ProduceInteger(1)));
  CodeGen::EndFor();

  // Now testing `|`.
  CodeGen::For();
  CodeGen::ForCondition(CodeGen::LessThanIntegers(CodeGen::GetVariable("i"), CodeGen::ProduceInteger(6)));
    // Assign elements.
    CodeGen::Assign(CodeGen::IndexArray(CodeGen::GetVariableReference("first_int_array"), CodeGen::GetVariable("i")), CodeGen::Load(CodeGen::GetVariableReference("i")));
    CodeGen::Assign(CodeGen::IndexArray(CodeGen::GetVariableReference("second_int_array"), CodeGen::GetVariable("i")), CodeGen::ProduceInteger(2));

    CodeGen::Assign(CodeGen::IndexArray(CodeGen::GetVariableReference("first_bool_array"), CodeGen::GetVariable("i")), CodeGen::ProduceBool(true));
    CodeGen::Assign(CodeGen::IndexArray(CodeGen::GetVariableReference("second_bool_array"), CodeGen::GetVariable("i")), CodeGen::ProduceBool(false));
    CodeGen::Assign("i", CodeGen::AddIntegers(CodeGen::GetVariable("i"), CodeGen::ProduceInteger(1)));
  CodeGen::EndFor();

  // result_int_array = & result_int_array;
  CodeGen::Assign(CodeGen::GetVariableReference("result_int_array"),
                  CodeGen::Load(CodeGen::OrArrays(CodeGen::GetVariableReference("first_int_array"),
                                                  CodeGen::GetVariableReference("second_int_array"),
                                                  6, AbstractType::Integer)));
  // result_bool_array = true & result_bool_array;
  CodeGen::Assign(CodeGen::GetVariableReference("result_bool_array"),
                  CodeGen::Load(CodeGen::OrArrays(CodeGen::GetVariableReference("first_bool_array"),
                                                  CodeGen::GetVariableReference("result_bool_array"),
                                                  6, AbstractType::Bool)));

  // Reset i = 0, for next loop.
  CodeGen::Assign("i", CodeGen::ProduceInteger(0));

  // Print all array elements.
  CodeGen::CallFunction("putString", { CodeGen::ProduceString("Printing |result_int_array| after |OrArrays()|:") });
  CodeGen::For();
  CodeGen::ForCondition(CodeGen::LessThanIntegers(CodeGen::GetVariable("i"), CodeGen::ProduceInteger(6)));
    CodeGen::CallFunction("putInteger", {  CodeGen::Load(CodeGen::IndexArray(CodeGen::GetVariableReference("result_int_array"), CodeGen::GetVariable("i")))   });
    CodeGen::Assign("i", CodeGen::AddIntegers(CodeGen::GetVariable("i"), CodeGen::ProduceInteger(1)));
  CodeGen::EndFor();

  // Reset i = 0, for next loop.
  CodeGen::Assign("i", CodeGen::ProduceInteger(0));

  // Print all array elements.
  CodeGen::CallFunction("putString", { CodeGen::ProduceString("Printing |result_bool_array| after |OrArrays()|:") });
  CodeGen::For();
  CodeGen::ForCondition(CodeGen::LessThanIntegers(CodeGen::GetVariable("i"), CodeGen::ProduceInteger(6)));
    CodeGen::CallFunction("putBool", {  CodeGen::Load(CodeGen::IndexArray(CodeGen::GetVariableReference("result_bool_array"), CodeGen::GetVariable("i")))   });
    CodeGen::Assign("i", CodeGen::AddIntegers(CodeGen::GetVariable("i"), CodeGen::ProduceInteger(1)));
  CodeGen::EndFor();

  CodeGen::Return(CodeGen::ProduceInteger(0));
  CodeGen::EndFunction();

  CodeGen::PrintBitCode("logical_operators_arrays");
  return 0;
}
