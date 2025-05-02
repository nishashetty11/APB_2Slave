

class ApbSequence extends uvm_sequence #(ApbSeqItem);

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
//////////////////////APBWRITESLAVE1SEQUENCE//////////////////////////////////
class ApbWriteSlave1Sequence extends ApbSequence;

  `uvm_object_utils(ApbWriteSlave1Sequence)

  function new(string name = "ApbWriteSlave1Sequence");
    super.new(name);
  endfunction : new

  ApbSeqItem txn;

  virtual task body();
    // Create the transaction object
    txn = ApbSeqItem::type_id::create("txn");
   repeat(10) begin
if (!txn.randomize() with {
  txn.transfer == 1;
  txn.READ_WRITE == 0;
  txn.apb_write_paddr[8] == 0;
})
  `uvm_error("SEQ", "Randomization failed");

//   $display("----------------------------------------------SEQUENCE-------------------------------------------------------");
  // txn.print();
  $display("WRITE ADDRESS == %b",txn.apb_write_paddr);
  // $display("----------------------------------------------SEQUENCE-------------------------------------------------------");
  
     start_item(txn); 

    finish_item(txn);
end
  endtask

endclass
////////////////APBWRITESLAVE2SEQUENCE////////////////////////////////////////////////
class ApbWriteSlave2Sequence extends ApbSequence;

  `uvm_object_utils(ApbWriteSlave2Sequence)

  function new(string name = "ApbWriteSlave2Sequence");
    super.new(name);
  endfunction : new

  ApbSeqItem txn;

  virtual task body();

    txn = ApbSeqItem::type_id::create("txn");

 repeat(10) begin
if (!txn.randomize() with {
  txn.transfer == 1;
  txn.READ_WRITE == 0;
  txn.apb_write_paddr[8] == 1;
})
  `uvm_error("SEQ", "Randomization failed");

//   $display("----------------------------------------------SEQUENCE-------------------------------------------------------");
  // txn.print();
  $display("WRITE ADDRESS == %b",txn.apb_write_paddr);
  // $display("----------------------------------------------SEQUENCE-------------------------------------------------------");
  
     start_item(txn); 

    finish_item(txn);
end
  endtask

endclass
//////////////APBREADSLAVE1SEQUENCE/////////////////
class ApbReadSlave1Sequence extends ApbSequence;

  `uvm_object_utils(ApbReadSlave1Sequence)

  function new(string name = "ApbReadSlave1Sequence");
    super.new(name);
  endfunction : new

  ApbSeqItem txn;

  virtual task body();
    txn = ApbSeqItem::type_id::create("txn");
repeat(10) begin
if (!txn.randomize() with {
  txn.transfer == 1;
  txn.READ_WRITE == 1;
  txn.apb_read_paddr[8] == 0;
})
  `uvm_error("SEQ", "Randomization failed");

//   $display("----------------------------------------------SEQUENCE-------------------------------------------------------");
  // txn.print();
  $display("WRITE ADDRESS == %b",txn.apb_write_paddr);
  // $display("----------------------------------------------SEQUENCE-------------------------------------------------------");
  
     start_item(txn); 

    finish_item(txn);
end
  endtask

endclass


////////////////////////APBREADSLAVE2SEQUENCE///////////////////////
class ApbReadSlave2Sequence extends ApbSequence;

  `uvm_object_utils(ApbReadSlave2Sequence)

  function new(string name = "ApbReadSlave2Sequence");
    super.new(name);
  endfunction : new

  ApbSeqItem txn;

  virtual task body();
    // Create the transaction object
    txn = ApbSeqItem::type_id::create("txn");
repeat(10) begin
if (!txn.randomize() with {
  txn.transfer == 1;
  txn.READ_WRITE == 1;
  txn.apb_read_paddr[8] == 1;
})
  `uvm_error("SEQ", "Randomization failed");

//   $display("----------------------------------------------SEQUENCE-------------------------------------------------------");
  // txn.print();
  $display("WRITE ADDRESS == %b",txn.apb_write_paddr);
  // $display("----------------------------------------------SEQUENCE-------------------------------------------------------");
  
     start_item(txn); 

    finish_item(txn);
end
  endtask

endclass

class ApbWriteReadSequence extends ApbSequence;

  `uvm_object_utils(ApbWriteReadSequence)

  function new(string name = "ApbWriteReadSequence");
    super.new(name);
  endfunction : new

  ApbSeqItem write_txn;
  ApbSeqItem read_txn;

  virtual task body();

    // Create and randomize the write transaction

    write_txn = ApbSeqItem::type_id::create("write_txn");
    if (!write_txn.randomize() with {
      write_txn.transfer == 1;
      write_txn.READ_WRITE == 0; // Write operation
      apb_write_paddr[8] == 1;
    }) 
      `uvm_error("SEQ", "Write transaction randomization failed")
   

    // Display write transaction details
    $display("WRITE ADDRESS == %b", write_txn.apb_write_paddr);
    $display("WRITE DATA    == %h", write_txn.apb_write_data);

    // Start and finish the write transaction
    start_item(write_txn);
    finish_item(write_txn);

    // Create the read transaction using the same address
    read_txn = ApbSeqItem::type_id::create("read_txn");
    read_txn.transfer = 1;
    read_txn.READ_WRITE = 1; // Read operation
    read_txn.apb_read_paddr = write_txn.apb_write_paddr;

    // Start and finish the read transaction
    start_item(read_txn);
    finish_item(read_txn);

    // Optionally, compare the read data with the written data
    if (read_txn.apb_read_data_out !== write_txn.apb_write_data) begin
      `uvm_error("SEQ", $sformatf("Data mismatch: Written %h, Read %h",
                  write_txn.apb_write_data, read_txn.apb_read_data_out))
    end else begin
      `uvm_info("SEQ", $sformatf("Data match: %h", read_txn.apb_read_data_out), UVM_LOW)
    end

  endtask : body

endclass : ApbWriteReadSequence


  





  












    
