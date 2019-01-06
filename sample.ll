; ModuleID = 'Dom Sample'
source_filename = "Dom Sample"

@0 = private unnamed_addr constant [21 x i8] c"Adder returning: %f\0A\00"
@1 = private unnamed_addr constant [18 x i8] c"boolArgument: %d\0A\00"
@2 = private unnamed_addr constant [26 x i8] c"if -> then was executed!\0A\00"
@3 = private unnamed_addr constant [26 x i8] c"if -> else was executed!\0A\00"
@4 = private unnamed_addr constant [20 x i8] c"dominicfarolino!!%d\00"

declare i32 @printf(i8*, ...)

define i32 @main() {
entry:
  %calladder = call float @AdderFunction(float 3.800000e+01, float 4.200000e+01)
  %float-to-bool = fcmp one float %calladder, 0.000000e+00
  call void @boolFunction(i1 %float-to-bool)
  %float-to-integer = fptosi float %calladder to i32
  %callprintf = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([20 x i8], [20 x i8]* @4, i32 0, i32 0), i32 %float-to-integer)
  ret i32 %float-to-integer
}

define float @AdderFunction(float %left, float %right) {
entry:
  %addUltimateReturn = fadd float %left, %right
  %callprintf = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([21 x i8], [21 x i8]* @0, i32 0, i32 0), float %addUltimateReturn)
  ret float %addUltimateReturn
}

define void @integerFunction(i32 %integerArgument) {
entry:
  ret void
}

define void @floatFunction(float %floatArgument) {
entry:
  ret void
}

define void @boolFunction(i1 %boolArgument) {
entry:
  %0 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([18 x i8], [18 x i8]* @1, i32 0, i32 0), i1 %boolArgument)
  br i1 %boolArgument, label %then, label %else

then:                                             ; preds = %entry
  %1 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([26 x i8], [26 x i8]* @2, i32 0, i32 0))
  br label %ifmerge

else:                                             ; preds = %entry
  %2 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([26 x i8], [26 x i8]* @3, i32 0, i32 0))
  br label %ifmerge

ifmerge:                                          ; preds = %else, %then
  %ifphi = phi float [ 1.000000e+00, %then ], [ 2.000000e+00, %else ]
  ret void
}

define void @charFunction(i8 %charArgument) {
entry:
  ret void
}

define void @stringFunction(i8* %stringArgument) {
entry:
  ret void
}
