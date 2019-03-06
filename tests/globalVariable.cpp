#include <iostream>
#include <vector>

#include "../CodeGen.h"

int main() {
  CodeGen::Setup();

  //////// MAIN.
  std::vector<std::pair<std::string, AbstractType>> mainArguments;
  CodeGen::CreateFunction("main", AbstractType::Integer, mainArguments);
  CodeGen::CreateVariable(AbstractType::Integer, "globalInteger", true);            // global int globalInteger; // will init to 0.

  CodeGen::CreateFunction("mutateGlobal", AbstractType::Void, {});                  // function mutateGlobal() {
  CodeGen::Assign("globalInteger", CodeGen::ProduceInteger(100));                   //   globalInteger = 100;
  CodeGen::CreateVariable(AbstractType::Integer, "tmp", false, false,               //   int tmp = 10 + 100;
                          CodeGen::AddIntegers(CodeGen::ProduceInteger(10),
                                               CodeGen::GetVariable("globalInteger")));
  CodeGen::Assign("globalInteger", CodeGen::GetVariable("tmp"));                    //   globalInteger = tmp;
                                                                                    //
  CodeGen::CallFunction("putString", { CodeGen::ProduceString("tmp:") });           //   putString("tmp:");
  CodeGen::CallFunction("putInteger", { CodeGen::GetVariable("tmp") });             //   putInteger(tmp);
  CodeGen::CallFunction("putString", { CodeGen::ProduceString("globalInteger:") }); //   putString("globalInteger:");
  CodeGen::CallFunction("putInteger", { CodeGen::GetVariable("globalInteger") });   //   putInteger(globalInteger);
  CodeGen::EndFunction();                                                           // }

  CodeGen::CallFunction("mutateGlobal", {});
  CodeGen::CallFunction("putString", { CodeGen::ProduceString("globalInteger:") }); //   putString("globalInteger:");
  CodeGen::CallFunction("putInteger", { CodeGen::GetVariable("globalInteger") });   //   putInteger(globalInteger);

  CodeGen::Return(CodeGen::ProduceInteger(0));
  CodeGen::EndFunction();

  CodeGen::PrintBitCode();
  return 0;
}
