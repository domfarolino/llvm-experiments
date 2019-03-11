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
@10 = private unnamed_addr constant [25 x i8] c"Assigning array elements\00"
@11 = private unnamed_addr constant [38 x i8] c"Top-level printing given array values\00"
@12 = private unnamed_addr constant [55 x i8] c"Printing the first and second integer and float arrays\00"
@13 = private unnamed_addr constant [53 x i8] c"Printing final_float_array (aka integer[] / float[])\00"

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
  %"$tmp_arr$93" = alloca [6 x double]
  %"$i$92" = alloca i32
  %"$tmp_arr$79" = alloca [6 x double]
  %"$i$78" = alloca i32
  %"$tmp_arr$65" = alloca [6 x i32]
  %"$i$64" = alloca i32
  %"$tmp_arr$51" = alloca [6 x i32]
  %"$i$50" = alloca i32
  %"$tmp_arr$37" = alloca [6 x double]
  %"$i$36" = alloca i32
  %"$tmp_arr$" = alloca [6 x double]
  %"$i$" = alloca i32
  %i = alloca i32
  %final_float_array = alloca [6 x double]
  %second_float_array = alloca [6 x double]
  %first_float_array = alloca [6 x double]
  %second_int_array = alloca [6 x i32]
  %first_int_array = alloca [6 x i32]
  store i32 0, i32* %i
  call void @putString(i8* getelementptr inbounds ([25 x i8], [25 x i8]* @10, i32 0, i32 0))
  br label %condeval

condeval:                                         ; preds = %loop, %entry
  %i1 = load i32, i32* %i
  %0 = icmp slt i32 %i1, 6
  br i1 %0, label %loop, label %postloop

loop:                                             ; preds = %condeval
  %i2 = load i32, i32* %i
  %array-index = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 %i2
  store i32 26, i32* %array-index
  %i3 = load i32, i32* %i
  %array-index4 = getelementptr [6 x i32], [6 x i32]* %second_int_array, i64 0, i32 %i3
  store i32 3, i32* %array-index4
  %i5 = load i32, i32* %i
  %array-index6 = getelementptr [6 x double], [6 x double]* %first_float_array, i64 0, i32 %i5
  store double 8.000000e-01, double* %array-index6
  %i7 = load i32, i32* %i
  %array-index8 = getelementptr [6 x double], [6 x double]* %second_float_array, i64 0, i32 %i7
  store double 3.000000e-01, double* %array-index8
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
  %array-index23 = getelementptr [6 x i32], [6 x i32]* %second_int_array, i64 0, i32 0
  %8 = load i32, i32* %array-index23
  %array-index24 = getelementptr [6 x double], [6 x double]* %second_float_array, i64 0, i32 0
  %9 = load double, double* %array-index24
  %array-index25 = getelementptr [6 x i32], [6 x i32]* %second_int_array, i64 0, i32 0
  %10 = load i32, i32* %array-index25
  %array-index26 = getelementptr [6 x double], [6 x double]* %second_float_array, i64 0, i32 0
  %11 = load double, double* %array-index26
  %array-index27 = getelementptr [6 x i32], [6 x i32]* %second_int_array, i64 0, i32 0
  %12 = load i32, i32* %array-index27
  %array-index28 = getelementptr [6 x i32], [6 x i32]* %second_int_array, i64 0, i32 0
  %array-index29 = getelementptr [6 x i32], [6 x i32]* %second_int_array, i64 0, i32 0
  %13 = load i32, i32* %array-index29
  %array-index30 = getelementptr [6 x i32], [6 x i32]* %second_int_array, i64 0, i32 0
  store i32 0, i32* %"$i$"
  br label %condeval31

condeval31:                                       ; preds = %loop32, %postloop22
  %14 = load i32, i32* %"$i$"
  %15 = icmp slt i32 %14, 6
  br i1 %15, label %loop32, label %postloop35

