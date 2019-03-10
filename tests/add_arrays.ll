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
@10 = private unnamed_addr constant [34 x i8] c"Top-level assigning array element\00"
@11 = private unnamed_addr constant [38 x i8] c"Top-level printing given array values\00"
@12 = private unnamed_addr constant [38 x i8] c"Top-level printing given array values\00"

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
  %"$tmp_arr$50" = alloca [6 x double]
  %"$i$49" = alloca i32
  %"$tmp_arr$41" = alloca [6 x double]
  %"$i$40" = alloca i32
  %"$tmp_arr$32" = alloca [6 x i32]
  %"$i$31" = alloca i32
  %"$tmp_arr$" = alloca [6 x i32]
  %"$i$" = alloca i32
  %i = alloca i32
  %second_float_array = alloca [6 x double]
  %first_float_array = alloca [6 x double]
  %second_int_array = alloca [6 x i32]
  %first_int_array = alloca [6 x i32]
  store i32 0, i32* %i
  br label %condeval

condeval:                                         ; preds = %loop, %entry
  %i1 = load i32, i32* %i
  %0 = icmp slt i32 %i1, 6
  br i1 %0, label %loop, label %postloop

loop:                                             ; preds = %condeval
  call void @putString(i8* getelementptr inbounds ([34 x i8], [34 x i8]* @10, i32 0, i32 0))
  %i2 = load i32, i32* %i
  %array-index = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 %i2
  store i32 2, i32* %array-index
  %i3 = load i32, i32* %i
  %array-index4 = getelementptr [6 x i32], [6 x i32]* %second_int_array, i64 0, i32 %i3
  store i32 3, i32* %array-index4
  %i5 = load i32, i32* %i
  %array-index6 = getelementptr [6 x double], [6 x double]* %first_float_array, i64 0, i32 %i5
  store double 1.800000e+00, double* %array-index6
  %i7 = load i32, i32* %i
  %array-index8 = getelementptr [6 x double], [6 x double]* %second_float_array, i64 0, i32 %i7
  store double 3.400000e+00, double* %array-index8
  %i9 = load i32, i32* %i
  %1 = add i32 %i9, 1
  store i32 %1, i32* %i
  br label %condeval

postloop:                                         ; preds = %condeval
  store i32 0, i32* %i
  call void @putString(i8* getelementptr inbounds ([38 x i8], [38 x i8]* @11, i32 0, i32 0))
  br label %condeval10

condeval10:                                       ; preds = %loop12, %postloop
  %i11 = load i32, i32* %i
  %2 = icmp slt i32 %i11, 6
  br i1 %2, label %loop12, label %postloop22

loop12:                                           ; preds = %condeval10
  %i13 = load i32, i32* %i
  %array-index14 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 %i13
  %3 = load i32, i32* %array-index14
  call void @putInteger(i32 %3)
  %i15 = load i32, i32* %i
  %array-index16 = getelementptr [6 x i32], [6 x i32]* %second_int_array, i64 0, i32 %i15
  %4 = load i32, i32* %array-index16
  call void @putInteger(i32 %4)
  %i17 = load i32, i32* %i
  %array-index18 = getelementptr [6 x double], [6 x double]* %first_float_array, i64 0, i32 %i17
  %5 = load double, double* %array-index18
  call void @putFloat(double %5)
  %i19 = load i32, i32* %i
  %array-index20 = getelementptr [6 x double], [6 x double]* %second_float_array, i64 0, i32 %i19
  %6 = load double, double* %array-index20
  call void @putFloat(double %6)
  %i21 = load i32, i32* %i
  %7 = add i32 %i21, 1
  store i32 %7, i32* %i
  br label %condeval10

postloop22:                                       ; preds = %condeval10
  %array-index23 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 0
  store i32 0, i32* %"$i$"
  br label %condeval24

condeval24:                                       ; preds = %loop25, %postloop22
  %8 = load i32, i32* %"$i$"
  %9 = icmp slt i32 %8, 6
  br i1 %9, label %loop25, label %postloop29

loop25:                                           ; preds = %condeval24
  %10 = load i32, i32* %"$i$"
  %array-index26 = getelementptr [6 x i32], [6 x i32]* %"$tmp_arr$", i64 0, i32 %10
  %11 = load i32, i32* %"$i$"
  %array-index27 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 %11
  %12 = load i32, i32* %array-index27
  %13 = load i32, i32* %"$i$"
  %array-index28 = getelementptr [6 x i32], [6 x i32]* %second_int_array, i64 0, i32 %13
  %14 = load i32, i32* %array-index28
  %15 = add i32 %12, %14
  store i32 %15, i32* %array-index26
  %16 = load i32, i32* %"$i$"
  %17 = add i32 %16, 1
  store i32 %17, i32* %"$i$"
  br label %condeval24

postloop29:                                       ; preds = %condeval24
  %18 = load [6 x i32], [6 x i32]* %"$tmp_arr$"
  store [6 x i32] %18, [6 x i32]* %first_int_array
  %array-index30 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 0
  store i32 0, i32* %"$i$31"
  br label %condeval33

condeval33:                                       ; preds = %loop34, %postloop29
  %19 = load i32, i32* %"$i$31"
  %20 = icmp slt i32 %19, 6
  br i1 %20, label %loop34, label %postloop38

