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
  %"$tmp_arr$62" = alloca [6 x i1]
  %"$i$61" = alloca i32
  %"$tmp_arr$52" = alloca [6 x i32]
  %"$i$51" = alloca i32
  %i38 = alloca i32
  %"$tmp_arr$18" = alloca [6 x i1]
  %"$i$17" = alloca i32
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
  %3 = load i32, i32* %array-index6
  %array-index7 = getelementptr [6 x i32], [6 x i32]* %result_int_array, i64 0, i32 0
  %array-index8 = getelementptr [6 x i32], [6 x i32]* %result_int_array, i64 0, i32 0
  %4 = load i32, i32* %array-index8
  store i32 0, i32* %"$i$"
  br label %condeval9

condeval9:                                        ; preds = %loop10, %postloop
  %5 = load i32, i32* %"$i$"
  %6 = icmp slt i32 %5, 6
  br i1 %6, label %loop10, label %postloop13

loop10:                                           ; preds = %condeval9
  %7 = load i32, i32* %"$i$"
  %array-index11 = getelementptr [6 x i32], [6 x i32]* %"$tmp_arr$", i64 0, i32 %7
  %8 = load i32, i32* %"$i$"
  %array-index12 = getelementptr [6 x i32], [6 x i32]* %result_int_array, i64 0, i32 %8
  %9 = load i32, i32* %array-index12
  %10 = and i32 2, %9
  store i32 %10, i32* %array-index11
  %11 = load i32, i32* %"$i$"
  %12 = add i32 %11, 1
  store i32 %12, i32* %"$i$"
  br label %condeval9

postloop13:                                       ; preds = %condeval9
  %13 = load [6 x i32], [6 x i32]* %"$tmp_arr$"
  store [6 x i32] %13, [6 x i32]* %result_int_array
  %array-index14 = getelementptr [6 x i1], [6 x i1]* %result_bool_array, i64 0, i32 0
  %14 = load i1, i1* %array-index14
  %array-index15 = getelementptr [6 x i1], [6 x i1]* %result_bool_array, i64 0, i32 0
  %array-index16 = getelementptr [6 x i1], [6 x i1]* %result_bool_array, i64 0, i32 0
  %15 = load i1, i1* %array-index16
  store i32 0, i32* %"$i$17"
  br label %condeval19

condeval19:                                       ; preds = %loop20, %postloop13
  %16 = load i32, i32* %"$i$17"
  %17 = icmp slt i32 %16, 6
  br i1 %17, label %loop20, label %postloop23

loop20:                                           ; preds = %condeval19
  %18 = load i32, i32* %"$i$17"
  %array-index21 = getelementptr [6 x i1], [6 x i1]* %"$tmp_arr$18", i64 0, i32 %18
  %19 = load i32, i32* %"$i$17"
  %array-index22 = getelementptr [6 x i1], [6 x i1]* %result_bool_array, i64 0, i32 %19
  %20 = load i1, i1* %array-index22
  %21 = and i1 false, %20
  store i1 %21, i1* %array-index21
  %22 = load i32, i32* %"$i$17"
  %23 = add i32 %22, 1
  store i32 %23, i32* %"$i$17"
  br label %condeval19

postloop23:                                       ; preds = %condeval19
  %24 = load [6 x i1], [6 x i1]* %"$tmp_arr$18"
  store [6 x i1] %24, [6 x i1]* %result_bool_array
  store i32 0, i32* %i
  call void @putString(i8* getelementptr inbounds ([54 x i8], [54 x i8]* @10, i32 0, i32 0))
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
  call void @putString(i8* getelementptr inbounds ([55 x i8], [55 x i8]* @11, i32 0, i32 0))
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
  store i32 0, i32* %i38
  br label %condeval39

condeval39:                                       ; preds = %loop41, %postloop37
  %i40 = load i32, i32* %i38
  %31 = icmp slt i32 %i40, 6
  br i1 %31, label %loop41, label %postloop47

loop41:                                           ; preds = %condeval39
  %i42 = load i32, i32* %i38
  %array-index43 = getelementptr [6 x i32], [6 x i32]* %result_int_array, i64 0, i32 %i42
  %32 = load i32, i32* %i38
  store i32 %32, i32* %array-index43
  %i44 = load i32, i32* %i38
  %array-index45 = getelementptr [6 x i1], [6 x i1]* %result_bool_array, i64 0, i32 %i44
  store i1 true, i1* %array-index45
  %i46 = load i32, i32* %i38
  %33 = add i32 %i46, 1
  store i32 %33, i32* %i38
  br label %condeval39

