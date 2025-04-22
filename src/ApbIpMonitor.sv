//------------------------------------------------------------------------------
// Project      : APB
// File Name    : ApbIpMonitor.sv
// Developers   :Nisha Shetty
//------------------------------------------------------------------------------
// Copyright    : 2024(c) Manipal Center of Excellence. All rights reserved.
//----------------------------------------------------------------------------


// ApbIpMonitor is a user-defined class which is extended from uvm_monitor 
// which is a pre-defined UVM class. It monitors signals from the DUT IP side.

class ApbIpMonitor extends uvm_monitor

  // Factory registration
  `uvm_component_utils(ApbIpMonitor)

  // Handle to virtual interface
  virtual ApbIntf vif;

  // Declaring a handle of ApbSeqItem to hold transaction data
  ApbSeqItem ip_mon_h;

  // Analysis port to send collected transactions to scoreboard
  uvm_analysis_port#(ApbSeqItem) item_collected_port;

  //--------------------------------------------------------------------------------
// Function: Class constructor
function ApbIpMonitor::new(string name = "ApbIpMonitor", uvm_component parent = null);
  super.new(name, parent);
  // Create analysis port to send collected transactions
  item_collected_port = new("item_collected_port", this);
endfunction : new

//--------------------------------------------------------------------------------
// Function: Build phase
function void ApbIpMonitor::build_phase(uvm_phase phase);
  super.build_phase(phase);

  // Create a new transaction object using factory
  // This object will be used to store monitored signal values
  ip_mon_h = ApbSeqItem::type_id::create("ip_mon_h");

  // Get the virtual interface from the configuration database
  // The testbench top or environment must have set this interface earlier
  // If it fails to get the interface, it throws a fatal error
  if (!uvm_config_db#(virtual ApbIntf)::get(this, "", "vif", vif))
    `uvm_fatal("NOVIF", {"virtual interface must be set for: ", get_full_name(), ".vif"});
endfunction : build_phase

//--------------------------------------------------------------------------------
// Task: Run phase
task ApbIpMonitor::run_phase(uvm_phase phase);
  
endtask : run_phase
  

endclass: ApbIpMonitor

