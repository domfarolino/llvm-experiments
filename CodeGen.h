#include <map>
#include <stack>
#include <vector>
#include <utility> // for std::tuple.

#include "llvm/IR/Verifier.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/LegacyPassManager.h"
#include "llvm/Support/TargetParser.h"
#include "llvm/Support/TargetRegistry.h"
#include "llvm/Support/TargetSelect.h"
#include "llvm/Target/TargetOptions.h"
#include "llvm/Target/TargetMachine.h"
#include "llvm/Bitcode/BitcodeWriter.h"
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
  FloatArray,
  FloatArrayRef,
  Bool,
  BoolRef,
  BoolArray,
  BoolArrayRef,
  Char,
  CharRef,
  CharArray,
  CharArrayRef,
  String,
  StringRef,
  StringArray,
  StringArrayRef,
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
    CodeGen::CreateFunction("putInteger", AbstractType::Void, { std::make_tuple("out", AbstractType::Integer, 0) });
    CodeGen::CallFunction("printf", { CodeGen::ProduceString("%d\n"), CodeGen::GetVariable("out") });
    CodeGen::EndFunction();

    // Declare |putFloat|.
    CodeGen::CreateFunction("putFloat", AbstractType::Void, { std::make_tuple("out", AbstractType::Float, 0) });
    CodeGen::CallFunction("printf", { CodeGen::ProduceString("%lf\n"), CodeGen::GetVariable("out") });
    CodeGen::EndFunction();

    // Declare |putBool|.
    CodeGen::CreateFunction("putBool", AbstractType::Void, { std::make_tuple("out", AbstractType::Bool, 0) });
    CodeGen::CallFunction("printf", { CodeGen::ProduceString("%d\n"), CodeGen::GetVariable("out") });
    CodeGen::EndFunction();

    // Declare |putChar|.
    CodeGen::CreateFunction("putChar", AbstractType::Void, { std::make_tuple("out", AbstractType::Char, 0) });
    CodeGen::CallFunction("printf", { CodeGen::ProduceString("%c\n"), CodeGen::GetVariable("out") });
    CodeGen::EndFunction();

    // Declare |putString|.
    CodeGen::CreateFunction("putString", AbstractType::Void, { std::make_tuple("out", AbstractType::String, 0) });
    CodeGen::CallFunction("printf", { CodeGen::ProduceString("%s\n"), CodeGen::GetVariable("out") });
    CodeGen::EndFunction();

    // Declare |getInteger|.
    CodeGen::CreateFunction("getInteger", AbstractType::Void, { std::make_tuple("out", AbstractType::IntegerRef, 0) });
    CodeGen::CallFunction("scanf", { CodeGen::ProduceString("%d"), CodeGen::GetVariable("out") });
    CodeGen::EndFunction();

    // Declare |getFloat|.
    CodeGen::CreateFunction("getFloat", AbstractType::Void, { std::make_tuple("out", AbstractType::FloatRef, 0) });
    CodeGen::CallFunction("scanf", { CodeGen::ProduceString("%lf"), CodeGen::GetVariable("out") });
    CodeGen::EndFunction();

    // Declare |getBool|.
    // This is a little more involved, because to get it to work correctly, we
    // have to give |scanf| an integer, and then cast the integer to a bool.
    CodeGen::CreateFunction("getBool", AbstractType::Void, { std::make_tuple("out", AbstractType::BoolRef, 0) });
    CodeGen::CreateVariable(AbstractType::Integer, "tmpInteger");
    CodeGen::CallFunction("scanf", { CodeGen::ProduceString("%d"), CodeGen::GetVariableReference("tmpInteger") });
    CodeGen::AssignReferenceVariable("out", CodeGen::CastIntegerToBool(CodeGen::GetVariable("tmpInteger")));
    CodeGen::EndFunction();

    // Declare |getChar|.
    CodeGen::CreateFunction("getChar", AbstractType::Void, { std::make_tuple("out", AbstractType::CharRef, 0) });
    CodeGen::CallFunction("scanf", { CodeGen::ProduceString(" %c"), CodeGen::GetVariable("out") });
    CodeGen::EndFunction();

    // Declare |getString|.
    CodeGen::CreateFunction("getString", AbstractType::Void, { std::make_tuple("out", AbstractType::StringRef, 0) });
    CodeGen::CallFunction("scanf", { CodeGen::ProduceString("%s"), CodeGen::GetReferenceVariableValue("out") });
    CodeGen::EndFunction();
  }

  // CreateVariable delegates to this.
  // Constants don't yet support user-defined initial values.
  static GlobalVariable* CreateGlobalVariable(AbstractType abstractType,
                                              const std::string& variableName,
                                              int array_length) {
    Constant* initialValue = CreateInitialValueGivenType(abstractType);
    GlobalVariable* globalVariable =
        new GlobalVariable(/* Module */ *TheModule,
                           /* Type */ AbstractTypeToLLVMType(abstractType,
                                                             array_length),
                           /* isConstant */ false, // Not yet supported by us.
                           /* Linkage */ GlobalValue::CommonLinkage,
                           /* Initializer */ initialValue,
                           /* name */ variableName.c_str());
    LocalVariables[variableName] = globalVariable;
    return globalVariable;
  }

  // Used as a helper.
  static Type* AbstractTypeToLLVMType(AbstractType abstractType,
                                      int array_size) {
    // Assert: (IsArrayType(abstract_type) && array_size) ||
    //         (!IsArrayType(abstract_type) && !array_size).
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
      return ArrayType::get(Type::getInt32Ty(TheContext), array_size);
    else if (abstractType == AbstractType::FloatArray)
      return ArrayType::get(Type::getDoubleTy(TheContext), array_size);
    else if (abstractType == AbstractType::BoolArray)
      return ArrayType::get(Type::getInt1Ty(TheContext), array_size);
    else if (abstractType == AbstractType::CharArray)
      return ArrayType::get(Type::getInt8Ty(TheContext), array_size);
    else if (abstractType == AbstractType::StringArray)
      return ArrayType::get(Type::getInt8Ty(TheContext)->getPointerTo(), array_size);
    // Array reference types.
    else if (abstractType == AbstractType::IntegerArrayRef)
      return ArrayType::get(Type::getInt32Ty(TheContext), array_size)->getPointerTo();
    else if (abstractType == AbstractType::FloatArrayRef)
      return ArrayType::get(Type::getDoubleTy(TheContext), array_size)->getPointerTo();
    else if (abstractType == AbstractType::BoolArrayRef)
      return ArrayType::get(Type::getInt1Ty(TheContext), array_size)->getPointerTo();
    else if (abstractType == AbstractType::CharArrayRef)
      return ArrayType::get(Type::getInt8Ty(TheContext), array_size)->getPointerTo();
    else if (abstractType == AbstractType::StringArrayRef)
      return ArrayType::get(Type::getInt8Ty(TheContext)->getPointerTo(), array_size)->getPointerTo();

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

  static void PrintBitCode(const std::string& file_name) {
    if (!ShouldGenerate()) return;
    TheModule->print(errs(), nullptr);

    InitializeAllTargetInfos();
    InitializeAllTargets();
    InitializeAllTargetMCs();
    InitializeAllAsmParsers();
    InitializeAllAsmPrinters();

    auto TargetTriple = sys::getDefaultTargetTriple();
    TheModule->setTargetTriple(TargetTriple);

    std::string Error;
    auto Target = TargetRegistry::lookupTarget(TargetTriple, Error);

    // Print an error and exit if we couldn't find the requested target.
    // This generally occurs if we've forgotten to initialise the
    // TargetRegistry or we have a bogus target triple.
    if (!Target) {
      errs() << Error;
      return;
    }

    auto CPU = "generic";
    auto Features = "";

    TargetOptions opt;
    auto RM = Optional<Reloc::Model>();
    auto TheTargetMachine =
        Target->createTargetMachine(TargetTriple, CPU, Features, opt, RM);

    TheModule->setDataLayout(TheTargetMachine->createDataLayout());

    std::error_code EC;
    std::string object_file_name = file_name + ".o";
    raw_fd_ostream dest(object_file_name, EC);

    if (EC) {
      errs() << "Could not open file: " << EC.message();
      return;
    }

    legacy::PassManager pass;
    auto FileType = TargetMachine::CGFT_ObjectFile;

    if (TheTargetMachine->addPassesToEmitFile(pass, dest, nullptr, FileType)) {
      errs() << "TheTargetMachine can't emit a file of this type";
      return;
    }

    pass.run(*TheModule);
    dest.flush();

    //outs() << "Wrote " << object_file_name << "\n";

    std::string sys1 = "clang " + object_file_name + " -o " + file_name + ".bin",
                sys2 = "rm " + object_file_name;
    system(sys1.c_str());
    system(sys2.c_str());
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

  static Constant* ProduceIntegerArray(int array_size) {
    return ConstantArray::get(ArrayType::get(Type::getInt32Ty(TheContext),
                                array_size),
                              std::vector<Constant*>(array_size,
                                                     ProduceInteger(0)));
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
  static Value* And(Value* lhs, Value* rhs, const std::string& regName = "") {
    if (!ShouldGenerate()) return nullptr;
    return Builder.CreateAnd(lhs, rhs, regName);
  }
  static Value* Or(Value* lhs, Value* rhs, const std::string& regName = "") {
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

  // Array operators.
  static Value* AndSingleArray(Value* left_val, Value* right_array,
                               int array_size, AbstractType primitive_type) {
    // |left_val|: the value we'll "&" all of the array elements with.
    // |right_array|: the array.

    AbstractType return_array_type = ArrayTypeFromPrimitive(primitive_type);
    // Assert: (return_array_type == AbstractType::IntegerArray ||
    //          return_array_type == AbstractType::BoolArray)

    Value* i = CodeGen::CreateVariable(AbstractType::Integer, "$i$");
    Value* return_array = CodeGen::CreateVariable(return_array_type,
                                                  "$tmp_arr$", false, true,
                                                  array_size);
    CodeGen::For();
    CodeGen::ForCondition(CodeGen::LessThanIntegers(CodeGen::Load(i), ProduceInteger(array_size)));
      // Right value at index |i|.
      Value* return_array_element = CodeGen::IndexArray(return_array, CodeGen::Load(i));
      Value* right_val = CodeGen::Load(CodeGen::IndexArray(right_array, CodeGen::Load(i)));

      // Assign elements.
      CodeGen::Assign(return_array_element, CodeGen::And(left_val, right_val));
      CodeGen::Assign(i, CodeGen::AddIntegers(CodeGen::Load(i), ProduceInteger(1)));
    CodeGen::EndFor();

    return return_array;
  }
  static Value* OrSingleArray(Value* left_val, Value* right_array, int array_size,
                               AbstractType primitive_type) {
    // |left_val|: the value we'll "|" all of the array elements with.
    // |right_array|: the array.

    AbstractType return_array_type = ArrayTypeFromPrimitive(primitive_type);
    // Assert: (return_array_type == AbstractType::IntegerArray ||
    //          return_array_type == AbstractType::BoolArray)

    Value* i = CodeGen::CreateVariable(AbstractType::Integer, "$i$");
    Value* return_array = CodeGen::CreateVariable(return_array_type,
                                                  "$tmp_arr$", false, true,
                                                  array_size);
    CodeGen::For();
    CodeGen::ForCondition(CodeGen::LessThanIntegers(CodeGen::Load(i), ProduceInteger(array_size)));
      // Right value at index |i|.
      Value* return_array_element = CodeGen::IndexArray(return_array, CodeGen::Load(i));
      Value* right_val = CodeGen::Load(CodeGen::IndexArray(right_array, CodeGen::Load(i)));

      // Assign elements.
      CodeGen::Assign(return_array_element, CodeGen::Or(left_val, right_val));
      CodeGen::Assign(i, CodeGen::AddIntegers(CodeGen::Load(i), ProduceInteger(1)));
    CodeGen::EndFor();

    return return_array;
  }
  static Value* AndArrays(Value* left_array, Value* right_array, int array_size,
                          AbstractType primitive_type) {
    AbstractType return_array_type = ArrayTypeFromPrimitive(primitive_type);
    // Assert: (return_array_type == AbstractType::IntegerArray ||
    //          return_array_type == AbstractType::BoolArray)

    Value* i = CodeGen::CreateVariable(AbstractType::Integer, "$i$");
    Value* return_array = CodeGen::CreateVariable(return_array_type,
                                                  "$tmp_arr$", false, true,
                                                  array_size);
    CodeGen::For();
    CodeGen::ForCondition(CodeGen::LessThanIntegers(CodeGen::Load(i), ProduceInteger(array_size)));
      // Left & right value at index |i|.
      Value* return_array_element = CodeGen::IndexArray(return_array, CodeGen::Load(i));
      Value* left_val = CodeGen::Load(CodeGen::IndexArray(left_array, CodeGen::Load(i)));
      Value* right_val = CodeGen::Load(CodeGen::IndexArray(right_array, CodeGen::Load(i)));

      // Assign elements.
      CodeGen::Assign(return_array_element, CodeGen::And(left_val, right_val));
      CodeGen::Assign(i, CodeGen::AddIntegers(CodeGen::Load(i), ProduceInteger(1)));
    CodeGen::EndFor();

    return return_array;
  }
  static Value* OrArrays(Value* left_array, Value* right_array, int array_size,
                          AbstractType primitive_type) {
    AbstractType return_array_type = ArrayTypeFromPrimitive(primitive_type);
    // Assert: (return_array_type == AbstractType::IntegerArray ||
    //          return_array_type == AbstractType::BoolArray)

    Value* i = CodeGen::CreateVariable(AbstractType::Integer, "$i$");
    Value* return_array = CodeGen::CreateVariable(return_array_type,
                                                  "$tmp_arr$", false, true,
                                                  array_size);
    CodeGen::For();
    CodeGen::ForCondition(CodeGen::LessThanIntegers(CodeGen::Load(i), ProduceInteger(array_size)));
      // Left & right value at index |i|.
      Value* return_array_element = CodeGen::IndexArray(return_array, CodeGen::Load(i));
      Value* left_val = CodeGen::Load(CodeGen::IndexArray(left_array, CodeGen::Load(i)));
      Value* right_val = CodeGen::Load(CodeGen::IndexArray(right_array, CodeGen::Load(i)));

      // Assign elements.
      CodeGen::Assign(return_array_element, CodeGen::Or(left_val, right_val));
      CodeGen::Assign(i, CodeGen::AddIntegers(CodeGen::Load(i), ProduceInteger(1)));
    CodeGen::EndFor();

    return return_array;
  }
  static Value* AddIntegerArrays(Value* left, Value* right) {
    int array_size = ArrayLength(left);
    // Assert: array_size == ArrayLength(right);

    Value* i = CodeGen::CreateVariable(AbstractType::Integer, "$i$");
    Value* return_array = CodeGen::CreateVariable(AbstractType::IntegerArray, "$tmp_arr$", false, true, array_size);
    CodeGen::For();
    CodeGen::ForCondition(CodeGen::LessThanIntegers(CodeGen::Load(i), ProduceInteger(array_size)));
      // Left & right value at index |i|.
      Value* return_array_element = CodeGen::IndexArray(return_array, CodeGen::Load(i));
      Value* left_val = CodeGen::Load(CodeGen::IndexArray(left, CodeGen::Load(i)));
      Value* right_val = CodeGen::Load(CodeGen::IndexArray(right, CodeGen::Load(i)));

      // Assign elements.
      CodeGen::Assign(return_array_element, CodeGen::AddIntegers(left_val, right_val));
      CodeGen::Assign(i, CodeGen::AddIntegers(CodeGen::Load(i), ProduceInteger(1)));
    CodeGen::EndFor();
    return return_array;
  }
  static Value* AddFloatArrays(Value* left, Value* right) {
    int array_size = ArrayLength(left);
    // Assert: array_size == ArrayLength(right);

    Value* i = CodeGen::CreateVariable(AbstractType::Integer, "$i$");
    Value* return_array = CodeGen::CreateVariable(AbstractType::FloatArray, "$tmp_arr$", false, true, array_size);
    CodeGen::For();
    CodeGen::ForCondition(CodeGen::LessThanIntegers(CodeGen::Load(i), ProduceInteger(array_size)));
      // Left & right value at index |i|.
      Value* return_array_element = CodeGen::IndexArray(return_array, CodeGen::Load(i));
      Value* left_val = CodeGen::Load(CodeGen::IndexArray(left, CodeGen::Load(i)));
      Value* right_val = CodeGen::Load(CodeGen::IndexArray(right, CodeGen::Load(i)));

      // Assign elements.
      CodeGen::Assign(return_array_element, CodeGen::AddFloats(left_val, right_val));
      CodeGen::Assign(i, CodeGen::AddIntegers(CodeGen::Load(i), ProduceInteger(1)));
    CodeGen::EndFor();
    return return_array;
  }

////////////////////////// Begin Variable Management //////////////////////////

  // 🛑 [WARNING] 🛑 : These methods should only be used for testing ////////////
  // They are considered testing-only, because they do fancy abstractions over
  // the basic bare-necessity |Load()| and |Assign()| methods, which make
  // testing easy, but aren't really necessary in the compiler project. Also
  // they all take in a string argument representing the name of the variable
  // they're operating on, which utilizes the |LocalVariables| map, which is a
  // test-only substitution for a symbol table. Therefore, we should never use
  // it in the context of an actual compiler, where the symbol Value*s are
  // available to us from the table.

  // General get-the-value-of-a-variable function.
  static Value* GetVariable(const std::string& name) {
    if (!ShouldGenerate()) return nullptr;
    if (LocalVariables.find(name) == LocalVariables.end()) {
      std::cout << "Could not find variable with name: " << name << std::endl;
      return nullptr;
    }

    Value* variable_alloca = LocalVariables[name];
    // This is probably going to be replaced by a call to ScopeManager::{lookup, getSymbol}.
    return Builder.CreateLoad(variable_alloca, name.c_str());
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

  // If we were to support chained assignments (x = y = 2), we may want the
  // implementations of |Assign| and |AssignReferenceVariable| to return the
  // |rhs| value.
  static void Assign(const std::string& variableName, Value* rhs) {
    if (!ShouldGenerate()) return;
    // Use original AllocaInst* (uh, Value*) because we don't want the actual
    // value as the LHS, but the "reference" to the value.
    Value* variable = LocalVariables[variableName];
    if (!variable) {
      std::cout << "Could not find local variable with name: '" <<
      variableName << "'" << std::endl;
      return;
    }

    Builder.CreateStore(rhs, variable);
  }

  // This is used to assign the value of a reference variable |variableName| to
  // |rhs|. It essentially is the same as |Assign|, but dereferences first.
  static void AssignReferenceVariable(const std::string& variableName,
                                      Value* rhs) {
    if (!ShouldGenerate()) return;
    // We create a load here.
    Value* variable = GetVariable(variableName);
    Builder.CreateStore(rhs, variable);
  }

  // End ✅ [WARNING] ✅  ////////////////////////////////////////////////////

  // The below Variable Management APIs are for "production" use, i.e.,
  // primarily used in the compiler project. They are the bare-minimum to
  // provide full variable and array functionality, and do not rely on the
  // built-in pseudo-symbol-table. We can still, however, use these methods in
  // tests, just by using |GetVariableReference()| whenever we need to get the
  // Value* of some variable that would otherwise be provided to us by an
  // external symbol table.

  // Our main "given an AllocaInst*, return the loaded Value* of it" function.
  static Value* Load(Value* value, const std::string& reg_name = "") {
    if (!ShouldGenerate()) return nullptr;
    return Builder.CreateLoad(value, reg_name.c_str());
  }

  // Given an AllocaInst* LHS and a Value* RHS whose type matches the type that
  // the AllocaInst* refers to, store RHS into the LHS variable.
  static void Assign(Value* lhs, Value* rhs) {
    Builder.CreateStore(rhs, lhs);
  }

  // This takes in an array's AllocaInst* Value*, and a literal index value in
  // Value*-form, and returns/creates a GEP (index, essentially) instruction to
  // access the intended element.
  static Value* IndexArray(Value* array_ptr, Value* index) {
    auto zero = ConstantInt::get(TheContext, APInt(64, 0, true));
    return Builder.CreateGEP(array_ptr, {zero, index}, "array-index");
  }

  // Creates a normal variable or reference (pointer) to a variable, optionally
  // global. The only time |initialValue| will be passed in is when
  // |CreateVariable| is being called from |CreateFunction|, and the argument
  // value is the |initialValue|. If |initialValue| is not passed in, an initial
  // value will be computed, in non-array-type cases.
  static Value* CreateVariable(AbstractType abstractType,
                               const std::string& variableName,
                               bool isGlobal = false,
                               bool isArray = false,
                               int array_size = 0,
                               Value* initialValue = nullptr) {
    if (!ShouldGenerate()) return nullptr;
    if (isGlobal)
      return CreateGlobalVariable(abstractType, variableName, array_size);

    // For non-array types that do not have an |initialValue|, we want to
    // compute one. We don't do this for arrays, as arrays do not need to
    // be "initialized".
    if (!isArray && !initialValue)
      initialValue = CreateInitialValueGivenType(abstractType);

    // Allocates a stack variable in the current function's |entry| block.
    Function* currentFunction = Builder.GetInsertBlock()->getParent();
    IRBuilder<> EntryBuilder(&currentFunction->getEntryBlock(),
                             currentFunction->getEntryBlock().begin());
    AllocaInst* argAlloca = EntryBuilder.CreateAlloca(
                                           AbstractTypeToLLVMType(abstractType,
                                                                  array_size),
                                           0, variableName.c_str());

    // |initialValue| will only be nullptr here when we're creating a
    // non-parameter array.
    // Assert: |initialValue| or |isArray|.
    if (initialValue) {
      Builder.CreateStore(initialValue, argAlloca);
    }
    LocalVariables[variableName] = argAlloca;
    return argAlloca;
  }

/////////////////////////// End Variable Management ///////////////////////////

////////////////// Begin Function & Control Flow Management ///////////////////

  // Creates an LLVM Function* prototype, generates an IR declaration for it,
  // and adds it to the FunctionTable.
  static FunctionDeclaration CreateFunction(const std::string& name,
                                  AbstractType abstractReturnType,
                                  std::vector<std::tuple<std::string, AbstractType, int>>
                                    arguments,
                                  bool variadic = false) {
    // CreateFunction must return this, so the caller can deal with the
    // Function* and parameter AllocaInst*s appropriately.
    FunctionDeclaration functionDeclaration;
    if (!ShouldGenerate()) return functionDeclaration;

    // Create arguments prototype vector.
    std::vector<Type*> argumentTypes;
    for (auto argumentPair: arguments) {
      argumentTypes.push_back(AbstractTypeToLLVMType(std::get<1>(argumentPair),
                                                     std::get<2>(argumentPair)));
    }

    // Create function prototype.
    // We never return arrays (currently).
    Type* returnType = AbstractTypeToLLVMType(abstractReturnType, 0);

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
      arg.setName(std::get<0>(arguments[i]));
      functionDeclaration.arguments.push_back(
        CreateVariable(/* abstractType */ std::get<1>(arguments[i]),
                       /* variableName */ arg.getName(),
                       /* isGlobal     */ false,
                       /* isArray      */ IsArrayType(std::get<1>(arguments[i])),
                       /* array_length */ std::get<2>(arguments[i]),
                       /* initialValue */ &arg)
      );
      i++;
    }

    FunctionTable[name] = function;
    return functionDeclaration;
  }

  static bool IsArrayType(AbstractType abstract_type) {
    // While it may actually be less writing to check if |abstract_type| is not
    // one of the non-array types, this saves us from when we add more non-array
    // types and potentially forget to update this method, because it would be
    // non-obvious that we'd have to tamper with this.
    return abstract_type == AbstractType::IntegerArray ||
           abstract_type == AbstractType::IntegerArrayRef ||
           abstract_type == AbstractType::FloatArray ||
           abstract_type == AbstractType::FloatArrayRef ||
           abstract_type == AbstractType::BoolArray ||
           abstract_type == AbstractType::BoolArrayRef ||
           abstract_type == AbstractType::CharArray ||
           abstract_type == AbstractType::CharArrayRef ||
           abstract_type == AbstractType::StringArray ||
           abstract_type == AbstractType::StringArrayRef;
  }

  static int ArrayLength(Value* array) {
    Type *T = cast<PointerType>(cast<GetElementPtrInst>(
                CodeGen::IndexArray(array, CodeGen::ProduceInteger(0)))
              ->getPointerOperandType())->getElementType();
    return cast<ArrayType>(T)->getNumElements();
  }

  static AbstractType ArrayTypeFromPrimitive(AbstractType primitive_type) {
    if (primitive_type == AbstractType::Integer)
      return AbstractType::IntegerArray;
    else if (primitive_type == AbstractType::Float)
      return AbstractType::FloatArray;
    else if (primitive_type == AbstractType::Bool)
      return AbstractType::BoolArray;
    else if (primitive_type == AbstractType::Char)
      return AbstractType::CharArray;
    else if (primitive_type == AbstractType::String)
      return AbstractType::StringArray;

    // Assert: Unreached.
    return AbstractType::IntegerArray;
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
//   - Float        => Integer
//   - Float        => Bool
//   - Integer      => Float
//   - Integer      => Bool
//   - Bool         => Integer
//   - Bool         => Float
//   - IntegerArray => FloatArray

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

  static Value* CastIntegerArrayToFloatArray(Value* integer_array) {
    /* Find total number of elements in array */
    int array_size = CodeGen::ArrayLength(integer_array);

    Value* i = CodeGen::CreateVariable(AbstractType::Integer, "$i$");
    Value* return_array = CodeGen::CreateVariable(AbstractType::FloatArray,
                                                  "$tmp_arr$", false, true,
                                                  array_size);
    CodeGen::For();
    CodeGen::ForCondition(CodeGen::LessThanIntegers(CodeGen::Load(i), ProduceInteger(array_size)));
      Value* return_array_element = CodeGen::IndexArray(return_array, CodeGen::Load(i));
      Value* integer_element = CodeGen::Load(CodeGen::IndexArray(integer_array , CodeGen::Load(i)));

      // Assign elements.
      CodeGen::Assign(return_array_element, CodeGen::CastIntegerToFloat(integer_element));
      CodeGen::Assign(i, CodeGen::AddIntegers(CodeGen::Load(i), ProduceInteger(1)));
    CodeGen::EndFor();

    return return_array;
  }

////////////////////////////////// End Casts //////////////////////////////////

};
