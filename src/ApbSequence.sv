

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

    // Create the transaction object
    txn = ApbSeqItem::type_id::create("txn");
    // Wait for the sequencer to grant the sequence
    wait_for_grant();
    // Randomize the transaction
    assert(txn.randomize());
    // Send the request to the driver
    send_request(txn);
    // Wait until driver completes the request
    wait_for_item_done();
  endtask : body

endclass : ApbSequence

/*class ApbWriteSequenceSlave1 extends ApbSequence;

  `uvm_object_utils(ApbWriteSequenceSlave1)

  function new(string name = "ApbWriteSequenceSlave1");
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

endclass*/

  













    
