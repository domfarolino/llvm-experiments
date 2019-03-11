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
@12 = private unnamed_addr constant [55 x i8] c"Printing the first and second integer and float arrays\00"
@13 = private unnamed_addr constant [51 x i8] c"Printing final_float_array (aka integer * float[])\00"
@14 = private unnamed_addr constant [51 x i8] c"Printing final_float_array (aka integer[] * float)\00"

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
  %"$tmp_arr$102" = alloca [6 x double]
  %"$i$101" = alloca i32
  %"$tmp_arr$94" = alloca [6 x double]
  %"$i$93" = alloca i32
  %"$tmp_arr$65" = alloca [6 x double]
  %"$i$64" = alloca i32
  %"$tmp_arr$54" = alloca [6 x double]
  %"$i$53" = alloca i32
  %"$tmp_arr$43" = alloca [6 x i32]
  %"$i$42" = alloca i32
  %"$tmp_arr$32" = alloca [6 x i32]
  %"$i$31" = alloca i32
  %"$tmp_arr$" = alloca [6 x double]
  %"$i$" = alloca i32
  %i = alloca i32
  %final_float_array = alloca [6 x double]
  %first_float_array = alloca [6 x double]
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
  %i3 = load i32, i32* %i
  store i32 %i3, i32* %array-index
  %i4 = load i32, i32* %i
  %array-index5 = getelementptr [6 x double], [6 x double]* %first_float_array, i64 0, i32 %i4
  %i6 = load i32, i32* %i
  %integer-to-float = sitofp i32 %i6 to double
  store double %integer-to-float, double* %array-index5
  %i7 = load i32, i32* %i
  %1 = add i32 %i7, 1
  store i32 %1, i32* %i
  br label %condeval

postloop:                                         ; preds = %condeval
  store i32 0, i32* %i
  call void @putString(i8* getelementptr inbounds ([38 x i8], [38 x i8]* @11, i32 0, i32 0))
  br label %condeval8

condeval8:                                        ; preds = %loop10, %postloop
  %i9 = load i32, i32* %i
  %2 = icmp slt i32 %i9, 6
  br i1 %2, label %loop10, label %postloop16

loop10:                                           ; preds = %condeval8
  %i11 = load i32, i32* %i
  %array-index12 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 %i11
  %3 = load i32, i32* %array-index12
  call void @putInteger(i32 %3)
  %i13 = load i32, i32* %i
  %array-index14 = getelementptr [6 x double], [6 x double]* %first_float_array, i64 0, i32 %i13
  %4 = load double, double* %array-index14
  call void @putFloat(double %4)
  %i15 = load i32, i32* %i
  %5 = add i32 %i15, 1
  store i32 %5, i32* %i
  br label %condeval8

postloop16:                                       ; preds = %condeval8
  %array-index17 = getelementptr [6 x double], [6 x double]* %first_float_array, i64 0, i32 0
  %6 = load double, double* %array-index17
  %array-index18 = getelementptr [6 x double], [6 x double]* %first_float_array, i64 0, i32 0
  %7 = load double, double* %array-index18
  %array-index19 = getelementptr [6 x double], [6 x double]* %first_float_array, i64 0, i32 0
  %8 = load double, double* %array-index19
  %array-index20 = getelementptr [6 x double], [6 x double]* %first_float_array, i64 0, i32 0
  %integer-to-float21 = sitofp i32 4 to double
  store i32 0, i32* %"$i$"
  br label %condeval22

condeval22:                                       ; preds = %loop23, %postloop16
  %9 = load i32, i32* %"$i$"
  %10 = icmp slt i32 %9, 6
  br i1 %10, label %loop23, label %postloop26

