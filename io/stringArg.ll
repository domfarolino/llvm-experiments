; ModuleID = 'stringArg.c'
source_filename = "stringArg.c"
target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.12.0"

@.str = private unnamed_addr constant [4 x i8] c"abc\00", align 1

; Function Attrs: noinline nounwind optnone ssp uwtable
define void @myFunctionWoo(i8* %string) #0 {
entry:
  %string.addr = alloca i8*, align 8
  store i8* %string, i8** %string.addr, align 8
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define i32 @main() #0 {
entry:
  %retval = alloca i32, align 4
  %myStringVar = alloca i8*, align 8
  store i32 0, i32* %retval, align 4
  store i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i32 0, i32 0), i8** %myStringVar, align 8
  ret i32 0
}
