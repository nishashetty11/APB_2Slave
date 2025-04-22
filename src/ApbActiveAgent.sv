//------------------------------------------------------------------------------
// Project      : APB 
// File Name    : ApbActiveAgent.sv
// Developers   : Nisha Shetty
//------------------------------------------------------------------------------
// Copyright    : 2024(c) Manipal Center of Excellence. All rights reserved.
//------------------------------------------------------------------------------

class ApbActiveAgent extends uvm_agent;

  // Factory registration macro
  `uvm_component_utils(ApbActiveAgent)

  // Declare handles for sequencer, driver, and monitor
  ApbSequencer seqr_h;
  ApbDriver drv_h;
  ApbIpMonitor ip_mon_h;

  // Constructor to initialize the agent
  function new(string name, uvm_component parent);
    super.new(name, parent); // Call parent constructor
  endfunction

  //--------------------------------------------------------------------------------
  // Build phase: Initialize the agent components like driver, sequencer, and monitor
  // Only if the agent is active
  function void build_phase(uvm_phase phase);
    if (get_is_active() == UVM_ACTIVE) begin
      // Create the driver (drv_h) and sequencer (seqr_h) only if the agent is active
      drv_h = ApbDriver::type_id::create("drv_h", this);
      seqr_h = ApbSequencer::type_id::create("seqr_h", this);
    end

    // Create the monitor (ip_mon_h) in all cases
    ip_mon_h = ApbIpMonitor::type_id::create("ip_mon_h", this);
  endfunction : build_phase

  //--------------------------------------------------------------------------------
  // Connect phase: Connect the sequencer and driver
  // Ensures that the sequencer and driver are properly connected
  function void connect_phase(uvm_phase phase);
    if (get_is_active() == UVM_ACTIVE) begin
      // Connect the sequencer's seq_item_export to the driver's seq_item_port
      drv_h.seq_item_port.connect(seqr_h.seq_item_export);
    end
  endfunction : connect_phase

endclass
