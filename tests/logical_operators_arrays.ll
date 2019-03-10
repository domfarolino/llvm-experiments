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
  %"$tmp_arr$84" = alloca [6 x i1]
  %"$i$83" = alloca i32
  %"$tmp_arr$70" = alloca [6 x i32]
  %"$i$69" = alloca i32
  %"$tmp_arr$29" = alloca [6 x i1]
  %"$i$28" = alloca i32
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
  %3 = load i32, i32* %array-index10
  %array-index11 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 0
  %array-index12 = getelementptr [6 x i32], [6 x i32]* %second_int_array, i64 0, i32 0
  %4 = load i32, i32* %array-index12
  %array-index13 = getelementptr [6 x i32], [6 x i32]* %second_int_array, i64 0, i32 0
  %array-index14 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 0
  %5 = load i32, i32* %array-index14
  %array-index15 = getelementptr [6 x i32], [6 x i32]* %second_int_array, i64 0, i32 0
  %6 = load i32, i32* %array-index15
  store i32 0, i32* %"$i$"
  br label %condeval16

condeval16:                                       ; preds = %loop17, %postloop
  %7 = load i32, i32* %"$i$"
  %8 = icmp slt i32 %7, 6
  br i1 %8, label %loop17, label %postloop21

loop17:                                           ; preds = %condeval16
  %9 = load i32, i32* %"$i$"
  %array-index18 = getelementptr [6 x i32], [6 x i32]* %"$tmp_arr$", i64 0, i32 %9
  %10 = load i32, i32* %"$i$"
  %array-index19 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 %10
  %11 = load i32, i32* %array-index19
  %12 = load i32, i32* %"$i$"
  %array-index20 = getelementptr [6 x i32], [6 x i32]* %second_int_array, i64 0, i32 %12
  %13 = load i32, i32* %array-index20
  %14 = and i32 %11, %13
  store i32 %14, i32* %array-index18
  %15 = load i32, i32* %"$i$"
  %16 = add i32 %15, 1
  store i32 %16, i32* %"$i$"
  br label %condeval16

postloop21:                                       ; preds = %condeval16
  %17 = load [6 x i32], [6 x i32]* %"$tmp_arr$"
  store [6 x i32] %17, [6 x i32]* %result_int_array
  %array-index22 = getelementptr [6 x i1], [6 x i1]* %first_bool_array, i64 0, i32 0
  %18 = load i1, i1* %array-index22
  %array-index23 = getelementptr [6 x i1], [6 x i1]* %first_bool_array, i64 0, i32 0
  %array-index24 = getelementptr [6 x i1], [6 x i1]* %second_bool_array, i64 0, i32 0
  %19 = load i1, i1* %array-index24
  %array-index25 = getelementptr [6 x i1], [6 x i1]* %second_bool_array, i64 0, i32 0
  %array-index26 = getelementptr [6 x i1], [6 x i1]* %first_bool_array, i64 0, i32 0
  %20 = load i1, i1* %array-index26
  %array-index27 = getelementptr [6 x i1], [6 x i1]* %second_bool_array, i64 0, i32 0
  %21 = load i1, i1* %array-index27
  store i32 0, i32* %"$i$28"
  br label %condeval30

condeval30:                                       ; preds = %loop31, %postloop21
  %22 = load i32, i32* %"$i$28"
  %23 = icmp slt i32 %22, 6
  br i1 %23, label %loop31, label %postloop35

loop31:                                           ; preds = %condeval30
  %24 = load i32, i32* %"$i$28"
  %array-index32 = getelementptr [6 x i1], [6 x i1]* %"$tmp_arr$29", i64 0, i32 %24
  %25 = load i32, i32* %"$i$28"
  %array-index33 = getelementptr [6 x i1], [6 x i1]* %first_bool_array, i64 0, i32 %25
  %26 = load i1, i1* %array-index33
  %27 = load i32, i32* %"$i$28"
  %array-index34 = getelementptr [6 x i1], [6 x i1]* %second_bool_array, i64 0, i32 %27
  %28 = load i1, i1* %array-index34
  %29 = and i1 %26, %28
  store i1 %29, i1* %array-index32
  %30 = load i32, i32* %"$i$28"
  %31 = add i32 %30, 1
  store i32 %31, i32* %"$i$28"
  br label %condeval30

