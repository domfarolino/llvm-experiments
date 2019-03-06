#include <map>
#include <stack>
#include <vector>
#include <utility> // for std::pair.

#include "llvm/IR/Verifier.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Support/raw_os_ostream.h"

using namespace llvm;

enum AbstractType {
  Integer,
  IntegerRef,
  IntegerArray,
  IntegerArrayRef,
  Float,
  FloatRef,
  Bool,
  BoolRef,
  Char,
  CharRef,
  String,
  StringRef,
  Void, // This should be last.
};

static LLVMContext TheContext;
static IRBuilder<> Builder(TheContext);
static std::unique_ptr<Module> TheModule;

struct IfBlocks {
  Value* Condition;
  BasicBlock *ThenBB, *ElseBB, *MergeBB;
  IfBlocks(Value* inCondition,
           BasicBlock* inThenBB,
           BasicBlock* inElseBB,
           BasicBlock* inMergeBB): Condition(inCondition),
                                   ThenBB(inThenBB),
                                   ElseBB(inElseBB),
                                   MergeBB(inMergeBB) {}
};

struct ForLoopBlocks {
  BasicBlock *CondEvalBB, *LoopBB, *PostLoopBB;
  ForLoopBlocks(BasicBlock* inCondEvalBB,
                BasicBlock* inLoopBB,
                BasicBlock* inPostLoopBB): CondEvalBB(inCondEvalBB),
                                           LoopBB(inLoopBB),
                                           PostLoopBB(inPostLoopBB) {}
};

struct FunctionDeclaration {
  Function* function;
  std::vector<Value*> arguments;
};

// These two are essentially mimicing our abstract symbol table.
static std::map<std::string, Value*> LocalVariables; // Value* can be a GlobalVariable* or AllocaInst*.
static std::map<std::string, Function*> FunctionTable;

// These are kind of ugly...
static std::stack<BasicBlock*> BasicBlockStack;
static std::stack<IfBlocks> IfBlocksStack;
static std::stack<ForLoopBlocks> ForLoopBlocksStack;

bool PendingReturn = false;
bool ErrorState = false;

class CodeGen {
private:
  // Disallow creating an instance of this class.
  CodeGen() {}

  static bool ShouldGenerate() {
    return !ErrorState && !PendingReturn;
  }

  static void NextBlockForInsertion() {
    BasicBlockStack.pop();
    BasicBlock* nextBlock = BasicBlockStack.empty() ? nullptr : BasicBlockStack.top();
    Builder.SetInsertPoint(nextBlock);
    PendingReturn = false;
  }

  static void ReplaceInsertionBlock(BasicBlock* nextBlock) {
    BasicBlockStack.pop();
    BasicBlockStack.push(nextBlock);
    Builder.SetInsertPoint(nextBlock);
    PendingReturn = false;
  }

  static Constant* CreateInitialValueGivenType(AbstractType abstractType) {
    // Only initial values need produced for primitive types. Arrays and/or
    // references should never be initialized here.
    if (abstractType == AbstractType::Integer)
      return ProduceInteger(0);
    else if (abstractType == AbstractType::Float)
      return ProduceFloat(0);
    else if (abstractType == AbstractType::Bool)
      return ProduceBool(false);
    else if (abstractType == AbstractType::Char)
      return ProduceChar(0);
    else if (abstractType == AbstractType::String)
      return ProduceString("");

    // Assert: unreached.
    return nullptr;
  }

  static void DeclarePrintf() {
    // Set up printf argument(s).
    std::vector<Type*> arguments(1, Type::getInt8Ty(TheContext)->getPointerTo());
    FunctionType* printfFunctionType = FunctionType::get(Type::getInt32Ty(TheContext), arguments, true);
    Function* printfFunction = Function::Create(printfFunctionType, Function::ExternalLinkage, "printf", TheModule.get());
    FunctionTable["printf"] = printfFunction;
  }

  static void DeclareScanf() {
    // Set up scanf argument(s).
    std::vector<Type*> arguments(1, Type::getInt8Ty(TheContext)->getPointerTo());
    FunctionType* scanfFunctionType = FunctionType::get(Type::getInt32Ty(TheContext), arguments, true);
    Function* scanfFunction = Function::Create(scanfFunctionType, Function::ExternalLinkage, "scanf", TheModule.get());
    FunctionTable["scanf"] = scanfFunction;
  }

