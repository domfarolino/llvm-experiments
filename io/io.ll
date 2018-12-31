; ModuleID = 'io.c'
source_filename = "io.c"
target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.12.0"

@.str = private unnamed_addr constant [8 x i8] c"dominic\00", align 1

; Function Attrs: noinline nounwind optnone ssp uwtable
define i32 @main() #0 {
entry:
  %retval = alloca i32, align 4
  %myStringVar = alloca i8*, align 8
  store i32 0, i32* %retval, align 4
  store i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str, i32 0, i32 0), i8** %myStringVar, align 8
  %0 = load i8*, i8** %myStringVar, align 8
  %call = call i32 (i8*, ...) @printf(i8* %0)
  ret i32 0
}

declare i32 @printf(i8*, ...) #1
