; ModuleID = 'Dom Sample'
source_filename = "Dom Sample"

@0 = private unnamed_addr constant [26 x i8] c"FloatAdder returning: %f\0A\00"
@1 = private unnamed_addr constant [28 x i8] c"IntegerAdder returning: %d\0A\00"
@2 = private unnamed_addr constant [9 x i8] c"%d <= 5\0A\00"
@3 = private unnamed_addr constant [8 x i8] c"%d > 5\0A\00"
@4 = private unnamed_addr constant [16 x i8] c"All finished!!\0A\00"
@5 = private unnamed_addr constant [33 x i8] c"FloatAdderResult(from main): %f\0A\00"
@6 = private unnamed_addr constant [35 x i8] c"IntegerAdderResult(from main): %d\0A\00"

declare i32 @printf(i8*, ...)

define i32 @main() {
entry:
  %calladder = call double @FloatAdder(double 4.200000e+01, double 3.800000e+01)
  %calladder1 = call i32 @IntegerAdder(i32 42, i32 38)
  %callprintfFloatAdder = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([33 x i8], [33 x i8]* @5, i32 0, i32 0), double %calladder)
  %callprintfIntegerAdder = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([35 x i8], [35 x i8]* @6, i32 0, i32 0), i32 %calladder1)
  %float-to-bool = fcmp one double %calladder, 0.000000e+00
  call void @integerFunction(i32 0)
  ret i32 %calladder1
}

define double @FloatAdder(double %floatLeft, double %floatRight) {
entry:
  %floatRight2 = alloca double
  %floatLeft1 = alloca double
  store double %floatLeft, double* %floatLeft1
  store double %floatRight, double* %floatRight2
  %floatLeft3 = load double, double* %floatLeft1
  %floatRight4 = load double, double* %floatRight2
  %floatAddUltimateReturn = fdiv double %floatLeft3, %floatRight4
  %callprintf = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([26 x i8], [26 x i8]* @0, i32 0, i32 0), double %floatAddUltimateReturn)
  ret double %floatAddUltimateReturn
}

define i32 @IntegerAdder(i32 %integerLeft, i32 %integerRight) {
entry:
  %integerRight2 = alloca i32
  %integerLeft1 = alloca i32
  store i32 %integerLeft, i32* %integerLeft1
  store i32 %integerRight, i32* %integerRight2
  %integerLeft3 = load i32, i32* %integerLeft1
  %integerRight4 = load i32, i32* %integerRight2
  %integerAddUltimateReturn = sdiv i32 %integerLeft3, %integerRight4
  %callprintf = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([28 x i8], [28 x i8]* @1, i32 0, i32 0), i32 %integerAddUltimateReturn)
  ret i32 %integerAddUltimateReturn
}

define void @integerFunction(i32 %integerArgument) {
entry:
  %integerArgument1 = alloca i32
  store i32 %integerArgument, i32* %integerArgument1
  %integerArgument2 = load i32, i32* %integerArgument1
  %0 = icmp slt i32 %integerArgument2, 10
  br i1 %0, label %then, label %else9

then:                                             ; preds = %entry
  %integerArgument3 = load i32, i32* %integerArgument1
  %1 = icmp sle i32 %integerArgument3, 5
  br i1 %1, label %then4, label %else

then4:                                            ; preds = %then
  %integerArgument5 = load i32, i32* %integerArgument1
  %2 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([9 x i8], [9 x i8]* @2, i32 0, i32 0), i32 %integerArgument5)
  br label %ifmerge

else:                                             ; preds = %then
  %integerArgument6 = load i32, i32* %integerArgument1
  %3 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @3, i32 0, i32 0), i32 %integerArgument6)
  br label %ifmerge

ifmerge:                                          ; preds = %else, %then4
  %integerArgument7 = load i32, i32* %integerArgument1
  %4 = add i32 %integerArgument7, 1
  store i32 %4, i32* %integerArgument1
  %integerArgument8 = load i32, i32* %integerArgument1
  call void @integerFunction(i32 %integerArgument8)
  br label %ifmerge10

else9:                                            ; preds = %entry
  %5 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([16 x i8], [16 x i8]* @4, i32 0, i32 0))
  br label %ifmerge10

ifmerge10:                                        ; preds = %else9, %ifmerge
  ret void
}

define void @floatFunction(double %floatArgument) {
entry:
  %floatArgument1 = alloca double
  store double %floatArgument, double* %floatArgument1
  ret void
}

define void @boolFunction(i1 %boolArgument) {
entry:
  %boolArgument1 = alloca i1
  store i1 %boolArgument, i1* %boolArgument1
  ret void
}

define void @charFunction(i8 %charArgument) {
entry:
  %charArgument1 = alloca i8
  store i8 %charArgument, i8* %charArgument1
  ret void
}

define void @stringFunction(i8* %stringArgument) {
entry:
  %stringArgument1 = alloca i8*
  store i8* %stringArgument, i8** %stringArgument1
  ret void
}