  // Define the built-ins, as per
  // https://eecs.ceas.uc.edu/~paw/classes/eecs6083/project/projectLanguage.pdf.
  static void DeclareBuiltins() {
    DeclarePrintf();
    DeclareScanf();

    // Declare |putInteger|.
    CodeGen::CreateFunction("putInteger", AbstractType::Void, { std::make_pair("out", AbstractType::Integer) });
    CodeGen::CallFunction("printf", { CodeGen::ProduceString("%d\n"), CodeGen::GetVariable("out") });
    CodeGen::EndFunction();

    // Declare |putFloat|.
    CodeGen::CreateFunction("putFloat", AbstractType::Void, { std::make_pair("out", AbstractType::Float) });
    CodeGen::CallFunction("printf", { CodeGen::ProduceString("%lf\n"), CodeGen::GetVariable("out") });
    CodeGen::EndFunction();

    // Declare |putBool|.
    CodeGen::CreateFunction("putBool", AbstractType::Void, { std::make_pair("out", AbstractType::Bool) });
    CodeGen::CallFunction("printf", { CodeGen::ProduceString("%d\n"), CodeGen::GetVariable("out") });
    CodeGen::EndFunction();

    // Declare |putChar|.
    CodeGen::CreateFunction("putChar", AbstractType::Void, { std::make_pair("out", AbstractType::Char) });
    CodeGen::CallFunction("printf", { CodeGen::ProduceString("%c\n"), CodeGen::GetVariable("out") });
    CodeGen::EndFunction();

    // Declare |putString|.
    CodeGen::CreateFunction("putString", AbstractType::Void, { std::make_pair("out", AbstractType::String) });
    CodeGen::CallFunction("printf", { CodeGen::ProduceString("%s\n"), CodeGen::GetVariable("out") });
    CodeGen::EndFunction();

    // Declare |getInteger|.
    CodeGen::CreateFunction("getInteger", AbstractType::Void, { std::make_pair("out", AbstractType::IntegerRef) });
    CodeGen::CallFunction("scanf", { CodeGen::ProduceString("%d"), CodeGen::GetVariable("out") });
    CodeGen::EndFunction();

    // Declare |getFloat|.
    CodeGen::CreateFunction("getFloat", AbstractType::Void, { std::make_pair("out", AbstractType::FloatRef) });
    CodeGen::CallFunction("scanf", { CodeGen::ProduceString("%lf"), CodeGen::GetVariable("out") });
    CodeGen::EndFunction();

    // Declare |getBool|.
    // This is a little more involved, because to get it to work correctly, we
    // have to give |scanf| an integer, and then cast the integer to a bool.
    CodeGen::CreateFunction("getBool", AbstractType::Void, { std::make_pair("out", AbstractType::BoolRef) });
    CodeGen::CreateVariable(AbstractType::Integer, "tmpInteger");
    CodeGen::CallFunction("scanf", { CodeGen::ProduceString("%d"), CodeGen::GetVariableReference("tmpInteger") });
    CodeGen::AssignReferenceVariable("out", CodeGen::CastIntegerToBool(CodeGen::GetVariable("tmpInteger")));
    CodeGen::EndFunction();

    // Declare |getChar|.
    CodeGen::CreateFunction("getChar", AbstractType::Void, { std::make_pair("out", AbstractType::CharRef) });
    CodeGen::CallFunction("scanf", { CodeGen::ProduceString(" %c"), CodeGen::GetVariable("out") });
    CodeGen::EndFunction();

    // Declare |getString|.
    CodeGen::CreateFunction("getString", AbstractType::Void, { std::make_pair("out", AbstractType::StringRef) });
    CodeGen::CallFunction("scanf", { CodeGen::ProduceString("%s"), CodeGen::GetReferenceVariableValue("out") });
    CodeGen::EndFunction();
  }

  // CreateVariable delegates to this.
  // Constants don't yet support user-defined initial values.
  static GlobalVariable* CreateGlobalVariable(AbstractType abstractType, const std::string& variableName) {
    Constant* initialValue = CreateInitialValueGivenType(abstractType);
    GlobalVariable* globalVariable =
        new GlobalVariable(/* Module */ *TheModule,
                           /* Type */ AbstractTypeToLLVMType(abstractType),
                           /* isConstant */ false, // Not yet supported by us.
                           /* Linkage */ GlobalValue::CommonLinkage,
                           /* Initializer */ initialValue,
                           /* name */ variableName.c_str());
    LocalVariables[variableName] = globalVariable;
    return globalVariable;
  }

