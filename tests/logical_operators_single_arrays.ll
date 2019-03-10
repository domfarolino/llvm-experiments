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
  %"$tmp_arr$58" = alloca [6 x i1]
  %"$i$57" = alloca i32
  %"$tmp_arr$49" = alloca [6 x i32]
  %"$i$48" = alloca i32
  %i36 = alloca i32
  %"$tmp_arr$16" = alloca [6 x i1]
  %"$i$15" = alloca i32
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
  %array-index7 = getelementptr [6 x i32], [6 x i32]* %result_int_array, i64 0, i32 0
  %3 = load i32, i32* %array-index7
  store i32 0, i32* %"$i$"
  br label %condeval8

condeval8:                                        ; preds = %loop9, %postloop
  %4 = load i32, i32* %"$i$"
  %5 = icmp slt i32 %4, 6
  br i1 %5, label %loop9, label %postloop12

loop9:                                            ; preds = %condeval8
  %6 = load i32, i32* %"$i$"
  %array-index10 = getelementptr [6 x i32], [6 x i32]* %"$tmp_arr$", i64 0, i32 %6
  %7 = load i32, i32* %"$i$"
  %array-index11 = getelementptr [6 x i32], [6 x i32]* %result_int_array, i64 0, i32 %7
  %8 = load i32, i32* %array-index11
  %9 = and i32 2, %8
  store i32 %9, i32* %array-index10
  %10 = load i32, i32* %"$i$"
  %11 = add i32 %10, 1
  store i32 %11, i32* %"$i$"
  br label %condeval8

postloop12:                                       ; preds = %condeval8
  %12 = load [6 x i32], [6 x i32]* %"$tmp_arr$"
  store [6 x i32] %12, [6 x i32]* %result_int_array
  %array-index13 = getelementptr [6 x i1], [6 x i1]* %result_bool_array, i64 0, i32 0
  %array-index14 = getelementptr [6 x i1], [6 x i1]* %result_bool_array, i64 0, i32 0
  %13 = load i1, i1* %array-index14
  store i32 0, i32* %"$i$15"
  br label %condeval17

condeval17:                                       ; preds = %loop18, %postloop12
  %14 = load i32, i32* %"$i$15"
  %15 = icmp slt i32 %14, 6
  br i1 %15, label %loop18, label %postloop21

loop18:                                           ; preds = %condeval17
  %16 = load i32, i32* %"$i$15"
  %array-index19 = getelementptr [6 x i1], [6 x i1]* %"$tmp_arr$16", i64 0, i32 %16
  %17 = load i32, i32* %"$i$15"
  %array-index20 = getelementptr [6 x i1], [6 x i1]* %result_bool_array, i64 0, i32 %17
  %18 = load i1, i1* %array-index20
  %19 = and i1 false, %18
  store i1 %19, i1* %array-index19
  %20 = load i32, i32* %"$i$15"
  %21 = add i32 %20, 1
  store i32 %21, i32* %"$i$15"
  br label %condeval17

postloop21:                                       ; preds = %condeval17
  %22 = load [6 x i1], [6 x i1]* %"$tmp_arr$16"
  store [6 x i1] %22, [6 x i1]* %result_bool_array
  store i32 0, i32* %i
  call void @putString(i8* getelementptr inbounds ([54 x i8], [54 x i8]* @10, i32 0, i32 0))
  br label %condeval22

condeval22:                                       ; preds = %loop24, %postloop21
  %i23 = load i32, i32* %i
  %23 = icmp slt i32 %i23, 6
  br i1 %23, label %loop24, label %postloop28

loop24:                                           ; preds = %condeval22
  %i25 = load i32, i32* %i
  %array-index26 = getelementptr [6 x i32], [6 x i32]* %result_int_array, i64 0, i32 %i25
  %24 = load i32, i32* %array-index26
  call void @putInteger(i32 %24)
  %i27 = load i32, i32* %i
  %25 = add i32 %i27, 1
  store i32 %25, i32* %i
  br label %condeval22

postloop28:                                       ; preds = %condeval22
  store i32 0, i32* %i
  call void @putString(i8* getelementptr inbounds ([55 x i8], [55 x i8]* @11, i32 0, i32 0))
  br label %condeval29

condeval29:                                       ; preds = %loop31, %postloop28
  %i30 = load i32, i32* %i
  %26 = icmp slt i32 %i30, 6
  br i1 %26, label %loop31, label %postloop35

loop31:                                           ; preds = %condeval29
  %i32 = load i32, i32* %i
  %array-index33 = getelementptr [6 x i1], [6 x i1]* %result_bool_array, i64 0, i32 %i32
  %27 = load i1, i1* %array-index33
  call void @putBool(i1 %27)
  %i34 = load i32, i32* %i
  %28 = add i32 %i34, 1
  store i32 %28, i32* %i
  br label %condeval29

postloop35:                                       ; preds = %condeval29
  store i32 0, i32* %i36
  br label %condeval37

condeval37:                                       ; preds = %loop39, %postloop35
  %i38 = load i32, i32* %i36
  %29 = icmp slt i32 %i38, 6
  br i1 %29, label %loop39, label %postloop45

