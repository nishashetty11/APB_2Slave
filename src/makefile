# ========================== DEFAULT TARGET =============================
usage:
	@echo ""
	@echo "------------------------- Usage ---------------------------------"
	@echo "make compile                  # Compile testbench"
	@echo "make run                      # Run simulation"
	@echo "make compile_with_cov         # Compile with functional coverage"
	@echo "make run_with_cov             # Run with functional coverage"
	@echo "make simulate_test TEST=Name  # Run specific UVM test"
	@echo "make merge_cov_report         # Merge coverage from multiple runs"
	@echo "make view                     # View waveform"
	@echo "make clean                    # Clean all"
	@echo "-----------------------------------------------------------------"

# ========================== FILES & VARIABLES ==========================
top_file     = ApbTop.sv
top_module   = top
design_file  = ApbDesign.sv
arg          = +UVM_VERBOSITY=UVM_MEDIUM

# ========================== COMPILATION ================================
compile:
	vlib work
	vlog -l compile.log ../src/$(top_file)

# ========================== RUN WITHOUT COVERAGE =======================
run:
	vsim -c -novopt -suppress 12110 work.$(top_module) $(arg) \
	     -l run.log -do "run -all; exit;" -wlf waveform.wlf

# ========================== VIEW WAVES ================================
view:
	vsim -view waveform.wlf

# ========================== COMPILATION WITH COVERAGE ==================
compile_with_cov:
	vlib work
	vlog -sv +acc +cover +fcover -l compile.log ../src/$(top_file)

# ========================== SIMULATION WITH COVERAGE ===================
run_with_cov:
	vlib work
	vlog -sv +acc +cover +fcover -l compile.log ../src/$(top_file)
	vsim -vopt work.$(top_module) $(arg) \
	     -voptargs=+acc=npr -assertdebug -l run.log -coverage -c \
	     -do "coverage save -onexit -assert -directive -cvg -codeAll coverage.ucdb; run -all; exit"
	vcover report -html coverage.ucdb -htmldir covReport -details
	@echo "-----------------------------------------------------------------"
	@echo "Coverage report: firefox covReport/index.html &"
	@echo "-----------------------------------------------------------------"
	@echo ""

# ========================== SIMULATE SPECIFIC UVM TEST =================
simulate_test:
ifndef TEST
	$(error TEST not set. Usage: make simulate_test TEST=YourTestName)
endif
	vsim -vopt work.$(top_module) +UVM_TESTNAME=$(TEST) \
	     -voptargs=+acc=npr -assertdebug -l run.log -coverage -c \
	     -do "coverage save -onexit -assert -directive -cvg -codeAll coverage.ucdb; run -all; exit"
	vcover report -html coverage.ucdb -htmldir covReport -details
	@echo ""
	@echo "-----------------------------------------------------------------"
	@echo "Coverage report: firefox covReport/index.html &"
	@echo "-----------------------------------------------------------------"
	@echo ""

# ========================== CLEAN ALL ==================================
clean:
	rm -rf transcript *.vcd *.wlf work/ *.log *.ucdb *.vstf covReport covhtmlreport ApbCoverage

