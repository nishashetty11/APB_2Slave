//------------------------------------------------------------------------------
// Project      : APB
// File Name    : ApbEnvironment.sv
// Developers   : Nisha Shetty
//------------------------------------------------------------------------------
// Copyright    : 2024(c) Manipal Center of Excellence. All rights reserved.
//------------------------------------------------------------------------------

class ApbEnvironment extends uvm_env;

  // Factory registration for the environment class
  `uvm_component_utils(ApbEnvironment)

  // Declare handles for the active and passive agents, scoreboard, and coverage collector
  ApbActiveAgent act_h;   
  ApbPassiveAgent pass_h; 
  ApbScoreboard scb_h;    
  ApbCoverage cov_h;      

  // Constructor for initializing the ApbEnvironment
  function new(string name = "ApbEnvironment", uvm_component parent);
    super.new(name, parent);  
  endfunction

  //--------------------------------------------------------------------------------
  // Build phase: Initializes the environment components
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase); 
    // Create the active agent to generate transactions
    act_h = ApbActiveAgent::type_id::create("act_h", this);
    // Create the passive agent to monitor transactions
    pass_h = ApbPassiveAgent::type_id::create("pass_h", this);
    // Create the scoreboard to verify the transactions
    scb_h = ApbScoreboard::type_id::create("scb_h", this);
    // Create the coverage collector to track coverage
    cov_h = ApbCoverage::type_id::create("cov_h", this);
  endfunction : build_phase

  //--------------------------------------------------------------------------------
  // Connect phase: Connects the components within the environment
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);  
    // Connect the item_collected_port of the active agent to the scoreboard's input port
    act_h.mon.item_collected_port.connect(scb_h.in_mon_port);
    //Connect the item_collected_port of the passive agent to the scoreboard's output port
    pass_h.mon.item_collected_port.connect(scb_h.out_mon_port);
    //Connect the active agent's monitor to the coverage collector's input
    act_h.mon.item_collected_port.connect(cov_h.ip_mon_imp);
    // Connect the passive agent's monitor to the coverage collector's output
    pass_h.mon.item_collected_port.connect(cov_h.op_mon_imp);
  endfunction : connect_phase

endclass: ApbEnvironment
