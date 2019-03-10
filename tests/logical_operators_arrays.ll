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
@10 = private unnamed_addr constant [49 x i8] c"Printing |result_int_array| after |AndArrays()|:\00"
@11 = private unnamed_addr constant [50 x i8] c"Printing |result_bool_array| after |AndArrays()|:\00"
@12 = private unnamed_addr constant [48 x i8] c"Printing |result_int_array| after |OrArrays()|:\00"
@13 = private unnamed_addr constant [49 x i8] c"Printing |result_bool_array| after |OrArrays()|:\00"

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
  %"$tmp_arr$68" = alloca [6 x i1]
  %"$i$67" = alloca i32
  %"$tmp_arr$58" = alloca [6 x i32]
  %"$i$57" = alloca i32
  %"$tmp_arr$21" = alloca [6 x i1]
  %"$i$20" = alloca i32
  %"$tmp_arr$" = alloca [6 x i32]
  %"$i$" = alloca i32
  %i = alloca i32
  %result_bool_array = alloca [6 x i1]
  %second_bool_array = alloca [6 x i1]
  %first_bool_array = alloca [6 x i1]
  %result_int_array = alloca [6 x i32]
  %second_int_array = alloca [6 x i32]
  %first_int_array = alloca [6 x i32]
  store i32 0, i32* %i
  br label %condeval

condeval:                                         ; preds = %loop, %entry
  %i1 = load i32, i32* %i
  %0 = icmp slt i32 %i1, 6
  br i1 %0, label %loop, label %postloop

loop:                                             ; preds = %condeval
  %i2 = load i32, i32* %i
  %array-index = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 %i2
  %1 = load i32, i32* %i
  store i32 %1, i32* %array-index
  %i3 = load i32, i32* %i
  %array-index4 = getelementptr [6 x i32], [6 x i32]* %second_int_array, i64 0, i32 %i3
  store i32 2, i32* %array-index4
  %i5 = load i32, i32* %i
  %array-index6 = getelementptr [6 x i1], [6 x i1]* %first_bool_array, i64 0, i32 %i5
  store i1 true, i1* %array-index6
  %i7 = load i32, i32* %i
  %array-index8 = getelementptr [6 x i1], [6 x i1]* %second_bool_array, i64 0, i32 %i7
  store i1 false, i1* %array-index8
  %i9 = load i32, i32* %i
  %2 = add i32 %i9, 1
  store i32 %2, i32* %i
  br label %condeval

postloop:                                         ; preds = %condeval
  %array-index10 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 0
  %array-index11 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 0
  %3 = load i32, i32* %array-index11
  store i32 0, i32* %"$i$"
  br label %condeval12

condeval12:                                       ; preds = %loop13, %postloop
  %4 = load i32, i32* %"$i$"
  %5 = icmp slt i32 %4, 6
  br i1 %5, label %loop13, label %postloop17

loop13:                                           ; preds = %condeval12
  %6 = load i32, i32* %"$i$"
  %array-index14 = getelementptr [6 x i32], [6 x i32]* %"$tmp_arr$", i64 0, i32 %6
  %7 = load i32, i32* %"$i$"
  %array-index15 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 %7
  %8 = load i32, i32* %array-index15
  %9 = load i32, i32* %"$i$"
  %array-index16 = getelementptr [6 x i32], [6 x i32]* %second_int_array, i64 0, i32 %9
  %10 = load i32, i32* %array-index16
  %11 = and i32 %8, %10
  store i32 %11, i32* %array-index14
  %12 = load i32, i32* %"$i$"
  %13 = add i32 %12, 1
  store i32 %13, i32* %"$i$"
  br label %condeval12

postloop17:                                       ; preds = %condeval12
  %14 = load [6 x i32], [6 x i32]* %"$tmp_arr$"
  store [6 x i32] %14, [6 x i32]* %result_int_array
  %array-index18 = getelementptr [6 x i1], [6 x i1]* %first_bool_array, i64 0, i32 0
  %array-index19 = getelementptr [6 x i1], [6 x i1]* %first_bool_array, i64 0, i32 0
  %15 = load i1, i1* %array-index19
  store i32 0, i32* %"$i$20"
  br label %condeval22

condeval22:                                       ; preds = %loop23, %postloop17
  %16 = load i32, i32* %"$i$20"
  %17 = icmp slt i32 %16, 6
  br i1 %17, label %loop23, label %postloop27