postloop35:                                       ; preds = %condeval30
  %32 = load [6 x i1], [6 x i1]* %"$tmp_arr$29"
  store [6 x i1] %32, [6 x i1]* %result_bool_array
  store i32 0, i32* %i
  call void @putString(i8* getelementptr inbounds ([49 x i8], [49 x i8]* @10, i32 0, i32 0))
  br label %condeval36

condeval36:                                       ; preds = %loop38, %postloop35
  %i37 = load i32, i32* %i
  %33 = icmp slt i32 %i37, 6
  br i1 %33, label %loop38, label %postloop42

loop38:                                           ; preds = %condeval36
  %i39 = load i32, i32* %i
  %array-index40 = getelementptr [6 x i32], [6 x i32]* %result_int_array, i64 0, i32 %i39
  %34 = load i32, i32* %array-index40
  call void @putInteger(i32 %34)
  %i41 = load i32, i32* %i
  %35 = add i32 %i41, 1
  store i32 %35, i32* %i
  br label %condeval36

postloop42:                                       ; preds = %condeval36
  store i32 0, i32* %i
  call void @putString(i8* getelementptr inbounds ([50 x i8], [50 x i8]* @11, i32 0, i32 0))
  br label %condeval43

condeval43:                                       ; preds = %loop45, %postloop42
  %i44 = load i32, i32* %i
  %36 = icmp slt i32 %i44, 6
  br i1 %36, label %loop45, label %postloop49

loop45:                                           ; preds = %condeval43
  %i46 = load i32, i32* %i
  %array-index47 = getelementptr [6 x i1], [6 x i1]* %result_bool_array, i64 0, i32 %i46
  %37 = load i1, i1* %array-index47
  call void @putBool(i1 %37)
  %i48 = load i32, i32* %i
  %38 = add i32 %i48, 1
  store i32 %38, i32* %i
  br label %condeval43

postloop49:                                       ; preds = %condeval43
  br label %condeval50

condeval50:                                       ; preds = %loop52, %postloop49
  %i51 = load i32, i32* %i
  %39 = icmp slt i32 %i51, 6
  br i1 %39, label %loop52, label %postloop62

loop52:                                           ; preds = %condeval50
  %i53 = load i32, i32* %i
  %array-index54 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 %i53
  %40 = load i32, i32* %i
  store i32 %40, i32* %array-index54
  %i55 = load i32, i32* %i
  %array-index56 = getelementptr [6 x i32], [6 x i32]* %second_int_array, i64 0, i32 %i55
  store i32 2, i32* %array-index56
  %i57 = load i32, i32* %i
  %array-index58 = getelementptr [6 x i1], [6 x i1]* %first_bool_array, i64 0, i32 %i57
  store i1 true, i1* %array-index58
  %i59 = load i32, i32* %i
  %array-index60 = getelementptr [6 x i1], [6 x i1]* %second_bool_array, i64 0, i32 %i59
  store i1 false, i1* %array-index60
  %i61 = load i32, i32* %i
  %41 = add i32 %i61, 1
  store i32 %41, i32* %i
  br label %condeval50

postloop62:                                       ; preds = %condeval50
  %array-index63 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 0
  %42 = load i32, i32* %array-index63
  %array-index64 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 0
  %array-index65 = getelementptr [6 x i32], [6 x i32]* %second_int_array, i64 0, i32 0
  %43 = load i32, i32* %array-index65
  %array-index66 = getelementptr [6 x i32], [6 x i32]* %second_int_array, i64 0, i32 0
  %array-index67 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 0
  %44 = load i32, i32* %array-index67
  %array-index68 = getelementptr [6 x i32], [6 x i32]* %second_int_array, i64 0, i32 0
  %45 = load i32, i32* %array-index68
  store i32 0, i32* %"$i$69"
  br label %condeval71

condeval71:                                       ; preds = %loop72, %postloop62
  %46 = load i32, i32* %"$i$69"
  %47 = icmp slt i32 %46, 6
  br i1 %47, label %loop72, label %postloop76

loop72:                                           ; preds = %condeval71
  %48 = load i32, i32* %"$i$69"
  %array-index73 = getelementptr [6 x i32], [6 x i32]* %"$tmp_arr$70", i64 0, i32 %48
  %49 = load i32, i32* %"$i$69"
  %array-index74 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 %49
  %50 = load i32, i32* %array-index74
  %51 = load i32, i32* %"$i$69"
  %array-index75 = getelementptr [6 x i32], [6 x i32]* %second_int_array, i64 0, i32 %51
  %52 = load i32, i32* %array-index75
  %53 = or i32 %50, %52
  store i32 %53, i32* %array-index73
  %54 = load i32, i32* %"$i$69"
  %55 = add i32 %54, 1
  store i32 %55, i32* %"$i$69"
  br label %condeval71

