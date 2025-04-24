//------------------------------------------------------------------------------
// Project      : APB
// File Name    : ApbSeqItem.sv
// Developers   :Nisha Shetty
//------------------------------------------------------------------------------
// Copyright    : 2024(c) Manipal Center of Excellence. All rights reserved.
//----------------------------------------------------------------------------

//-----------------------------------------------------------------------------------
//APB_SEQ_ITEM PSEUDOCODE:
//-----------------------------------------------------------------------------------
//ApbSeqItem is a user-defined class which is extended from uvm_sequence_item,
//a predefined UVM base class for sequence items used in sequences
class ApbSeqItem extends uvm_sequence_item;

//Class properties:
//Randomizable APB transfer signals
rand bit [`AW - 1:0] apb_write_paddr;   // Write address
rand bit [`AW - 1:0] apb_read_paddr;    // Read address
rand bit [`DW - 1:0] apb_write_data;    // Data to be written
rand bit transfer;                     // Transfer enable signal
rand bit READ_WRITE;                   // 0 = write, 1 = read

//Non-random output signal (read data from DUT)
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


//Constructor to initialize the object
function new(string name = "ApbSeqItem");
  super.new(name); // Calls parent class constructor
endfunction : new

endclass : ApbSeqItem

