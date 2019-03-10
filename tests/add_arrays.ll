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
@12 = private unnamed_addr constant [56 x i8] c"Printing the first and second integer andn float arrays\00"
@13 = private unnamed_addr constant [53 x i8] c"Printing final_float_array (aka integer[] + float[])\00"

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
  %"$tmp_arr$77" = alloca [6 x double]
  %"$i$76" = alloca i32
  %"$tmp_arr$66" = alloca [6 x double]
  %"$i$65" = alloca i32
  %"$tmp_arr$55" = alloca [6 x i32]
  %"$i$54" = alloca i32
  %"$tmp_arr$44" = alloca [6 x i32]
  %"$i$43" = alloca i32
  %"$tmp_arr$33" = alloca [6 x double]
  %"$i$32" = alloca i32
  %"$tmp_arr$" = alloca [6 x double]
  %"$i$" = alloca i32
  %i = alloca i32
  %final_float_array = alloca [6 x double]
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
  %array-index23 = getelementptr [6 x i32], [6 x i32]* %second_int_array, i64 0, i32 0
  %array-index24 = getelementptr [6 x i32], [6 x i32]* %second_int_array, i64 0, i32 0
  %8 = load i32, i32* %array-index24
  %array-index25 = getelementptr [6 x double], [6 x double]* %second_float_array, i64 0, i32 0
  %9 = load double, double* %array-index25
  %array-index26 = getelementptr [6 x i32], [6 x i32]* %second_int_array, i64 0, i32 0
  store i32 0, i32* %"$i$"
  br label %condeval27

condeval27:                                       ; preds = %loop28, %postloop22
  %10 = load i32, i32* %"$i$"
  %11 = icmp slt i32 %10, 6
  br i1 %11, label %loop28, label %postloop31

loop28:                                           ; preds = %condeval27
  %12 = load i32, i32* %"$i$"
  %array-index29 = getelementptr [6 x double], [6 x double]* %"$tmp_arr$", i64 0, i32 %12
  %13 = load i32, i32* %"$i$"
  %array-index30 = getelementptr [6 x i32], [6 x i32]* %second_int_array, i64 0, i32 %13
  %14 = load i32, i32* %array-index30
  %integer-to-float = sitofp i32 %14 to double
  store double %integer-to-float, double* %array-index29
  %15 = load i32, i32* %"$i$"
  %16 = add i32 %15, 1
  store i32 %16, i32* %"$i$"
  br label %condeval27

postloop31:                                       ; preds = %condeval27
  store i32 0, i32* %"$i$32"
  br label %condeval34

condeval34:                                       ; preds = %loop35, %postloop31
  %17 = load i32, i32* %"$i$32"
  %18 = icmp slt i32 %17, 6
  br i1 %18, label %loop35, label %postloop39

loop35:                                           ; preds = %condeval34
  %19 = load i32, i32* %"$i$32"
  %array-index36 = getelementptr [6 x double], [6 x double]* %"$tmp_arr$33", i64 0, i32 %19
  %20 = load i32, i32* %"$i$32"
  %array-index37 = getelementptr [6 x double], [6 x double]* %"$tmp_arr$", i64 0, i32 %20
  %21 = load double, double* %array-index37
  %22 = load i32, i32* %"$i$32"
  %array-index38 = getelementptr [6 x double], [6 x double]* %second_float_array, i64 0, i32 %22
  %23 = load double, double* %array-index38
  %24 = fadd double %21, %23
  store double %24, double* %array-index36
  %25 = load i32, i32* %"$i$32"
  %26 = add i32 %25, 1
  store i32 %26, i32* %"$i$32"
  br label %condeval34

postloop39:                                       ; preds = %condeval34
  %27 = load [6 x double], [6 x double]* %"$tmp_arr$33"
  store [6 x double] %27, [6 x double]* %final_float_array
  %array-index40 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 0
  %array-index41 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 0
  %28 = load i32, i32* %array-index41
  %array-index42 = getelementptr [6 x i32], [6 x i32]* %second_int_array, i64 0, i32 0
  %29 = load i32, i32* %array-index42
  store i32 0, i32* %"$i$43"
  br label %condeval45

