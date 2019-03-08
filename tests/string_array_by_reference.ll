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
@10 = private unnamed_addr constant [52 x i8] c"Printing given array values inside fn `input_array`\00"
@11 = private unnamed_addr constant [48 x i8] c"Assigning array element inside fn `input_array`\00"
@12 = private unnamed_addr constant [7 x i8] c"modify\00"
@13 = private unnamed_addr constant [52 x i8] c"Printing given array values inside fn `input_array`\00"
@14 = private unnamed_addr constant [34 x i8] c"Top-level assigning array element\00"
@15 = private unnamed_addr constant [9 x i8] c"original\00"
@16 = private unnamed_addr constant [38 x i8] c"Top-level printing given array values\00"
@17 = private unnamed_addr constant [38 x i8] c"Top-level printing given array values\00"

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
  %i = alloca i32
  %my_array = alloca [10 x i8*]
  store i32 0, i32* %i
  br label %condeval

condeval:                                         ; preds = %loop, %entry
  %i1 = load i32, i32* %i
  %0 = icmp slt i32 %i1, 10
  br i1 %0, label %loop, label %postloop

loop:                                             ; preds = %condeval
  call void @putString(i8* getelementptr inbounds ([34 x i8], [34 x i8]* @14, i32 0, i32 0))
  %i2 = load i32, i32* %i
  %array-index = getelementptr [10 x i8*], [10 x i8*]* %my_array, i64 0, i32 %i2
  store i8* getelementptr inbounds ([9 x i8], [9 x i8]* @15, i32 0, i32 0), i8** %array-index
  %i3 = load i32, i32* %i
  %1 = add i32 %i3, 1
  store i32 %1, i32* %i
  br label %condeval

postloop:                                         ; preds = %condeval
  store i32 0, i32* %i
  call void @putString(i8* getelementptr inbounds ([38 x i8], [38 x i8]* @16, i32 0, i32 0))
  br label %condeval4

condeval4:                                        ; preds = %loop6, %postloop
  %i5 = load i32, i32* %i
  %2 = icmp slt i32 %i5, 10
  br i1 %2, label %loop6, label %postloop10

loop6:                                            ; preds = %condeval4
  %i7 = load i32, i32* %i
  %array-index8 = getelementptr [10 x i8*], [10 x i8*]* %my_array, i64 0, i32 %i7
  %3 = load i8*, i8** %array-index8
  call void @putString(i8* %3)
  %i9 = load i32, i32* %i
  %4 = add i32 %i9, 1
  store i32 %4, i32* %i
  br label %condeval4

postloop10:                                       ; preds = %condeval4
  call void @takes_array([10 x i8*]* %my_array)
  store i32 0, i32* %i
  call void @putString(i8* getelementptr inbounds ([38 x i8], [38 x i8]* @17, i32 0, i32 0))
  br label %condeval11

condeval11:                                       ; preds = %loop13, %postloop10
  %i12 = load i32, i32* %i
  %5 = icmp slt i32 %i12, 10
  br i1 %5, label %loop13, label %postloop17

loop13:                                           ; preds = %condeval11
  %i14 = load i32, i32* %i
  %array-index15 = getelementptr [10 x i8*], [10 x i8*]* %my_array, i64 0, i32 %i14
  %6 = load i8*, i8** %array-index15
  call void @putString(i8* %6)
  %i16 = load i32, i32* %i
  %7 = add i32 %i16, 1
  store i32 %7, i32* %i
  br label %condeval11

postloop17:                                       ; preds = %condeval11
  ret i32 0
}

define void @takes_array([10 x i8*]* %input_array) {
entry:
  %i = alloca i32
  %input_array1 = alloca [10 x i8*]*
  store [10 x i8*]* %input_array, [10 x i8*]** %input_array1
  call void @putString(i8* getelementptr inbounds ([52 x i8], [52 x i8]* @10, i32 0, i32 0))
  store i32 0, i32* %i
  br label %condeval

condeval:                                         ; preds = %loop, %entry
  %i2 = load i32, i32* %i
  %0 = icmp slt i32 %i2, 10
  br i1 %0, label %loop, label %postloop

loop:                                             ; preds = %condeval
  %input_array3 = load [10 x i8*]*, [10 x i8*]** %input_array1
  %i4 = load i32, i32* %i
  %array-index = getelementptr [10 x i8*], [10 x i8*]* %input_array3, i64 0, i32 %i4
  %1 = load i8*, i8** %array-index
  call void @putString(i8* %1)
  %i5 = load i32, i32* %i
  %2 = add i32 %i5, 1
  store i32 %2, i32* %i
  br label %condeval

postloop:                                         ; preds = %condeval
  store i32 0, i32* %i
  br label %condeval6

condeval6:                                        ; preds = %loop8, %postloop
  %i7 = load i32, i32* %i
  %3 = icmp slt i32 %i7, 10
  br i1 %3, label %loop8, label %postloop13

loop8:                                            ; preds = %condeval6
  call void @putString(i8* getelementptr inbounds ([48 x i8], [48 x i8]* @11, i32 0, i32 0))
  %input_array9 = load [10 x i8*]*, [10 x i8*]** %input_array1
  %i10 = load i32, i32* %i
  %array-index11 = getelementptr [10 x i8*], [10 x i8*]* %input_array9, i64 0, i32 %i10
  store i8* getelementptr inbounds ([7 x i8], [7 x i8]* @12, i32 0, i32 0), i8** %array-index11
  %i12 = load i32, i32* %i
  %4 = add i32 %i12, 1
  store i32 %4, i32* %i
  br label %condeval6

postloop13:                                       ; preds = %condeval6
  store i32 0, i32* %i
  call void @putString(i8* getelementptr inbounds ([52 x i8], [52 x i8]* @13, i32 0, i32 0))
  br label %condeval14

condeval14:                                       ; preds = %loop16, %postloop13
  %i15 = load i32, i32* %i
  %5 = icmp slt i32 %i15, 10
  br i1 %5, label %loop16, label %postloop21

loop16:                                           ; preds = %condeval14
  %input_array17 = load [10 x i8*]*, [10 x i8*]** %input_array1
  %i18 = load i32, i32* %i
  %array-index19 = getelementptr [10 x i8*], [10 x i8*]* %input_array17, i64 0, i32 %i18
  %6 = load i8*, i8** %array-index19
  call void @putString(i8* %6)
  %i20 = load i32, i32* %i
  %7 = add i32 %i20, 1
  store i32 %7, i32* %i
  br label %condeval14

postloop21:                                       ; preds = %condeval14
  ret void
}
