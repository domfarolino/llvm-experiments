; ModuleID = 'Dom Sample'
source_filename = "Dom Sample"

@0 = private unnamed_addr constant [4 x i8] c"%d\0A\00"
@1 = private unnamed_addr constant [4 x i8] c"%d\0A\00"
@2 = private unnamed_addr constant [4 x i8] c"%f\0A\00"
@3 = private unnamed_addr constant [4 x i8] c"%s\0A\00"
@4 = private unnamed_addr constant [4 x i8] c"%c\0A\00"
@5 = private unnamed_addr constant [21 x i8] c"integerArgument: %d\0A\00"
@6 = private unnamed_addr constant [19 x i8] c"floatArgument: %f\0A\00"

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
  call void @negateInteger(i32 234)
  call void @negateFloat(double 1.080940e+01)
  ret i32 0
}

define void @negateInteger(i32 %integerArgument) {
entry:
  %integerArgument1 = alloca i32
  store i32 %integerArgument, i32* %integerArgument1
  %integerArgument2 = load i32, i32* %integerArgument1
  %0 = sub i32 0, %integerArgument2
  store i32 %0, i32* %integerArgument1
  %integerArgument3 = load i32, i32* %integerArgument1
  %1 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([21 x i8], [21 x i8]* @5, i32 0, i32 0), i32 %integerArgument3)
  ret void
}

define void @negateFloat(double %floatArgument) {
entry:
  %floatArgument1 = alloca double
  store double %floatArgument, double* %floatArgument1
  %floatArgument2 = load double, double* %floatArgument1
  %0 = fsub double 0.000000e+00, %floatArgument2
  store double %0, double* %floatArgument1
  %floatArgument3 = load double, double* %floatArgument1
  %1 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([19 x i8], [19 x i8]* @6, i32 0, i32 0), double %floatArgument3)
  ret void
}
