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
  %"$tmp_arr$50" = alloca [6 x i1]
  %"$i$49" = alloca i32
  %"$tmp_arr$43" = alloca [6 x i32]
  %"$i$42" = alloca i32
  %i32 = alloca i32
  %"$tmp_arr$12" = alloca [6 x i1]
  %"$i$11" = alloca i32
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
  store i32 0, i32* %"$i$"
  br label %condeval6

condeval6:                                        ; preds = %loop7, %postloop
  %3 = load i32, i32* %"$i$"
  %4 = icmp slt i32 %3, 6
  br i1 %4, label %loop7, label %postloop10

loop7:                                            ; preds = %condeval6
  %5 = load i32, i32* %"$i$"
  %array-index8 = getelementptr [6 x i32], [6 x i32]* %"$tmp_arr$", i64 0, i32 %5
  %6 = load i32, i32* %"$i$"
  %array-index9 = getelementptr [6 x i32], [6 x i32]* %result_int_array, i64 0, i32 %6
  %7 = load i32, i32* %array-index9
  %8 = and i32 2, %7
  store i32 %8, i32* %array-index8
  %9 = load i32, i32* %"$i$"
  %10 = add i32 %9, 1
  store i32 %10, i32* %"$i$"
  br label %condeval6

postloop10:                                       ; preds = %condeval6
  %11 = load [6 x i32], [6 x i32]* %"$tmp_arr$"
  store [6 x i32] %11, [6 x i32]* %result_int_array
  store i32 0, i32* %"$i$11"
  br label %condeval13

condeval13:                                       ; preds = %loop14, %postloop10
  %12 = load i32, i32* %"$i$11"
  %13 = icmp slt i32 %12, 6
  br i1 %13, label %loop14, label %postloop17

loop14:                                           ; preds = %condeval13
  %14 = load i32, i32* %"$i$11"
  %array-index15 = getelementptr [6 x i1], [6 x i1]* %"$tmp_arr$12", i64 0, i32 %14
  %15 = load i32, i32* %"$i$11"
  %array-index16 = getelementptr [6 x i1], [6 x i1]* %result_bool_array, i64 0, i32 %15
  %16 = load i1, i1* %array-index16
  %17 = and i1 false, %16
  store i1 %17, i1* %array-index15
  %18 = load i32, i32* %"$i$11"
  %19 = add i32 %18, 1
  store i32 %19, i32* %"$i$11"
  br label %condeval13

postloop17:                                       ; preds = %condeval13
  %20 = load [6 x i1], [6 x i1]* %"$tmp_arr$12"
  store [6 x i1] %20, [6 x i1]* %result_bool_array
  store i32 0, i32* %i
  call void @putString(i8* getelementptr inbounds ([54 x i8], [54 x i8]* @10, i32 0, i32 0))
  br label %condeval18

condeval18:                                       ; preds = %loop20, %postloop17
  %i19 = load i32, i32* %i
  %21 = icmp slt i32 %i19, 6
  br i1 %21, label %loop20, label %postloop24

loop20:                                           ; preds = %condeval18
  %i21 = load i32, i32* %i
  %array-index22 = getelementptr [6 x i32], [6 x i32]* %result_int_array, i64 0, i32 %i21
  %22 = load i32, i32* %array-index22
  call void @putInteger(i32 %22)
  %i23 = load i32, i32* %i
  %23 = add i32 %i23, 1
  store i32 %23, i32* %i
  br label %condeval18

postloop24:                                       ; preds = %condeval18
  store i32 0, i32* %i
  call void @putString(i8* getelementptr inbounds ([55 x i8], [55 x i8]* @11, i32 0, i32 0))
  br label %condeval25

condeval25:                                       ; preds = %loop27, %postloop24
  %i26 = load i32, i32* %i
  %24 = icmp slt i32 %i26, 6
  br i1 %24, label %loop27, label %postloop31

loop27:                                           ; preds = %condeval25
  %i28 = load i32, i32* %i
  %array-index29 = getelementptr [6 x i1], [6 x i1]* %result_bool_array, i64 0, i32 %i28
  %25 = load i1, i1* %array-index29
  call void @putBool(i1 %25)
  %i30 = load i32, i32* %i
  %26 = add i32 %i30, 1
  store i32 %26, i32* %i
  br label %condeval25

postloop31:                                       ; preds = %condeval25
  store i32 0, i32* %i32
  br label %condeval33

condeval33:                                       ; preds = %loop35, %postloop31
  %i34 = load i32, i32* %i32
  %27 = icmp slt i32 %i34, 6
  br i1 %27, label %loop35, label %postloop41