loop32:                                           ; preds = %condeval31
  %16 = load i32, i32* %"$i$"
  %array-index33 = getelementptr [6 x double], [6 x double]* %"$tmp_arr$", i64 0, i32 %16
  %17 = load i32, i32* %"$i$"
  %array-index34 = getelementptr [6 x i32], [6 x i32]* %second_int_array, i64 0, i32 %17
  %18 = load i32, i32* %array-index34
  %integer-to-float = sitofp i32 %18 to double
  store double %integer-to-float, double* %array-index33
  %19 = load i32, i32* %"$i$"
  %20 = add i32 %19, 1
  store i32 %20, i32* %"$i$"
  br label %condeval31

postloop35:                                       ; preds = %condeval31
  store i32 0, i32* %"$i$36"
  br label %condeval38

condeval38:                                       ; preds = %loop39, %postloop35
  %21 = load i32, i32* %"$i$36"
  %22 = icmp slt i32 %21, 6
  br i1 %22, label %loop39, label %postloop43

loop39:                                           ; preds = %condeval38
  %23 = load i32, i32* %"$i$36"
  %array-index40 = getelementptr [6 x double], [6 x double]* %"$tmp_arr$37", i64 0, i32 %23
  %24 = load i32, i32* %"$i$36"
  %array-index41 = getelementptr [6 x double], [6 x double]* %"$tmp_arr$", i64 0, i32 %24
  %25 = load double, double* %array-index41
  %26 = load i32, i32* %"$i$36"
  %array-index42 = getelementptr [6 x double], [6 x double]* %second_float_array, i64 0, i32 %26
  %27 = load double, double* %array-index42
  %28 = fdiv double %25, %27
  store double %28, double* %array-index40
  %29 = load i32, i32* %"$i$36"
  %30 = add i32 %29, 1
  store i32 %30, i32* %"$i$36"
  br label %condeval38

postloop43:                                       ; preds = %condeval38
  %31 = load [6 x double], [6 x double]* %"$tmp_arr$37"
  store [6 x double] %31, [6 x double]* %final_float_array
  %array-index44 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 0
  %32 = load i32, i32* %array-index44
  %array-index45 = getelementptr [6 x i32], [6 x i32]* %second_int_array, i64 0, i32 0
  %33 = load i32, i32* %array-index45
  %array-index46 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 0
  %34 = load i32, i32* %array-index46
  %array-index47 = getelementptr [6 x i32], [6 x i32]* %second_int_array, i64 0, i32 0
  %35 = load i32, i32* %array-index47
  %array-index48 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 0
  %36 = load i32, i32* %array-index48
  %array-index49 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 0
  store i32 0, i32* %"$i$50"
  br label %condeval52

condeval52:                                       ; preds = %loop53, %postloop43
  %37 = load i32, i32* %"$i$50"
  %38 = icmp slt i32 %37, 6
  br i1 %38, label %loop53, label %postloop57

loop53:                                           ; preds = %condeval52
  %39 = load i32, i32* %"$i$50"
  %array-index54 = getelementptr [6 x i32], [6 x i32]* %"$tmp_arr$51", i64 0, i32 %39
  %40 = load i32, i32* %"$i$50"
  %array-index55 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 %40
  %41 = load i32, i32* %array-index55
  %42 = load i32, i32* %"$i$50"
  %array-index56 = getelementptr [6 x i32], [6 x i32]* %second_int_array, i64 0, i32 %42
  %43 = load i32, i32* %array-index56
  %44 = sdiv i32 %41, %43
  store i32 %44, i32* %array-index54
  %45 = load i32, i32* %"$i$50"
  %46 = add i32 %45, 1
  store i32 %46, i32* %"$i$50"
  br label %condeval52

postloop57:                                       ; preds = %condeval52
  %47 = load [6 x i32], [6 x i32]* %"$tmp_arr$51"
  store [6 x i32] %47, [6 x i32]* %first_int_array
  %array-index58 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 0
  %48 = load i32, i32* %array-index58
  %array-index59 = getelementptr [6 x i32], [6 x i32]* %second_int_array, i64 0, i32 0
  %49 = load i32, i32* %array-index59
  %array-index60 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 0
  %50 = load i32, i32* %array-index60
  %array-index61 = getelementptr [6 x i32], [6 x i32]* %second_int_array, i64 0, i32 0
  %51 = load i32, i32* %array-index61
  %array-index62 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 0
  %52 = load i32, i32* %array-index62
  %array-index63 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 0
  store i32 0, i32* %"$i$64"
  br label %condeval66

