; ModuleID = 'Dom Sample'
source_filename = "Dom Sample"

@0 = private unnamed_addr constant [4 x i8] c"%d\0A\00"
@1 = private unnamed_addr constant [4 x i8] c"%f\0A\00"
@2 = private unnamed_addr constant [4 x i8] c"%d\0A\00"
@3 = private unnamed_addr constant [4 x i8] c"%c\0A\00"
@4 = private unnamed_addr constant [4 x i8] c"%s\0A\00"
@5 = private unnamed_addr constant [11 x i8] c"stringArg:\00"
@6 = private unnamed_addr constant [9 x i8] c"farolino\00"
@7 = private unnamed_addr constant [11 x i8] c"stringArg:\00"
@8 = private unnamed_addr constant [8 x i8] c"dominic\00"
@9 = private unnamed_addr constant [10 x i8] c"myString:\00"
@10 = private unnamed_addr constant [10 x i8] c"myString:\00"

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
  %0 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @1, i32 0, i32 0), double %out2)
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

define i32 @main() {
entry:
  %myString = alloca i8*
  store i8* getelementptr inbounds ([8 x i8], [8 x i8]* @8, i32 0, i32 0), i8** %myString
  call void @putString(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @9, i32 0, i32 0))
  %myString1 = load i8*, i8** %myString
  call void @putString(i8* %myString1)
  %myString2 = load i8*, i8** %myString
  call void @stringFunc(i8* %myString2)
  call void @putString(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @10, i32 0, i32 0))
  %myString3 = load i8*, i8** %myString
  call void @putString(i8* %myString3)
  ret i32 0
}

define void @stringFunc(i8* %stringArg) {
entry:
  %stringArg1 = alloca i8*
  store i8* %stringArg, i8** %stringArg1
  call void @putString(i8* getelementptr inbounds ([11 x i8], [11 x i8]* @5, i32 0, i32 0))
  %stringArg2 = load i8*, i8** %stringArg1
  call void @putString(i8* %stringArg2)
  store i8* getelementptr inbounds ([9 x i8], [9 x i8]* @6, i32 0, i32 0), i8** %stringArg1
  call void @putString(i8* getelementptr inbounds ([11 x i8], [11 x i8]* @7, i32 0, i32 0))
  %stringArg3 = load i8*, i8** %stringArg1
  call void @putString(i8* %stringArg3)
  ret void
}