loop35:                                           ; preds = %condeval33
  %i36 = load i32, i32* %i32
  %array-index37 = getelementptr [6 x i32], [6 x i32]* %result_int_array, i64 0, i32 %i36
  %28 = load i32, i32* %i32
  store i32 %28, i32* %array-index37
  %i38 = load i32, i32* %i32
  %array-index39 = getelementptr [6 x i1], [6 x i1]* %result_bool_array, i64 0, i32 %i38
  store i1 true, i1* %array-index39
  %i40 = load i32, i32* %i32
  %29 = add i32 %i40, 1
  store i32 %29, i32* %i32
  br label %condeval33

postloop41:                                       ; preds = %condeval33
  store i32 0, i32* %"$i$42"
  br label %condeval44

condeval44:                                       ; preds = %loop45, %postloop41
  %30 = load i32, i32* %"$i$42"
  %31 = icmp slt i32 %30, 6
  br i1 %31, label %loop45, label %postloop48

loop45:                                           ; preds = %condeval44
  %32 = load i32, i32* %"$i$42"
  %array-index46 = getelementptr [6 x i32], [6 x i32]* %"$tmp_arr$43", i64 0, i32 %32
  %33 = load i32, i32* %"$i$42"
  %array-index47 = getelementptr [6 x i32], [6 x i32]* %result_int_array, i64 0, i32 %33
  %34 = load i32, i32* %array-index47
  %35 = or i32 2, %34
  store i32 %35, i32* %array-index46
  %36 = load i32, i32* %"$i$42"
  %37 = add i32 %36, 1
  store i32 %37, i32* %"$i$42"
  br label %condeval44

postloop48:                                       ; preds = %condeval44
  %38 = load [6 x i32], [6 x i32]* %"$tmp_arr$43"
  store [6 x i32] %38, [6 x i32]* %result_int_array
  store i32 0, i32* %"$i$49"
  br label %condeval51

condeval51:                                       ; preds = %loop52, %postloop48
  %39 = load i32, i32* %"$i$49"
  %40 = icmp slt i32 %39, 6
  br i1 %40, label %loop52, label %postloop55

loop52:                                           ; preds = %condeval51
  %41 = load i32, i32* %"$i$49"
  %array-index53 = getelementptr [6 x i1], [6 x i1]* %"$tmp_arr$50", i64 0, i32 %41
  %42 = load i32, i32* %"$i$49"
  %array-index54 = getelementptr [6 x i1], [6 x i1]* %result_bool_array, i64 0, i32 %42
  %43 = load i1, i1* %array-index54
  %44 = or i1 false, %43
  store i1 %44, i1* %array-index53
  %45 = load i32, i32* %"$i$49"
  %46 = add i32 %45, 1
  store i32 %46, i32* %"$i$49"
  br label %condeval51

postloop55:                                       ; preds = %condeval51
  %47 = load [6 x i1], [6 x i1]* %"$tmp_arr$50"
  store [6 x i1] %47, [6 x i1]* %result_bool_array
  store i32 0, i32* %i32
  call void @putString(i8* getelementptr inbounds ([53 x i8], [53 x i8]* @12, i32 0, i32 0))
  br label %condeval56

condeval56:                                       ; preds = %loop58, %postloop55
  %i57 = load i32, i32* %i32
  %48 = icmp slt i32 %i57, 6
  br i1 %48, label %loop58, label %postloop62

loop58:                                           ; preds = %condeval56
  %i59 = load i32, i32* %i32
  %array-index60 = getelementptr [6 x i32], [6 x i32]* %result_int_array, i64 0, i32 %i59
  %49 = load i32, i32* %array-index60
  call void @putInteger(i32 %49)
  %i61 = load i32, i32* %i32
  %50 = add i32 %i61, 1
  store i32 %50, i32* %i32
  br label %condeval56

postloop62:                                       ; preds = %condeval56
  store i32 0, i32* %i32
  call void @putString(i8* getelementptr inbounds ([54 x i8], [54 x i8]* @13, i32 0, i32 0))
  br label %condeval63

condeval63:                                       ; preds = %loop65, %postloop62
  %i64 = load i32, i32* %i32
  %51 = icmp slt i32 %i64, 6
  br i1 %51, label %loop65, label %postloop69

loop65:                                           ; preds = %condeval63
  %i66 = load i32, i32* %i32
  %array-index67 = getelementptr [6 x i1], [6 x i1]* %result_bool_array, i64 0, i32 %i66
  %52 = load i1, i1* %array-index67
  call void @putBool(i1 %52)
  %i68 = load i32, i32* %i32
  %53 = add i32 %i68, 1
  store i32 %53, i32* %i32
  br label %condeval63

postloop69:                                       ; preds = %condeval63
  ret i32 0
}