loop23:                                           ; preds = %condeval22
  %18 = load i32, i32* %"$i$20"
  %array-index24 = getelementptr [6 x i1], [6 x i1]* %"$tmp_arr$21", i64 0, i32 %18
  %19 = load i32, i32* %"$i$20"
  %array-index25 = getelementptr [6 x i1], [6 x i1]* %first_bool_array, i64 0, i32 %19
  %20 = load i1, i1* %array-index25
  %21 = load i32, i32* %"$i$20"
  %array-index26 = getelementptr [6 x i1], [6 x i1]* %second_bool_array, i64 0, i32 %21
  %22 = load i1, i1* %array-index26
  %23 = and i1 %20, %22
  store i1 %23, i1* %array-index24
  %24 = load i32, i32* %"$i$20"
  %25 = add i32 %24, 1
  store i32 %25, i32* %"$i$20"
  br label %condeval22

postloop27:                                       ; preds = %condeval22
  %26 = load [6 x i1], [6 x i1]* %"$tmp_arr$21"
  store [6 x i1] %26, [6 x i1]* %result_bool_array
  store i32 0, i32* %i
  call void @putString(i8* getelementptr inbounds ([49 x i8], [49 x i8]* @10, i32 0, i32 0))
  br label %condeval28

condeval28:                                       ; preds = %loop30, %postloop27
  %i29 = load i32, i32* %i
  %27 = icmp slt i32 %i29, 6
  br i1 %27, label %loop30, label %postloop34

loop30:                                           ; preds = %condeval28
  %i31 = load i32, i32* %i
  %array-index32 = getelementptr [6 x i32], [6 x i32]* %result_int_array, i64 0, i32 %i31
  %28 = load i32, i32* %array-index32
  call void @putInteger(i32 %28)
  %i33 = load i32, i32* %i
  %29 = add i32 %i33, 1
  store i32 %29, i32* %i
  br label %condeval28

postloop34:                                       ; preds = %condeval28
  store i32 0, i32* %i
  call void @putString(i8* getelementptr inbounds ([50 x i8], [50 x i8]* @11, i32 0, i32 0))
  br label %condeval35

condeval35:                                       ; preds = %loop37, %postloop34
  %i36 = load i32, i32* %i
  %30 = icmp slt i32 %i36, 6
  br i1 %30, label %loop37, label %postloop41

loop37:                                           ; preds = %condeval35
  %i38 = load i32, i32* %i
  %array-index39 = getelementptr [6 x i1], [6 x i1]* %result_bool_array, i64 0, i32 %i38
  %31 = load i1, i1* %array-index39
  call void @putBool(i1 %31)
  %i40 = load i32, i32* %i
  %32 = add i32 %i40, 1
  store i32 %32, i32* %i
  br label %condeval35

postloop41:                                       ; preds = %condeval35
  br label %condeval42

condeval42:                                       ; preds = %loop44, %postloop41
  %i43 = load i32, i32* %i
  %33 = icmp slt i32 %i43, 6
  br i1 %33, label %loop44, label %postloop54

loop44:                                           ; preds = %condeval42
  %i45 = load i32, i32* %i
  %array-index46 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 %i45
  %34 = load i32, i32* %i
  store i32 %34, i32* %array-index46
  %i47 = load i32, i32* %i
  %array-index48 = getelementptr [6 x i32], [6 x i32]* %second_int_array, i64 0, i32 %i47
  store i32 2, i32* %array-index48
  %i49 = load i32, i32* %i
  %array-index50 = getelementptr [6 x i1], [6 x i1]* %first_bool_array, i64 0, i32 %i49
  store i1 true, i1* %array-index50
  %i51 = load i32, i32* %i
  %array-index52 = getelementptr [6 x i1], [6 x i1]* %second_bool_array, i64 0, i32 %i51
  store i1 false, i1* %array-index52
  %i53 = load i32, i32* %i
  %35 = add i32 %i53, 1
  store i32 %35, i32* %i
  br label %condeval42

postloop54:                                       ; preds = %condeval42
  %array-index55 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 0
  %array-index56 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 0
  %36 = load i32, i32* %array-index56
  store i32 0, i32* %"$i$57"
  br label %condeval59

condeval59:                                       ; preds = %loop60, %postloop54
  %37 = load i32, i32* %"$i$57"
  %38 = icmp slt i32 %37, 6
  br i1 %38, label %loop60, label %postloop64

