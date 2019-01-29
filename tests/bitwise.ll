; ModuleID = 'Dom Sample'
source_filename = "Dom Sample"

@0 = private unnamed_addr constant [24 x i8] c"bitwise and result: %d\0A\00"
@1 = private unnamed_addr constant [23 x i8] c"bitwise or result: %d\0A\00"

declare i32 @printf(i8*, ...)

define i32 @main() {
entry:
  call void @bitwiseAndInteger(i32 64, i32 32)
  call void @bitwiseOrInteger(i32 64, i32 32)
  ret i32 0
}

define void @bitwiseAndInteger(i32 %arg1, i32 %arg2) {
entry:
  %bitwiseResult = alloca i32
  %arg22 = alloca i32
  %arg11 = alloca i32
  store i32 %arg1, i32* %arg11
  store i32 %arg2, i32* %arg22
  store i32 0, i32* %bitwiseResult
  %arg13 = load i32, i32* %arg11
  %arg24 = load i32, i32* %arg22
  %0 = and i32 %arg13, %arg24
  store i32 %0, i32* %bitwiseResult
  %bitwiseResult5 = load i32, i32* %bitwiseResult
  %1 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([24 x i8], [24 x i8]* @0, i32 0, i32 0), i32 %bitwiseResult5)
  ret void
}

define void @bitwiseOrInteger(i32 %arg1, i32 %arg2) {
entry:
  %bitwiseResult = alloca i32
  %arg22 = alloca i32
  %arg11 = alloca i32
  store i32 %arg1, i32* %arg11
  store i32 %arg2, i32* %arg22
  store i32 0, i32* %bitwiseResult
  %arg13 = load i32, i32* %arg11
  %arg24 = load i32, i32* %arg22
  %0 = or i32 %arg13, %arg24
  store i32 %0, i32* %bitwiseResult
  %bitwiseResult5 = load i32, i32* %bitwiseResult
  %1 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([23 x i8], [23 x i8]* @1, i32 0, i32 0), i32 %bitwiseResult5)
  ret void
}
