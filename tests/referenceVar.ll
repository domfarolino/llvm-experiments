; ModuleID = 'Dom Sample'
source_filename = "Dom Sample"

@0 = private unnamed_addr constant [4 x i8] c"%d\0A\00"
@1 = private unnamed_addr constant [4 x i8] c"%f\0A\00"
@2 = private unnamed_addr constant [4 x i8] c"%d\0A\00"
@3 = private unnamed_addr constant [4 x i8] c"%c\0A\00"
@4 = private unnamed_addr constant [4 x i8] c"%s\0A\00"
@5 = private unnamed_addr constant [22 x i8] c"i have been modified!\00"
@6 = private unnamed_addr constant [8 x i8] c"initial\00"
@7 = private unnamed_addr constant [8 x i8] c"Before:\00"
@8 = private unnamed_addr constant [7 x i8] c"After:\00"

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
  %myChar = alloca i8
  %myBool = alloca i1
  %myFloat = alloca double
  %myInteger = alloca i32
  store i32 123, i32* %myInteger
  store double 0x405EC23C4B09E98E, double* %myFloat
  store i1 false, i1* %myBool
  store i8 97, i8* %myChar
  store i8* getelementptr inbounds ([8 x i8], [8 x i8]* @6, i32 0, i32 0), i8** %myString
  call void @putString(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @7, i32 0, i32 0))
  %myInteger1 = load i32, i32* %myInteger
  call void @putInteger(i32 %myInteger1)
  %myFloat2 = load double, double* %myFloat
  call void @putFloat(double %myFloat2)
  %myBool3 = load i1, i1* %myBool
  call void @putBool(i1 %myBool3)
  %myChar4 = load i8, i8* %myChar
  call void @putChar(i8 %myChar4)
  %myString5 = load i8*, i8** %myString
  call void @putString(i8* %myString5)
  call void @modifyArgs(i32* %myInteger, double* %myFloat, i1* %myBool, i8* %myChar, i8** %myString)
  call void @putString(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @8, i32 0, i32 0))
  %myInteger6 = load i32, i32* %myInteger
  call void @putInteger(i32 %myInteger6)
  %myFloat7 = load double, double* %myFloat
  call void @putFloat(double %myFloat7)
  %myBool8 = load i1, i1* %myBool
  call void @putBool(i1 %myBool8)
  %myChar9 = load i8, i8* %myChar
  call void @putChar(i8 %myChar9)
  %myString10 = load i8*, i8** %myString
  call void @putString(i8* %myString10)
  ret i32 0
}

define void @modifyArgs(i32* %outInteger, double* %outFloat, i1* %outBool, i8* %outChar, i8** %outString) {
entry:
  %outString5 = alloca i8**
  %outChar4 = alloca i8*
  %outBool3 = alloca i1*
  %outFloat2 = alloca double*
  %outInteger1 = alloca i32*
  store i32* %outInteger, i32** %outInteger1
  store double* %outFloat, double** %outFloat2
  store i1* %outBool, i1** %outBool3
  store i8* %outChar, i8** %outChar4
  store i8** %outString, i8*** %outString5
  %outInteger6 = load i32*, i32** %outInteger1
  %0 = load i32, i32* %outInteger6
  %1 = add i32 %0, 234
  %outInteger7 = load i32*, i32** %outInteger1
  store i32 %1, i32* %outInteger7
  %outFloat8 = load double*, double** %outFloat2
  store double 0x406D42FBD273D5BB, double* %outFloat8
  %outBool9 = load i1*, i1** %outBool3
  store i1 true, i1* %outBool9
  %outChar10 = load i8*, i8** %outChar4
  store i8 100, i8* %outChar10
  %outString11 = load i8**, i8*** %outString5
  store i8* getelementptr inbounds ([22 x i8], [22 x i8]* @5, i32 0, i32 0), i8** %outString11
  ret void
}
