//------------------------------------------------------------------------------
// Project      : APB 
// File Name    : ApbOpMonitor.sv
// Developers   : Nisha Shetty
//------------------------------------------------------------------------------
// Copyright    : 2024(c) Manipal Center of Excellence. All rights reserved.
//------------------------------------------------------------------------------

class ApbOpMonitor extends uvm_monitor;

  // Factory registration
  `uvm_component_utils(ApbOpMonitor)

  // Handle to the virtual interface
  virtual ApbIntf vif;

  // Declaring a handle of ApbSeqItem to hold transaction data
  ApbSeqItem op_mon_h;

  // Analysis port to send collected transactions to scoreboard
  uvm_analysis_port #(ApbSeqItem) item_collected_port;

  //--------------------------------------------------------------------------------
  // Function: Constructor
  // Initializes the class and creates the analysis port for collecting transactions
  function new (string name="ApbOpMonitor", uvm_component parent);
    super.new(name, parent);
    // Create the analysis port which will be used to send monitored items to scoreboard
    item_collected_port = new("item_collected_port", this);
  endfunction

  //--------------------------------------------------------------------------------
  // Function: Build phase
  // This phase initializes necessary components like transaction object and interface.
  // Create a new transaction object (op_mon_h) to hold monitored signal values.
  //  Retrieve the virtual interface (vif) from the UVM config database.
  // If retrieval fails, a fatal error is raised.
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Create a new transaction object using the factory
    // This object will hold the monitored signal values for APB operations
    op_mon_h = ApbSeqItem::type_id::create("op_mon_h");

    // Retrieve the virtual interface from the UVM config database
    // The top-level environment should have set the virtual interface before.
    // If it cannot be retrieved, a fatal error is thrown.
    if (!uvm_config_db#(virtual ApbIntf)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", {"virtual interface must be set for: ", get_full_name(), ".vif"});
  endfunction

  //--------------------------------------------------------------------------------
  // Task: Run phase
  virtual task run_phase(uvm_phase phase);
    // Monitoring logic can be added here (currently empty).
  endtask

endclass
