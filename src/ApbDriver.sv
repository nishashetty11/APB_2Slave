class ApbDriver extends uvm_driver#(ApbSeqItem);

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
//  repeat(2)
  //@(vif.drv_cb);
    forever begin
      seq_item_port.get_next_item(txn); // Get transaction from sequence
      drive(); // Call drive task to apply txn to interface
      seq_item_port.item_done(); // Notify UVM that item is done
    end
  endtask: run_phase

virtual task drive();
@(vif.drv_cb);

 @(vif.drv_cb) begin
 if (!vif.presetn)
      begin
     @(vif.drv_cb);
        vif.transfer <='b0;
        vif.READ_WRITE <='b0;
        vif.apb_write_paddr <='b0;
        vif.apb_write_data <= 'b0;
        vif.apb_read_paddr <= 'b0;
     end
   else
     begin
repeat(3)
    @(vif.drv_cb);
           vif.drv_cb.transfer <= txn.transfer;
           vif.drv_cb.READ_WRITE <= txn.READ_WRITE;
//        @(vif.drv_cb);
            if(txn.transfer) begin
           if(txn.READ_WRITE)
           vif.drv_cb.apb_read_paddr <= txn.apb_read_paddr;
         else
     begin
           vif.drv_cb.apb_write_paddr <= txn.apb_write_paddr;
           vif.drv_cb.apb_write_data <= txn.apb_write_data;
        
    end
   end
    else begin
        vif.READ_WRITE <='b0;
        vif.apb_write_paddr <='b0;
        vif.apb_write_data <= 'b0;
        vif.apb_read_paddr <= 'b0;
 
  end
end
      
        $display("---------------------------------DRIVER-------------------");
          txn.print();
        $display("--------------------------------------DRIVER----------------------------------");

 end
endtask



endclass: ApbDriver
