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
  %"$tmp_arr$99" = alloca [6 x double]
  %"$i$98" = alloca i32
  %"$tmp_arr$85" = alloca [6 x double]
  %"$i$84" = alloca i32
  %"$tmp_arr$71" = alloca [6 x i32]
  %"$i$70" = alloca i32
  %"$tmp_arr$57" = alloca [6 x i32]
  %"$i$56" = alloca i32
  %"$tmp_arr$43" = alloca [6 x double]
  %"$i$42" = alloca i32
  %"$tmp_arr$" = alloca [6 x double]
  %"$i$" = alloca i32
  %i = alloca i32
  %final_float_array = alloca [6 x double]
  %second_float_array = alloca [6 x double]
  %first_float_array = alloca [6 x double]
  %second_int_array = alloca [6 x i32]
  %first_int_array = alloca [6 x i32]
  store i32 0, i32* %i
  call void @putString(i8* getelementptr inbounds ([34 x i8], [34 x i8]* @10, i32 0, i32 0))
  br label %condeval

condeval:                                         ; preds = %loop, %entry
  %i1 = load i32, i32* %i
  %0 = icmp slt i32 %i1, 6
  br i1 %0, label %loop, label %postloop

loop:                                             ; preds = %condeval
  %i2 = load i32, i32* %i
  %array-index = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 %i2
  %i3 = load i32, i32* %i
  store i32 %i3, i32* %array-index
  %i4 = load i32, i32* %i
  %array-index5 = getelementptr [6 x i32], [6 x i32]* %second_int_array, i64 0, i32 %i4
  %i6 = load i32, i32* %i
  store i32 %i6, i32* %array-index5
  %i7 = load i32, i32* %i
  %array-index8 = getelementptr [6 x double], [6 x double]* %first_float_array, i64 0, i32 %i7
  %i9 = load i32, i32* %i
  %integer-to-float = sitofp i32 %i9 to double
  store double %integer-to-float, double* %array-index8
  %i10 = load i32, i32* %i
  %array-index11 = getelementptr [6 x double], [6 x double]* %second_float_array, i64 0, i32 %i10
  %i12 = load i32, i32* %i
  %integer-to-float13 = sitofp i32 %i12 to double
  store double %integer-to-float13, double* %array-index11
  %i14 = load i32, i32* %i
  %1 = add i32 %i14, 1
  store i32 %1, i32* %i
  br label %condeval

postloop:                                         ; preds = %condeval
  store i32 0, i32* %i
  call void @putString(i8* getelementptr inbounds ([38 x i8], [38 x i8]* @11, i32 0, i32 0))
  br label %condeval15

condeval15:                                       ; preds = %loop17, %postloop
  %i16 = load i32, i32* %i
  %2 = icmp slt i32 %i16, 6
  br i1 %2, label %loop17, label %postloop27

loop17:                                           ; preds = %condeval15
  %i18 = load i32, i32* %i
  %array-index19 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 %i18
  %3 = load i32, i32* %array-index19
  call void @putInteger(i32 %3)
  %i20 = load i32, i32* %i
  %array-index21 = getelementptr [6 x i32], [6 x i32]* %second_int_array, i64 0, i32 %i20
  %4 = load i32, i32* %array-index21
  call void @putInteger(i32 %4)
  %i22 = load i32, i32* %i
  %array-index23 = getelementptr [6 x double], [6 x double]* %first_float_array, i64 0, i32 %i22
  %5 = load double, double* %array-index23
  call void @putFloat(double %5)
  %i24 = load i32, i32* %i
  %array-index25 = getelementptr [6 x double], [6 x double]* %second_float_array, i64 0, i32 %i24
  %6 = load double, double* %array-index25
  call void @putFloat(double %6)
  %i26 = load i32, i32* %i
  %7 = add i32 %i26, 1
  store i32 %7, i32* %i
  br label %condeval15

