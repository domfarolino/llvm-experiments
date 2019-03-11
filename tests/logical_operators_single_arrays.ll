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
  %"$tmp_arr$66" = alloca [6 x i1]
  %"$i$65" = alloca i32
  %"$tmp_arr$55" = alloca [6 x i32]
  %"$i$54" = alloca i32
  %i40 = alloca i32
  %"$tmp_arr$20" = alloca [6 x i1]
  %"$i$19" = alloca i32
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
  %4 = load i32, i32* %array-index7
  %array-index8 = getelementptr [6 x i32], [6 x i32]* %result_int_array, i64 0, i32 0
  %5 = load i32, i32* %array-index8
  %array-index9 = getelementptr [6 x i32], [6 x i32]* %result_int_array, i64 0, i32 0
  store i32 0, i32* %"$i$"
  br label %condeval10

condeval10:                                       ; preds = %loop11, %postloop
  %6 = load i32, i32* %"$i$"
  %7 = icmp slt i32 %6, 6
  br i1 %7, label %loop11, label %postloop14

loop11:                                           ; preds = %condeval10
  %8 = load i32, i32* %"$i$"
  %array-index12 = getelementptr [6 x i32], [6 x i32]* %"$tmp_arr$", i64 0, i32 %8
  %9 = load i32, i32* %"$i$"
  %array-index13 = getelementptr [6 x i32], [6 x i32]* %result_int_array, i64 0, i32 %9
  %10 = load i32, i32* %array-index13
  %11 = and i32 2, %10
  store i32 %11, i32* %array-index12
  %12 = load i32, i32* %"$i$"
  %13 = add i32 %12, 1
  store i32 %13, i32* %"$i$"
  br label %condeval10

postloop14:                                       ; preds = %condeval10
  %14 = load [6 x i32], [6 x i32]* %"$tmp_arr$"
  store [6 x i32] %14, [6 x i32]* %result_int_array
  %array-index15 = getelementptr [6 x i1], [6 x i1]* %result_bool_array, i64 0, i32 0
  %15 = load i1, i1* %array-index15
  %array-index16 = getelementptr [6 x i1], [6 x i1]* %result_bool_array, i64 0, i32 0
  %16 = load i1, i1* %array-index16
  %array-index17 = getelementptr [6 x i1], [6 x i1]* %result_bool_array, i64 0, i32 0
  %17 = load i1, i1* %array-index17
  %array-index18 = getelementptr [6 x i1], [6 x i1]* %result_bool_array, i64 0, i32 0
  store i32 0, i32* %"$i$19"
  br label %condeval21

condeval21:                                       ; preds = %loop22, %postloop14
  %18 = load i32, i32* %"$i$19"
  %19 = icmp slt i32 %18, 6
  br i1 %19, label %loop22, label %postloop25

loop22:                                           ; preds = %condeval21
  %20 = load i32, i32* %"$i$19"
  %array-index23 = getelementptr [6 x i1], [6 x i1]* %"$tmp_arr$20", i64 0, i32 %20
  %21 = load i32, i32* %"$i$19"
  %array-index24 = getelementptr [6 x i1], [6 x i1]* %result_bool_array, i64 0, i32 %21
  %22 = load i1, i1* %array-index24
  %23 = and i1 false, %22
  store i1 %23, i1* %array-index23
  %24 = load i32, i32* %"$i$19"
  %25 = add i32 %24, 1
  store i32 %25, i32* %"$i$19"
  br label %condeval21

postloop25:                                       ; preds = %condeval21
  %26 = load [6 x i1], [6 x i1]* %"$tmp_arr$20"
  store [6 x i1] %26, [6 x i1]* %result_bool_array
  store i32 0, i32* %i
  call void @putString(i8* getelementptr inbounds ([49 x i8], [49 x i8]* @10, i32 0, i32 0))
  br label %condeval26

condeval26:                                       ; preds = %loop28, %postloop25
  %i27 = load i32, i32* %i
  %27 = icmp slt i32 %i27, 6
  br i1 %27, label %loop28, label %postloop32

loop28:                                           ; preds = %condeval26
  %i29 = load i32, i32* %i
  %array-index30 = getelementptr [6 x i32], [6 x i32]* %result_int_array, i64 0, i32 %i29
  %28 = load i32, i32* %array-index30
  call void @putInteger(i32 %28)
  %i31 = load i32, i32* %i
  %29 = add i32 %i31, 1
  store i32 %29, i32* %i
  br label %condeval26

postloop32:                                       ; preds = %condeval26
  store i32 0, i32* %i
  call void @putString(i8* getelementptr inbounds ([50 x i8], [50 x i8]* @11, i32 0, i32 0))
  br label %condeval33

condeval33:                                       ; preds = %loop35, %postloop32
  %i34 = load i32, i32* %i
  %30 = icmp slt i32 %i34, 6
  br i1 %30, label %loop35, label %postloop39

loop35:                                           ; preds = %condeval33
  %i36 = load i32, i32* %i
  %array-index37 = getelementptr [6 x i1], [6 x i1]* %result_bool_array, i64 0, i32 %i36
  %31 = load i1, i1* %array-index37
  call void @putBool(i1 %31)
  %i38 = load i32, i32* %i
  %32 = add i32 %i38, 1
  store i32 %32, i32* %i
  br label %condeval33

postloop39:                                       ; preds = %condeval33
  store i32 0, i32* %i40
  br label %condeval41

condeval41:                                       ; preds = %loop43, %postloop39
  %i42 = load i32, i32* %i40
  %33 = icmp slt i32 %i42, 6
  br i1 %33, label %loop43, label %postloop49

