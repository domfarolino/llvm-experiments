CXX=g++
PROGRAMS=sample add_arrays arrays_by_reference arrays_by_value string_array_by_reference negate bitwise putX boolTo globalVariable produceBool referenceVar stringArg getX logical_operators logical_operators_single_arrays logical_operators_arrays
# g++ sample.cpp `$(brew --prefix llvm)/bin/llvm-config --cppflags --ldflags --libs all --system-libs core` -std=c++0x
CFLAGS=-I/usr/local/Cellar/llvm/7.0.1/include -D__STDC_CONSTANT_MACROS -D__STDC_FORMAT_MACROS -D__STDC_LIMIT_MACROS -L/usr/local/Cellar/llvm/7.0.1/lib -Wl,-search_paths_first -Wl,-headerpad_max_install_names -lLLVMLTO -lLLVMPasses -lLLVMObjCARCOpts -lLLVMSymbolize -lLLVMDebugInfoPDB -lLLVMDebugInfoDWARF -lLLVMMIRParser -lLLVMFuzzMutate -lLLVMCoverage -lLLVMTableGen -lLLVMDlltoolDriver -lLLVMOrcJIT -lLLVMXCoreDisassembler -lLLVMXCoreCodeGen -lLLVMXCoreDesc -lLLVMXCoreInfo -lLLVMXCoreAsmPrinter -lLLVMSystemZDisassembler -lLLVMSystemZCodeGen -lLLVMSystemZAsmParser -lLLVMSystemZDesc -lLLVMSystemZInfo -lLLVMSystemZAsmPrinter -lLLVMSparcDisassembler -lLLVMSparcCodeGen -lLLVMSparcAsmParser -lLLVMSparcDesc -lLLVMSparcInfo -lLLVMSparcAsmPrinter -lLLVMPowerPCDisassembler -lLLVMPowerPCCodeGen -lLLVMPowerPCAsmParser -lLLVMPowerPCDesc -lLLVMPowerPCInfo -lLLVMPowerPCAsmPrinter -lLLVMNVPTXCodeGen -lLLVMNVPTXDesc -lLLVMNVPTXInfo -lLLVMNVPTXAsmPrinter -lLLVMMSP430CodeGen -lLLVMMSP430Desc -lLLVMMSP430Info -lLLVMMSP430AsmPrinter -lLLVMMipsDisassembler -lLLVMMipsCodeGen -lLLVMMipsAsmParser -lLLVMMipsDesc -lLLVMMipsInfo -lLLVMMipsAsmPrinter -lLLVMLanaiDisassembler -lLLVMLanaiCodeGen -lLLVMLanaiAsmParser -lLLVMLanaiDesc -lLLVMLanaiAsmPrinter -lLLVMLanaiInfo -lLLVMHexagonDisassembler -lLLVMHexagonCodeGen -lLLVMHexagonAsmParser -lLLVMHexagonDesc -lLLVMHexagonInfo -lLLVMBPFDisassembler -lLLVMBPFCodeGen -lLLVMBPFAsmParser -lLLVMBPFDesc -lLLVMBPFInfo -lLLVMBPFAsmPrinter -lLLVMARMDisassembler -lLLVMARMCodeGen -lLLVMARMAsmParser -lLLVMARMDesc -lLLVMARMInfo -lLLVMARMAsmPrinter -lLLVMARMUtils -lLLVMAMDGPUDisassembler -lLLVMAMDGPUCodeGen -lLLVMAMDGPUAsmParser -lLLVMAMDGPUDesc -lLLVMAMDGPUInfo -lLLVMAMDGPUAsmPrinter -lLLVMAMDGPUUtils -lLLVMAArch64Disassembler -lLLVMAArch64CodeGen -lLLVMAArch64AsmParser -lLLVMAArch64Desc -lLLVMAArch64Info -lLLVMAArch64AsmPrinter -lLLVMAArch64Utils -lLLVMObjectYAML -lLLVMLibDriver -lLLVMOption -lLLVMWindowsManifest -lLLVMX86Disassembler -lLLVMX86AsmParser -lLLVMX86CodeGen -lLLVMGlobalISel -lLLVMSelectionDAG -lLLVMAsmPrinter -lLLVMX86Desc -lLLVMMCDisassembler -lLLVMX86Info -lLLVMX86AsmPrinter -lLLVMX86Utils -lLLVMMCJIT -lLLVMLineEditor -lLLVMInterpreter -lLLVMExecutionEngine -lLLVMRuntimeDyld -lLLVMCodeGen -lLLVMTarget -lLLVMCoroutines -lLLVMipo -lLLVMInstrumentation -lLLVMVectorize -lLLVMScalarOpts -lLLVMLinker -lLLVMIRReader -lLLVMAsmParser -lLLVMInstCombine -lLLVMBitWriter -lLLVMAggressiveInstCombine -lLLVMTransformUtils -lLLVMAnalysis -lLLVMProfileData -lLLVMObject -lLLVMMCParser -lLLVMMC -lLLVMDebugInfoCodeView -lLLVMDebugInfoMSF -lLLVMBitReader -lLLVMCore -lLLVMBinaryFormat -lLLVMSupport -lLLVMDemangle -lz -lcurses -lm -lxml2 -std=c++0x

all: $(PROGRAMS)

add_arrays: tests/add_arrays.cpp
	$(CXX) $^ -o tests/$@ $(CFLAGS)

arrays_by_reference: tests/arrays_by_reference.cpp
	$(CXX) $^ -o tests/$@ $(CFLAGS)

arrays_by_value: tests/arrays_by_value.cpp
	$(CXX) $^ -o tests/$@ $(CFLAGS)

string_array_by_reference: tests/string_array_by_reference.cpp
	$(CXX) $^ -o tests/$@ $(CFLAGS)

sample: sample.cpp
	$(CXX) $^ -o $@ $(CFLAGS)

negate: tests/negate.cpp
	$(CXX) $^ -o tests/$@ $(CFLAGS)

bitwise: tests/bitwise.cpp
	$(CXX) $^ -o tests/$@ $(CFLAGS)

putX: tests/putX.cpp
	$(CXX) $^ -o tests/$@ $(CFLAGS)

boolTo: tests/boolTo.cpp
	$(CXX) $^ -o tests/$@ $(CFLAGS)

globalVariable: tests/globalVariable.cpp
	$(CXX) $^ -o tests/$@ $(CFLAGS)

produceBool: tests/produceBool.cpp
	$(CXX) $^ -o tests/$@ $(CFLAGS)

referenceVar: tests/referenceVar.cpp
	$(CXX) $^ -o tests/$@ $(CFLAGS)

stringArg: tests/stringArg.cpp
	$(CXX) $^ -o tests/$@ $(CFLAGS)

getX: tests/getX.cpp
	$(CXX) $^ -o tests/$@ $(CFLAGS)

logical_operators: tests/logical_operators.cpp
	$(CXX) $^ -o tests/$@ $(CFLAGS)

logical_operators_single_arrays: tests/logical_operators_single_arrays.cpp
	$(CXX) $^ -o tests/$@ $(CFLAGS)

logical_operators_arrays: tests/logical_operators_arrays.cpp
	$(CXX) $^ -o tests/$@ $(CFLAGS)

clean:
	rm -r $(PROGRAMS)
