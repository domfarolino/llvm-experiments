; ModuleID = 'Dom Sample'
source_filename = "Dom Sample"

@0 = private unnamed_addr constant [4 x i8] c"%d\0A\00"
@1 = private unnamed_addr constant [5 x i8] c"%lf\0A\00"
@2 = private unnamed_addr constant [4 x i8] c"%d\0A\00"
@3 = private unnamed_addr constant [4 x i8] c"%c\0A\00"
@4 = private unnamed_addr constant [4 x i8] c"%s\0A\00"
@5 = private unnamed_addr constant [3 x i8] c"%d\00"
@6 = private unnamed_addr constant [4 x i8] c"%lf\00"
@7 = private unnamed_addr constant [3 x i8] c"%d\00"
@8 = private unnamed_addr constant [4 x i8] c" %c\00"
@9 = private unnamed_addr constant [3 x i8] c"%s\00"
@10 = private unnamed_addr constant [21 x i8] c"Starting out with &&\00"
@11 = private unnamed_addr constant [21 x i8] c"Logical and was true\00"
@12 = private unnamed_addr constant [22 x i8] c"Logical and was false\00"
@13 = private unnamed_addr constant [21 x i8] c"Logical and was true\00"
@14 = private unnamed_addr constant [22 x i8] c"Logical and was false\00"
@15 = private unnamed_addr constant [21 x i8] c"Logical and was true\00"
@16 = private unnamed_addr constant [22 x i8] c"Logical and was false\00"
@17 = private unnamed_addr constant [16 x i8] c"Switching to ||\00"
@18 = private unnamed_addr constant [20 x i8] c"Logical or was true\00"
@19 = private unnamed_addr constant [21 x i8] c"Logical or was false\00"
@20 = private unnamed_addr constant [20 x i8] c"Logical or was true\00"
@21 = private unnamed_addr constant [21 x i8] c"Logical or was false\00"
@22 = private unnamed_addr constant [20 x i8] c"Logical or was true\00"
@23 = private unnamed_addr constant [21 x i8] c"Logical or was false\00"

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
  %0 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([5 x i8], [5 x i8]* @1, i32 0, i32 0), double %out2)
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

define void @getInteger(i32* %out) {
entry:
  %out1 = alloca i32*
  store i32* %out, i32** %out1
  %out2 = load i32*, i32** %out1
  %0 = call i32 (i8*, ...) @scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @5, i32 0, i32 0), i32* %out2)
  ret void
}

define void @getFloat(double* %out) {
entry:
  %out1 = alloca double*
  store double* %out, double** %out1
  %out2 = load double*, double** %out1
  %0 = call i32 (i8*, ...) @scanf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @6, i32 0, i32 0), double* %out2)
  ret void
}

define void @getBool(i1* %out) {
entry:
  %tmpInteger = alloca i32
  %out1 = alloca i1*
  store i1* %out, i1** %out1
  store i32 0, i32* %tmpInteger
  %0 = call i32 (i8*, ...) @scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @7, i32 0, i32 0), i32* %tmpInteger)
  %tmpInteger2 = load i32, i32* %tmpInteger
  %integer-to-float = sitofp i32 %tmpInteger2 to double
  %integer-to-bool = fcmp one double %integer-to-float, 0.000000e+00
  %out3 = load i1*, i1** %out1
  store i1 %integer-to-bool, i1* %out3
  ret void
}

define void @getChar(i8* %out) {
entry:
  %out1 = alloca i8*
  store i8* %out, i8** %out1
  %out2 = load i8*, i8** %out1
  %0 = call i32 (i8*, ...) @scanf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @8, i32 0, i32 0), i8* %out2)
  ret void
}

define void @getString(i8** %out) {
entry:
  %out1 = alloca i8**
  store i8** %out, i8*** %out1
  %out2 = load i8**, i8*** %out1
  %0 = load i8*, i8** %out2
  %1 = call i32 (i8*, ...) @scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @9, i32 0, i32 0), i8* %0)
  ret void
}

define i32 @main() {
entry:
  call void @useIf()
  ret i32 0
}

define void @useIf() {
entry:
  call void @putString(i8* getelementptr inbounds ([21 x i8], [21 x i8]* @10, i32 0, i32 0))
  br i1 true, label %then, label %else

then:                                             ; preds = %entry
  call void @putString(i8* getelementptr inbounds ([21 x i8], [21 x i8]* @11, i32 0, i32 0))
  br label %ifmerge

else:                                             ; preds = %entry
  call void @putString(i8* getelementptr inbounds ([22 x i8], [22 x i8]* @12, i32 0, i32 0))
  br label %ifmerge

ifmerge:                                          ; preds = %else, %then
  br i1 false, label %then1, label %else2

then1:                                            ; preds = %ifmerge
  call void @putString(i8* getelementptr inbounds ([21 x i8], [21 x i8]* @13, i32 0, i32 0))
  br label %ifmerge3

else2:                                            ; preds = %ifmerge
  call void @putString(i8* getelementptr inbounds ([22 x i8], [22 x i8]* @14, i32 0, i32 0))
  br label %ifmerge3

ifmerge3:                                         ; preds = %else2, %then1
  br i1 false, label %then4, label %else5

then4:                                            ; preds = %ifmerge3
  call void @putString(i8* getelementptr inbounds ([21 x i8], [21 x i8]* @15, i32 0, i32 0))
  br label %ifmerge6

else5:                                            ; preds = %ifmerge3
  call void @putString(i8* getelementptr inbounds ([22 x i8], [22 x i8]* @16, i32 0, i32 0))
  br label %ifmerge6

ifmerge6:                                         ; preds = %else5, %then4
  call void @putString(i8* getelementptr inbounds ([16 x i8], [16 x i8]* @17, i32 0, i32 0))
  br i1 true, label %then7, label %else8

then7:                                            ; preds = %ifmerge6
  call void @putString(i8* getelementptr inbounds ([20 x i8], [20 x i8]* @18, i32 0, i32 0))
  br label %ifmerge9

else8:                                            ; preds = %ifmerge6
  call void @putString(i8* getelementptr inbounds ([21 x i8], [21 x i8]* @19, i32 0, i32 0))
  br label %ifmerge9

ifmerge9:                                         ; preds = %else8, %then7
  br i1 true, label %then10, label %else11

then10:                                           ; preds = %ifmerge9
  call void @putString(i8* getelementptr inbounds ([20 x i8], [20 x i8]* @20, i32 0, i32 0))
  br label %ifmerge12

else11:                                           ; preds = %ifmerge9
  call void @putString(i8* getelementptr inbounds ([21 x i8], [21 x i8]* @21, i32 0, i32 0))
  br label %ifmerge12

ifmerge12:                                        ; preds = %else11, %then10
  br i1 false, label %then13, label %else14

then13:                                           ; preds = %ifmerge12
  call void @putString(i8* getelementptr inbounds ([20 x i8], [20 x i8]* @22, i32 0, i32 0))
  br label %ifmerge15

else14:                                           ; preds = %ifmerge12
  call void @putString(i8* getelementptr inbounds ([21 x i8], [21 x i8]* @23, i32 0, i32 0))
  br label %ifmerge15

ifmerge15:                                        ; preds = %else14, %then13
  ret void
}