postloop47:                                       ; preds = %condeval39
  %array-index48 = getelementptr [6 x i32], [6 x i32]* %result_int_array, i64 0, i32 0
  %34 = load i32, i32* %array-index48
  %array-index49 = getelementptr [6 x i32], [6 x i32]* %result_int_array, i64 0, i32 0
  %array-index50 = getelementptr [6 x i32], [6 x i32]* %result_int_array, i64 0, i32 0
  %35 = load i32, i32* %array-index50
  store i32 0, i32* %"$i$51"
  br label %condeval53

condeval53:                                       ; preds = %loop54, %postloop47
  %36 = load i32, i32* %"$i$51"
  %37 = icmp slt i32 %36, 6
  br i1 %37, label %loop54, label %postloop57

loop54:                                           ; preds = %condeval53
  %38 = load i32, i32* %"$i$51"
  %array-index55 = getelementptr [6 x i32], [6 x i32]* %"$tmp_arr$52", i64 0, i32 %38
  %39 = load i32, i32* %"$i$51"
  %array-index56 = getelementptr [6 x i32], [6 x i32]* %result_int_array, i64 0, i32 %39
  %40 = load i32, i32* %array-index56
  %41 = or i32 2, %40
  store i32 %41, i32* %array-index55
  %42 = load i32, i32* %"$i$51"
  %43 = add i32 %42, 1
  store i32 %43, i32* %"$i$51"
  br label %condeval53

postloop57:                                       ; preds = %condeval53
  %44 = load [6 x i32], [6 x i32]* %"$tmp_arr$52"
  store [6 x i32] %44, [6 x i32]* %result_int_array
  %array-index58 = getelementptr [6 x i1], [6 x i1]* %result_bool_array, i64 0, i32 0
  %45 = load i1, i1* %array-index58
  %array-index59 = getelementptr [6 x i1], [6 x i1]* %result_bool_array, i64 0, i32 0
  %array-index60 = getelementptr [6 x i1], [6 x i1]* %result_bool_array, i64 0, i32 0
  %46 = load i1, i1* %array-index60
  store i32 0, i32* %"$i$61"
  br label %condeval63

condeval63:                                       ; preds = %loop64, %postloop57
  %47 = load i32, i32* %"$i$61"
  %48 = icmp slt i32 %47, 6
  br i1 %48, label %loop64, label %postloop67

loop64:                                           ; preds = %condeval63
  %49 = load i32, i32* %"$i$61"
  %array-index65 = getelementptr [6 x i1], [6 x i1]* %"$tmp_arr$62", i64 0, i32 %49
  %50 = load i32, i32* %"$i$61"
  %array-index66 = getelementptr [6 x i1], [6 x i1]* %result_bool_array, i64 0, i32 %50
  %51 = load i1, i1* %array-index66
  %52 = or i1 false, %51
  store i1 %52, i1* %array-index65
  %53 = load i32, i32* %"$i$61"
  %54 = add i32 %53, 1
  store i32 %54, i32* %"$i$61"
  br label %condeval63

postloop67:                                       ; preds = %condeval63
  %55 = load [6 x i1], [6 x i1]* %"$tmp_arr$62"
  store [6 x i1] %55, [6 x i1]* %result_bool_array
  store i32 0, i32* %i38
  call void @putString(i8* getelementptr inbounds ([53 x i8], [53 x i8]* @12, i32 0, i32 0))
  br label %condeval68

condeval68:                                       ; preds = %loop70, %postloop67
  %i69 = load i32, i32* %i38
  %56 = icmp slt i32 %i69, 6
  br i1 %56, label %loop70, label %postloop74

loop70:                                           ; preds = %condeval68
  %i71 = load i32, i32* %i38
  %array-index72 = getelementptr [6 x i32], [6 x i32]* %result_int_array, i64 0, i32 %i71
  %57 = load i32, i32* %array-index72
  call void @putInteger(i32 %57)
  %i73 = load i32, i32* %i38
  %58 = add i32 %i73, 1
  store i32 %58, i32* %i38
  br label %condeval68

postloop74:                                       ; preds = %condeval68
  store i32 0, i32* %i38
  call void @putString(i8* getelementptr inbounds ([54 x i8], [54 x i8]* @13, i32 0, i32 0))
  br label %condeval75

condeval75:                                       ; preds = %loop77, %postloop74
  %i76 = load i32, i32* %i38
  %59 = icmp slt i32 %i76, 6
  br i1 %59, label %loop77, label %postloop81

loop77:                                           ; preds = %condeval75
  %i78 = load i32, i32* %i38
  %array-index79 = getelementptr [6 x i1], [6 x i1]* %result_bool_array, i64 0, i32 %i78
  %60 = load i1, i1* %array-index79
  call void @putBool(i1 %60)
  %i80 = load i32, i32* %i38
  %61 = add i32 %i80, 1
  store i32 %61, i32* %i38
  br label %condeval75

postloop81:                                       ; preds = %condeval75
  ret i32 0
}