  // Used as a helper.
  static Type* AbstractTypeToLLVMType(AbstractType abstractType) {
    // Primitive types.
    if (abstractType == AbstractType::Integer)
      return Type::getInt32Ty(TheContext);
    else if (abstractType == AbstractType::Float)
      return Type::getDoubleTy(TheContext);
    else if (abstractType == AbstractType::Bool)
      return Type::getInt1Ty(TheContext);
    else if (abstractType == AbstractType::Char)
      return Type::getInt8Ty(TheContext);
    else if (abstractType == AbstractType::String)
      return Type::getInt8Ty(TheContext)->getPointerTo();
    else if (abstractType == AbstractType::Void)
      return Type::getVoidTy(TheContext);
    // Primitive reference (pointer) types.
    else if (abstractType == AbstractType::IntegerRef)
      return Type::getInt32Ty(TheContext)->getPointerTo();
    else if (abstractType == AbstractType::FloatRef)
      return Type::getDoubleTy(TheContext)->getPointerTo();
    else if (abstractType == AbstractType::BoolRef)
      return Type::getInt1Ty(TheContext)->getPointerTo();
    else if (abstractType == AbstractType::CharRef)
      return Type::getInt8Ty(TheContext)->getPointerTo();
    else if (abstractType == AbstractType::StringRef)
      return Type::getInt8Ty(TheContext)->getPointerTo()->getPointerTo();
    // Array types.
    else if (abstractType == AbstractType::IntegerArray)
      return ArrayType::get(Type::getInt32Ty(TheContext), 10);
    // Array reference types.
    else if (abstractType == AbstractType::IntegerArrayRef)
      return ArrayType::get(Type::getInt32Ty(TheContext), 10)->getPointerTo();

    // Assert: This is never reached.
    return Type::getDoubleTy(TheContext);
  }

public:
  static void EnterErrorState() {
    ErrorState = true;
  }

  static void Setup() {
    TheModule = make_unique<Module>("Dom Sample", TheContext);
    // TODO(domfarolino): [COMPILER] once this is merged into the larger
    // compiler project, we should call DeclarePrintf, and remove the
    // DeclareBuiltins() implementation.
    // See https://github.com/domfarolino/llvm-experiments/issues/23.
    DeclareBuiltins();
  }

  static void PrintBitCode() {
    if (!ShouldGenerate()) return;
    TheModule->print(errs(), nullptr);
  }

  static Constant* ProduceFloat(double val) {
    return ConstantFP::get(TheContext, APFloat(val));
  }

  static Constant* ProduceInteger(int val) {
    return ConstantInt::get(TheContext, APInt(/* nbits */ 32, /* value */ val, /* is signed */ true));
  }

  static Constant* ProduceChar(char val) {
    return ConstantInt::get(TheContext, APInt(/* nbits */ 8, /* value */ val, /* is signed */ true));
  }

  static Constant* ProduceBool(bool val) {
    return ConstantInt::get(TheContext, APInt(/* nbits */ 1, /* value */ val, /* is signed */ true));
  }

  static Constant* ProduceString(const std::string& str) {
    return Builder.CreateGlobalStringPtr(str);
  }

  // Unary operators.
  static Value* NegateInteger(Value* value) {
    if (!ShouldGenerate()) return nullptr;
    return Builder.CreateSub(ProduceInteger(0), value);
  }
  static Value* NegateFloat(Value* value) {
    if (!ShouldGenerate()) return nullptr;
    return Builder.CreateFSub(ProduceFloat(0), value);
  }

  // Arithmetic operators.
  static Value* AddFloats(Value* lhs, Value* rhs, const std::string& regName = "") {
    if (!ShouldGenerate()) return nullptr;
    return Builder.CreateFAdd(lhs, rhs, regName);
  }
  static Value* AddIntegers(Value* lhs, Value* rhs, const std::string& regName = "") {
    if (!ShouldGenerate()) return nullptr;
    return Builder.CreateAdd(lhs, rhs, regName);
  }
  static Value* SubtractFloats(Value* lhs, Value* rhs, const std::string& regName = "") {
    if (!ShouldGenerate()) return nullptr;
    return Builder.CreateFSub(lhs, rhs, regName);
  }
  static Value* SubtractIntegers(Value* lhs, Value* rhs, const std::string& regName = "") {
    if (!ShouldGenerate()) return nullptr;
    return Builder.CreateSub(lhs, rhs, regName);
  }
  static Value* MultiplyFloats(Value* lhs, Value* rhs, const std::string& regName = "") {
    if (!ShouldGenerate()) return nullptr;
    return Builder.CreateFMul(lhs, rhs, regName);
  }
  static Value* MultiplyIntegers(Value* lhs, Value* rhs, const std::string& regName = "") {
    if (!ShouldGenerate()) return nullptr;
    return Builder.CreateMul(lhs, rhs, regName);
  }
  static Value* DivideFloats(Value* lhs, Value* rhs, const std::string& regName = "") {
    if (!ShouldGenerate()) return nullptr;
    return Builder.CreateFDiv(lhs, rhs, regName);
  }
  static Value* DivideIntegers(Value* lhs, Value* rhs, const std::string& regName = "") {
    if (!ShouldGenerate()) return nullptr;
    return Builder.CreateSDiv(lhs, rhs, regName);
  }
  static Value* BitwiseAndIntegers(Value* lhs, Value* rhs, const std::string& regName = "") {
    if (!ShouldGenerate()) return nullptr;
    return Builder.CreateAnd(lhs, rhs, regName);
  }
  static Value* BitwiseOrIntegers(Value* lhs, Value* rhs, const std::string& regName = "") {
    if (!ShouldGenerate()) return nullptr;
    return Builder.CreateOr(lhs, rhs, regName);
  }