postloop27:                                       ; preds = %condeval15
  %array-index28 = getelementptr [6 x i32], [6 x i32]* %second_int_array, i64 0, i32 0
  %8 = load i32, i32* %array-index28
  %array-index29 = getelementptr [6 x double], [6 x double]* %second_float_array, i64 0, i32 0
  %9 = load double, double* %array-index29
  %array-index30 = getelementptr [6 x i32], [6 x i32]* %second_int_array, i64 0, i32 0
  %10 = load i32, i32* %array-index30
  %array-index31 = getelementptr [6 x double], [6 x double]* %second_float_array, i64 0, i32 0
  %11 = load double, double* %array-index31
  %array-index32 = getelementptr [6 x i32], [6 x i32]* %second_int_array, i64 0, i32 0
  %12 = load i32, i32* %array-index32
  %array-index33 = getelementptr [6 x i32], [6 x i32]* %second_int_array, i64 0, i32 0
  %array-index34 = getelementptr [6 x i32], [6 x i32]* %second_int_array, i64 0, i32 0
  %13 = load i32, i32* %array-index34
  %array-index35 = getelementptr [6 x i32], [6 x i32]* %second_int_array, i64 0, i32 0
  store i32 0, i32* %"$i$"
  br label %condeval36

condeval36:                                       ; preds = %loop37, %postloop27
  %14 = load i32, i32* %"$i$"
  %15 = icmp slt i32 %14, 6
  br i1 %15, label %loop37, label %postloop41

loop37:                                           ; preds = %condeval36
  %16 = load i32, i32* %"$i$"
  %array-index38 = getelementptr [6 x double], [6 x double]* %"$tmp_arr$", i64 0, i32 %16
  %17 = load i32, i32* %"$i$"
  %array-index39 = getelementptr [6 x i32], [6 x i32]* %second_int_array, i64 0, i32 %17
  %18 = load i32, i32* %array-index39
  %integer-to-float40 = sitofp i32 %18 to double
  store double %integer-to-float40, double* %array-index38
  %19 = load i32, i32* %"$i$"
  %20 = add i32 %19, 1
  store i32 %20, i32* %"$i$"
  br label %condeval36

postloop41:                                       ; preds = %condeval36
  store i32 0, i32* %"$i$42"
  br label %condeval44

condeval44:                                       ; preds = %loop45, %postloop41
  %21 = load i32, i32* %"$i$42"
  %22 = icmp slt i32 %21, 6
  br i1 %22, label %loop45, label %postloop49

loop45:                                           ; preds = %condeval44
  %23 = load i32, i32* %"$i$42"
  %array-index46 = getelementptr [6 x double], [6 x double]* %"$tmp_arr$43", i64 0, i32 %23
  %24 = load i32, i32* %"$i$42"
  %array-index47 = getelementptr [6 x double], [6 x double]* %"$tmp_arr$", i64 0, i32 %24
  %25 = load double, double* %array-index47
  %26 = load i32, i32* %"$i$42"
  %array-index48 = getelementptr [6 x double], [6 x double]* %second_float_array, i64 0, i32 %26
  %27 = load double, double* %array-index48
  %28 = fmul double %25, %27
  store double %28, double* %array-index46
  %29 = load i32, i32* %"$i$42"
  %30 = add i32 %29, 1
  store i32 %30, i32* %"$i$42"
  br label %condeval44

postloop49:                                       ; preds = %condeval44
  %31 = load [6 x double], [6 x double]* %"$tmp_arr$43"
  store [6 x double] %31, [6 x double]* %final_float_array
  %array-index50 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 0
  %32 = load i32, i32* %array-index50
  %array-index51 = getelementptr [6 x i32], [6 x i32]* %second_int_array, i64 0, i32 0
  %33 = load i32, i32* %array-index51
  %array-index52 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 0
  %34 = load i32, i32* %array-index52
  %array-index53 = getelementptr [6 x i32], [6 x i32]* %second_int_array, i64 0, i32 0
  %35 = load i32, i32* %array-index53
  %array-index54 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 0
  %36 = load i32, i32* %array-index54
  %array-index55 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 0
  store i32 0, i32* %"$i$56"
  br label %condeval58

condeval58:                                       ; preds = %loop59, %postloop49
  %37 = load i32, i32* %"$i$56"
  %38 = icmp slt i32 %37, 6
  br i1 %38, label %loop59, label %postloop63

loop59:                                           ; preds = %condeval58
  %39 = load i32, i32* %"$i$56"
  %array-index60 = getelementptr [6 x i32], [6 x i32]* %"$tmp_arr$57", i64 0, i32 %39
  %40 = load i32, i32* %"$i$56"
  %array-index61 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 %40
  %41 = load i32, i32* %array-index61
  %42 = load i32, i32* %"$i$56"
  %array-index62 = getelementptr [6 x i32], [6 x i32]* %second_int_array, i64 0, i32 %42
  %43 = load i32, i32* %array-index62
  %44 = mul i32 %41, %43
  store i32 %44, i32* %array-index60
  %45 = load i32, i32* %"$i$56"
  %46 = add i32 %45, 1
  store i32 %46, i32* %"$i$56"
  br label %condeval58