loop43:                                           ; preds = %condeval41
  %i44 = load i32, i32* %i40
  %array-index45 = getelementptr [6 x i32], [6 x i32]* %result_int_array, i64 0, i32 %i44
  %34 = load i32, i32* %i40
  store i32 %34, i32* %array-index45
  %i46 = load i32, i32* %i40
  %array-index47 = getelementptr [6 x i1], [6 x i1]* %result_bool_array, i64 0, i32 %i46
  store i1 true, i1* %array-index47
  %i48 = load i32, i32* %i40
  %35 = add i32 %i48, 1
  store i32 %35, i32* %i40
  br label %condeval41

postloop49:                                       ; preds = %condeval41
  %array-index50 = getelementptr [6 x i32], [6 x i32]* %result_int_array, i64 0, i32 0
  %36 = load i32, i32* %array-index50
  %array-index51 = getelementptr [6 x i32], [6 x i32]* %result_int_array, i64 0, i32 0
  %37 = load i32, i32* %array-index51
  %array-index52 = getelementptr [6 x i32], [6 x i32]* %result_int_array, i64 0, i32 0
  %38 = load i32, i32* %array-index52
  %array-index53 = getelementptr [6 x i32], [6 x i32]* %result_int_array, i64 0, i32 0
  store i32 0, i32* %"$i$54"
  br label %condeval56

condeval56:                                       ; preds = %loop57, %postloop49
  %39 = load i32, i32* %"$i$54"
  %40 = icmp slt i32 %39, 6
  br i1 %40, label %loop57, label %postloop60

loop57:                                           ; preds = %condeval56
  %41 = load i32, i32* %"$i$54"
  %array-index58 = getelementptr [6 x i32], [6 x i32]* %"$tmp_arr$55", i64 0, i32 %41
  %42 = load i32, i32* %"$i$54"
  %array-index59 = getelementptr [6 x i32], [6 x i32]* %result_int_array, i64 0, i32 %42
  %43 = load i32, i32* %array-index59
  %44 = or i32 %43, 2
  store i32 %44, i32* %array-index58
  %45 = load i32, i32* %"$i$54"
  %46 = add i32 %45, 1
  store i32 %46, i32* %"$i$54"
  br label %condeval56

postloop60:                                       ; preds = %condeval56
  %47 = load [6 x i32], [6 x i32]* %"$tmp_arr$55"
  store [6 x i32] %47, [6 x i32]* %result_int_array
  %array-index61 = getelementptr [6 x i1], [6 x i1]* %result_bool_array, i64 0, i32 0
  %48 = load i1, i1* %array-index61
  %array-index62 = getelementptr [6 x i1], [6 x i1]* %result_bool_array, i64 0, i32 0
  %49 = load i1, i1* %array-index62
  %array-index63 = getelementptr [6 x i1], [6 x i1]* %result_bool_array, i64 0, i32 0
  %50 = load i1, i1* %array-index63
  %array-index64 = getelementptr [6 x i1], [6 x i1]* %result_bool_array, i64 0, i32 0
  store i32 0, i32* %"$i$65"
  br label %condeval67

condeval67:                                       ; preds = %loop68, %postloop60
  %51 = load i32, i32* %"$i$65"
  %52 = icmp slt i32 %51, 6
  br i1 %52, label %loop68, label %postloop71

loop68:                                           ; preds = %condeval67
  %53 = load i32, i32* %"$i$65"
  %array-index69 = getelementptr [6 x i1], [6 x i1]* %"$tmp_arr$66", i64 0, i32 %53
  %54 = load i32, i32* %"$i$65"
  %array-index70 = getelementptr [6 x i1], [6 x i1]* %result_bool_array, i64 0, i32 %54
  %55 = load i1, i1* %array-index70
  store i1 %55, i1* %array-index69
  %56 = load i32, i32* %"$i$65"
  %57 = add i32 %56, 1
  store i32 %57, i32* %"$i$65"
  br label %condeval67

postloop71:                                       ; preds = %condeval67
  %58 = load [6 x i1], [6 x i1]* %"$tmp_arr$66"
  store [6 x i1] %58, [6 x i1]* %result_bool_array
  store i32 0, i32* %i40
  call void @putString(i8* getelementptr inbounds ([48 x i8], [48 x i8]* @12, i32 0, i32 0))
  br label %condeval72

condeval72:                                       ; preds = %loop74, %postloop71
  %i73 = load i32, i32* %i40
  %59 = icmp slt i32 %i73, 6
  br i1 %59, label %loop74, label %postloop78

loop74:                                           ; preds = %condeval72
  %i75 = load i32, i32* %i40
  %array-index76 = getelementptr [6 x i32], [6 x i32]* %result_int_array, i64 0, i32 %i75
  %60 = load i32, i32* %array-index76
  call void @putInteger(i32 %60)
  %i77 = load i32, i32* %i40
  %61 = add i32 %i77, 1
  store i32 %61, i32* %i40
  br label %condeval72

postloop78:                                       ; preds = %condeval72
  store i32 0, i32* %i40
  call void @putString(i8* getelementptr inbounds ([49 x i8], [49 x i8]* @13, i32 0, i32 0))
  br label %condeval79

condeval79:                                       ; preds = %loop81, %postloop78
  %i80 = load i32, i32* %i40
  %62 = icmp slt i32 %i80, 6
  br i1 %62, label %loop81, label %postloop85

loop81:                                           ; preds = %condeval79
  %i82 = load i32, i32* %i40
  %array-index83 = getelementptr [6 x i1], [6 x i1]* %result_bool_array, i64 0, i32 %i82
  %63 = load i1, i1* %array-index83
  call void @putBool(i1 %63)
  %i84 = load i32, i32* %i40
  %64 = add i32 %i84, 1
  store i32 %64, i32* %i40
  br label %condeval79

postloop85:                                       ; preds = %condeval79
  ret i32 0
}