  // Relational operators.
  static Value* LessThanFloats(Value* lhs, Value* rhs, const std::string& regName = "") {
    if (!ShouldGenerate()) return nullptr;
    return Builder.CreateFCmpOLT(lhs, rhs, regName);
  }
  static Value* LessThanIntegers(Value* lhs, Value* rhs, const std::string& regName = "") {
    if (!ShouldGenerate()) return nullptr;
    return Builder.CreateICmpSLT(lhs, rhs, regName);
  }
  static Value* LessThanOrEqualFloats(Value* lhs, Value* rhs, const std::string& regName = "") {
    if (!ShouldGenerate()) return nullptr;
    return Builder.CreateFCmpOLE(lhs, rhs, regName);
  }
  static Value* LessThanOrEqualIntegers(Value* lhs, Value* rhs, const std::string& regName = "") {
    if (!ShouldGenerate()) return nullptr;
    return Builder.CreateICmpSLE(lhs, rhs, regName);
  }
  static Value* GreaterThanFloats(Value* lhs, Value* rhs, const std::string& regName = "") {
    if (!ShouldGenerate()) return nullptr;
    return Builder.CreateFCmpOGT(lhs, rhs, regName);
  }
  static Value* GreaterThanIntegers(Value* lhs, Value* rhs, const std::string& regName = "") {
    if (!ShouldGenerate()) return nullptr;
    return Builder.CreateICmpSGT(lhs, rhs, regName);
  }
  static Value* GreaterThanOrEqualFloats(Value* lhs, Value* rhs, const std::string& regName = "") {
    if (!ShouldGenerate()) return nullptr;
    return Builder.CreateFCmpOGE(lhs, rhs, regName);
  }
  static Value* GreaterThanOrEqualIntegers(Value* lhs, Value* rhs, const std::string& regName = "") {
    if (!ShouldGenerate()) return nullptr;
    return Builder.CreateICmpSGE(lhs, rhs, regName);
  }
  static Value* EqualFloats(Value* lhs, Value* rhs, const std::string& regName = "") {
    if (!ShouldGenerate()) return nullptr;
    return Builder.CreateFCmpOEQ(lhs, rhs, regName);
  }
  static Value* EqualIntegers(Value* lhs, Value* rhs, const std::string& regName = "") {
    if (!ShouldGenerate()) return nullptr;
    return Builder.CreateICmpEQ(lhs, rhs, regName);
  }
  static Value* NotEqualFloats(Value* lhs, Value* rhs, const std::string& regName = "") {
    if (!ShouldGenerate()) return nullptr;
    return Builder.CreateFCmpONE(lhs, rhs, regName);
  }
  static Value* NotEqualIntegers(Value* lhs, Value* rhs, const std::string& regName = "") {
    if (!ShouldGenerate()) return nullptr;
    return Builder.CreateICmpNE(lhs, rhs, regName);
  }

////////////////////////// Begin Variable Management //////////////////////////

  // General get-the-value-of-a-variable function.
  static Value* GetVariable(const std::string& name) {
    if (!ShouldGenerate()) return nullptr;
    if (LocalVariables.find(name) == LocalVariables.end()) {
      std::cout << "Could not find variable with name: " << name << std::endl;
      return nullptr;
    }

    Value* variableAlloca = LocalVariables[name];
    // This is probably going to be replaced by a call to ScopeManager::{lookup, getSymbol}.
    return Builder.CreateLoad(variableAlloca, name.c_str());
  }