loop23:                                           ; preds = %condeval22
  %11 = load i32, i32* %"$i$"
  %array-index24 = getelementptr [6 x double], [6 x double]* %"$tmp_arr$", i64 0, i32 %11
  %12 = load i32, i32* %"$i$"
  %array-index25 = getelementptr [6 x double], [6 x double]* %first_float_array, i64 0, i32 %12
  %13 = load double, double* %array-index25
  %14 = fmul double %integer-to-float21, %13
  store double %14, double* %array-index24
  %15 = load i32, i32* %"$i$"
  %16 = add i32 %15, 1
  store i32 %16, i32* %"$i$"
  br label %condeval22

postloop26:                                       ; preds = %condeval22
  %17 = load [6 x double], [6 x double]* %"$tmp_arr$"
  store [6 x double] %17, [6 x double]* %final_float_array
  %array-index27 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 0
  %18 = load i32, i32* %array-index27
  %array-index28 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 0
  %19 = load i32, i32* %array-index28
  %array-index29 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 0
  %20 = load i32, i32* %array-index29
  %array-index30 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 0
  store i32 0, i32* %"$i$31"
  br label %condeval33

condeval33:                                       ; preds = %loop34, %postloop26
  %21 = load i32, i32* %"$i$31"
  %22 = icmp slt i32 %21, 6
  br i1 %22, label %loop34, label %postloop37

loop34:                                           ; preds = %condeval33
  %23 = load i32, i32* %"$i$31"
  %array-index35 = getelementptr [6 x i32], [6 x i32]* %"$tmp_arr$32", i64 0, i32 %23
  %24 = load i32, i32* %"$i$31"
  %array-index36 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 %24
  %25 = load i32, i32* %array-index36
  %26 = mul i32 2, %25
  store i32 %26, i32* %array-index35
  %27 = load i32, i32* %"$i$31"
  %28 = add i32 %27, 1
  store i32 %28, i32* %"$i$31"
  br label %condeval33

postloop37:                                       ; preds = %condeval33
  %29 = load [6 x i32], [6 x i32]* %"$tmp_arr$32"
  store [6 x i32] %29, [6 x i32]* %first_int_array
  %array-index38 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 0
  %30 = load i32, i32* %array-index38
  %array-index39 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 0
  %31 = load i32, i32* %array-index39
  %array-index40 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 0
  %32 = load i32, i32* %array-index40
  %array-index41 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 0
  store i32 0, i32* %"$i$42"
  br label %condeval44

condeval44:                                       ; preds = %loop45, %postloop37
  %33 = load i32, i32* %"$i$42"
  %34 = icmp slt i32 %33, 6
  br i1 %34, label %loop45, label %postloop48

loop45:                                           ; preds = %condeval44
  %35 = load i32, i32* %"$i$42"
  %array-index46 = getelementptr [6 x i32], [6 x i32]* %"$tmp_arr$43", i64 0, i32 %35
  %36 = load i32, i32* %"$i$42"
  %array-index47 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 %36
  %37 = load i32, i32* %array-index47
  %38 = mul i32 %37, 5
  store i32 %38, i32* %array-index46
  %39 = load i32, i32* %"$i$42"
  %40 = add i32 %39, 1
  store i32 %40, i32* %"$i$42"
  br label %condeval44

postloop48:                                       ; preds = %condeval44
  %41 = load [6 x i32], [6 x i32]* %"$tmp_arr$43"
  store [6 x i32] %41, [6 x i32]* %first_int_array
  %array-index49 = getelementptr [6 x double], [6 x double]* %first_float_array, i64 0, i32 0
  %42 = load double, double* %array-index49
  %array-index50 = getelementptr [6 x double], [6 x double]* %first_float_array, i64 0, i32 0
  %43 = load double, double* %array-index50
  %array-index51 = getelementptr [6 x double], [6 x double]* %first_float_array, i64 0, i32 0
  %44 = load double, double* %array-index51
  %array-index52 = getelementptr [6 x double], [6 x double]* %first_float_array, i64 0, i32 0
  store i32 0, i32* %"$i$53"
  br label %condeval55

