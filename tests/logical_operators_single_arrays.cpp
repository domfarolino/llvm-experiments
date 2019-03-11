#include <iostream>
#include <vector>

#include "../CodeGen.h"

int main() {
  CodeGen::Setup();

  //////// MAIN.
  std::vector<std::tuple<std::string, AbstractType, int>> mainArguments;
  CodeGen::CreateFunction("main", AbstractType::Integer, mainArguments);

  CodeGen::CreateVariable(AbstractType::IntegerArray, "result_int_array", false, true, 6);
  CodeGen::CreateVariable(AbstractType::BoolArray, "result_bool_array", false, true, 6);

  // First testing `&`.

  // Assign all array elements.
  CodeGen::CreateVariable(AbstractType::Integer, "i");
  CodeGen::For();
  CodeGen::ForCondition(CodeGen::LessThanIntegers(CodeGen::GetVariable("i"), CodeGen::ProduceInteger(6)));
    // Assign elements.
    CodeGen::Assign(CodeGen::IndexArray(CodeGen::GetVariableReference("result_int_array"), CodeGen::GetVariable("i")), CodeGen::Load(CodeGen::GetVariableReference("i")));

    CodeGen::Assign(CodeGen::IndexArray(CodeGen::GetVariableReference("result_bool_array"), CodeGen::GetVariable("i")), CodeGen::ProduceBool(true));

    CodeGen::Assign("i", CodeGen::AddIntegers(CodeGen::GetVariable("i"), CodeGen::ProduceInteger(1)));
  CodeGen::EndFor();

  // result_int_array = 2 & result_int_array;
  CodeGen::Assign(CodeGen::GetVariableReference("result_int_array"),
                  CodeGen::Load(CodeGen::AndArrays(CodeGen::ProduceInteger(2),
                                                        CodeGen::GetVariableReference("result_int_array"))));
  // result_bool_array = true & result_bool_array;
  CodeGen::Assign(CodeGen::GetVariableReference("result_bool_array"),
                  CodeGen::Load(CodeGen::AndArrays(CodeGen::ProduceBool(false),
                                                        CodeGen::GetVariableReference("result_bool_array"))));

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
  // Assign all array elements.
  CodeGen::CreateVariable(AbstractType::Integer, "i");
  CodeGen::For();
  CodeGen::ForCondition(CodeGen::LessThanIntegers(CodeGen::GetVariable("i"), CodeGen::ProduceInteger(6)));
    // Assign elements.
    CodeGen::Assign(CodeGen::IndexArray(CodeGen::GetVariableReference("result_int_array"), CodeGen::GetVariable("i")), CodeGen::Load(CodeGen::GetVariableReference("i")));
    CodeGen::Assign(CodeGen::IndexArray(CodeGen::GetVariableReference("result_bool_array"), CodeGen::GetVariable("i")), CodeGen::ProduceBool(true));
    CodeGen::Assign("i", CodeGen::AddIntegers(CodeGen::GetVariable("i"), CodeGen::ProduceInteger(1)));
  CodeGen::EndFor();

  // result_int_array = 2 & result_int_array;
  CodeGen::Assign(CodeGen::GetVariableReference("result_int_array"),
                  CodeGen::Load(CodeGen::OrArrays(CodeGen::GetVariableReference("result_int_array"),
                                                  CodeGen::ProduceInteger(2))));
  // result_bool_array = true & result_bool_array;
  CodeGen::Assign(CodeGen::GetVariableReference("result_bool_array"),
                  CodeGen::Load(CodeGen::OrArrays(CodeGen::GetVariableReference("result_bool_array"),
                                                  CodeGen::ProduceBool(false))));

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

  CodeGen::PrintBitCode("logical_operators_single_arrays");
  return 0;
}