  // This is used to dereference a variable of name |name| that we have a
  // reference to. This only does a single-dereference though, so I might have
  // to re-think this when arrays are implemented. This should be used when the
  // value of a reference ("out") variable is needed for something. Example:
  // someFunc(i32* someArg) // |someArg| is an AbstractType::IntegerRef.
  //   integer tmp = 10;
  //   ... CodeGen::AddIntegers(CodeGen::GetVariable("tmp"),
  //                            CodeGen::GetReferenceVariableValue("someArg"));
  static Value* GetReferenceVariableValue(const std::string& name) {
    if (!ShouldGenerate()) return nullptr;
    if (LocalVariables.find(name) == LocalVariables.end()) {
      std::cout << "Could not find variable with name: " << name << std::endl;
      return nullptr;
    }

    Value* variableAlloca = LocalVariables[name];
    // Load variable.
    Value* firstLoad = Builder.CreateLoad(variableAlloca, name.c_str());

    // Dereference variable.
    return Builder.CreateLoad(firstLoad);
  }

  // Similar to |GetVariable|, but instead of getting the value of a variable to
  // be used variable, this gets a reference (pointer) to the variable |name|.
  // It should mostly be used to pass a reference of a variable ("out" variable)
  // to a function. Example:
  // CodeGen::CallFunction("someFunc",
  //   { CodeGen::GetVariable("someArg") }); // someFunc(someArg);
  //
  // CodeGen::CallFunction("someFunc",
  //   { CodeGen::GetVariableReference("someArg") }); // someFunc(&someArg);
  static Value* GetVariableReference(const std::string& name) {
    if (!ShouldGenerate()) return nullptr;
    if (LocalVariables.find(name) == LocalVariables.end()) {
      std::cout << "Could not find variable with name: " << name << std::endl;
      return nullptr;
    }

    return LocalVariables[name];
  }

  // If we were to support chained assignments (x = y = 2), we may want the
  // implementations of |Assign| and |AssignReferenceVariable| to return the
  // |rhs| value.
  static void Assign(const std::string& variableName, Value* rhs) {
    if (!ShouldGenerate()) return;
    // Use original AllocaInst* (uh, Value*) because we don't want the actual
    // value as the LHS, but the "reference" to the value.
    Value* variable = LocalVariables[variableName];
    if (!variable) {
      std::cout << "Could not find local variable with name: '" << variableName << "'" << std::endl;
      return;
    }

    Builder.CreateStore(rhs, variable);
  }

  // TODO(domfarolino): This is probably what |Assign| should be come; make note
  // of this as an issue.
  static void Assign(Value* lhs, Value* rhs) {
    Builder.CreateStore(rhs, lhs);
  }

  // This is used to assign the value of a reference variable |variableName| to
  // |rhs|. It essentially is the same as |Assign|, but dereferences first.
  static void AssignReferenceVariable(const std::string& variableName, Value* rhs) {
    if (!ShouldGenerate()) return;
    // We create a load here.
    Value* variable = GetVariable(variableName);
    Builder.CreateStore(rhs, variable);
  }

  // Creates a normal primitive or reference (pointer) to a primitive,
  // optionally global. The only time |initialValue| will be passed in is when
  // |CreateVariable| is being called from |CreateFunction|, and the argument
  // value is the |initialValue|.
  static Value* CreateVariable(AbstractType abstractType,
                               const std::string& variableName,
                               bool isGlobal = false,
                               bool isArray = false,
                               Value* initialValue = nullptr) {
    if (!ShouldGenerate()) return nullptr;
    if (isGlobal)
      return CreateGlobalVariable(abstractType, variableName);

    if (isArray && initialValue) {
      // Assert: Unreachable; we haven't implemented this.
      // TODO(domfarolino): Like this.
      // At the time of writing, arrays are given initial values only when
      // they are passed or copied by value. We have to copy the contents over
      // via a sequence of element-by-element `store` instructions. We
      // implicitly trust that the lengths match and that we won't run into any
      // any issues, because the compiler's type checker should have ensured
      // this for us to get here.
    }

    // |initialValue| is not always nullptr, for example, in the case of
    // function parameters.
    if (!initialValue)
      initialValue = CreateInitialValueGivenType(abstractType);

    // Allocates a stack variable in the current function's |entry| block.
    Function* currentFunction = Builder.GetInsertBlock()->getParent();
    IRBuilder<> EntryBuilder(&currentFunction->getEntryBlock(),
                             currentFunction->getEntryBlock().begin());
    AllocaInst* argAlloca = EntryBuilder.CreateAlloca(
                                           AbstractTypeToLLVMType(abstractType),
                                           0, variableName.c_str());

    // Arrays do not get initial values `store`d into them. If an initial value
    // is provided, it is because the array was passed or copied by value, and
    // we have to copy the contents of the array over via a sequence of `store`
    // instructions, which we do in the `isArray` check above.
    if (!isArray) {
      // Assert: |initialValue| is non-null.
      Builder.CreateStore(initialValue, argAlloca);
    }
    LocalVariables[variableName] = argAlloca;
    return argAlloca;
  }

