class ApbPassiveAgent extends uvm_agent;

  `uvm_component_utils(ApbPassiveAgent)

  ApbOpMonitor op_mon_h;  
  ApbSequencer seqr_h;    

  function new(string name="ApbPassiveAgent", uvm_component parent);
    super.new(name, parent);  
  endfunction

  function void build_phase(uvm_phase phase);
    op_mon_h = ApbOpMonitor::type_id::create("op_mon_h", this);
  endfunction : build_phase

endclass
