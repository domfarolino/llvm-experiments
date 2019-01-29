; ModuleID = 'Dom Sample'
source_filename = "Dom Sample"

@0 = private unnamed_addr constant [4 x i8] c"%d\0A\00"
@1 = private unnamed_addr constant [4 x i8] c"%d\0A\00"
@2 = private unnamed_addr constant [4 x i8] c"%f\0A\00"
@3 = private unnamed_addr constant [4 x i8] c"%s\0A\00"
@4 = private unnamed_addr constant [4 x i8] c"%c\0A\00"
@5 = private unnamed_addr constant [22 x i8] c"FloatAdder returning:\00"
@6 = private unnamed_addr constant [24 x i8] c"IntegerAdder returning:\00"
@7 = private unnamed_addr constant [9 x i8] c"%d <= 5\0A\00"
@8 = private unnamed_addr constant [8 x i8] c"%d > 5\0A\00"
@9 = private unnamed_addr constant [16 x i8] c"All finished!!\0A\00"
@10 = private unnamed_addr constant [14 x i8] c"i: %d, j: %d\0A\00"
@11 = private unnamed_addr constant [33 x i8] c"FloatAdderResult(from main): %f\0A\00"
@12 = private unnamed_addr constant [35 x i8] c"IntegerAdderResult(from main): %d\0A\00"
@13 = private unnamed_addr constant [15 x i8] c"fibonacci: %d\0A\00"

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
  %calladder = call double @FloatAdder(double 4.200000e+01, double 3.800000e+01)
  %calladder1 = call i32 @IntegerAdder(i32 42, i32 38)
  %callprintfFloatAdder = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([33 x i8], [33 x i8]* @11, i32 0, i32 0), double %calladder)
  %callprintfIntegerAdder = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([35 x i8], [35 x i8]* @12, i32 0, i32 0), i32 %calladder1)
  %float-to-bool = fcmp one double %calladder, 0.000000e+00
  call void @integerFunction(i32 0)
  %0 = call i32 @fibonacci(i32 6)
  %1 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([15 x i8], [15 x i8]* @13, i32 0, i32 0), i32 %0)
  call void @nSquared(i32 7)
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
  call void @putString(i8* getelementptr inbounds ([22 x i8], [22 x i8]* @5, i32 0, i32 0))
  call void @putFloat(double %floatAddUltimateReturn)
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
  call void @putString(i8* getelementptr inbounds ([24 x i8], [24 x i8]* @6, i32 0, i32 0))
  call void @putInteger(i32 %integerAddUltimateReturn)
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
  %2 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([9 x i8], [9 x i8]* @7, i32 0, i32 0), i32 %integerArgument5)
  br label %ifmerge

else:                                             ; preds = %then
  %integerArgument6 = load i32, i32* %integerArgument1
  %3 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @8, i32 0, i32 0), i32 %integerArgument6)
  br label %ifmerge

ifmerge:                                          ; preds = %else, %then4
  %integerArgument7 = load i32, i32* %integerArgument1
  %4 = add i32 %integerArgument7, 1
  store i32 %4, i32* %integerArgument1
  %integerArgument8 = load i32, i32* %integerArgument1
  call void @integerFunction(i32 %integerArgument8)
  br label %ifmerge10

else9:                                            ; preds = %entry
  %5 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([16 x i8], [16 x i8]* @9, i32 0, i32 0))
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

define i32 @fibonacci(i32 %n) {
entry:
  %tmp = alloca i32
  %second = alloca i32
  %first = alloca i32
  %n1 = alloca i32
  store i32 %n, i32* %n1
  store i32 0, i32* %first
  store i32 0, i32* %second
  store i32 0, i32* %tmp
  store i32 1, i32* %first
  store i32 1, i32* %second
  br label %condeval

condeval:                                         ; preds = %loop, %entry
  %n2 = load i32, i32* %n1
  %0 = icmp sgt i32 %n2, 1
  br i1 %0, label %loop, label %postloop

loop:                                             ; preds = %condeval
  %first3 = load i32, i32* %first
  store i32 %first3, i32* %tmp
  %second4 = load i32, i32* %second
  store i32 %second4, i32* %first
  %second5 = load i32, i32* %second
  %tmp6 = load i32, i32* %tmp
  %1 = add i32 %second5, %tmp6
  store i32 %1, i32* %second
  %n7 = load i32, i32* %n1
  %2 = sub i32 %n7, 1
  store i32 %2, i32* %n1
  br label %condeval

postloop:                                         ; preds = %condeval
  %first8 = load i32, i32* %first
  ret i32 %first8
}

define void @nSquared(i32 %k) {
entry:
  %j = alloca i32
  %i = alloca i32
  %k1 = alloca i32
  store i32 %k, i32* %k1
  store i32 0, i32* %i
  store i32 0, i32* %j
  store i32 0, i32* %i
  br label %condeval

condeval:                                         ; preds = %postloop, %entry
  %i2 = load i32, i32* %i
  %k3 = load i32, i32* %k1
  %0 = icmp slt i32 %i2, %k3
  br i1 %0, label %loop, label %postloop12

loop:                                             ; preds = %condeval
  store i32 0, i32* %j
  br label %condeval4

condeval4:                                        ; preds = %loop7, %loop
  %j5 = load i32, i32* %j
  %i6 = load i32, i32* %i
  %1 = icmp sle i32 %j5, %i6
  br i1 %1, label %loop7, label %postloop

loop7:                                            ; preds = %condeval4
  %i8 = load i32, i32* %i
  %j9 = load i32, i32* %j
  %2 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([14 x i8], [14 x i8]* @10, i32 0, i32 0), i32 %i8, i32 %j9)
  %j10 = load i32, i32* %j
  %3 = add i32 %j10, 1
  store i32 %3, i32* %j
  br label %condeval4

postloop:                                         ; preds = %condeval4
  %i11 = load i32, i32* %i
  %4 = add i32 %i11, 1
  store i32 %4, i32* %i
  br label %condeval

postloop12:                                       ; preds = %condeval
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