condeval45:                                       ; preds = %loop46, %postloop39
  %30 = load i32, i32* %"$i$43"
  %31 = icmp slt i32 %30, 6
  br i1 %31, label %loop46, label %postloop50

loop46:                                           ; preds = %condeval45
  %32 = load i32, i32* %"$i$43"
  %array-index47 = getelementptr [6 x i32], [6 x i32]* %"$tmp_arr$44", i64 0, i32 %32
  %33 = load i32, i32* %"$i$43"
  %array-index48 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 %33
  %34 = load i32, i32* %array-index48
  %35 = load i32, i32* %"$i$43"
  %array-index49 = getelementptr [6 x i32], [6 x i32]* %second_int_array, i64 0, i32 %35
  %36 = load i32, i32* %array-index49
  %37 = add i32 %34, %36
  store i32 %37, i32* %array-index47
  %38 = load i32, i32* %"$i$43"
  %39 = add i32 %38, 1
  store i32 %39, i32* %"$i$43"
  br label %condeval45

postloop50:                                       ; preds = %condeval45
  %40 = load [6 x i32], [6 x i32]* %"$tmp_arr$44"
  store [6 x i32] %40, [6 x i32]* %first_int_array
  %array-index51 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 0
  %array-index52 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 0
  %41 = load i32, i32* %array-index52
  %array-index53 = getelementptr [6 x i32], [6 x i32]* %second_int_array, i64 0, i32 0
  %42 = load i32, i32* %array-index53
  store i32 0, i32* %"$i$54"
  br label %condeval56

condeval56:                                       ; preds = %loop57, %postloop50
  %43 = load i32, i32* %"$i$54"
  %44 = icmp slt i32 %43, 6
  br i1 %44, label %loop57, label %postloop61

loop57:                                           ; preds = %condeval56
  %45 = load i32, i32* %"$i$54"
  %array-index58 = getelementptr [6 x i32], [6 x i32]* %"$tmp_arr$55", i64 0, i32 %45
  %46 = load i32, i32* %"$i$54"
  %array-index59 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 %46
  %47 = load i32, i32* %array-index59
  %48 = load i32, i32* %"$i$54"
  %array-index60 = getelementptr [6 x i32], [6 x i32]* %second_int_array, i64 0, i32 %48
  %49 = load i32, i32* %array-index60
  %50 = add i32 %47, %49
  store i32 %50, i32* %array-index58
  %51 = load i32, i32* %"$i$54"
  %52 = add i32 %51, 1
  store i32 %52, i32* %"$i$54"
  br label %condeval56

postloop61:                                       ; preds = %condeval56
  %53 = load [6 x i32], [6 x i32]* %"$tmp_arr$55"
  store [6 x i32] %53, [6 x i32]* %first_int_array
  %array-index62 = getelementptr [6 x double], [6 x double]* %first_float_array, i64 0, i32 0
  %array-index63 = getelementptr [6 x double], [6 x double]* %first_float_array, i64 0, i32 0
  %54 = load double, double* %array-index63
  %array-index64 = getelementptr [6 x double], [6 x double]* %second_float_array, i64 0, i32 0
  %55 = load double, double* %array-index64
  store i32 0, i32* %"$i$65"
  br label %condeval67

condeval67:                                       ; preds = %loop68, %postloop61
  %56 = load i32, i32* %"$i$65"
  %57 = icmp slt i32 %56, 6
  br i1 %57, label %loop68, label %postloop72

loop68:                                           ; preds = %condeval67
  %58 = load i32, i32* %"$i$65"
  %array-index69 = getelementptr [6 x double], [6 x double]* %"$tmp_arr$66", i64 0, i32 %58
  %59 = load i32, i32* %"$i$65"
  %array-index70 = getelementptr [6 x double], [6 x double]* %first_float_array, i64 0, i32 %59
  %60 = load double, double* %array-index70
  %61 = load i32, i32* %"$i$65"
  %array-index71 = getelementptr [6 x double], [6 x double]* %second_float_array, i64 0, i32 %61
  %62 = load double, double* %array-index71
  %63 = fadd double %60, %62
  store double %63, double* %array-index69
  %64 = load i32, i32* %"$i$65"
  %65 = add i32 %64, 1
  store i32 %65, i32* %"$i$65"
  br label %condeval67