  // TODO(domfarolino): Write documentation for this.
  static Value* IndexArray(const std::string& array_name, Value* index) {
    Value* array_ptr = GetVariableReference(array_name);
    auto zero = ConstantInt::get(TheContext, APInt(64, 0, true));
    return Builder.CreateGEP(array_ptr, {zero, index}, "array-index");
  }
  // TODO(domfarolino): Write documentation for this.
  static Value* IndexArrayGetValue(const std::string& array_name,
                                   Value* index) {
    Value* array_ptr = GetVariableReference(array_name);
    auto zero = ConstantInt::get(TheContext, APInt(64, 0, true));
    return Builder.CreateLoad(Builder.CreateGEP(array_ptr, {zero, index}, "array-index"), "");
  }

/////////////////////////// End Variable Management ///////////////////////////

////////////////// Begin Function & Control Flow Management ///////////////////

  // Creates an LLVM Function* prototype, generates an IR declaration for it,
  // and adds it to the FunctionTable.
  static FunctionDeclaration CreateFunction(const std::string& name,
                                  AbstractType abstractReturnType,
                                  std::vector<std::pair<std::string, AbstractType>>
                                    arguments,
                                  bool variadic = false) {
    // CreateFunction must return this, so the caller can deal with the
    // Function* and parameter AllocaInst*s appropriately.
    FunctionDeclaration functionDeclaration;
    if (!ShouldGenerate()) return functionDeclaration;

    // Create arguments prototype vector.
    std::vector<Type*> argumentTypes;
    for (auto argumentPair: arguments) {
      argumentTypes.push_back(AbstractTypeToLLVMType(argumentPair.second));
    }

    // Create function prototype.
    Type* returnType = AbstractTypeToLLVMType(abstractReturnType);

    // Make Function.
    FunctionType* functionType = FunctionType::get(returnType, argumentTypes, variadic);
    Function* function = Function::Create(functionType, Function::ExternalLinkage, name, TheModule.get());

    // Create BasicBlock to start inserting function body IR into; the BasicBlock
    // is inserted into the Function.
    BasicBlock* BB = BasicBlock::Create(TheContext, "entry", function);
    Builder.SetInsertPoint(BB); // New instructions should be inserted into the BasicBlock.
    BasicBlockStack.push(BB);

    functionDeclaration.function = function;

    // Name arguments and add as local variables.
    // Now that we're "inside" the function, we want to have access to the
    // function arguments via local variables.
    int i = 0;
    for (auto& arg: function->args()) {
      arg.setName(arguments[i].first);
      functionDeclaration.arguments.push_back(
        CreateVariable(/* abstractType */ arguments[i++].second,
                       /* variableName */ arg.getName(),
                       /* isGlobal     */ false,
                       /* isArray      */ false,
                       /* initialValue */ &arg)
      );
    }

    FunctionTable[name] = function;
    return functionDeclaration;
  }

  static void Return() {
    if (!ShouldGenerate()) return;
    Builder.CreateRetVoid();
    PendingReturn = true;
  }

  static void Return(Value* returnValue) {
    if (!ShouldGenerate()) return;
    Builder.CreateRet(returnValue);
    PendingReturn = true;
  }

  static void EndFunction(Value* returnValue = nullptr) {
    // We shouldn't have the full-blown |ShouldGenerate| check here, or else
    // when we have a pending return out, we'll never be able to escape this
    // state. Instead, we just want an |ErrorState| check so that we can
    // "unflip" the |PendingReturn| state.
    if (ErrorState) return;
    Function* currentFunction = Builder.GetInsertBlock()->getParent();
    verifyFunction(*currentFunction);

    // TODO(domfarolino): Remove parameters from |LocalVariables| map
    // https://github.com/domfarolino/llvm-experiments/issues/13.

    Return();
    NextBlockForInsertion();
  }

  static Value* CallFunction(const std::string& name,
                             const std::vector<Value*>& args,
                             const std::string& regName = "") {
    if (!ShouldGenerate()) return nullptr;
    Function* function = FunctionTable[name];
    return Builder.CreateCall(function, args, regName);
  }

