# llvm-experiments

Just me, experimenting with the LLVM C API

Helpful links so far:
 - https://llvm.org/docs/tutorial/LangImpl03.html
 - https://stackoverflow.com/questions/20059036/llvm-cast-instructions
 - https://www.ibm.com/developerworks/library/os-createcompilerllvm1/index.html

The testing story for htis repository is less than ideal. To get going:

 1. Build the tests: `make`
 1. Run the tests: `bash tests/run_tests.sh`

# CodeGen API

This section contains various documentation bits for the `CodeGen::` APIs.

## Meta APIs

This section contains APIs that don't often get called, and instead deal mostly with
setup, teardown, or "administrative" tasks often unrelated to core functionality.

#### `void CodeGen::Setup()`

This should be called once in the beginning of `CodeGen`'s life. It needs modified,
however, before being merged into the [compiler](https://github.com/domfarolino/compiler.git).
See https://github.com/domfarolino/llvm-experiments/issues/23.

#### `void CodeGen::PrintBitCode()`

This is a temporary method that likely won't exist when this project is merged into
the compiler. For now it is used to emit LLVM bitcode to stdout, for basic testing
purposes. It is "good enough" for now, since removing this in favor or
executable-producing code does not actually improve the "functionality" of the code
generator, per se.

#### `Value* CodeGen::Produce{Type}(Type)`

The `{Type}` is supposed to represent a placeholder for all of the valid types. This
method takes in a C++ value for some type, and statically produces an LLVM `Value*`
representing it. This is mostly used for static variable assignments.

## Operators

### Unary Operators

This section is relatively brief, as the inputs and outputs are self-explanatory.
Provided below is a brief list of everything in this category:

 - `Value* CodeGen::NegateInteger(Value*)`
   - Produces an `sub` instruction, subtracting the given value from `0`, thus
     negating it.
 - `Value* CodeGen::NegateFloat(Value*)`
   - Produces an `fsub` instruction, subtracting the given value from `0`, thus
     negating it.

#### Binary Operators

This section is relatively brief, as the inputs and outputs are self-explanatory.
Provided below is a brief list of everything in this category:

 - `AddFloats`
 - `AddIntegers`
 - `SubtractFloats`
 - `SubtractIntegers`
 - `MultiplyFloats`
 - `MultiplyIntegers`
 - `DivideFloats`
 - `DivideIntegers`
 - `BitwiseAndIntegers`
 - `BitwiseOrIntegers`

Relational operators:

 - `LessThanFloats`
 - `LessThanIntegers`
 - `LessThanOrEqualFloats`
 - `LessThanOrEqualIntegers`
 - `GreaterThanFloats`
 - `GreaterThanIntegers`
 - `GreaterThanOrEqualFloats`
 - `GreaterThanOrEqualIntegers`
 - `EqualFloats`
 - `EqualIntegers`
 - `NotEqualFloats`
 - `NotEqualIntegers`

## Core APIs

This section contains APIs relevant to the core functionality of the code generator.

#### `Value* CodeGen::GetVariable(name)`

This is the go-to general get-the-value-of-the-variable method. It takes a string
`|name|`, and creates a `load` instruction for the LLVM `Value*` associated with
`|name|`, in the `LocalVariables` map. It returns the loaded `Value*`.

This is used when passing non-reference variables to the `putX` methods, as well as
passing variables by *value* to functions, etc.

#### `Value* CodeGen::GetReferenceVariableValue(name)`

A variable in some scope may be a reference variable (think, pointer), and when we
want to use the value of a reference variable we effectively need to *"dereference*" it.
That's what this method does:

 - Takes in the name of a reference variable
 - Creates a `load` instruction for the variable reference
 - Creates a `load` instruction for the _loaded_ variable reference
 - Returns the result of the step immediately above, an LLVM `Value*`

This is used when passing reference-variables to the `putX` methods, as well as
passing variables by *reference* to functions, etc.

#### `Value* CodeGen::GetVariableReference(name)`

#### `Value* CodeGen::Assign(name)`

#### `Value* CodeGen::AssignReferenceVariable(name)`

#### `Value* CodeGen::CreateVariable(type, name, global, init_val)`

# Provided Tests

The tests in this repository are as follows:

 - bitwise.cpp
   - Tests `CodeGen::BitwiseAndIntegers` and `CodeGen::BitwiseOrIntegers`
 - boolTo.cpp
   - Tests `CodeGen::CastBoolToInteger` and `CodeGen::CastBoolToFloat`
