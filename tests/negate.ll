; ModuleID = 'Dom Sample'
source_filename = "Dom Sample"

@0 = private unnamed_addr constant [21 x i8] c"integerArgument: %d\0A\00"
@1 = private unnamed_addr constant [19 x i8] c"floatArgument: %f\0A\00"

declare i32 @printf(i8*, ...)

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
  %1 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([21 x i8], [21 x i8]* @0, i32 0, i32 0), i32 %integerArgument3)
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
  %1 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([19 x i8], [19 x i8]* @1, i32 0, i32 0), double %floatArgument3)
  ret void
}