  static void IfThen(Value* inCondition) {
    if (!ShouldGenerate()) return;
    inCondition = ToBool(inCondition);
    // Assert: |inCondition| is now an integer type, whose width is 1. See
    // http://llvm.org/doxygen/Type_8h_source.html#l00199.

    Function* currentFunction = Builder.GetInsertBlock()->getParent();

    // Add |ThenBB| to |currentFunction| right now.
    BasicBlock *ThenBB = BasicBlock::Create(TheContext, "then", currentFunction),
               *ElseBB = BasicBlock::Create(TheContext, "else"),
               *MergeBB = BasicBlock::Create(TheContext, "ifmerge");
    IfBlocksStack.push(IfBlocks(inCondition, ThenBB, ElseBB, MergeBB));
    Builder.CreateCondBr(inCondition, ThenBB, ElseBB);

    // Start generating code into |ThenBB|.
    ReplaceInsertionBlock(ThenBB);
  }

  static void Else() {
    if (ErrorState || IfBlocksStack.empty()) return;
    // When we're ready to generate into |ElseBB|, we have to have |ThenBB|
    // branch to |MergeBB|, update our reference to |ThenBB|, push |ElseBB| to
    // the current function's list of BasicBlocks, and start generating into
    // |ElseBB|.

    // Assert: !IfBlocksStack.empty().
    IfBlocks CurrentIfBlock = IfBlocksStack.top();
    if (!PendingReturn) Builder.CreateBr(CurrentIfBlock.MergeBB);

    // This is subtle but necessary, as 'Then' codegen can change the current
    // block.
    // TODO(domfarolino): Can I get rid of this now that we're not using a PHI
    // node?
    CurrentIfBlock.ThenBB = Builder.GetInsertBlock();

    // Push |ElseBB| to |currentFunction|'s list of BasicBlocks, and start
    // generating into |ElseBB|.
    Function* currentFunction = Builder.GetInsertBlock()->getParent();
    currentFunction->getBasicBlockList().push_back(CurrentIfBlock.ElseBB);
    ReplaceInsertionBlock(CurrentIfBlock.ElseBB);
  }

  static void EndIf() {
    if (ErrorState || IfBlocksStack.empty()) return;
    // Assert: !IfBlocksStack.empty().
    IfBlocks CurrentIfBlock = IfBlocksStack.top();
    // See Else().
    if (!PendingReturn) Builder.CreateBr(CurrentIfBlock.MergeBB);

    // Same subtle-but-necessary trick as in Else().
    CurrentIfBlock.ElseBB = Builder.GetInsertBlock();

    // Deal with |MergeBB|.
    Function* currentFunction = Builder.GetInsertBlock()->getParent();
    currentFunction->getBasicBlockList().push_back(CurrentIfBlock.MergeBB);
    ReplaceInsertionBlock(CurrentIfBlock.MergeBB);

    /*Shouldn't need this (also it is breaking in nested ifs).
    PHINode *PHN = Builder.CreatePHI(Type::getDoubleTy(TheContext), 2, "ifphi");
    PHN->addIncoming(ProduceFloat(1), CurrentIfBlock.ThenBB);
    PHN->addIncoming(ProduceFloat(2), CurrentIfBlock.ElseBB);*/

    IfBlocksStack.pop();
  }

  // For loop APIs.
  // Maybe refactor the for loop initialization methods. See
  // https://github.com/domfarolino/llvm-experiments/issues/32.
  static void For() {
    if (!ShouldGenerate()) return;
    Function* currentFunction = Builder.GetInsertBlock()->getParent();

    BasicBlock *CondEvalBB = BasicBlock::Create(TheContext, "condeval", currentFunction),
               *LoopBB = BasicBlock::Create(TheContext, "loop"),
               *PostLoopBB = BasicBlock::Create(TheContext, "postloop");
    ForLoopBlocksStack.push(ForLoopBlocks(CondEvalBB, LoopBB, PostLoopBB));

    // Start generating code into |CondEvalBB|.
    Builder.CreateBr(CondEvalBB);
    ReplaceInsertionBlock(CondEvalBB);
  }

  static void ForCondition(Value* inCondition) {
    if (!ShouldGenerate()) return;
    inCondition = ToBool(inCondition);
    // Assert: |inCondition| is now an integer type, whose width is 1. See
    // http://llvm.org/doxygen/Type_8h_source.html#l00199.

    ForLoopBlocks CurrentForLoopBlock = ForLoopBlocksStack.top();
    Function* currentFunction = Builder.GetInsertBlock()->getParent();
    currentFunction->getBasicBlockList().push_back(CurrentForLoopBlock.LoopBB);

    // Start generating code into |LoopBB|.
    Builder.CreateCondBr(inCondition, CurrentForLoopBlock.LoopBB, CurrentForLoopBlock.PostLoopBB);
    ReplaceInsertionBlock(CurrentForLoopBlock.LoopBB);
  }

