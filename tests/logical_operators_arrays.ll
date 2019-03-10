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
  %"$tmp_arr$60" = alloca [6 x i1]
  %"$i$59" = alloca i32
  %"$tmp_arr$52" = alloca [6 x i32]
  %"$i$51" = alloca i32
  %"$tmp_arr$17" = alloca [6 x i1]
  %"$i$16" = alloca i32
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
  store i32 0, i32* %"$i$"
  br label %condeval10

condeval10:                                       ; preds = %loop11, %postloop
  %3 = load i32, i32* %"$i$"
  %4 = icmp slt i32 %3, 6
  br i1 %4, label %loop11, label %postloop15

loop11:                                           ; preds = %condeval10
  %5 = load i32, i32* %"$i$"
  %array-index12 = getelementptr [6 x i32], [6 x i32]* %"$tmp_arr$", i64 0, i32 %5
  %6 = load i32, i32* %"$i$"
  %array-index13 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 %6
  %7 = load i32, i32* %array-index13
  %8 = load i32, i32* %"$i$"
  %array-index14 = getelementptr [6 x i32], [6 x i32]* %second_int_array, i64 0, i32 %8
  %9 = load i32, i32* %array-index14
  %10 = and i32 %7, %9
  store i32 %10, i32* %array-index12
  %11 = load i32, i32* %"$i$"
  %12 = add i32 %11, 1
  store i32 %12, i32* %"$i$"
  br label %condeval10

postloop15:                                       ; preds = %condeval10
  %13 = load [6 x i32], [6 x i32]* %"$tmp_arr$"
  store [6 x i32] %13, [6 x i32]* %result_int_array
  store i32 0, i32* %"$i$16"
  br label %condeval18

condeval18:                                       ; preds = %loop19, %postloop15
  %14 = load i32, i32* %"$i$16"
  %15 = icmp slt i32 %14, 6
  br i1 %15, label %loop19, label %postloop23

loop19:                                           ; preds = %condeval18
  %16 = load i32, i32* %"$i$16"
  %array-index20 = getelementptr [6 x i1], [6 x i1]* %"$tmp_arr$17", i64 0, i32 %16
  %17 = load i32, i32* %"$i$16"
  %array-index21 = getelementptr [6 x i1], [6 x i1]* %first_bool_array, i64 0, i32 %17
  %18 = load i1, i1* %array-index21
  %19 = load i32, i32* %"$i$16"
  %array-index22 = getelementptr [6 x i1], [6 x i1]* %second_bool_array, i64 0, i32 %19
  %20 = load i1, i1* %array-index22
  %21 = and i1 %18, %20
  store i1 %21, i1* %array-index20
  %22 = load i32, i32* %"$i$16"
  %23 = add i32 %22, 1
  store i32 %23, i32* %"$i$16"
  br label %condeval18

postloop23:                                       ; preds = %condeval18
  %24 = load [6 x i1], [6 x i1]* %"$tmp_arr$17"
  store [6 x i1] %24, [6 x i1]* %result_bool_array
  store i32 0, i32* %i
  call void @putString(i8* getelementptr inbounds ([49 x i8], [49 x i8]* @10, i32 0, i32 0))
  br label %condeval24

condeval24:                                       ; preds = %loop26, %postloop23
  %i25 = load i32, i32* %i
  %25 = icmp slt i32 %i25, 6
  br i1 %25, label %loop26, label %postloop30

loop26:                                           ; preds = %condeval24
  %i27 = load i32, i32* %i
  %array-index28 = getelementptr [6 x i32], [6 x i32]* %result_int_array, i64 0, i32 %i27
  %26 = load i32, i32* %array-index28
  call void @putInteger(i32 %26)
  %i29 = load i32, i32* %i
  %27 = add i32 %i29, 1
  store i32 %27, i32* %i
  br label %condeval24

postloop30:                                       ; preds = %condeval24
  store i32 0, i32* %i
  call void @putString(i8* getelementptr inbounds ([50 x i8], [50 x i8]* @11, i32 0, i32 0))
  br label %condeval31

condeval31:                                       ; preds = %loop33, %postloop30
  %i32 = load i32, i32* %i
  %28 = icmp slt i32 %i32, 6
  br i1 %28, label %loop33, label %postloop37

loop33:                                           ; preds = %condeval31
  %i34 = load i32, i32* %i
  %array-index35 = getelementptr [6 x i1], [6 x i1]* %result_bool_array, i64 0, i32 %i34
  %29 = load i1, i1* %array-index35
  call void @putBool(i1 %29)
  %i36 = load i32, i32* %i
  %30 = add i32 %i36, 1
  store i32 %30, i32* %i
  br label %condeval31

postloop37:                                       ; preds = %condeval31
  br label %condeval38

condeval38:                                       ; preds = %loop40, %postloop37
  %i39 = load i32, i32* %i
  %31 = icmp slt i32 %i39, 6
  br i1 %31, label %loop40, label %postloop50

