class ApbSeqItem extends uvm_sequence_item;

rand bit [`AW - 1:0] apb_write_paddr;   // Write address
rand bit [`AW - 1:0] apb_read_paddr;    // Read address
rand bit [`DW - 1:0] apb_write_data;    // Data to be written
rand bit transfer;                     // Transfer enable signal
rand bit READ_WRITE;                   // 0 = write, 1 = read

bit [`DW - 1:0] apb_read_data_out;     // Output data from read operation
//Factory registration for enabling creation via UVM factory
`uvm_object_utils_begin(ApbSeqItem)
  //Registering all class variables for automation and reporting
  `uvm_field_int(apb_write_paddr, UVM_DEFAULT)
  `uvm_field_int(apb_read_paddr, UVM_DEFAULT)
  `uvm_field_int(apb_write_data, UVM_DEFAULT)
  `uvm_field_int(transfer, UVM_DEFAULT)
  `uvm_field_int(READ_WRITE, UVM_DEFAULT)
  `uvm_field_int(apb_read_data_out, UVM_DEFAULT)
`uvm_object_utils_end


function new(string name = "ApbSeqItem");
  super.new(name); // Calls parent class constructor
endfunction : new

constraint c1_transfer { if(transfer ==0)
                 {READ_WRITE==0;
                 apb_write_paddr==0;
                 apb_write_data==0;
                 apb_read_paddr==0;
                 apb_read_data_out==0;
                }}

  constraint c2_apb_slave_select {
   soft apb_write_paddr[8] dist {0:=1,1:=1};
  }
  constraint c3_write_address {
    if (transfer==1 && READ_WRITE == 1) 
  {
    apb_write_paddr inside {[0:255]}; 
    apb_write_data inside {[0:255]};
  }
}
    constraint c4_read_address {
      if (transfer==1 && READ_WRITE == 0) {
    apb_read_paddr inside {[0:255]}; 
  }
}


endclass : ApbSeqItem

