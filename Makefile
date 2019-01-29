CXX=g++
PROGRAMS=sample negate bitwise putX boolTo
# g++ sample.cpp `$(brew --prefix llvm)/bin/llvm-config --cppflags --ldflags --libs --system-libs core` -std=c++0x
CFLAGS=-I/usr/local/Cellar/llvm/7.0.1/include -D__STDC_CONSTANT_MACROS -D__STDC_FORMAT_MACROS -D__STDC_LIMIT_MACROS -L/usr/local/Cellar/llvm/7.0.1/lib -Wl,-search_paths_first -Wl,-headerpad_max_install_names -lLLVMCore -lLLVMBinaryFormat -lLLVMSupport -lLLVMDemangle -lz -lcurses -lm -lxml2 -std=c++0x

all: $(PROGRAMS)

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

clean:
	rm -r $(PROGRAMS)