loop40:                                           ; preds = %condeval38
  %i41 = load i32, i32* %i
  %array-index42 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 %i41
  %32 = load i32, i32* %i
  store i32 %32, i32* %array-index42
  %i43 = load i32, i32* %i
  %array-index44 = getelementptr [6 x i32], [6 x i32]* %second_int_array, i64 0, i32 %i43
  store i32 2, i32* %array-index44
  %i45 = load i32, i32* %i
  %array-index46 = getelementptr [6 x i1], [6 x i1]* %first_bool_array, i64 0, i32 %i45
  store i1 true, i1* %array-index46
  %i47 = load i32, i32* %i
  %array-index48 = getelementptr [6 x i1], [6 x i1]* %second_bool_array, i64 0, i32 %i47
  store i1 false, i1* %array-index48
  %i49 = load i32, i32* %i
  %33 = add i32 %i49, 1
  store i32 %33, i32* %i
  br label %condeval38

postloop50:                                       ; preds = %condeval38
  store i32 0, i32* %"$i$51"
  br label %condeval53

condeval53:                                       ; preds = %loop54, %postloop50
  %34 = load i32, i32* %"$i$51"
  %35 = icmp slt i32 %34, 6
  br i1 %35, label %loop54, label %postloop58

loop54:                                           ; preds = %condeval53
  %36 = load i32, i32* %"$i$51"
  %array-index55 = getelementptr [6 x i32], [6 x i32]* %"$tmp_arr$52", i64 0, i32 %36
  %37 = load i32, i32* %"$i$51"
  %array-index56 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 %37
  %38 = load i32, i32* %array-index56
  %39 = load i32, i32* %"$i$51"
  %array-index57 = getelementptr [6 x i32], [6 x i32]* %second_int_array, i64 0, i32 %39
  %40 = load i32, i32* %array-index57
  %41 = or i32 %38, %40
  store i32 %41, i32* %array-index55
  %42 = load i32, i32* %"$i$51"
  %43 = add i32 %42, 1
  store i32 %43, i32* %"$i$51"
  br label %condeval53

postloop58:                                       ; preds = %condeval53
  %44 = load [6 x i32], [6 x i32]* %"$tmp_arr$52"
  store [6 x i32] %44, [6 x i32]* %result_int_array
  store i32 0, i32* %"$i$59"
  br label %condeval61

condeval61:                                       ; preds = %loop62, %postloop58
  %45 = load i32, i32* %"$i$59"
  %46 = icmp slt i32 %45, 6
  br i1 %46, label %loop62, label %postloop66

loop62:                                           ; preds = %condeval61
  %47 = load i32, i32* %"$i$59"
  %array-index63 = getelementptr [6 x i1], [6 x i1]* %"$tmp_arr$60", i64 0, i32 %47
  %48 = load i32, i32* %"$i$59"
  %array-index64 = getelementptr [6 x i1], [6 x i1]* %first_bool_array, i64 0, i32 %48
  %49 = load i1, i1* %array-index64
  %50 = load i32, i32* %"$i$59"
  %array-index65 = getelementptr [6 x i1], [6 x i1]* %result_bool_array, i64 0, i32 %50
  %51 = load i1, i1* %array-index65
  %52 = or i1 %49, %51
  store i1 %52, i1* %array-index63
  %53 = load i32, i32* %"$i$59"
  %54 = add i32 %53, 1
  store i32 %54, i32* %"$i$59"
  br label %condeval61

postloop66:                                       ; preds = %condeval61
  %55 = load [6 x i1], [6 x i1]* %"$tmp_arr$60"
  store [6 x i1] %55, [6 x i1]* %result_bool_array
  store i32 0, i32* %i
  call void @putString(i8* getelementptr inbounds ([48 x i8], [48 x i8]* @12, i32 0, i32 0))
  br label %condeval67

condeval67:                                       ; preds = %loop69, %postloop66
  %i68 = load i32, i32* %i
  %56 = icmp slt i32 %i68, 6
  br i1 %56, label %loop69, label %postloop73

loop69:                                           ; preds = %condeval67
  %i70 = load i32, i32* %i
  %array-index71 = getelementptr [6 x i32], [6 x i32]* %result_int_array, i64 0, i32 %i70
  %57 = load i32, i32* %array-index71
  call void @putInteger(i32 %57)
  %i72 = load i32, i32* %i
  %58 = add i32 %i72, 1
  store i32 %58, i32* %i
  br label %condeval67

postloop73:                                       ; preds = %condeval67
  store i32 0, i32* %i
  call void @putString(i8* getelementptr inbounds ([49 x i8], [49 x i8]* @13, i32 0, i32 0))
  br label %condeval74

condeval74:                                       ; preds = %loop76, %postloop73
  %i75 = load i32, i32* %i
  %59 = icmp slt i32 %i75, 6
  br i1 %59, label %loop76, label %postloop80

loop76:                                           ; preds = %condeval74
  %i77 = load i32, i32* %i
  %array-index78 = getelementptr [6 x i1], [6 x i1]* %result_bool_array, i64 0, i32 %i77
  %60 = load i1, i1* %array-index78
  call void @putBool(i1 %60)
  %i79 = load i32, i32* %i
  %61 = add i32 %i79, 1
  store i32 %61, i32* %i
  br label %condeval74

postloop80:                                       ; preds = %condeval74
  ret i32 0
}
