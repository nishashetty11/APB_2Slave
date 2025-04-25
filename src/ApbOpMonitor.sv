

class ApbOpMonitor extends uvm_monitor;

  `uvm_component_utils(ApbOpMonitor)

  virtual ApbInterface vif;

  ApbSeqItem op_mon_h;

  uvm_analysis_port #(ApbSeqItem) item_collected_port;

  //--------------------------------------------------------------------------------
  // Function: Constructor
  function new (string name="ApbOpMonitor", uvm_component parent);
    super.new(name, parent);
    item_collected_port = new("item_collected_port", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    op_mon_h = ApbSeqItem::type_id::create("op_mon_h");
    if (!uvm_config_db#(virtual ApbInterface)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", {"virtual interface must be set for: ", get_full_name(), ".vif"});
  endfunction

  virtual task run_phase(uvm_phase phase);
     forever 
       begin
         @(vif.mon_cb) ;
           op_mon_h.transfer <= vif.transfer;
           op_mon_h.READ_WRITE <=vif.READ_WRITE;
           op_mon_h.apb_write_paddr <= vif.apb_write_paddr;
           op_mon_h.apb_write_data <= vif.apb_write_data;
           op_mon_h.apb_read_paddr <= vif.apb_read_paddr;
           op_mon_h.apb_read_data_out <= vif.apb_read_data_out;
          item_collected_port.write(op_mon_h);
   $display("----------------------------------------------OUTPUT MONITOR-------------------------------------------------------");

          `uvm_info("OUTPUT MONITOR",$sformatf("[%0t] transfer =%b , READ_WRITE =%b, apb_write_paddr =%h , apb_write_data =%h , apb_read_paddr =%h, apb_read_data=%0h",$time, vif.transfer, vif.READ_WRITE, vif.apb_write_paddr, vif.apb_write_data, vif.apb_read_paddr, vif.apb_read_data_out),UVM_LOW)
 
   $display("----------------------------------------------OUTPUT MONITOR-------------------------------------------------------");
   end
           
  endtask

endclass