condeval55:                                       ; preds = %loop56, %postloop48
  %45 = load i32, i32* %"$i$53"
  %46 = icmp slt i32 %45, 6
  br i1 %46, label %loop56, label %postloop59

loop56:                                           ; preds = %condeval55
  %47 = load i32, i32* %"$i$53"
  %array-index57 = getelementptr [6 x double], [6 x double]* %"$tmp_arr$54", i64 0, i32 %47
  %48 = load i32, i32* %"$i$53"
  %array-index58 = getelementptr [6 x double], [6 x double]* %first_float_array, i64 0, i32 %48
  %49 = load double, double* %array-index58
  %50 = fmul double 2.000000e+00, %49
  store double %50, double* %array-index57
  %51 = load i32, i32* %"$i$53"
  %52 = add i32 %51, 1
  store i32 %52, i32* %"$i$53"
  br label %condeval55

postloop59:                                       ; preds = %condeval55
  %53 = load [6 x double], [6 x double]* %"$tmp_arr$54"
  store [6 x double] %53, [6 x double]* %first_float_array
  %array-index60 = getelementptr [6 x double], [6 x double]* %first_float_array, i64 0, i32 0
  %54 = load double, double* %array-index60
  %array-index61 = getelementptr [6 x double], [6 x double]* %first_float_array, i64 0, i32 0
  %55 = load double, double* %array-index61
  %array-index62 = getelementptr [6 x double], [6 x double]* %first_float_array, i64 0, i32 0
  %56 = load double, double* %array-index62
  %array-index63 = getelementptr [6 x double], [6 x double]* %first_float_array, i64 0, i32 0
  store i32 0, i32* %"$i$64"
  br label %condeval66

condeval66:                                       ; preds = %loop67, %postloop59
  %57 = load i32, i32* %"$i$64"
  %58 = icmp slt i32 %57, 6
  br i1 %58, label %loop67, label %postloop70

loop67:                                           ; preds = %condeval66
  %59 = load i32, i32* %"$i$64"
  %array-index68 = getelementptr [6 x double], [6 x double]* %"$tmp_arr$65", i64 0, i32 %59
  %60 = load i32, i32* %"$i$64"
  %array-index69 = getelementptr [6 x double], [6 x double]* %first_float_array, i64 0, i32 %60
  %61 = load double, double* %array-index69
  %62 = fmul double %61, 5.000000e+00
  store double %62, double* %array-index68
  %63 = load i32, i32* %"$i$64"
  %64 = add i32 %63, 1
  store i32 %64, i32* %"$i$64"
  br label %condeval66

postloop70:                                       ; preds = %condeval66
  %65 = load [6 x double], [6 x double]* %"$tmp_arr$65"
  store [6 x double] %65, [6 x double]* %first_float_array
  store i32 0, i32* %i
  call void @putString(i8* getelementptr inbounds ([55 x i8], [55 x i8]* @12, i32 0, i32 0))
  br label %condeval71

condeval71:                                       ; preds = %loop73, %postloop70
  %i72 = load i32, i32* %i
  %66 = icmp slt i32 %i72, 6
  br i1 %66, label %loop73, label %postloop79

loop73:                                           ; preds = %condeval71
  %i74 = load i32, i32* %i
  %array-index75 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 %i74
  %67 = load i32, i32* %array-index75
  call void @putInteger(i32 %67)
  %i76 = load i32, i32* %i
  %array-index77 = getelementptr [6 x double], [6 x double]* %first_float_array, i64 0, i32 %i76
  %68 = load double, double* %array-index77
  call void @putFloat(double %68)
  %i78 = load i32, i32* %i
  %69 = add i32 %i78, 1
  store i32 %69, i32* %i
  br label %condeval71

postloop79:                                       ; preds = %condeval71
  store i32 0, i32* %i
  call void @putString(i8* getelementptr inbounds ([51 x i8], [51 x i8]* @13, i32 0, i32 0))
  br label %condeval80