loop39:                                           ; preds = %condeval37
  %i40 = load i32, i32* %i36
  %array-index41 = getelementptr [6 x i32], [6 x i32]* %result_int_array, i64 0, i32 %i40
  %30 = load i32, i32* %i36
  store i32 %30, i32* %array-index41
  %i42 = load i32, i32* %i36
  %array-index43 = getelementptr [6 x i1], [6 x i1]* %result_bool_array, i64 0, i32 %i42
  store i1 true, i1* %array-index43
  %i44 = load i32, i32* %i36
  %31 = add i32 %i44, 1
  store i32 %31, i32* %i36
  br label %condeval37

postloop45:                                       ; preds = %condeval37
  %array-index46 = getelementptr [6 x i32], [6 x i32]* %result_int_array, i64 0, i32 0
  %array-index47 = getelementptr [6 x i32], [6 x i32]* %result_int_array, i64 0, i32 0
  %32 = load i32, i32* %array-index47
  store i32 0, i32* %"$i$48"
  br label %condeval50

condeval50:                                       ; preds = %loop51, %postloop45
  %33 = load i32, i32* %"$i$48"
  %34 = icmp slt i32 %33, 6
  br i1 %34, label %loop51, label %postloop54

loop51:                                           ; preds = %condeval50
  %35 = load i32, i32* %"$i$48"
  %array-index52 = getelementptr [6 x i32], [6 x i32]* %"$tmp_arr$49", i64 0, i32 %35
  %36 = load i32, i32* %"$i$48"
  %array-index53 = getelementptr [6 x i32], [6 x i32]* %result_int_array, i64 0, i32 %36
  %37 = load i32, i32* %array-index53
  %38 = or i32 2, %37
  store i32 %38, i32* %array-index52
  %39 = load i32, i32* %"$i$48"
  %40 = add i32 %39, 1
  store i32 %40, i32* %"$i$48"
  br label %condeval50

postloop54:                                       ; preds = %condeval50
  %41 = load [6 x i32], [6 x i32]* %"$tmp_arr$49"
  store [6 x i32] %41, [6 x i32]* %result_int_array
  %array-index55 = getelementptr [6 x i1], [6 x i1]* %result_bool_array, i64 0, i32 0
  %array-index56 = getelementptr [6 x i1], [6 x i1]* %result_bool_array, i64 0, i32 0
  %42 = load i1, i1* %array-index56
  store i32 0, i32* %"$i$57"
  br label %condeval59

condeval59:                                       ; preds = %loop60, %postloop54
  %43 = load i32, i32* %"$i$57"
  %44 = icmp slt i32 %43, 6
  br i1 %44, label %loop60, label %postloop63

loop60:                                           ; preds = %condeval59
  %45 = load i32, i32* %"$i$57"
  %array-index61 = getelementptr [6 x i1], [6 x i1]* %"$tmp_arr$58", i64 0, i32 %45
  %46 = load i32, i32* %"$i$57"
  %array-index62 = getelementptr [6 x i1], [6 x i1]* %result_bool_array, i64 0, i32 %46
  %47 = load i1, i1* %array-index62
  %48 = or i1 false, %47
  store i1 %48, i1* %array-index61
  %49 = load i32, i32* %"$i$57"
  %50 = add i32 %49, 1
  store i32 %50, i32* %"$i$57"
  br label %condeval59

postloop63:                                       ; preds = %condeval59
  %51 = load [6 x i1], [6 x i1]* %"$tmp_arr$58"
  store [6 x i1] %51, [6 x i1]* %result_bool_array
  store i32 0, i32* %i36
  call void @putString(i8* getelementptr inbounds ([53 x i8], [53 x i8]* @12, i32 0, i32 0))
  br label %condeval64

condeval64:                                       ; preds = %loop66, %postloop63
  %i65 = load i32, i32* %i36
  %52 = icmp slt i32 %i65, 6
  br i1 %52, label %loop66, label %postloop70

loop66:                                           ; preds = %condeval64
  %i67 = load i32, i32* %i36
  %array-index68 = getelementptr [6 x i32], [6 x i32]* %result_int_array, i64 0, i32 %i67
  %53 = load i32, i32* %array-index68
  call void @putInteger(i32 %53)
  %i69 = load i32, i32* %i36
  %54 = add i32 %i69, 1
  store i32 %54, i32* %i36
  br label %condeval64

postloop70:                                       ; preds = %condeval64
  store i32 0, i32* %i36
  call void @putString(i8* getelementptr inbounds ([54 x i8], [54 x i8]* @13, i32 0, i32 0))
  br label %condeval71

condeval71:                                       ; preds = %loop73, %postloop70
  %i72 = load i32, i32* %i36
  %55 = icmp slt i32 %i72, 6
  br i1 %55, label %loop73, label %postloop77

loop73:                                           ; preds = %condeval71
  %i74 = load i32, i32* %i36
  %array-index75 = getelementptr [6 x i1], [6 x i1]* %result_bool_array, i64 0, i32 %i74
  %56 = load i1, i1* %array-index75
  call void @putBool(i1 %56)
  %i76 = load i32, i32* %i36
  %57 = add i32 %i76, 1
  store i32 %57, i32* %i36
  br label %condeval71

postloop77:                                       ; preds = %condeval71
  ret i32 0
}
