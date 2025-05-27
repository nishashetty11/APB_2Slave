#!/bin/bash

mkdir -p logs

while read testname; do
  echo "Running test: $testname"
  vsim -c work.top +UVM_TESTNAME=$testname -do "run -all; exit" -l logs/$testname.log
done < testlist.txt