  static void EndFor() {
    if (ErrorState || ForLoopBlocksStack.empty()) return;
    ForLoopBlocks CurrentForLoopBlock = ForLoopBlocksStack.top();

    if (!PendingReturn) Builder.CreateBr(CurrentForLoopBlock.CondEvalBB);

    Function* currentFunction = Builder.GetInsertBlock()->getParent();
    currentFunction->getBasicBlockList().push_back(CurrentForLoopBlock.PostLoopBB);

    // Start generating post-loop code into |PostLoopBB|.
    ReplaceInsertionBlock(CurrentForLoopBlock.PostLoopBB);
    ForLoopBlocksStack.pop();
  }

/////////////////// End Function & Control Flow Management ////////////////////

///////////////////////////////// Begin Casts /////////////////////////////////
// This subsection consists of various casting algorithms implemented on top of
// the LLVM builder APIs. The following casts are implemented so far:
//   - Float   => Integer
//   - Float   => Bool
//   - Integer => Float
//   - Integer => Bool
//   - Bool    => Integer
//   - Bool    => Float

  // This function should only be called whenever the input Value* is
  // guaranteed to be boolean-equivalent.
  static Value* ToBool(Value* input) {
    if (!ShouldGenerate()) return nullptr;
    if (input->getType()->isDoubleTy())
      return CastFloatToBool(input);
    else if (static_cast<IntegerType*>(input->getType())->getBitWidth() == 32)
      return CastIntegerToBool(input);

    // Assert: getBitWidth == 1 (already a bool).
    return input;
  }

  static Value* CastFloatToInteger(Value* input) {
    if (!ShouldGenerate()) return nullptr;
    BasicBlock* BB = Builder.GetInsertBlock();
    if (!BB) {
      std::cout << "BasicBlock not available for cast, something is wrong..." << std::endl;
      return nullptr;
    }

    return new FPToSIInst(input, Type::getInt32Ty(TheContext), "float-to-integer", BB);
  }

  static Value* CastFloatToBool(Value* input) {
    if (!ShouldGenerate()) return nullptr;
    BasicBlock* BB = Builder.GetInsertBlock();
    if (!BB) {
      std::cout << "BasicBlock not available for cast, something is wrong..." << std::endl;
      return nullptr;
    }

    return Builder.CreateFCmpONE(input, ProduceFloat(0.0), "float-to-bool");
  }

  static Value* CastIntegerToFloat(Value* input) {
    if (!ShouldGenerate()) return nullptr;
    BasicBlock* BB = Builder.GetInsertBlock();
    if (!BB) {
      std::cout << "BasicBlock not available for cast, something is wrong..." << std::endl;
      return nullptr;
    }

    return new SIToFPInst(input, Type::getDoubleTy(TheContext), "integer-to-float", BB);
  }

  static Value* CastIntegerToBool(Value* input) {
    if (!ShouldGenerate()) return nullptr;
    BasicBlock* BB = Builder.GetInsertBlock();
    if (!BB) {
      std::cout << "BasicBlock not available for cast, something is wrong..." << std::endl;
      return nullptr;
    }

    // TODO(domfarolino): Maybe replace this with a more straightforward cast:
    // https://stackoverflow.com/questions/47264133/.
    return Builder.CreateFCmpONE(CastIntegerToFloat(input), ProduceFloat(0), "integer-to-bool");
  }

  static Value* CastBoolToInteger(Value* input) {
    if (!ShouldGenerate()) return nullptr;
    BasicBlock* BB = Builder.GetInsertBlock();
    if (!BB) {
      std::cout << "BasicBlock not available for cast, something is wrong..." << std::endl;
      return nullptr;
    }

    return Builder.CreateZExt(input, Type::getInt32Ty(TheContext), "bool-to-integer");
  }

  static Value* CastBoolToFloat(Value* input) {
    if (!ShouldGenerate()) return nullptr;
    BasicBlock* BB = Builder.GetInsertBlock();
    if (!BB) {
      std::cout << "BasicBlock not available for cast, something is wrong..." << std::endl;
      return nullptr;
    }

    // float something = integer(someBoolean);
    return CastIntegerToFloat(CastBoolToInteger(input));
  }

////////////////////////////////// End Casts //////////////////////////////////

};
