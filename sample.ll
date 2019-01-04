; ModuleID = 'Dom Sample'
source_filename = "Dom Sample"

@0 = private unnamed_addr constant [21 x i8] c"Adder returning: %f\0A\00"
@1 = private unnamed_addr constant [20 x i8] c"dominicfarolino!!%d\00"

declare i32 @printf(i8*, ...)

define i32 @main() {
entry:
  %calladder = call double @AdderFunction(double 3.800000e+01, double 4.200000e+01)
  call void @comparisonFunction(double %calladder)
  %fpToIntegerConv = fptosi double %calladder to i32
  %callprintf = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([20 x i8], [20 x i8]* @1, i32 0, i32 0), i32 %fpToIntegerConv)
  ret i32 %fpToIntegerConv
}

define double @AdderFunction(double %left, double %right) {
entry:
  %addUltimateReturn = fadd double %left, %right
  %callprintf = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([21 x i8], [21 x i8]* @0, i32 0, i32 0), double %addUltimateReturn)
  ret double %addUltimateReturn
}

define void @comparisonFunction(double %value) {
entry:
  ret void
}
