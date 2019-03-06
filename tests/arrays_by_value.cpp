#include <iostream>
#include <vector>

#include "../CodeGen.h"

int main() {
  CodeGen::Setup();

  //////// MAIN.
  std::vector<std::pair<std::string, AbstractType>> mainArguments;
  CodeGen::CreateFunction("main", AbstractType::Integer, mainArguments);

  ///////////////////////////////////////////////////////////////////////////////////
  // Create a function that accepts an array by value.
  std::vector<std::pair<std::string, AbstractType>> fn_args =
    { std::make_pair("input_array", AbstractType::IntegerArray) };
  CodeGen::CreateFunction("takes_array", AbstractType::Void, fn_args);
    CodeGen::CallFunction("putString", { CodeGen::ProduceString("Printing given array values inside fn `input_array`") });
    CodeGen::CreateVariable(AbstractType::Integer, "i");

    // Print all given array elements.
    CodeGen::For();
    CodeGen::ForCondition(CodeGen::LessThanIntegers(CodeGen::GetVariable("i"), CodeGen::ProduceInteger(10)));
      CodeGen::CallFunction("putInteger", {  CodeGen::IndexArrayGetValue("input_array", CodeGen::GetVariable("i"))   });
      CodeGen::Assign("i", CodeGen::AddIntegers(CodeGen::GetVariable("i"), CodeGen::ProduceInteger(1)));
    CodeGen::EndFor();

    // Reset i = 0, for next loop.
    CodeGen::Assign("i", CodeGen::ProduceInteger(0));

    // Assign all array elements.
    CodeGen::For();
    CodeGen::ForCondition(CodeGen::LessThanIntegers(CodeGen::GetVariable("i"), CodeGen::ProduceInteger(10)));
      // Assign elements.
      CodeGen::CallFunction("putString", { CodeGen::ProduceString("Assigning array element inside fn `input_array`") });
      CodeGen::Assign(CodeGen::IndexArray("input_array", CodeGen::GetVariable("i")), CodeGen::ProduceInteger(66));

      CodeGen::Assign("i", CodeGen::AddIntegers(CodeGen::GetVariable("i"), CodeGen::ProduceInteger(1)));
    CodeGen::EndFor();

    // Reset i = 0, for next loop.
    CodeGen::Assign("i", CodeGen::ProduceInteger(0));

    // Print all array elements.
    CodeGen::CallFunction("putString", { CodeGen::ProduceString("Printing given array values inside fn `input_array`") });
    CodeGen::For();
    CodeGen::ForCondition(CodeGen::LessThanIntegers(CodeGen::GetVariable("i"), CodeGen::ProduceInteger(10)));
      CodeGen::CallFunction("putInteger", {  CodeGen::IndexArrayGetValue("input_array", CodeGen::GetVariable("i"))   });
      CodeGen::Assign("i", CodeGen::AddIntegers(CodeGen::GetVariable("i"), CodeGen::ProduceInteger(1)));
    CodeGen::EndFor();

  CodeGen::EndFunction();
  ///////////////////////////////////////////////////////////////////////////////////

  // Body of main.
  // Create future argument variable.
  CodeGen::CreateVariable(AbstractType::IntegerArray, "my_array", false, true);

  // Assign all array elements.
  CodeGen::CreateVariable(AbstractType::Integer, "i");
  CodeGen::For();
  CodeGen::ForCondition(CodeGen::LessThanIntegers(CodeGen::GetVariable("i"), CodeGen::ProduceInteger(10)));
    // Assign elements.
    CodeGen::CallFunction("putString", { CodeGen::ProduceString("Top-level assigning array element") });
    CodeGen::Assign(CodeGen::IndexArray("my_array", CodeGen::GetVariable("i")), CodeGen::GetVariable("i"));

    CodeGen::Assign("i", CodeGen::AddIntegers(CodeGen::GetVariable("i"), CodeGen::ProduceInteger(1)));
  CodeGen::EndFor();

  // Reset i = 0, for next loop.
  CodeGen::Assign("i", CodeGen::ProduceInteger(0));

  // Print all array elements.
  CodeGen::CallFunction("putString", { CodeGen::ProduceString("Top-level printing given array values") });
  CodeGen::For();
  CodeGen::ForCondition(CodeGen::LessThanIntegers(CodeGen::GetVariable("i"), CodeGen::ProduceInteger(10)));
    CodeGen::CallFunction("putInteger", {  CodeGen::IndexArrayGetValue("my_array", CodeGen::GetVariable("i"))   });
    CodeGen::Assign("i", CodeGen::AddIntegers(CodeGen::GetVariable("i"), CodeGen::ProduceInteger(1)));
  CodeGen::EndFor();


  CodeGen::CallFunction("takes_array", {CodeGen::GetVariable("my_array")});

  // Reset i = 0, for next loop.
  CodeGen::Assign("i", CodeGen::ProduceInteger(0));

  // Print all array elements.
  CodeGen::CallFunction("putString", { CodeGen::ProduceString("Top-level printing given array values") });
  CodeGen::For();
  CodeGen::ForCondition(CodeGen::LessThanIntegers(CodeGen::GetVariable("i"), CodeGen::ProduceInteger(10)));
    CodeGen::CallFunction("putInteger", {  CodeGen::IndexArrayGetValue("my_array", CodeGen::GetVariable("i"))   });
    CodeGen::Assign("i", CodeGen::AddIntegers(CodeGen::GetVariable("i"), CodeGen::ProduceInteger(1)));
  CodeGen::EndFor();

  CodeGen::Return(CodeGen::ProduceInteger(0));
  CodeGen::EndFunction();

  CodeGen::PrintBitCode();
  return 0;
}