loop60:                                           ; preds = %condeval59
  %39 = load i32, i32* %"$i$57"
  %array-index61 = getelementptr [6 x i32], [6 x i32]* %"$tmp_arr$58", i64 0, i32 %39
  %40 = load i32, i32* %"$i$57"
  %array-index62 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 %40
  %41 = load i32, i32* %array-index62
  %42 = load i32, i32* %"$i$57"
  %array-index63 = getelementptr [6 x i32], [6 x i32]* %second_int_array, i64 0, i32 %42
  %43 = load i32, i32* %array-index63
  %44 = or i32 %41, %43
  store i32 %44, i32* %array-index61
  %45 = load i32, i32* %"$i$57"
  %46 = add i32 %45, 1
  store i32 %46, i32* %"$i$57"
  br label %condeval59

postloop64:                                       ; preds = %condeval59
  %47 = load [6 x i32], [6 x i32]* %"$tmp_arr$58"
  store [6 x i32] %47, [6 x i32]* %result_int_array
  %array-index65 = getelementptr [6 x i1], [6 x i1]* %first_bool_array, i64 0, i32 0
  %array-index66 = getelementptr [6 x i1], [6 x i1]* %first_bool_array, i64 0, i32 0
  %48 = load i1, i1* %array-index66
  store i32 0, i32* %"$i$67"
  br label %condeval69

condeval69:                                       ; preds = %loop70, %postloop64
  %49 = load i32, i32* %"$i$67"
  %50 = icmp slt i32 %49, 6
  br i1 %50, label %loop70, label %postloop74

loop70:                                           ; preds = %condeval69
  %51 = load i32, i32* %"$i$67"
  %array-index71 = getelementptr [6 x i1], [6 x i1]* %"$tmp_arr$68", i64 0, i32 %51
  %52 = load i32, i32* %"$i$67"
  %array-index72 = getelementptr [6 x i1], [6 x i1]* %first_bool_array, i64 0, i32 %52
  %53 = load i1, i1* %array-index72
  %54 = load i32, i32* %"$i$67"
  %array-index73 = getelementptr [6 x i1], [6 x i1]* %result_bool_array, i64 0, i32 %54
  %55 = load i1, i1* %array-index73
  %56 = or i1 %53, %55
  store i1 %56, i1* %array-index71
  %57 = load i32, i32* %"$i$67"
  %58 = add i32 %57, 1
  store i32 %58, i32* %"$i$67"
  br label %condeval69

postloop74:                                       ; preds = %condeval69
  %59 = load [6 x i1], [6 x i1]* %"$tmp_arr$68"
  store [6 x i1] %59, [6 x i1]* %result_bool_array
  store i32 0, i32* %i
  call void @putString(i8* getelementptr inbounds ([48 x i8], [48 x i8]* @12, i32 0, i32 0))
  br label %condeval75

condeval75:                                       ; preds = %loop77, %postloop74
  %i76 = load i32, i32* %i
  %60 = icmp slt i32 %i76, 6
  br i1 %60, label %loop77, label %postloop81

loop77:                                           ; preds = %condeval75
  %i78 = load i32, i32* %i
  %array-index79 = getelementptr [6 x i32], [6 x i32]* %result_int_array, i64 0, i32 %i78
  %61 = load i32, i32* %array-index79
  call void @putInteger(i32 %61)
  %i80 = load i32, i32* %i
  %62 = add i32 %i80, 1
  store i32 %62, i32* %i
  br label %condeval75

postloop81:                                       ; preds = %condeval75
  store i32 0, i32* %i
  call void @putString(i8* getelementptr inbounds ([49 x i8], [49 x i8]* @13, i32 0, i32 0))
  br label %condeval82

condeval82:                                       ; preds = %loop84, %postloop81
  %i83 = load i32, i32* %i
  %63 = icmp slt i32 %i83, 6
  br i1 %63, label %loop84, label %postloop88

loop84:                                           ; preds = %condeval82
  %i85 = load i32, i32* %i
  %array-index86 = getelementptr [6 x i1], [6 x i1]* %result_bool_array, i64 0, i32 %i85
  %64 = load i1, i1* %array-index86
  call void @putBool(i1 %64)
  %i87 = load i32, i32* %i
  %65 = add i32 %i87, 1
  store i32 %65, i32* %i
  br label %condeval82

postloop88:                                       ; preds = %condeval82
  ret i32 0
}
