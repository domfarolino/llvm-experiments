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
  %"$tmp_arr$46" = alloca [6 x double]
  %"$i$45" = alloca i32
  %"$tmp_arr$38" = alloca [6 x double]
  %"$i$37" = alloca i32
  %"$tmp_arr$30" = alloca [6 x i32]
  %"$i$29" = alloca i32
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
  store i32 0, i32* %"$i$"
  br label %condeval23

condeval23:                                       ; preds = %loop24, %postloop22
  %8 = load i32, i32* %"$i$"
  %9 = icmp slt i32 %8, 6
  br i1 %9, label %loop24, label %postloop28

loop24:                                           ; preds = %condeval23
  %10 = load i32, i32* %"$i$"
  %array-index25 = getelementptr [6 x i32], [6 x i32]* %"$tmp_arr$", i64 0, i32 %10
  %11 = load i32, i32* %"$i$"
  %array-index26 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 %11
  %12 = load i32, i32* %array-index26
  %13 = load i32, i32* %"$i$"
  %array-index27 = getelementptr [6 x i32], [6 x i32]* %second_int_array, i64 0, i32 %13
  %14 = load i32, i32* %array-index27
  %15 = add i32 %12, %14
  store i32 %15, i32* %array-index25
  %16 = load i32, i32* %"$i$"
  %17 = add i32 %16, 1
  store i32 %17, i32* %"$i$"
  br label %condeval23

postloop28:                                       ; preds = %condeval23
  %18 = load [6 x i32], [6 x i32]* %"$tmp_arr$"
  store [6 x i32] %18, [6 x i32]* %first_int_array
  store i32 0, i32* %"$i$29"
  br label %condeval31

condeval31:                                       ; preds = %loop32, %postloop28
  %19 = load i32, i32* %"$i$29"
  %20 = icmp slt i32 %19, 6
  br i1 %20, label %loop32, label %postloop36

loop32:                                           ; preds = %condeval31
  %21 = load i32, i32* %"$i$29"
  %array-index33 = getelementptr [6 x i32], [6 x i32]* %"$tmp_arr$30", i64 0, i32 %21
  %22 = load i32, i32* %"$i$29"
  %array-index34 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 %22
  %23 = load i32, i32* %array-index34
  %24 = load i32, i32* %"$i$29"
  %array-index35 = getelementptr [6 x i32], [6 x i32]* %second_int_array, i64 0, i32 %24
  %25 = load i32, i32* %array-index35
  %26 = add i32 %23, %25
  store i32 %26, i32* %array-index33
  %27 = load i32, i32* %"$i$29"
  %28 = add i32 %27, 1
  store i32 %28, i32* %"$i$29"
  br label %condeval31

postloop36:                                       ; preds = %condeval31
  %29 = load [6 x i32], [6 x i32]* %"$tmp_arr$30"
  store [6 x i32] %29, [6 x i32]* %first_int_array
  store i32 0, i32* %"$i$37"
  br label %condeval39

condeval39:                                       ; preds = %loop40, %postloop36
  %30 = load i32, i32* %"$i$37"
  %31 = icmp slt i32 %30, 6
  br i1 %31, label %loop40, label %postloop44

loop40:                                           ; preds = %condeval39
  %32 = load i32, i32* %"$i$37"
  %array-index41 = getelementptr [6 x double], [6 x double]* %"$tmp_arr$38", i64 0, i32 %32
  %33 = load i32, i32* %"$i$37"
  %array-index42 = getelementptr [6 x double], [6 x double]* %first_float_array, i64 0, i32 %33
  %34 = load double, double* %array-index42
  %35 = load i32, i32* %"$i$37"
  %array-index43 = getelementptr [6 x double], [6 x double]* %second_float_array, i64 0, i32 %35
  %36 = load double, double* %array-index43
  %37 = fadd double %34, %36
  store double %37, double* %array-index41
  %38 = load i32, i32* %"$i$37"
  %39 = add i32 %38, 1
  store i32 %39, i32* %"$i$37"
  br label %condeval39

postloop44:                                       ; preds = %condeval39
  %40 = load [6 x double], [6 x double]* %"$tmp_arr$38"
  store [6 x double] %40, [6 x double]* %first_float_array
  store i32 0, i32* %"$i$45"
  br label %condeval47

condeval47:                                       ; preds = %loop48, %postloop44
  %41 = load i32, i32* %"$i$45"
  %42 = icmp slt i32 %41, 6
  br i1 %42, label %loop48, label %postloop52

loop48:                                           ; preds = %condeval47
  %43 = load i32, i32* %"$i$45"
  %array-index49 = getelementptr [6 x double], [6 x double]* %"$tmp_arr$46", i64 0, i32 %43
  %44 = load i32, i32* %"$i$45"
  %array-index50 = getelementptr [6 x double], [6 x double]* %first_float_array, i64 0, i32 %44
  %45 = load double, double* %array-index50
  %46 = load i32, i32* %"$i$45"
  %array-index51 = getelementptr [6 x double], [6 x double]* %second_float_array, i64 0, i32 %46
  %47 = load double, double* %array-index51
  %48 = fadd double %45, %47
  store double %48, double* %array-index49
  %49 = load i32, i32* %"$i$45"
  %50 = add i32 %49, 1
  store i32 %50, i32* %"$i$45"
  br label %condeval47

postloop52:                                       ; preds = %condeval47
  %51 = load [6 x double], [6 x double]* %"$tmp_arr$46"
  store [6 x double] %51, [6 x double]* %first_float_array
  store i32 0, i32* %i
  call void @putString(i8* getelementptr inbounds ([38 x i8], [38 x i8]* @12, i32 0, i32 0))
  br label %condeval53

condeval53:                                       ; preds = %loop55, %postloop52
  %i54 = load i32, i32* %i
  %52 = icmp slt i32 %i54, 6
  br i1 %52, label %loop55, label %postloop65

loop55:                                           ; preds = %condeval53
  %i56 = load i32, i32* %i
  %array-index57 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 %i56
  %53 = load i32, i32* %array-index57
  call void @putInteger(i32 %53)
  %i58 = load i32, i32* %i
  %array-index59 = getelementptr [6 x i32], [6 x i32]* %second_int_array, i64 0, i32 %i58
  %54 = load i32, i32* %array-index59
  call void @putInteger(i32 %54)
  %i60 = load i32, i32* %i
  %array-index61 = getelementptr [6 x double], [6 x double]* %first_float_array, i64 0, i32 %i60
  %55 = load double, double* %array-index61
  call void @putFloat(double %55)
  %i62 = load i32, i32* %i
  %array-index63 = getelementptr [6 x double], [6 x double]* %second_float_array, i64 0, i32 %i62
  %56 = load double, double* %array-index63
  call void @putFloat(double %56)
  %i64 = load i32, i32* %i
  %57 = add i32 %i64, 1
  store i32 %57, i32* %i
  br label %condeval53

postloop65:                                       ; preds = %condeval53
  ret i32 0
}
