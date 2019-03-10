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
@10 = private unnamed_addr constant [54 x i8] c"Printing |result_int_array| after |AndSingleArray()|:\00"
@11 = private unnamed_addr constant [55 x i8] c"Printing |result_bool_array| after |AndSingleArray()|:\00"
@12 = private unnamed_addr constant [53 x i8] c"Printing |result_int_array| after |OrSingleArray()|:\00"
@13 = private unnamed_addr constant [54 x i8] c"Printing |result_bool_array| after |OrSingleArray()|:\00"

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
  %"$tmp_arr$54" = alloca [6 x i1]
  %"$i$53" = alloca i32
  %"$tmp_arr$46" = alloca [6 x i32]
  %"$i$45" = alloca i32
  %i34 = alloca i32
  %"$tmp_arr$14" = alloca [6 x i1]
  %"$i$13" = alloca i32
  %"$tmp_arr$" = alloca [6 x i32]
  %"$i$" = alloca i32
  %i = alloca i32
  %result_bool_array = alloca [6 x i1]
  %result_int_array = alloca [6 x i32]
  store i32 0, i32* %i
  br label %condeval

condeval:                                         ; preds = %loop, %entry
  %i1 = load i32, i32* %i
  %0 = icmp slt i32 %i1, 6
  br i1 %0, label %loop, label %postloop

loop:                                             ; preds = %condeval
  %i2 = load i32, i32* %i
  %array-index = getelementptr [6 x i32], [6 x i32]* %result_int_array, i64 0, i32 %i2
  %1 = load i32, i32* %i
  store i32 %1, i32* %array-index
  %i3 = load i32, i32* %i
  %array-index4 = getelementptr [6 x i1], [6 x i1]* %result_bool_array, i64 0, i32 %i3
  store i1 true, i1* %array-index4
  %i5 = load i32, i32* %i
  %2 = add i32 %i5, 1
  store i32 %2, i32* %i
  br label %condeval

postloop:                                         ; preds = %condeval
  %array-index6 = getelementptr [6 x i32], [6 x i32]* %result_int_array, i64 0, i32 0
  store i32 0, i32* %"$i$"
  br label %condeval7

condeval7:                                        ; preds = %loop8, %postloop
  %3 = load i32, i32* %"$i$"
  %4 = icmp slt i32 %3, 6
  br i1 %4, label %loop8, label %postloop11

loop8:                                            ; preds = %condeval7
  %5 = load i32, i32* %"$i$"
  %array-index9 = getelementptr [6 x i32], [6 x i32]* %"$tmp_arr$", i64 0, i32 %5
  %6 = load i32, i32* %"$i$"
  %array-index10 = getelementptr [6 x i32], [6 x i32]* %result_int_array, i64 0, i32 %6
  %7 = load i32, i32* %array-index10
  %8 = and i32 2, %7
  store i32 %8, i32* %array-index9
  %9 = load i32, i32* %"$i$"
  %10 = add i32 %9, 1
  store i32 %10, i32* %"$i$"
  br label %condeval7

postloop11:                                       ; preds = %condeval7
  %11 = load [6 x i32], [6 x i32]* %"$tmp_arr$"
  store [6 x i32] %11, [6 x i32]* %result_int_array
  %array-index12 = getelementptr [6 x i1], [6 x i1]* %result_bool_array, i64 0, i32 0
  store i32 0, i32* %"$i$13"
  br label %condeval15

condeval15:                                       ; preds = %loop16, %postloop11
  %12 = load i32, i32* %"$i$13"
  %13 = icmp slt i32 %12, 6
  br i1 %13, label %loop16, label %postloop19

loop16:                                           ; preds = %condeval15
  %14 = load i32, i32* %"$i$13"
  %array-index17 = getelementptr [6 x i1], [6 x i1]* %"$tmp_arr$14", i64 0, i32 %14
  %15 = load i32, i32* %"$i$13"
  %array-index18 = getelementptr [6 x i1], [6 x i1]* %result_bool_array, i64 0, i32 %15
  %16 = load i1, i1* %array-index18
  %17 = and i1 false, %16
  store i1 %17, i1* %array-index17
  %18 = load i32, i32* %"$i$13"
  %19 = add i32 %18, 1
  store i32 %19, i32* %"$i$13"
  br label %condeval15

postloop19:                                       ; preds = %condeval15
  %20 = load [6 x i1], [6 x i1]* %"$tmp_arr$14"
  store [6 x i1] %20, [6 x i1]* %result_bool_array
  store i32 0, i32* %i
  call void @putString(i8* getelementptr inbounds ([54 x i8], [54 x i8]* @10, i32 0, i32 0))
  br label %condeval20

condeval20:                                       ; preds = %loop22, %postloop19
  %i21 = load i32, i32* %i
  %21 = icmp slt i32 %i21, 6
  br i1 %21, label %loop22, label %postloop26

loop22:                                           ; preds = %condeval20
  %i23 = load i32, i32* %i
  %array-index24 = getelementptr [6 x i32], [6 x i32]* %result_int_array, i64 0, i32 %i23
  %22 = load i32, i32* %array-index24
  call void @putInteger(i32 %22)
  %i25 = load i32, i32* %i
  %23 = add i32 %i25, 1
  store i32 %23, i32* %i
  br label %condeval20

postloop26:                                       ; preds = %condeval20
  store i32 0, i32* %i
  call void @putString(i8* getelementptr inbounds ([55 x i8], [55 x i8]* @11, i32 0, i32 0))
  br label %condeval27

condeval27:                                       ; preds = %loop29, %postloop26
  %i28 = load i32, i32* %i
  %24 = icmp slt i32 %i28, 6
  br i1 %24, label %loop29, label %postloop33

