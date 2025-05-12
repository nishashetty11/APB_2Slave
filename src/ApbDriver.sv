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
   repeat(2)  @(vif.drv_cb);
    forever begin
     // wait(vif.presetn); // Wait until reset is released
      seq_item_port.get_next_item(txn); // Get transaction from sequence
      drive(); // Call drive task to apply txn to interface
      seq_item_port.item_done(); // Notify UVM that item is done
    end
  endtask: run_phase

virtual task drive();
  @(vif.drv_cb) begin
 if (!vif.presetn)
      begin
 //       @(vif.drv_cb);
        vif.transfer <='b0;
        vif.READ_WRITE <='b0;
        vif.apb_write_paddr <='b0;
        vif.apb_write_data <= 'b0;
        vif.apb_read_paddr <= 'b0;
     end
   else
     begin


 
           vif.drv_cb.transfer <= txn.transfer;
           vif.drv_cb.READ_WRITE <= txn.READ_WRITE;
//           if(txn.READ_WRITE) begin
           //vif.drv_cb.apb_write_paddr <= txn.apb_write_paddr;
          // vif.drv_cb.apb_write_data <= txn.apb_write_data;
           vif.drv_cb.apb_read_paddr <= txn.apb_read_paddr;
  //         end
    //         else
           vif.drv_cb.apb_write_paddr <= txn.apb_write_paddr;
           vif.drv_cb.apb_write_data <= txn.apb_write_data;

          // vif.drv_cb.apb_read_paddr <= txn.apb_read_paddr;
end 
`uvm_info("DRIVER", $sformatf("[%0t] presetn = %b, transfer = %b, READ_WRITE = %b, apb_write_paddr = %h, apb_write_data = %h, apb_read_paddr = %h",
                              $time, vif.presetn, txn.transfer, txn.READ_WRITE, txn.apb_write_paddr, txn.apb_write_data, txn.apb_read_paddr), UVM_LOW)
      
$display("---------------------------------DRIVER-------------------");
          txn.print();
        $display("--------------------------------------DRIVER----------------------------------");

 end
endtask



endclass: ApbDriver
