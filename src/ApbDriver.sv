class ApbDriver extends uvm_driver #(ApbSeqItem);

  `uvm_component_utils(ApbDriver)

  virtual ApbInterface vif;

  ApbSeqItem txn;

  function new(string name = "ApbDriver", uvm_component parent = null);
    super.new(name, parent);
  endfunction: new


  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual ApbInterface)::get(this, "", "vif", vif))
      `uvm_fatal("No vif", {"Set virtual interface to: ", get_full_name(), ".vif"});
  endfunction: build_phase

  
  task run_phase(uvm_phase phase);
    forever begin
      wait(vif.presetn); // Wait until reset is released
      seq_item_port.get_next_item(txn); // Get transaction from sequence
      drive(); // Call drive task to apply txn to interface
      seq_item_port.item_done(); // Notify UVM that item is done
    end
  endtask: run_phase

task drive();
   if (!vif.presetn)
      begin
        @(posedge vif.pclk);
        vif.drv_cb.transfer <='b0;
        vif.drv_cb.READ_WRITE <='b0;
        vif.drv_cb.apb_write_paddr <='b0;
        vif.drv_cb.apb_write_data <= 'b0;
        vif.drv_cb.apb_read_paddr <= 'b0;
     end
   else
     begin
       @(posedge vif.pclk);
         vif.drv_cb.transfer <= txn.transfer;
         vif.drv_cb.READ_WRITE <= txn.READ_WRITE;
         if(vif.drv_cb.READ_WRITE) begin
           vif.drv_cb.apb_write_paddr <= txn.apb_write_paddr;
           vif.drv_cb.apb_write_data <= txn.apb_write_data;
          end
         else
           vif.drv_cb.apb_read_paddr <= txn.apb_read_paddr;
       `uvm_info("DRIVER",$sformatf("[%0t] transfer = %b, READ_WRITE = %b, apb_write_paddr =%h , apb_write_data =%h , apb_write_paddr =%h , apb_read_paddr =%h", vif.drv_cb.transfer, vif.drv_cb.READ_WRITE, vif.drv_cb.apb_write_paddr, vif.drv_cb.apb_write_data, vif.drv_cb.apb_read_data),UVM_LOW);
   end
endtask



endclass: ApbDriver
//-----------------------------------------------------------------------------------