loop29:                                           ; preds = %condeval27
  %i30 = load i32, i32* %i
  %array-index31 = getelementptr [6 x i1], [6 x i1]* %result_bool_array, i64 0, i32 %i30
  %25 = load i1, i1* %array-index31
  call void @putBool(i1 %25)
  %i32 = load i32, i32* %i
  %26 = add i32 %i32, 1
  store i32 %26, i32* %i
  br label %condeval27

postloop33:                                       ; preds = %condeval27
  store i32 0, i32* %i34
  br label %condeval35

condeval35:                                       ; preds = %loop37, %postloop33
  %i36 = load i32, i32* %i34
  %27 = icmp slt i32 %i36, 6
  br i1 %27, label %loop37, label %postloop43

loop37:                                           ; preds = %condeval35
  %i38 = load i32, i32* %i34
  %array-index39 = getelementptr [6 x i32], [6 x i32]* %result_int_array, i64 0, i32 %i38
  %28 = load i32, i32* %i34
  store i32 %28, i32* %array-index39
  %i40 = load i32, i32* %i34
  %array-index41 = getelementptr [6 x i1], [6 x i1]* %result_bool_array, i64 0, i32 %i40
  store i1 true, i1* %array-index41
  %i42 = load i32, i32* %i34
  %29 = add i32 %i42, 1
  store i32 %29, i32* %i34
  br label %condeval35

postloop43:                                       ; preds = %condeval35
  %array-index44 = getelementptr [6 x i32], [6 x i32]* %result_int_array, i64 0, i32 0
  store i32 0, i32* %"$i$45"
  br label %condeval47

condeval47:                                       ; preds = %loop48, %postloop43
  %30 = load i32, i32* %"$i$45"
  %31 = icmp slt i32 %30, 6
  br i1 %31, label %loop48, label %postloop51

loop48:                                           ; preds = %condeval47
  %32 = load i32, i32* %"$i$45"
  %array-index49 = getelementptr [6 x i32], [6 x i32]* %"$tmp_arr$46", i64 0, i32 %32
  %33 = load i32, i32* %"$i$45"
  %array-index50 = getelementptr [6 x i32], [6 x i32]* %result_int_array, i64 0, i32 %33
  %34 = load i32, i32* %array-index50
  %35 = or i32 2, %34
  store i32 %35, i32* %array-index49
  %36 = load i32, i32* %"$i$45"
  %37 = add i32 %36, 1
  store i32 %37, i32* %"$i$45"
  br label %condeval47

postloop51:                                       ; preds = %condeval47
  %38 = load [6 x i32], [6 x i32]* %"$tmp_arr$46"
  store [6 x i32] %38, [6 x i32]* %result_int_array
  %array-index52 = getelementptr [6 x i1], [6 x i1]* %result_bool_array, i64 0, i32 0
  store i32 0, i32* %"$i$53"
  br label %condeval55

condeval55:                                       ; preds = %loop56, %postloop51
  %39 = load i32, i32* %"$i$53"
  %40 = icmp slt i32 %39, 6
  br i1 %40, label %loop56, label %postloop59

loop56:                                           ; preds = %condeval55
  %41 = load i32, i32* %"$i$53"
  %array-index57 = getelementptr [6 x i1], [6 x i1]* %"$tmp_arr$54", i64 0, i32 %41
  %42 = load i32, i32* %"$i$53"
  %array-index58 = getelementptr [6 x i1], [6 x i1]* %result_bool_array, i64 0, i32 %42
  %43 = load i1, i1* %array-index58
  %44 = or i1 false, %43
  store i1 %44, i1* %array-index57
  %45 = load i32, i32* %"$i$53"
  %46 = add i32 %45, 1
  store i32 %46, i32* %"$i$53"
  br label %condeval55

postloop59:                                       ; preds = %condeval55
  %47 = load [6 x i1], [6 x i1]* %"$tmp_arr$54"
  store [6 x i1] %47, [6 x i1]* %result_bool_array
  store i32 0, i32* %i34
  call void @putString(i8* getelementptr inbounds ([53 x i8], [53 x i8]* @12, i32 0, i32 0))
  br label %condeval60

condeval60:                                       ; preds = %loop62, %postloop59
  %i61 = load i32, i32* %i34
  %48 = icmp slt i32 %i61, 6
  br i1 %48, label %loop62, label %postloop66

loop62:                                           ; preds = %condeval60
  %i63 = load i32, i32* %i34
  %array-index64 = getelementptr [6 x i32], [6 x i32]* %result_int_array, i64 0, i32 %i63
  %49 = load i32, i32* %array-index64
  call void @putInteger(i32 %49)
  %i65 = load i32, i32* %i34
  %50 = add i32 %i65, 1
  store i32 %50, i32* %i34
  br label %condeval60

postloop66:                                       ; preds = %condeval60
  store i32 0, i32* %i34
  call void @putString(i8* getelementptr inbounds ([54 x i8], [54 x i8]* @13, i32 0, i32 0))
  br label %condeval67

condeval67:                                       ; preds = %loop69, %postloop66
  %i68 = load i32, i32* %i34
  %51 = icmp slt i32 %i68, 6
  br i1 %51, label %loop69, label %postloop73

loop69:                                           ; preds = %condeval67
  %i70 = load i32, i32* %i34
  %array-index71 = getelementptr [6 x i1], [6 x i1]* %result_bool_array, i64 0, i32 %i70
  %52 = load i1, i1* %array-index71
  call void @putBool(i1 %52)
  %i72 = load i32, i32* %i34
  %53 = add i32 %i72, 1
  store i32 %53, i32* %i34
  br label %condeval67

postloop73:                                       ; preds = %condeval67
  ret i32 0
}
