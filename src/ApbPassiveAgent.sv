//------------------------------------------------------------------------------
// Project      : APB 
// File Name    : ApbPassiveAgent.sv 
// Developers   : Nisha Shetty
//------------------------------------------------------------------------------
// Copyright    : 2024(c) [Your Organization]. All rights reserved.
//------------------------------------------------------------------------------

class ApbPassiveAgent extends uvm_agent;

  // Factory registration macro for the component
  `uvm_component_utils(ApbPassiveAgent)

  // Declare handles for the monitor and sequencer
  ApbOpMonitor op_mon_h;  
  ApbSequencer seqr_h;    

  // Constructor for initializing the ApbPassiveAgent
  function new(string name="ApbPassiveAgent", uvm_component parent);
    super.new(name, parent);  
  endfunction

  //--------------------------------------------------------------------------------
  // Build phase: Initializes the components for the passive agent
  function void build_phase(uvm_phase phase);
    // Create the APB Operation Monitor
    // This component will monitor APB read and write transactions
    op_mon_h = ApbOpMonitor::type_id::create("op_mon_h", this);

  endfunction : build_phase

endclass
