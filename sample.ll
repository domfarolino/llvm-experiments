; ModuleID = 'Dom Sample'
source_filename = "Dom Sample"

define double @AdderFunction(double %argument0, double %argument1) {
entry:
  %addUltimateReturn = fadd double %argument0, %argument1
  ret double %addUltimateReturn
}

define i32 @main() {
entry:
  %calladder = call double @AdderFunction(double 3.800000e+01, double 4.200000e+01)
  %fptointegerconv = fptosi double %calladder to i32
  ret i32 %fptointegerconv
}
