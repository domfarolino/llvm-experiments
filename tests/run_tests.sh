./bitwise &> bitwise.ll &&
./boolTo &> boolTo.ll &&
./globalVariable &> globalVariable.ll &&
./negate &> negate.ll &&
./putX &> putX.ll &&
./produceBool &> produceBool.ll &&
./referenceVar &> referenceVar.ll &&
./stringArg &> stringArg.ll &&
./getX &> getX.ll

/usr/local/opt/llvm/bin/lli bitwise.ll > bitwise.out &&
/usr/local/opt/llvm/bin/lli boolTo.ll > boolTo.out &&
/usr/local/opt/llvm/bin/lli globalVariable.ll > globalVariable.out &&
/usr/local/opt/llvm/bin/lli negate.ll > negate.out &&
/usr/local/opt/llvm/bin/lli putX.ll > putX.out &&
/usr/local/opt/llvm/bin/lli produceBool.ll > produceBool.out &&
/usr/local/opt/llvm/bin/lli referenceVar.ll > referenceVar.out &&
/usr/local/opt/llvm/bin/lli stringArg.ll > stringArg.out
