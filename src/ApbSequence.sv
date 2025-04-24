

class ApbSequence extends uvm_sequence #(ApbSeqItem);

  // Factory registration for enabling object creation using type_id::create
  `uvm_object_utils(ApbSequence)

  // Handle for the transaction item of type ApbSeqItem
  ApbSeqItem txn;

  
  function new(string name = "ApbSequence");
    super.new(name);
  endfunction : new

  
  virtual task body;
    `uvm_info("SEQUENCE", "Sequence started", UVM_LOW)

    txn = ApbSeqItem::type_id::create("txn");
    wait_for_grant();
    assert(txn.randomize());
    send_request(txn);
    wait_for_item_done();
  endtask : body

endclass : ApbSequence

class ApbWriteSlave1Sequence extends ApbSequence;

  `uvm_object_utils(ApbWriteSlave1Sequence)

  function new(string name = "ApbWriteSlave1Sequence");
    super.new(name);
  endfunction : new

  ApbSeqItem txn;

  virtual task body();
    // Create the transaction object
    txn = ApbSeqItem::type_id::create("txn");

    // Randomize the transaction
    if (!txn.randomize() with {
        txn.transfer == 1;
        txn.READ_WRITE == 1;
        txn.apb_write_paddr[8] == 0;
      })
      `uvm_error("SEQUENCE", "Randomization failed!")

    `uvm_info("SEQUENCE", $sformatf("[%0t] transfer = %b, READ_WRITE = %b, apb_write_paddr = %h, apb_write_data = %h", 
                $time, txn.transfer, txn.READ_WRITE, txn.apb_write_paddr, txn.apb_write_data), UVM_LOW)

    // Start and finish transaction
    start_item(txn);
    finish_item(txn);
  endtask

endclass

class ApbWriteSlave2Sequence extends ApbSequence;

  `uvm_object_utils(ApbWriteSlave2Sequence)

  function new(string name = "ApbWriteSlave2Sequence");
    super.new(name);
  endfunction : new

  ApbSeqItem txn;

  virtual task body();
    // Create the transaction object
    txn = ApbSeqItem::type_id::create("txn");

    // Randomize the transaction
    if (!txn.randomize() with {
        txn.transfer == 1;
        txn.READ_WRITE == 1;
        txn.apb_write_paddr[8] == 1;
      })
      `uvm_error("SEQUENCE", "Randomization failed!")

    `uvm_info("SEQUENCE", $sformatf("[%0t] transfer = %b, READ_WRITE = %b, apb_write_paddr = %h, apb_write_data = %h", 
                $time, txn.transfer, txn.READ_WRITE, txn.apb_write_paddr, txn.apb_write_data), UVM_LOW)

    // Start and finish transaction
    start_item(txn);
    finish_item(txn);
  endtask

endclass

class ApbReadSlave1Sequence extends ApbSequence;

  `uvm_object_utils(ApbReadSlave1Sequence)

  function new(string name = "ApbReadSlave1Sequence");
    super.new(name);
  endfunction : new

  ApbSeqItem txn;

  virtual task body();
    // Create the transaction object
    txn = ApbSeqItem::type_id::create("txn");

    // Randomize the transaction
    if (!txn.randomize() with {
        txn.transfer == 1;
        txn.READ_WRITE == 0;
        txn.apb_write_paddr[8] == 0;
      })
      `uvm_error("SEQUENCE", "Randomization failed!")

    `uvm_info("SEQUENCE", $sformatf("[%0t] transfer = %b, READ_WRITE = %b, apb_write_paddr = %h, apb_write_data = %h apb_read_paddr =%h apb_read_data_out =%h ", 
                $time, txn.transfer, txn.READ_WRITE, txn.apb_write_paddr, txn.apb_write_data,txn.apb_read_paddr,txn.apb_read_data_out), UVM_LOW)

    // Start and finish transaction
    start_item(txn);
    finish_item(txn);
  endtask

endclass



class ApbReadSlave2Sequence extends ApbSequence;

  `uvm_object_utils(ApbReadSlave2Sequence)

  function new(string name = "ApbReadSlave2Sequence");
    super.new(name);
  endfunction : new

  ApbSeqItem txn;

  virtual task body();
    // Create the transaction object
    txn = ApbSeqItem::type_id::create("txn");

    // Randomize the transaction
    if (!txn.randomize() with {
        txn.transfer == 1;
        txn.READ_WRITE == 0;
        txn.apb_write_paddr[8] == 1;
      })
      `uvm_error("SEQUENCE", "Randomization failed!")

    `uvm_info("SEQUENCE", $sformatf("[%0t] transfer = %b, READ_WRITE = %b, apb_write_paddr = %h, apb_write_data = %h apb_read_paddr =%h apb_read_data_out =%h ", 
                $time, txn.transfer, txn.READ_WRITE, txn.apb_write_paddr, txn.apb_write_data,txn.apb_read_paddr,txn.apb_read_data_out), UVM_LOW)

    // Start and finish transaction
    start_item(txn);
    finish_item(txn);
  endtask

endclass



  





  













    