postloop63:                                       ; preds = %condeval58
  %47 = load [6 x i32], [6 x i32]* %"$tmp_arr$57"
  store [6 x i32] %47, [6 x i32]* %first_int_array
  %array-index64 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 0
  %48 = load i32, i32* %array-index64
  %array-index65 = getelementptr [6 x i32], [6 x i32]* %second_int_array, i64 0, i32 0
  %49 = load i32, i32* %array-index65
  %array-index66 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 0
  %50 = load i32, i32* %array-index66
  %array-index67 = getelementptr [6 x i32], [6 x i32]* %second_int_array, i64 0, i32 0
  %51 = load i32, i32* %array-index67
  %array-index68 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 0
  %52 = load i32, i32* %array-index68
  %array-index69 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 0
  store i32 0, i32* %"$i$70"
  br label %condeval72

condeval72:                                       ; preds = %loop73, %postloop63
  %53 = load i32, i32* %"$i$70"
  %54 = icmp slt i32 %53, 6
  br i1 %54, label %loop73, label %postloop77

loop73:                                           ; preds = %condeval72
  %55 = load i32, i32* %"$i$70"
  %array-index74 = getelementptr [6 x i32], [6 x i32]* %"$tmp_arr$71", i64 0, i32 %55
  %56 = load i32, i32* %"$i$70"
  %array-index75 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 %56
  %57 = load i32, i32* %array-index75
  %58 = load i32, i32* %"$i$70"
  %array-index76 = getelementptr [6 x i32], [6 x i32]* %second_int_array, i64 0, i32 %58
  %59 = load i32, i32* %array-index76
  %60 = mul i32 %57, %59
  store i32 %60, i32* %array-index74
  %61 = load i32, i32* %"$i$70"
  %62 = add i32 %61, 1
  store i32 %62, i32* %"$i$70"
  br label %condeval72

postloop77:                                       ; preds = %condeval72
  %63 = load [6 x i32], [6 x i32]* %"$tmp_arr$71"
  store [6 x i32] %63, [6 x i32]* %first_int_array
  %array-index78 = getelementptr [6 x double], [6 x double]* %first_float_array, i64 0, i32 0
  %64 = load double, double* %array-index78
  %array-index79 = getelementptr [6 x double], [6 x double]* %second_float_array, i64 0, i32 0
  %65 = load double, double* %array-index79
  %array-index80 = getelementptr [6 x double], [6 x double]* %first_float_array, i64 0, i32 0
  %66 = load double, double* %array-index80
  %array-index81 = getelementptr [6 x double], [6 x double]* %second_float_array, i64 0, i32 0
  %67 = load double, double* %array-index81
  %array-index82 = getelementptr [6 x double], [6 x double]* %first_float_array, i64 0, i32 0
  %68 = load double, double* %array-index82
  %array-index83 = getelementptr [6 x double], [6 x double]* %first_float_array, i64 0, i32 0
  store i32 0, i32* %"$i$84"
  br label %condeval86

condeval86:                                       ; preds = %loop87, %postloop77
  %69 = load i32, i32* %"$i$84"
  %70 = icmp slt i32 %69, 6
  br i1 %70, label %loop87, label %postloop91

loop87:                                           ; preds = %condeval86
  %71 = load i32, i32* %"$i$84"
  %array-index88 = getelementptr [6 x double], [6 x double]* %"$tmp_arr$85", i64 0, i32 %71
  %72 = load i32, i32* %"$i$84"
  %array-index89 = getelementptr [6 x double], [6 x double]* %first_float_array, i64 0, i32 %72
  %73 = load double, double* %array-index89
  %74 = load i32, i32* %"$i$84"
  %array-index90 = getelementptr [6 x double], [6 x double]* %second_float_array, i64 0, i32 %74
  %75 = load double, double* %array-index90
  %76 = fmul double %73, %75
  store double %76, double* %array-index88
  %77 = load i32, i32* %"$i$84"
  %78 = add i32 %77, 1
  store i32 %78, i32* %"$i$84"
  br label %condeval86

