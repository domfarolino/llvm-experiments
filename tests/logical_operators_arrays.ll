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
  %"$tmp_arr$64" = alloca [6 x i1]
  %"$i$63" = alloca i32
  %"$tmp_arr$55" = alloca [6 x i32]
  %"$i$54" = alloca i32
  %"$tmp_arr$19" = alloca [6 x i1]
  %"$i$18" = alloca i32
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
  store i32 0, i32* %"$i$"
  br label %condeval11

condeval11:                                       ; preds = %loop12, %postloop
  %3 = load i32, i32* %"$i$"
  %4 = icmp slt i32 %3, 6
  br i1 %4, label %loop12, label %postloop16

loop12:                                           ; preds = %condeval11
  %5 = load i32, i32* %"$i$"
  %array-index13 = getelementptr [6 x i32], [6 x i32]* %"$tmp_arr$", i64 0, i32 %5
  %6 = load i32, i32* %"$i$"
  %array-index14 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 %6
  %7 = load i32, i32* %array-index14
  %8 = load i32, i32* %"$i$"
  %array-index15 = getelementptr [6 x i32], [6 x i32]* %second_int_array, i64 0, i32 %8
  %9 = load i32, i32* %array-index15
  %10 = and i32 %7, %9
  store i32 %10, i32* %array-index13
  %11 = load i32, i32* %"$i$"
  %12 = add i32 %11, 1
  store i32 %12, i32* %"$i$"
  br label %condeval11

postloop16:                                       ; preds = %condeval11
  %13 = load [6 x i32], [6 x i32]* %"$tmp_arr$"
  store [6 x i32] %13, [6 x i32]* %result_int_array
  %array-index17 = getelementptr [6 x i1], [6 x i1]* %first_bool_array, i64 0, i32 0
  store i32 0, i32* %"$i$18"
  br label %condeval20

condeval20:                                       ; preds = %loop21, %postloop16
  %14 = load i32, i32* %"$i$18"
  %15 = icmp slt i32 %14, 6
  br i1 %15, label %loop21, label %postloop25

loop21:                                           ; preds = %condeval20
  %16 = load i32, i32* %"$i$18"
  %array-index22 = getelementptr [6 x i1], [6 x i1]* %"$tmp_arr$19", i64 0, i32 %16
  %17 = load i32, i32* %"$i$18"
  %array-index23 = getelementptr [6 x i1], [6 x i1]* %first_bool_array, i64 0, i32 %17
  %18 = load i1, i1* %array-index23
  %19 = load i32, i32* %"$i$18"
  %array-index24 = getelementptr [6 x i1], [6 x i1]* %second_bool_array, i64 0, i32 %19
  %20 = load i1, i1* %array-index24
  %21 = and i1 %18, %20
  store i1 %21, i1* %array-index22
  %22 = load i32, i32* %"$i$18"
  %23 = add i32 %22, 1
  store i32 %23, i32* %"$i$18"
  br label %condeval20

postloop25:                                       ; preds = %condeval20
  %24 = load [6 x i1], [6 x i1]* %"$tmp_arr$19"
  store [6 x i1] %24, [6 x i1]* %result_bool_array
  store i32 0, i32* %i
  call void @putString(i8* getelementptr inbounds ([49 x i8], [49 x i8]* @10, i32 0, i32 0))
  br label %condeval26

condeval26:                                       ; preds = %loop28, %postloop25
  %i27 = load i32, i32* %i
  %25 = icmp slt i32 %i27, 6
  br i1 %25, label %loop28, label %postloop32

loop28:                                           ; preds = %condeval26
  %i29 = load i32, i32* %i
  %array-index30 = getelementptr [6 x i32], [6 x i32]* %result_int_array, i64 0, i32 %i29
  %26 = load i32, i32* %array-index30
  call void @putInteger(i32 %26)
  %i31 = load i32, i32* %i
  %27 = add i32 %i31, 1
  store i32 %27, i32* %i
  br label %condeval26

postloop32:                                       ; preds = %condeval26
  store i32 0, i32* %i
  call void @putString(i8* getelementptr inbounds ([50 x i8], [50 x i8]* @11, i32 0, i32 0))
  br label %condeval33

condeval33:                                       ; preds = %loop35, %postloop32
  %i34 = load i32, i32* %i
  %28 = icmp slt i32 %i34, 6
  br i1 %28, label %loop35, label %postloop39

loop35:                                           ; preds = %condeval33
  %i36 = load i32, i32* %i
  %array-index37 = getelementptr [6 x i1], [6 x i1]* %result_bool_array, i64 0, i32 %i36
  %29 = load i1, i1* %array-index37
  call void @putBool(i1 %29)
  %i38 = load i32, i32* %i
  %30 = add i32 %i38, 1
  store i32 %30, i32* %i
  br label %condeval33

postloop39:                                       ; preds = %condeval33
  br label %condeval40

condeval40:                                       ; preds = %loop42, %postloop39
  %i41 = load i32, i32* %i
  %31 = icmp slt i32 %i41, 6
  br i1 %31, label %loop42, label %postloop52