postloop72:                                       ; preds = %condeval67
  %66 = load [6 x double], [6 x double]* %"$tmp_arr$66"
  store [6 x double] %66, [6 x double]* %first_float_array
  %array-index73 = getelementptr [6 x double], [6 x double]* %first_float_array, i64 0, i32 0
  %array-index74 = getelementptr [6 x double], [6 x double]* %first_float_array, i64 0, i32 0
  %67 = load double, double* %array-index74
  %array-index75 = getelementptr [6 x double], [6 x double]* %second_float_array, i64 0, i32 0
  %68 = load double, double* %array-index75
  store i32 0, i32* %"$i$76"
  br label %condeval78

condeval78:                                       ; preds = %loop79, %postloop72
  %69 = load i32, i32* %"$i$76"
  %70 = icmp slt i32 %69, 6
  br i1 %70, label %loop79, label %postloop83

loop79:                                           ; preds = %condeval78
  %71 = load i32, i32* %"$i$76"
  %array-index80 = getelementptr [6 x double], [6 x double]* %"$tmp_arr$77", i64 0, i32 %71
  %72 = load i32, i32* %"$i$76"
  %array-index81 = getelementptr [6 x double], [6 x double]* %first_float_array, i64 0, i32 %72
  %73 = load double, double* %array-index81
  %74 = load i32, i32* %"$i$76"
  %array-index82 = getelementptr [6 x double], [6 x double]* %second_float_array, i64 0, i32 %74
  %75 = load double, double* %array-index82
  %76 = fadd double %73, %75
  store double %76, double* %array-index80
  %77 = load i32, i32* %"$i$76"
  %78 = add i32 %77, 1
  store i32 %78, i32* %"$i$76"
  br label %condeval78

postloop83:                                       ; preds = %condeval78
  %79 = load [6 x double], [6 x double]* %"$tmp_arr$77"
  store [6 x double] %79, [6 x double]* %first_float_array
  store i32 0, i32* %i
  call void @putString(i8* getelementptr inbounds ([56 x i8], [56 x i8]* @12, i32 0, i32 0))
  br label %condeval84

condeval84:                                       ; preds = %loop86, %postloop83
  %i85 = load i32, i32* %i
  %80 = icmp slt i32 %i85, 6
  br i1 %80, label %loop86, label %postloop96

loop86:                                           ; preds = %condeval84
  %i87 = load i32, i32* %i
  %array-index88 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 %i87
  %81 = load i32, i32* %array-index88
  call void @putInteger(i32 %81)
  %i89 = load i32, i32* %i
  %array-index90 = getelementptr [6 x i32], [6 x i32]* %second_int_array, i64 0, i32 %i89
  %82 = load i32, i32* %array-index90
  call void @putInteger(i32 %82)
  %i91 = load i32, i32* %i
  %array-index92 = getelementptr [6 x double], [6 x double]* %first_float_array, i64 0, i32 %i91
  %83 = load double, double* %array-index92
  call void @putFloat(double %83)
  %i93 = load i32, i32* %i
  %array-index94 = getelementptr [6 x double], [6 x double]* %second_float_array, i64 0, i32 %i93
  %84 = load double, double* %array-index94
  call void @putFloat(double %84)
  %i95 = load i32, i32* %i
  %85 = add i32 %i95, 1
  store i32 %85, i32* %i
  br label %condeval84

postloop96:                                       ; preds = %condeval84
  store i32 0, i32* %i
  call void @putString(i8* getelementptr inbounds ([53 x i8], [53 x i8]* @13, i32 0, i32 0))
  br label %condeval97

condeval97:                                       ; preds = %loop99, %postloop96
  %i98 = load i32, i32* %i
  %86 = icmp slt i32 %i98, 6
  br i1 %86, label %loop99, label %postloop103

loop99:                                           ; preds = %condeval97
  %i100 = load i32, i32* %i
  %array-index101 = getelementptr [6 x double], [6 x double]* %final_float_array, i64 0, i32 %i100
  %87 = load double, double* %array-index101
  call void @putFloat(double %87)
  %i102 = load i32, i32* %i
  %88 = add i32 %i102, 1
  store i32 %88, i32* %i
  br label %condeval97

postloop103:                                      ; preds = %condeval97
  ret i32 0
}
