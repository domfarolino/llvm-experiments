; ModuleID = 'Dom Sample'
source_filename = "Dom Sample"

@0 = private unnamed_addr constant [4 x i8] c"%d\0A\00"
@1 = private unnamed_addr constant [5 x i8] c"%lf\0A\00"
@2 = private unnamed_addr constant [4 x i8] c"%d\0A\00"
@3 = private unnamed_addr constant [4 x i8] c"%c\0A\00"
@4 = private unnamed_addr constant [4 x i8] c"%s\0A\00"
@5 = private unnamed_addr constant [3 x i8] c"%d\00"
@6 = private unnamed_addr constant [4 x i8] c"%lf\00"
@7 = private unnamed_addr constant [3 x i8] c"%d\00"
@8 = private unnamed_addr constant [4 x i8] c" %c\00"
@9 = private unnamed_addr constant [3 x i8] c"%s\00"
@10 = private unnamed_addr constant [63 x i8] c"Printing |float_array| after |CastIntegerArrayToFloatArray()|:\00"

declare i32 @printf(i8*, ...)

declare i32 @scanf(i8*, ...)

define void @putInteger(i32 %out) {
entry:
  %out1 = alloca i32
  store i32 %out, i32* %out1
  %out2 = load i32, i32* %out1
  %0 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @0, i32 0, i32 0), i32 %out2)
  ret void
}

define void @putFloat(double %out) {
entry:
  %out1 = alloca double
  store double %out, double* %out1
  %out2 = load double, double* %out1
  %0 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([5 x i8], [5 x i8]* @1, i32 0, i32 0), double %out2)
  ret void
}

define void @putBool(i1 %out) {
entry:
  %out1 = alloca i1
  store i1 %out, i1* %out1
  %out2 = load i1, i1* %out1
  %0 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @2, i32 0, i32 0), i1 %out2)
  ret void
}

define void @putChar(i8 %out) {
entry:
  %out1 = alloca i8
  store i8 %out, i8* %out1
  %out2 = load i8, i8* %out1
  %0 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @3, i32 0, i32 0), i8 %out2)
  ret void
}

define void @putString(i8* %out) {
entry:
  %out1 = alloca i8*
  store i8* %out, i8** %out1
  %out2 = load i8*, i8** %out1
  %0 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @4, i32 0, i32 0), i8* %out2)
  ret void
}

define void @getInteger(i32* %out) {
entry:
  %out1 = alloca i32*
  store i32* %out, i32** %out1
  %out2 = load i32*, i32** %out1
  %0 = call i32 (i8*, ...) @scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @5, i32 0, i32 0), i32* %out2)
  ret void
}

define void @getFloat(double* %out) {
entry:
  %out1 = alloca double*
  store double* %out, double** %out1
  %out2 = load double*, double** %out1
  %0 = call i32 (i8*, ...) @scanf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @6, i32 0, i32 0), double* %out2)
  ret void
}

define void @getBool(i1* %out) {
entry:
  %tmpInteger = alloca i32
  %out1 = alloca i1*
  store i1* %out, i1** %out1
  store i32 0, i32* %tmpInteger
  %0 = call i32 (i8*, ...) @scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @7, i32 0, i32 0), i32* %tmpInteger)
  %tmpInteger2 = load i32, i32* %tmpInteger
  %integer-to-float = sitofp i32 %tmpInteger2 to double
  %integer-to-bool = fcmp one double %integer-to-float, 0.000000e+00
  %out3 = load i1*, i1** %out1
  store i1 %integer-to-bool, i1* %out3
  ret void
}

define void @getChar(i8* %out) {
entry:
  %out1 = alloca i8*
  store i8* %out, i8** %out1
  %out2 = load i8*, i8** %out1
  %0 = call i32 (i8*, ...) @scanf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @8, i32 0, i32 0), i8* %out2)
  ret void
}

define void @getString(i8** %out) {
entry:
  %out1 = alloca i8**
  store i8** %out, i8*** %out1
  %out2 = load i8**, i8*** %out1
  %0 = load i8*, i8** %out2
  %1 = call i32 (i8*, ...) @scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @9, i32 0, i32 0), i8* %0)
  ret void
}

define i32 @main() {
entry:
  %"$tmp_arr$" = alloca [6 x double]
  %"$i$" = alloca i32
  %i = alloca i32
  %float_array = alloca [6 x double]
  %integer_array = alloca [6 x i32]
  store i32 0, i32* %i
  br label %condeval

condeval:                                         ; preds = %loop, %entry
  %i1 = load i32, i32* %i
  %0 = icmp slt i32 %i1, 6
  br i1 %0, label %loop, label %postloop

loop:                                             ; preds = %condeval
  %i2 = load i32, i32* %i
  %array-index = getelementptr [6 x i32], [6 x i32]* %integer_array, i64 0, i32 %i2
  store i32 2, i32* %array-index
  %i3 = load i32, i32* %i
  %1 = add i32 %i3, 1
  store i32 %1, i32* %i
  br label %condeval

postloop:                                         ; preds = %condeval
  %array-index4 = getelementptr [6 x i32], [6 x i32]* %integer_array, i64 0, i32 0
  %2 = load i32, i32* %array-index4
  %array-index5 = getelementptr [6 x i32], [6 x i32]* %integer_array, i64 0, i32 0
  store i32 0, i32* %"$i$"
  br label %condeval6

condeval6:                                        ; preds = %loop7, %postloop
  %3 = load i32, i32* %"$i$"
  %4 = icmp slt i32 %3, 6
  br i1 %4, label %loop7, label %postloop10

loop7:                                            ; preds = %condeval6
  %5 = load i32, i32* %"$i$"
  %array-index8 = getelementptr [6 x double], [6 x double]* %"$tmp_arr$", i64 0, i32 %5
  %6 = load i32, i32* %"$i$"
  %array-index9 = getelementptr [6 x i32], [6 x i32]* %integer_array, i64 0, i32 %6
  %7 = load i32, i32* %array-index9
  %integer-to-float = sitofp i32 %7 to double
  store double %integer-to-float, double* %array-index8
  %8 = load i32, i32* %"$i$"
  %9 = add i32 %8, 1
  store i32 %9, i32* %"$i$"
  br label %condeval6

postloop10:                                       ; preds = %condeval6
  %10 = load [6 x double], [6 x double]* %"$tmp_arr$"
  store [6 x double] %10, [6 x double]* %float_array
  store i32 0, i32* %i
  call void @putString(i8* getelementptr inbounds ([63 x i8], [63 x i8]* @10, i32 0, i32 0))
  br label %condeval11

condeval11:                                       ; preds = %loop13, %postloop10
  %i12 = load i32, i32* %i
  %11 = icmp slt i32 %i12, 6
  br i1 %11, label %loop13, label %postloop17

loop13:                                           ; preds = %condeval11
  %i14 = load i32, i32* %i
  %array-index15 = getelementptr [6 x double], [6 x double]* %float_array, i64 0, i32 %i14
  %12 = load double, double* %array-index15
  call void @putFloat(double %12)
  %i16 = load i32, i32* %i
  %13 = add i32 %i16, 1
  store i32 %13, i32* %i
  br label %condeval11

postloop17:                                       ; preds = %condeval11
  ret i32 0
}