loop34:                                           ; preds = %condeval33
  %21 = load i32, i32* %"$i$31"
  %array-index35 = getelementptr [6 x i32], [6 x i32]* %"$tmp_arr$32", i64 0, i32 %21
  %22 = load i32, i32* %"$i$31"
  %array-index36 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 %22
  %23 = load i32, i32* %array-index36
  %24 = load i32, i32* %"$i$31"
  %array-index37 = getelementptr [6 x i32], [6 x i32]* %second_int_array, i64 0, i32 %24
  %25 = load i32, i32* %array-index37
  %26 = add i32 %23, %25
  store i32 %26, i32* %array-index35
  %27 = load i32, i32* %"$i$31"
  %28 = add i32 %27, 1
  store i32 %28, i32* %"$i$31"
  br label %condeval33

postloop38:                                       ; preds = %condeval33
  %29 = load [6 x i32], [6 x i32]* %"$tmp_arr$32"
  store [6 x i32] %29, [6 x i32]* %first_int_array
  %array-index39 = getelementptr [6 x double], [6 x double]* %first_float_array, i64 0, i32 0
  store i32 0, i32* %"$i$40"
  br label %condeval42

condeval42:                                       ; preds = %loop43, %postloop38
  %30 = load i32, i32* %"$i$40"
  %31 = icmp slt i32 %30, 6
  br i1 %31, label %loop43, label %postloop47

loop43:                                           ; preds = %condeval42
  %32 = load i32, i32* %"$i$40"
  %array-index44 = getelementptr [6 x double], [6 x double]* %"$tmp_arr$41", i64 0, i32 %32
  %33 = load i32, i32* %"$i$40"
  %array-index45 = getelementptr [6 x double], [6 x double]* %first_float_array, i64 0, i32 %33
  %34 = load double, double* %array-index45
  %35 = load i32, i32* %"$i$40"
  %array-index46 = getelementptr [6 x double], [6 x double]* %second_float_array, i64 0, i32 %35
  %36 = load double, double* %array-index46
  %37 = fadd double %34, %36
  store double %37, double* %array-index44
  %38 = load i32, i32* %"$i$40"
  %39 = add i32 %38, 1
  store i32 %39, i32* %"$i$40"
  br label %condeval42

postloop47:                                       ; preds = %condeval42
  %40 = load [6 x double], [6 x double]* %"$tmp_arr$41"
  store [6 x double] %40, [6 x double]* %first_float_array
  %array-index48 = getelementptr [6 x double], [6 x double]* %first_float_array, i64 0, i32 0
  store i32 0, i32* %"$i$49"
  br label %condeval51

condeval51:                                       ; preds = %loop52, %postloop47
  %41 = load i32, i32* %"$i$49"
  %42 = icmp slt i32 %41, 6
  br i1 %42, label %loop52, label %postloop56

loop52:                                           ; preds = %condeval51
  %43 = load i32, i32* %"$i$49"
  %array-index53 = getelementptr [6 x double], [6 x double]* %"$tmp_arr$50", i64 0, i32 %43
  %44 = load i32, i32* %"$i$49"
  %array-index54 = getelementptr [6 x double], [6 x double]* %first_float_array, i64 0, i32 %44
  %45 = load double, double* %array-index54
  %46 = load i32, i32* %"$i$49"
  %array-index55 = getelementptr [6 x double], [6 x double]* %second_float_array, i64 0, i32 %46
  %47 = load double, double* %array-index55
  %48 = fadd double %45, %47
  store double %48, double* %array-index53
  %49 = load i32, i32* %"$i$49"
  %50 = add i32 %49, 1
  store i32 %50, i32* %"$i$49"
  br label %condeval51

postloop56:                                       ; preds = %condeval51
  %51 = load [6 x double], [6 x double]* %"$tmp_arr$50"
  store [6 x double] %51, [6 x double]* %first_float_array
  store i32 0, i32* %i
  call void @putString(i8* getelementptr inbounds ([38 x i8], [38 x i8]* @12, i32 0, i32 0))
  br label %condeval57

condeval57:                                       ; preds = %loop59, %postloop56
  %i58 = load i32, i32* %i
  %52 = icmp slt i32 %i58, 6
  br i1 %52, label %loop59, label %postloop69

loop59:                                           ; preds = %condeval57
  %i60 = load i32, i32* %i
  %array-index61 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 %i60
  %53 = load i32, i32* %array-index61
  call void @putInteger(i32 %53)
  %i62 = load i32, i32* %i
  %array-index63 = getelementptr [6 x i32], [6 x i32]* %second_int_array, i64 0, i32 %i62
  %54 = load i32, i32* %array-index63
  call void @putInteger(i32 %54)
  %i64 = load i32, i32* %i
  %array-index65 = getelementptr [6 x double], [6 x double]* %first_float_array, i64 0, i32 %i64
  %55 = load double, double* %array-index65
  call void @putFloat(double %55)
  %i66 = load i32, i32* %i
  %array-index67 = getelementptr [6 x double], [6 x double]* %second_float_array, i64 0, i32 %i66
  %56 = load double, double* %array-index67
  call void @putFloat(double %56)
  %i68 = load i32, i32* %i
  %57 = add i32 %i68, 1
  store i32 %57, i32* %i
  br label %condeval57

postloop69:                                       ; preds = %condeval57
  ret i32 0
}