postloop91:                                       ; preds = %condeval86
  %79 = load [6 x double], [6 x double]* %"$tmp_arr$85"
  store [6 x double] %79, [6 x double]* %first_float_array
  %array-index92 = getelementptr [6 x double], [6 x double]* %first_float_array, i64 0, i32 0
  %80 = load double, double* %array-index92
  %array-index93 = getelementptr [6 x double], [6 x double]* %second_float_array, i64 0, i32 0
  %81 = load double, double* %array-index93
  %array-index94 = getelementptr [6 x double], [6 x double]* %first_float_array, i64 0, i32 0
  %82 = load double, double* %array-index94
  %array-index95 = getelementptr [6 x double], [6 x double]* %second_float_array, i64 0, i32 0
  %83 = load double, double* %array-index95
  %array-index96 = getelementptr [6 x double], [6 x double]* %first_float_array, i64 0, i32 0
  %84 = load double, double* %array-index96
  %array-index97 = getelementptr [6 x double], [6 x double]* %first_float_array, i64 0, i32 0
  store i32 0, i32* %"$i$98"
  br label %condeval100

condeval100:                                      ; preds = %loop101, %postloop91
  %85 = load i32, i32* %"$i$98"
  %86 = icmp slt i32 %85, 6
  br i1 %86, label %loop101, label %postloop105

loop101:                                          ; preds = %condeval100
  %87 = load i32, i32* %"$i$98"
  %array-index102 = getelementptr [6 x double], [6 x double]* %"$tmp_arr$99", i64 0, i32 %87
  %88 = load i32, i32* %"$i$98"
  %array-index103 = getelementptr [6 x double], [6 x double]* %first_float_array, i64 0, i32 %88
  %89 = load double, double* %array-index103
  %90 = load i32, i32* %"$i$98"
  %array-index104 = getelementptr [6 x double], [6 x double]* %second_float_array, i64 0, i32 %90
  %91 = load double, double* %array-index104
  %92 = fmul double %89, %91
  store double %92, double* %array-index102
  %93 = load i32, i32* %"$i$98"
  %94 = add i32 %93, 1
  store i32 %94, i32* %"$i$98"
  br label %condeval100

postloop105:                                      ; preds = %condeval100
  %95 = load [6 x double], [6 x double]* %"$tmp_arr$99"
  store [6 x double] %95, [6 x double]* %first_float_array
  store i32 0, i32* %i
  call void @putString(i8* getelementptr inbounds ([56 x i8], [56 x i8]* @12, i32 0, i32 0))
  br label %condeval106

condeval106:                                      ; preds = %loop108, %postloop105
  %i107 = load i32, i32* %i
  %96 = icmp slt i32 %i107, 6
  br i1 %96, label %loop108, label %postloop118

loop108:                                          ; preds = %condeval106
  %i109 = load i32, i32* %i
  %array-index110 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 %i109
  %97 = load i32, i32* %array-index110
  call void @putInteger(i32 %97)
  %i111 = load i32, i32* %i
  %array-index112 = getelementptr [6 x i32], [6 x i32]* %second_int_array, i64 0, i32 %i111
  %98 = load i32, i32* %array-index112
  call void @putInteger(i32 %98)
  %i113 = load i32, i32* %i
  %array-index114 = getelementptr [6 x double], [6 x double]* %first_float_array, i64 0, i32 %i113
  %99 = load double, double* %array-index114
  call void @putFloat(double %99)
  %i115 = load i32, i32* %i
  %array-index116 = getelementptr [6 x double], [6 x double]* %second_float_array, i64 0, i32 %i115
  %100 = load double, double* %array-index116
  call void @putFloat(double %100)
  %i117 = load i32, i32* %i
  %101 = add i32 %i117, 1
  store i32 %101, i32* %i
  br label %condeval106

postloop118:                                      ; preds = %condeval106
  store i32 0, i32* %i
  call void @putString(i8* getelementptr inbounds ([53 x i8], [53 x i8]* @13, i32 0, i32 0))
  br label %condeval119

condeval119:                                      ; preds = %loop121, %postloop118
  %i120 = load i32, i32* %i
  %102 = icmp slt i32 %i120, 6
  br i1 %102, label %loop121, label %postloop125

loop121:                                          ; preds = %condeval119
  %i122 = load i32, i32* %i
  %array-index123 = getelementptr [6 x double], [6 x double]* %final_float_array, i64 0, i32 %i122
  %103 = load double, double* %array-index123
  call void @putFloat(double %103)
  %i124 = load i32, i32* %i
  %104 = add i32 %i124, 1
  store i32 %104, i32* %i
  br label %condeval119

postloop125:                                      ; preds = %condeval119
  ret i32 0
}
