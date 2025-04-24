class ApbActiveAgent extends uvm_agent;
  `uvm_component_utils(ApbActiveAgent)

  ApbSequencer seqr_h;
  ApbDriver drv_h;
  ApbIpMonitor ip_mon_h;

  function new(string name, uvm_component parent);
    super.new(name, parent); 
  endfunction

  function void build_phase(uvm_phase phase);
    if (get_is_active() == UVM_ACTIVE) begin  
      drv_h = ApbDriver::type_id::create("drv_h", this);
      seqr_h = ApbSequencer::type_id::create("seqr_h", this);
    end
    ip_mon_h = ApbIpMonitor::type_id::create("ip_mon_h", this);
  endfunction : build_phase

  
  function void connect_phase(uvm_phase phase);
    if (get_is_active() == UVM_ACTIVE) begin
     
      drv_h.seq_item_port.connect(seqr_h.seq_item_export);
    end
  endfunction : connect_phase

endclass