condeval80:                                       ; preds = %loop82, %postloop79
  %i81 = load i32, i32* %i
  %70 = icmp slt i32 %i81, 6
  br i1 %70, label %loop82, label %postloop86

loop82:                                           ; preds = %condeval80
  %i83 = load i32, i32* %i
  %array-index84 = getelementptr [6 x double], [6 x double]* %final_float_array, i64 0, i32 %i83
  %71 = load double, double* %array-index84
  call void @putFloat(double %71)
  %i85 = load i32, i32* %i
  %72 = add i32 %i85, 1
  store i32 %72, i32* %i
  br label %condeval80

postloop86:                                       ; preds = %condeval80
  store i32 0, i32* %i
  %array-index87 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 0
  %73 = load i32, i32* %array-index87
  %array-index88 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 0
  %74 = load i32, i32* %array-index88
  %array-index89 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 0
  %75 = load i32, i32* %array-index89
  %array-index90 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 0
  %array-index91 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 0
  %76 = load i32, i32* %array-index91
  %array-index92 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 0
  store i32 0, i32* %"$i$93"
  br label %condeval95

condeval95:                                       ; preds = %loop96, %postloop86
  %77 = load i32, i32* %"$i$93"
  %78 = icmp slt i32 %77, 6
  br i1 %78, label %loop96, label %postloop100

loop96:                                           ; preds = %condeval95
  %79 = load i32, i32* %"$i$93"
  %array-index97 = getelementptr [6 x double], [6 x double]* %"$tmp_arr$94", i64 0, i32 %79
  %80 = load i32, i32* %"$i$93"
  %array-index98 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 %80
  %81 = load i32, i32* %array-index98
  %integer-to-float99 = sitofp i32 %81 to double
  store double %integer-to-float99, double* %array-index97
  %82 = load i32, i32* %"$i$93"
  %83 = add i32 %82, 1
  store i32 %83, i32* %"$i$93"
  br label %condeval95

postloop100:                                      ; preds = %condeval95
  store i32 0, i32* %"$i$101"
  br label %condeval103

condeval103:                                      ; preds = %loop104, %postloop100
  %84 = load i32, i32* %"$i$101"
  %85 = icmp slt i32 %84, 6
  br i1 %85, label %loop104, label %postloop107

loop104:                                          ; preds = %condeval103
  %86 = load i32, i32* %"$i$101"
  %array-index105 = getelementptr [6 x double], [6 x double]* %"$tmp_arr$102", i64 0, i32 %86
  %87 = load i32, i32* %"$i$101"
  %array-index106 = getelementptr [6 x double], [6 x double]* %"$tmp_arr$94", i64 0, i32 %87
  %88 = load double, double* %array-index106
  %89 = fmul double %88, 4.000000e+00
  store double %89, double* %array-index105
  %90 = load i32, i32* %"$i$101"
  %91 = add i32 %90, 1
  store i32 %91, i32* %"$i$101"
  br label %condeval103

postloop107:                                      ; preds = %condeval103
  %92 = load [6 x double], [6 x double]* %"$tmp_arr$102"
  store [6 x double] %92, [6 x double]* %final_float_array
  call void @putString(i8* getelementptr inbounds ([51 x i8], [51 x i8]* @14, i32 0, i32 0))
  br label %condeval108

condeval108:                                      ; preds = %loop110, %postloop107
  %i109 = load i32, i32* %i
  %93 = icmp slt i32 %i109, 6
  br i1 %93, label %loop110, label %postloop114

loop110:                                          ; preds = %condeval108
  %i111 = load i32, i32* %i
  %array-index112 = getelementptr [6 x double], [6 x double]* %final_float_array, i64 0, i32 %i111
  %94 = load double, double* %array-index112
  call void @putFloat(double %94)
  %i113 = load i32, i32* %i
  %95 = add i32 %i113, 1
  store i32 %95, i32* %i
  br label %condeval108

postloop114:                                      ; preds = %condeval108
  ret i32 0
}
