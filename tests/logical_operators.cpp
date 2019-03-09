#include <iostream>
#include <vector>

#include "../CodeGen.h"

int main() {
  CodeGen::Setup();

  //////// MAIN.
  std::vector<std::tuple<std::string, AbstractType, int>> mainArguments;
  CodeGen::CreateFunction("main", AbstractType::Integer, mainArguments);

  CodeGen::CreateFunction("useIf", AbstractType::Void, {});
  CodeGen::CallFunction("putString", { CodeGen::ProduceString("Starting out with &&") });

  // true && true.
  CodeGen::IfThen(CodeGen::And(CodeGen::ProduceBool(true), CodeGen::ProduceBool(true)));
  CodeGen::CallFunction("putString", { CodeGen::ProduceString("Logical and was true") });
  CodeGen::Else();
  CodeGen::CallFunction("putString", { CodeGen::ProduceString("Logical and was false") });
  CodeGen::EndIf();

  // true && false.
  CodeGen::IfThen(CodeGen::And(CodeGen::ProduceBool(true), CodeGen::ProduceBool(false)));
  CodeGen::CallFunction("putString", { CodeGen::ProduceString("Logical and was true") });
  CodeGen::Else();
  CodeGen::CallFunction("putString", { CodeGen::ProduceString("Logical and was false") });
  CodeGen::EndIf();

  // false && false.
  CodeGen::IfThen(CodeGen::And(CodeGen::ProduceBool(false), CodeGen::ProduceBool(false)));
  CodeGen::CallFunction("putString", { CodeGen::ProduceString("Logical and was true") });
  CodeGen::Else();
  CodeGen::CallFunction("putString", { CodeGen::ProduceString("Logical and was false") });
  CodeGen::EndIf();

  CodeGen::CallFunction("putString", { CodeGen::ProduceString("Switching to ||") });

  // true || true.
  CodeGen::IfThen(CodeGen::Or(CodeGen::ProduceBool(true), CodeGen::ProduceBool(true)));
  CodeGen::CallFunction("putString", { CodeGen::ProduceString("Logical or was true") });
  CodeGen::Else();
  CodeGen::CallFunction("putString", { CodeGen::ProduceString("Logical or was false") });
  CodeGen::EndIf();

  // true || false.
  CodeGen::IfThen(CodeGen::Or(CodeGen::ProduceBool(true), CodeGen::ProduceBool(false)));
  CodeGen::CallFunction("putString", { CodeGen::ProduceString("Logical or was true") });
  CodeGen::Else();
  CodeGen::CallFunction("putString", { CodeGen::ProduceString("Logical or was false") });
  CodeGen::EndIf();

  // false || false.
  CodeGen::IfThen(CodeGen::Or(CodeGen::ProduceBool(false), CodeGen::ProduceBool(false)));
  CodeGen::CallFunction("putString", { CodeGen::ProduceString("Logical or was true") });
  CodeGen::Else();
  CodeGen::CallFunction("putString", { CodeGen::ProduceString("Logical or was false") });
  CodeGen::EndIf();


  CodeGen::EndFunction();

  CodeGen::CallFunction("useIf", {});
  CodeGen::Return(CodeGen::ProduceInteger(0));
  CodeGen::EndFunction();

  CodeGen::PrintBitCode("logical_operators");
  return 0;
}
