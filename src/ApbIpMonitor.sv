class ApbIpMonitor extends uvm_monitor;

  `uvm_component_utils(ApbIpMonitor)
  virtual ApbInterface vif;
  ApbSeqItem ip_mon_h;
  
  uvm_analysis_port#(ApbSeqItem) item_collected_port;
 function new (string name="apb_ip_mon", uvm_component parent);
  super.new(name, parent);

  item_collected_port = new("item_collected_port", this);
endfunction : new

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  ip_mon_h = ApbSeqItem::type_id::create("ip_mon_h");

  if (!uvm_config_db#(virtual ApbInterface)::get(this, "", "vif", vif))
    `uvm_fatal("NOVIF", {"virtual interface must be set for: ", get_full_name(), ".vif"});
endfunction : build_phase


virtual task run_phase(uvm_phase phase); 
 forever begin
   @(vif.mon_cb) begin
      ip_mon_h.transfer = vif.transfer;
      ip_mon_h.READ_WRITE =vif.READ_WRITE;
      ip_mon_h.apb_write_data = vif.apb_write_data;
      ip_mon_h.apb_write_paddr = vif.apb_write_paddr;
      ip_mon_h.apb_read_paddr = vif.apb_read_paddr;
      item_collected_port.write(ip_mon_h);
   $display("----------------------------------------------INPUT MONITOR-------------------------------------------------------");
    ip_mon_h.print();
    $display("WRITE ADDRESS = %b  READ ADDRESS =%b ", ip_mon_h.apb_write_paddr, ip_mon_h.apb_read_paddr);
    $display("THE RESET IS %0b",vif.presetn);
   $display("----------------------------------------------INPUT MONITOR-------------------------------------------------------");
  end
end
endtask
endclass: ApbIpMonitor
