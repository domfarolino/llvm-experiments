; ModuleID = 'Dom Sample'
source_filename = "Dom Sample"

@0 = private unnamed_addr constant [11 x i8] c"dominic!!\0A\00"

declare i32 @printf(i8*, ...)

define double @AdderFunction(double %argument0, double %argument1) {
entry:
  %addUltimateReturn = fadd double %argument0, %argument1
  ret double %addUltimateReturn
}

define i32 @main() {
entry:
  %calladder = call double @AdderFunction(double 3.800000e+01, double 4.200000e+01)
  %fptointegerconv = fptosi double %calladder to i32
  %callprintf = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([11 x i8], [11 x i8]* @0, i32 0, i32 0))
  ret i32 %fptointegerconv
}