condeval66:                                       ; preds = %loop67, %postloop57
  %53 = load i32, i32* %"$i$64"
  %54 = icmp slt i32 %53, 6
  br i1 %54, label %loop67, label %postloop71

loop67:                                           ; preds = %condeval66
  %55 = load i32, i32* %"$i$64"
  %array-index68 = getelementptr [6 x i32], [6 x i32]* %"$tmp_arr$65", i64 0, i32 %55
  %56 = load i32, i32* %"$i$64"
  %array-index69 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 %56
  %57 = load i32, i32* %array-index69
  %58 = load i32, i32* %"$i$64"
  %array-index70 = getelementptr [6 x i32], [6 x i32]* %second_int_array, i64 0, i32 %58
  %59 = load i32, i32* %array-index70
  %60 = sdiv i32 %57, %59
  store i32 %60, i32* %array-index68
  %61 = load i32, i32* %"$i$64"
  %62 = add i32 %61, 1
  store i32 %62, i32* %"$i$64"
  br label %condeval66

postloop71:                                       ; preds = %condeval66
  %63 = load [6 x i32], [6 x i32]* %"$tmp_arr$65"
  store [6 x i32] %63, [6 x i32]* %first_int_array
  %array-index72 = getelementptr [6 x double], [6 x double]* %first_float_array, i64 0, i32 0
  %64 = load double, double* %array-index72
  %array-index73 = getelementptr [6 x double], [6 x double]* %second_float_array, i64 0, i32 0
  %65 = load double, double* %array-index73
  %array-index74 = getelementptr [6 x double], [6 x double]* %first_float_array, i64 0, i32 0
  %66 = load double, double* %array-index74
  %array-index75 = getelementptr [6 x double], [6 x double]* %second_float_array, i64 0, i32 0
  %67 = load double, double* %array-index75
  %array-index76 = getelementptr [6 x double], [6 x double]* %first_float_array, i64 0, i32 0
  %68 = load double, double* %array-index76
  %array-index77 = getelementptr [6 x double], [6 x double]* %first_float_array, i64 0, i32 0
  store i32 0, i32* %"$i$78"
  br label %condeval80

condeval80:                                       ; preds = %loop81, %postloop71
  %69 = load i32, i32* %"$i$78"
  %70 = icmp slt i32 %69, 6
  br i1 %70, label %loop81, label %postloop85

loop81:                                           ; preds = %condeval80
  %71 = load i32, i32* %"$i$78"
  %array-index82 = getelementptr [6 x double], [6 x double]* %"$tmp_arr$79", i64 0, i32 %71
  %72 = load i32, i32* %"$i$78"
  %array-index83 = getelementptr [6 x double], [6 x double]* %first_float_array, i64 0, i32 %72
  %73 = load double, double* %array-index83
  %74 = load i32, i32* %"$i$78"
  %array-index84 = getelementptr [6 x double], [6 x double]* %second_float_array, i64 0, i32 %74
  %75 = load double, double* %array-index84
  %76 = fdiv double %73, %75
  store double %76, double* %array-index82
  %77 = load i32, i32* %"$i$78"
  %78 = add i32 %77, 1
  store i32 %78, i32* %"$i$78"
  br label %condeval80

postloop85:                                       ; preds = %condeval80
  %79 = load [6 x double], [6 x double]* %"$tmp_arr$79"
  store [6 x double] %79, [6 x double]* %first_float_array
  %array-index86 = getelementptr [6 x double], [6 x double]* %first_float_array, i64 0, i32 0
  %80 = load double, double* %array-index86
  %array-index87 = getelementptr [6 x double], [6 x double]* %second_float_array, i64 0, i32 0
  %81 = load double, double* %array-index87
  %array-index88 = getelementptr [6 x double], [6 x double]* %first_float_array, i64 0, i32 0
  %82 = load double, double* %array-index88
  %array-index89 = getelementptr [6 x double], [6 x double]* %second_float_array, i64 0, i32 0
  %83 = load double, double* %array-index89
  %array-index90 = getelementptr [6 x double], [6 x double]* %first_float_array, i64 0, i32 0
  %84 = load double, double* %array-index90
  %array-index91 = getelementptr [6 x double], [6 x double]* %first_float_array, i64 0, i32 0
  store i32 0, i32* %"$i$92"
  br label %condeval94

