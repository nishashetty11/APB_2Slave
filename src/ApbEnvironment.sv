class ApbEnvironment extends uvm_env;

  
  `uvm_component_utils(ApbEnvironment)

  
  ApbActiveAgent act_h;   
  ApbPassiveAgent pass_h; 
  ApbScoreboard scb_h;    
  ApbCoverage cov_h;      

 
  function new(string name = "ApbEnvironment", uvm_component parent);
    super.new(name, parent);  
  endfunction

  
virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  act_h  = ApbActiveAgent::type_id::create("act_h", this);
  pass_h = ApbPassiveAgent::type_id::create("pass_h", this);
  scb_h  = ApbScoreboard::type_id::create("scb_h", this);
  cov_h  = ApbCoverage::type_id::create("cov_h", this);
endfunction : build_phase


  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);  
    act_h.ip_mon_h.item_collected_port.connect(scb_h.in_mon_port);
     pass_h.op_mon_h.item_collected_port.connect(scb_h.out_mon_port);
     act_h.ip_mon_h.item_collected_port.connect(cov_h.ip_mon_imp);
     pass_h.op_mon_h.item_collected_port.connect(cov_h.op_mon_imp);
  endfunction : connect_phase

endclass: ApbEnvironment
