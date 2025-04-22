//------------------------------------------------------------------------------
// Project      : APB
// File Name    : ApbDriver.sv
// Developers   :Nisha Shetty
//------------------------------------------------------------------------------
// Copyright    : 2024(c) Manipal Center of Excellence. All rights reserved.
//----------------------------------------------------------------------------
//-----------------------------------------------------------------------------------
// APB_DRIVER PSEUDOCODE:
//-----------------------------------------------------------------------------------
// ApbDriver is a user-defined class which extends from uvm_driver #(ApbSeqItem),
// used to drive stimulus to the DUT through the APB interface.
class ApbDriver extends uvm_driver #(ApbSeqItem)

// Factory registration for ApbDriver
`uvm_component_utils(ApbDriver)

// Constructor of the class
function new(string name = "ApbDriver", uvm_component parent)
  super.new(name, parent)
endfunction: new

// Virtual interface handle to connect to DUT
virtual ApbIntf vif

// Build phase: Get the virtual interface from config DB
function void build_phase(uvm_phase phase)
  super.build_phase(phase)
  if (!uvm_config_db#(virtual ApbIntf)::get(this, "", "vif", vif))
    `uvm_fatal("No vif", {"Set virtual interface to: ", get_full_name(), ".vif"})
endfunction: build_phase

// Handle to sequence item (transaction)
ApbSeqItem txn

// run_phase: Continuously waits for reset to deassert, gets sequence item,
// calls the drive task to send signals to DUT, and completes the item.
task run_phase(uvm_phase phase)
  forever begin
    wait(vif.presetn) // Wait until reset is released
    seq_item_port.get_next_item(txn) // Get transaction from sequence
    drive() // Call drive task to apply txn to interface
    seq_item_port.item_done() // Notify UVM that item is done
  end
endtask: run_phase

// drive task: Drives the transaction signals to the DUT using the virtual interface
task drive()
  // Logic to check READ/WRITE and drive corresponding signals on interface
endtask: drive

endclass: ApbDriver
//-----------------------------------------------------------------------------------
