; ModuleID = 'Dom Sample'
source_filename = "Dom Sample"

@0 = private unnamed_addr constant [26 x i8] c"FloatAdder returning: %f\0A\00"
@1 = private unnamed_addr constant [28 x i8] c"IntegerAdder returning: %d\0A\00"
@2 = private unnamed_addr constant [13 x i8] c"plusOne: %d\0A\00"
@3 = private unnamed_addr constant [16 x i8] c"All finished!!\0A\00"
@4 = private unnamed_addr constant [18 x i8] c"boolArgument: %d\0A\00"
@5 = private unnamed_addr constant [26 x i8] c"if -> then was executed!\0A\00"
@6 = private unnamed_addr constant [26 x i8] c"if -> else was executed!\0A\00"
@7 = private unnamed_addr constant [33 x i8] c"FloatAdderResult(from main): %f\0A\00"
@8 = private unnamed_addr constant [35 x i8] c"IntegerAdderResult(from main): %d\0A\00"
@9 = private unnamed_addr constant [15 x i8] c"relResult: %d\0A\00"

declare i32 @printf(i8*, ...)

define i32 @main() {
entry:
  %calladder = call double @FloatAdder(double 4.200000e+01, double 3.800000e+01)
  %calladder1 = call i32 @IntegerAdder(i32 42, i32 38)
  %callprintfFloatAdder = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([33 x i8], [33 x i8]* @7, i32 0, i32 0), double %calladder)
  %callprintfIntegerAdder = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([35 x i8], [35 x i8]* @8, i32 0, i32 0), i32 %calladder1)
  %0 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([15 x i8], [15 x i8]* @9, i32 0, i32 0), i1 false)
  %float-to-bool = fcmp one double %calladder, 0.000000e+00
  call void @boolFunction(i1 %float-to-bool)
  call void @integerFunction(i32 0)
  ret i32 %calladder1
}

define double @FloatAdder(double %floatLeft, double %floatRight) {
entry:
  %floatAddUltimateReturn = fdiv double %floatLeft, %floatRight
  %callprintf = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([26 x i8], [26 x i8]* @0, i32 0, i32 0), double %floatAddUltimateReturn)
  ret double %floatAddUltimateReturn
}

define i32 @IntegerAdder(i32 %integerLeft, i32 %integerRight) {
entry:
  %integerAddUltimateReturn = sdiv i32 %integerLeft, %integerRight
  %callprintf = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([28 x i8], [28 x i8]* @1, i32 0, i32 0), i32 %integerAddUltimateReturn)
  ret i32 %integerAddUltimateReturn
}

define void @integerFunction(i32 %integerArgument) {
entry:
  %0 = icmp slt i32 %integerArgument, 10
  br i1 %0, label %then, label %else

then:                                             ; preds = %entry
  %1 = add i32 %integerArgument, 1
  %2 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([13 x i8], [13 x i8]* @2, i32 0, i32 0), i32 %1)
  call void @integerFunction(i32 %1)
  br label %ifmerge

else:                                             ; preds = %entry
  %3 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([16 x i8], [16 x i8]* @3, i32 0, i32 0))
  br label %ifmerge

ifmerge:                                          ; preds = %else, %then
  %ifphi = phi double [ 1.000000e+00, %then ], [ 2.000000e+00, %else ]
  ret void
}

define void @floatFunction(double %floatArgument) {
entry:
  ret void
}

define void @boolFunction(i1 %boolArgument) {
entry:
  %0 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([18 x i8], [18 x i8]* @4, i32 0, i32 0), i1 %boolArgument)
  br i1 %boolArgument, label %then, label %else

then:                                             ; preds = %entry
  %1 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([26 x i8], [26 x i8]* @5, i32 0, i32 0))
  br label %ifmerge

else:                                             ; preds = %entry
  %2 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([26 x i8], [26 x i8]* @6, i32 0, i32 0))
  br label %ifmerge

ifmerge:                                          ; preds = %else, %then
  %ifphi = phi double [ 1.000000e+00, %then ], [ 2.000000e+00, %else ]
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
