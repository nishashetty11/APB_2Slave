# Makefile for SystemVerilog regression with coverage

# Tools (adjust if needed)
VLOG = vlog
VSIM = vsim
VOPT = vopt
VCOV = vsim -coverage

# Directories
SRC_DIR = src
TESTLIST = $(SRC_DIR)/testlist/ApbRegression.list
LOGFILE = $(SRC_DIR)/run.log
COV_DIR = $(SRC_DIR)/covReport

# Source files
SRCS = $(wildcard $(SRC_DIR)/*.sv)

# Top-level testbench or module to simulate (adjust accordingly)
TOPLEVEL = top

# Simulator options
SIM_OPTS = -c -do "run -all; quit"

.PHONY: all compile run coverage clean

all: compile run coverage

compile:
	@echo "Compiling SystemVerilog files..."
	$(VLOG) $(SRCS) | tee $(LOGFILE)

run:
	@echo "Running regression tests listed in $(TESTLIST)..."
	# For each test listed in ApbRegression.list, run simulation (example assumes tests are named)
	@while read test; do \
	  echo "Running test: $$test"; \
	  $(VSIM) $(SIM_OPTS) $(TOPLEVEL) -testname $$test | tee -a $(LOGFILE); \
	done < $(TESTLIST)

coverage:
	@echo "Generating coverage report..."
	mkdir -p $(COV_DIR)
	$(VCOV) -coverage $(TOPLEVEL) -do "report coverage -all; quit" | tee -a $(LOGFILE)
	mv *.ucdb $(COV_DIR) || true

clean:
	@echo "Cleaning intermediate and log files..."
	rm -rf transcript vsim.wlf *.log *.ucdb $(COV_DIR)/* $(LOGFILE)

