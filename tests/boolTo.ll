; ModuleID = 'Dom Sample'
source_filename = "Dom Sample"

@0 = private unnamed_addr constant [4 x i8] c"%d\0A\00"
@1 = private unnamed_addr constant [4 x i8] c"%d\0A\00"
@2 = private unnamed_addr constant [4 x i8] c"%f\0A\00"
@3 = private unnamed_addr constant [4 x i8] c"%s\0A\00"
@4 = private unnamed_addr constant [4 x i8] c"%c\0A\00"

declare i32 @printf(i8*, ...)

define void @putBool(i1 %out) {
entry:
  %out1 = alloca i1
  store i1 %out, i1* %out1
  %out2 = load i1, i1* %out1
  %0 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @0, i32 0, i32 0), i1 %out2)
  ret void
}

define void @putInteger(i32 %out) {
entry:
  %out1 = alloca i32
  store i32 %out, i32* %out1
  %out2 = load i32, i32* %out1
  %0 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @1, i32 0, i32 0), i32 %out2)
  ret void
}

define void @putFloat(double %out) {
entry:
  %out1 = alloca double
  store double %out, double* %out1
  %out2 = load double, double* %out1
  %0 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @2, i32 0, i32 0), double %out2)
  ret void
}

define void @putString(i8* %out) {
entry:
  %out1 = alloca i8*
  store i8* %out, i8** %out1
  %out2 = load i8*, i8** %out1
  %0 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @3, i32 0, i32 0), i8* %out2)
  ret void
}

define void @putChar(i8 %out) {
entry:
  %out1 = alloca i8
  store i8 %out, i8* %out1
  %out2 = load i8, i8* %out1
  %0 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @4, i32 0, i32 0), i8 %out2)
  ret void
}

define i32 @main() {
entry:
  %floatVariable = alloca double
  %integerVariable = alloca i32
  %boolVariable = alloca i1
  store i1 false, i1* %boolVariable
  store i32 0, i32* %integerVariable
  store double 0.000000e+00, double* %floatVariable
  store i1 true, i1* %boolVariable
  %boolVariable1 = load i1, i1* %boolVariable
  %bool-to-integer = zext i1 %boolVariable1 to i32
  store i32 %bool-to-integer, i32* %integerVariable
  %boolVariable2 = load i1, i1* %boolVariable
  %bool-to-integer3 = zext i1 %boolVariable2 to i32
  %integer-to-float = sitofp i32 %bool-to-integer3 to double
  store double %integer-to-float, double* %floatVariable
  %integerVariable4 = load i32, i32* %integerVariable
  call void @putInteger(i32 %integerVariable4)
  %floatVariable5 = load double, double* %floatVariable
  call void @putFloat(double %floatVariable5)
  store i1 false, i1* %boolVariable
  %boolVariable6 = load i1, i1* %boolVariable
  %bool-to-integer7 = zext i1 %boolVariable6 to i32
  store i32 %bool-to-integer7, i32* %integerVariable
  %boolVariable8 = load i1, i1* %boolVariable
  %bool-to-integer9 = zext i1 %boolVariable8 to i32
  %integer-to-float10 = sitofp i32 %bool-to-integer9 to double
  store double %integer-to-float10, double* %floatVariable
  %integerVariable11 = load i32, i32* %integerVariable
  call void @putInteger(i32 %integerVariable11)
  %floatVariable12 = load double, double* %floatVariable
  call void @putFloat(double %floatVariable12)
  ret i32 0
}