condeval94:                                       ; preds = %loop95, %postloop85
  %85 = load i32, i32* %"$i$92"
  %86 = icmp slt i32 %85, 6
  br i1 %86, label %loop95, label %postloop99

loop95:                                           ; preds = %condeval94
  %87 = load i32, i32* %"$i$92"
  %array-index96 = getelementptr [6 x double], [6 x double]* %"$tmp_arr$93", i64 0, i32 %87
  %88 = load i32, i32* %"$i$92"
  %array-index97 = getelementptr [6 x double], [6 x double]* %first_float_array, i64 0, i32 %88
  %89 = load double, double* %array-index97
  %90 = load i32, i32* %"$i$92"
  %array-index98 = getelementptr [6 x double], [6 x double]* %second_float_array, i64 0, i32 %90
  %91 = load double, double* %array-index98
  %92 = fdiv double %89, %91
  store double %92, double* %array-index96
  %93 = load i32, i32* %"$i$92"
  %94 = add i32 %93, 1
  store i32 %94, i32* %"$i$92"
  br label %condeval94

postloop99:                                       ; preds = %condeval94
  %95 = load [6 x double], [6 x double]* %"$tmp_arr$93"
  store [6 x double] %95, [6 x double]* %first_float_array
  store i32 0, i32* %i
  call void @putString(i8* getelementptr inbounds ([55 x i8], [55 x i8]* @12, i32 0, i32 0))
  br label %condeval100

condeval100:                                      ; preds = %loop102, %postloop99
  %i101 = load i32, i32* %i
  %96 = icmp slt i32 %i101, 6
  br i1 %96, label %loop102, label %postloop112

loop102:                                          ; preds = %condeval100
  %i103 = load i32, i32* %i
  %array-index104 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 %i103
  %97 = load i32, i32* %array-index104
  call void @putInteger(i32 %97)
  %i105 = load i32, i32* %i
  %array-index106 = getelementptr [6 x i32], [6 x i32]* %second_int_array, i64 0, i32 %i105
  %98 = load i32, i32* %array-index106
  call void @putInteger(i32 %98)
  %i107 = load i32, i32* %i
  %array-index108 = getelementptr [6 x double], [6 x double]* %first_float_array, i64 0, i32 %i107
  %99 = load double, double* %array-index108
  call void @putFloat(double %99)
  %i109 = load i32, i32* %i
  %array-index110 = getelementptr [6 x double], [6 x double]* %second_float_array, i64 0, i32 %i109
  %100 = load double, double* %array-index110
  call void @putFloat(double %100)
  %i111 = load i32, i32* %i
  %101 = add i32 %i111, 1
  store i32 %101, i32* %i
  br label %condeval100

postloop112:                                      ; preds = %condeval100
  store i32 0, i32* %i
  call void @putString(i8* getelementptr inbounds ([53 x i8], [53 x i8]* @13, i32 0, i32 0))
  br label %condeval113

condeval113:                                      ; preds = %loop115, %postloop112
  %i114 = load i32, i32* %i
  %102 = icmp slt i32 %i114, 6
  br i1 %102, label %loop115, label %postloop119

loop115:                                          ; preds = %condeval113
  %i116 = load i32, i32* %i
  %array-index117 = getelementptr [6 x double], [6 x double]* %final_float_array, i64 0, i32 %i116
  %103 = load double, double* %array-index117
  call void @putFloat(double %103)
  %i118 = load i32, i32* %i
  %104 = add i32 %i118, 1
  store i32 %104, i32* %i
  br label %condeval113

postloop119:                                      ; preds = %condeval113
  ret i32 0
}