postloop76:                                       ; preds = %condeval71
  %56 = load [6 x i32], [6 x i32]* %"$tmp_arr$70"
  store [6 x i32] %56, [6 x i32]* %result_int_array
  %array-index77 = getelementptr [6 x i1], [6 x i1]* %first_bool_array, i64 0, i32 0
  %57 = load i1, i1* %array-index77
  %array-index78 = getelementptr [6 x i1], [6 x i1]* %first_bool_array, i64 0, i32 0
  %array-index79 = getelementptr [6 x i1], [6 x i1]* %result_bool_array, i64 0, i32 0
  %58 = load i1, i1* %array-index79
  %array-index80 = getelementptr [6 x i1], [6 x i1]* %result_bool_array, i64 0, i32 0
  %array-index81 = getelementptr [6 x i1], [6 x i1]* %first_bool_array, i64 0, i32 0
  %59 = load i1, i1* %array-index81
  %array-index82 = getelementptr [6 x i1], [6 x i1]* %result_bool_array, i64 0, i32 0
  %60 = load i1, i1* %array-index82
  store i32 0, i32* %"$i$83"
  br label %condeval85

condeval85:                                       ; preds = %loop86, %postloop76
  %61 = load i32, i32* %"$i$83"
  %62 = icmp slt i32 %61, 6
  br i1 %62, label %loop86, label %postloop90

loop86:                                           ; preds = %condeval85
  %63 = load i32, i32* %"$i$83"
  %array-index87 = getelementptr [6 x i1], [6 x i1]* %"$tmp_arr$84", i64 0, i32 %63
  %64 = load i32, i32* %"$i$83"
  %array-index88 = getelementptr [6 x i1], [6 x i1]* %first_bool_array, i64 0, i32 %64
  %65 = load i1, i1* %array-index88
  %66 = load i32, i32* %"$i$83"
  %array-index89 = getelementptr [6 x i1], [6 x i1]* %result_bool_array, i64 0, i32 %66
  %67 = load i1, i1* %array-index89
  %68 = or i1 %65, %67
  store i1 %68, i1* %array-index87
  %69 = load i32, i32* %"$i$83"
  %70 = add i32 %69, 1
  store i32 %70, i32* %"$i$83"
  br label %condeval85

postloop90:                                       ; preds = %condeval85
  %71 = load [6 x i1], [6 x i1]* %"$tmp_arr$84"
  store [6 x i1] %71, [6 x i1]* %result_bool_array
  store i32 0, i32* %i
  call void @putString(i8* getelementptr inbounds ([48 x i8], [48 x i8]* @12, i32 0, i32 0))
  br label %condeval91

condeval91:                                       ; preds = %loop93, %postloop90
  %i92 = load i32, i32* %i
  %72 = icmp slt i32 %i92, 6
  br i1 %72, label %loop93, label %postloop97

loop93:                                           ; preds = %condeval91
  %i94 = load i32, i32* %i
  %array-index95 = getelementptr [6 x i32], [6 x i32]* %result_int_array, i64 0, i32 %i94
  %73 = load i32, i32* %array-index95
  call void @putInteger(i32 %73)
  %i96 = load i32, i32* %i
  %74 = add i32 %i96, 1
  store i32 %74, i32* %i
  br label %condeval91

postloop97:                                       ; preds = %condeval91
  store i32 0, i32* %i
  call void @putString(i8* getelementptr inbounds ([49 x i8], [49 x i8]* @13, i32 0, i32 0))
  br label %condeval98

condeval98:                                       ; preds = %loop100, %postloop97
  %i99 = load i32, i32* %i
  %75 = icmp slt i32 %i99, 6
  br i1 %75, label %loop100, label %postloop104

loop100:                                          ; preds = %condeval98
  %i101 = load i32, i32* %i
  %array-index102 = getelementptr [6 x i1], [6 x i1]* %result_bool_array, i64 0, i32 %i101
  %76 = load i1, i1* %array-index102
  call void @putBool(i1 %76)
  %i103 = load i32, i32* %i
  %77 = add i32 %i103, 1
  store i32 %77, i32* %i
  br label %condeval98

postloop104:                                      ; preds = %condeval98
  ret i32 0
}
