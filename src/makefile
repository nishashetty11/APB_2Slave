TESTS = ApbWriteSlave1Test ApbWriteReadSlave2Test ApbWriteReadSlaveTest

all: $(TESTS)

$(TESTS):
	vsim -c -do "run -all; exit" -sv_seed random +UVM_TESTNAME=$@ work.top -l logs/$@.log

clean:
	rm -f *.log *.ucdb transcript