loop42:                                           ; preds = %condeval40
  %i43 = load i32, i32* %i
  %array-index44 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 %i43
  %32 = load i32, i32* %i
  store i32 %32, i32* %array-index44
  %i45 = load i32, i32* %i
  %array-index46 = getelementptr [6 x i32], [6 x i32]* %second_int_array, i64 0, i32 %i45
  store i32 2, i32* %array-index46
  %i47 = load i32, i32* %i
  %array-index48 = getelementptr [6 x i1], [6 x i1]* %first_bool_array, i64 0, i32 %i47
  store i1 true, i1* %array-index48
  %i49 = load i32, i32* %i
  %array-index50 = getelementptr [6 x i1], [6 x i1]* %second_bool_array, i64 0, i32 %i49
  store i1 false, i1* %array-index50
  %i51 = load i32, i32* %i
  %33 = add i32 %i51, 1
  store i32 %33, i32* %i
  br label %condeval40

postloop52:                                       ; preds = %condeval40
  %array-index53 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 0
  store i32 0, i32* %"$i$54"
  br label %condeval56

condeval56:                                       ; preds = %loop57, %postloop52
  %34 = load i32, i32* %"$i$54"
  %35 = icmp slt i32 %34, 6
  br i1 %35, label %loop57, label %postloop61

loop57:                                           ; preds = %condeval56
  %36 = load i32, i32* %"$i$54"
  %array-index58 = getelementptr [6 x i32], [6 x i32]* %"$tmp_arr$55", i64 0, i32 %36
  %37 = load i32, i32* %"$i$54"
  %array-index59 = getelementptr [6 x i32], [6 x i32]* %first_int_array, i64 0, i32 %37
  %38 = load i32, i32* %array-index59
  %39 = load i32, i32* %"$i$54"
  %array-index60 = getelementptr [6 x i32], [6 x i32]* %second_int_array, i64 0, i32 %39
  %40 = load i32, i32* %array-index60
  %41 = or i32 %38, %40
  store i32 %41, i32* %array-index58
  %42 = load i32, i32* %"$i$54"
  %43 = add i32 %42, 1
  store i32 %43, i32* %"$i$54"
  br label %condeval56

postloop61:                                       ; preds = %condeval56
  %44 = load [6 x i32], [6 x i32]* %"$tmp_arr$55"
  store [6 x i32] %44, [6 x i32]* %result_int_array
  %array-index62 = getelementptr [6 x i1], [6 x i1]* %first_bool_array, i64 0, i32 0
  store i32 0, i32* %"$i$63"
  br label %condeval65

condeval65:                                       ; preds = %loop66, %postloop61
  %45 = load i32, i32* %"$i$63"
  %46 = icmp slt i32 %45, 6
  br i1 %46, label %loop66, label %postloop70

loop66:                                           ; preds = %condeval65
  %47 = load i32, i32* %"$i$63"
  %array-index67 = getelementptr [6 x i1], [6 x i1]* %"$tmp_arr$64", i64 0, i32 %47
  %48 = load i32, i32* %"$i$63"
  %array-index68 = getelementptr [6 x i1], [6 x i1]* %first_bool_array, i64 0, i32 %48
  %49 = load i1, i1* %array-index68
  %50 = load i32, i32* %"$i$63"
  %array-index69 = getelementptr [6 x i1], [6 x i1]* %result_bool_array, i64 0, i32 %50
  %51 = load i1, i1* %array-index69
  %52 = or i1 %49, %51
  store i1 %52, i1* %array-index67
  %53 = load i32, i32* %"$i$63"
  %54 = add i32 %53, 1
  store i32 %54, i32* %"$i$63"
  br label %condeval65

postloop70:                                       ; preds = %condeval65
  %55 = load [6 x i1], [6 x i1]* %"$tmp_arr$64"
  store [6 x i1] %55, [6 x i1]* %result_bool_array
  store i32 0, i32* %i
  call void @putString(i8* getelementptr inbounds ([48 x i8], [48 x i8]* @12, i32 0, i32 0))
  br label %condeval71

condeval71:                                       ; preds = %loop73, %postloop70
  %i72 = load i32, i32* %i
  %56 = icmp slt i32 %i72, 6
  br i1 %56, label %loop73, label %postloop77

loop73:                                           ; preds = %condeval71
  %i74 = load i32, i32* %i
  %array-index75 = getelementptr [6 x i32], [6 x i32]* %result_int_array, i64 0, i32 %i74
  %57 = load i32, i32* %array-index75
  call void @putInteger(i32 %57)
  %i76 = load i32, i32* %i
  %58 = add i32 %i76, 1
  store i32 %58, i32* %i
  br label %condeval71

postloop77:                                       ; preds = %condeval71
  store i32 0, i32* %i
  call void @putString(i8* getelementptr inbounds ([49 x i8], [49 x i8]* @13, i32 0, i32 0))
  br label %condeval78

condeval78:                                       ; preds = %loop80, %postloop77
  %i79 = load i32, i32* %i
  %59 = icmp slt i32 %i79, 6
  br i1 %59, label %loop80, label %postloop84

loop80:                                           ; preds = %condeval78
  %i81 = load i32, i32* %i
  %array-index82 = getelementptr [6 x i1], [6 x i1]* %result_bool_array, i64 0, i32 %i81
  %60 = load i1, i1* %array-index82
  call void @putBool(i1 %60)
  %i83 = load i32, i32* %i
  %61 = add i32 %i83, 1
  store i32 %61, i32* %i
  br label %condeval78

postloop84:                                       ; preds = %condeval78
  ret i32 0
}
