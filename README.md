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

### `void CodeGen::Setup()`

This should be called once in the beginning of `CodeGen`'s life. It needs modified,
however, before being merged into the [compiler](https://github.com/domfarolino/compiler.git).
See https://github.com/domfarolino/llvm-experiments/issues/23.

### `void CodeGen::PrintBitCode()`

This is a temporary method that likely won't exist when this project is merged into
the compiler. For now it is used to emit LLVM bitcode to stdout, for basic testing
purposes. It is "good enough" for now, since removing this in favor or
executable-producing code does not actually improve the "functionality" of the code
generator, per se.

### `Value* CodeGen::Produce${Type}(Type)`

The `${Type}` is supposed to represent a placeholder for all of the valid types. This
method takes in a C++ value for some type, and statically produces an LLVM `Value*`
representing it. This is mostly used for static variable assignments.

## Unary Operators

This section is relatively brief, as the inputs and outputs are self-explanatory.
Provided below is a brief list of everything in this category:

 - `Value* CodeGen::NegateInteger(Value*)`
   - Produces an `sub` instruction, subtracting the given value from `0`, thus
     negating it.
 - `Value* CodeGen::NegateFloat(Value*)`
   - Produces an `fsub` instruction, subtracting the given value from `0`, thus
     negating it.

## Binary Operators

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

### `Value* CodeGen::GetVariable(name)`

As documentation in the source code indicates, this is the go-to general
get-the-value-of-the-variable method. It takes in a string `|name|`, and returns the
LLVM `Value*` associated with `|name|`, in the `LocalVariables` map.

# Provided Tests

The tests in this repository are as follows:

 - bitwise.cpp
   - Tests `CodeGen::BitwiseAndIntegers` and `CodeGen::BitwiseOrIntegers`
 - boolTo.cpp
   - Tests `CodeGen::CastBoolToInteger` and `CodeGen::CastBoolToFloat`
