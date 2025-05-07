

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
repeat(100) begin
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
repeat(100) begin
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
/*
class ApbWriteReadSequence extends ApbSequence;

  `uvm_object_utils(ApbWriteReadSequence)

  function new(string name = "ApbWriteReadSequence");
    super.new(name);
  endfunction : new

  ApbSeqItem txn;

  virtual task body();


    txn = ApbSeqItem::type_id::create("txn");
    if (!txn.randomize() with {
      txn.transfer == 1;
      txn.READ_WRITE == 0; // Write operation
      txn.apb_write_paddr[8] == 1;
    }) 
      `uvm_error("SEQ", "Write transaction randomization failed")
   

    // Display write transaction details
    $display("WRITE ADDRESS == %b", txn.apb_write_paddr);
    $display("WRITE DATA    == %h", txn.apb_write_data);

    // Start and finish the write transaction
  //  start_item(write_txn);
   //  finish_item(write_txn);
     txn.apb_write_paddr.rand_mode(0);
     txn.apb_write_data.rand_mode(0);

    // Create the read transaction using the same address
    txn.transfer = 1;
    read_txn.READ_WRITE = 1; // Read operation
    read_txn.apb_read_paddr = write_txn.apb_write_paddr;
   
    `uvm_do_with(txn,{txn.transfer ==1 , txn.READ_WRITE ==1, txn.apb_read_paddr == txn.apb_write_paddr});
    // Start and finish the read transaction
    start_item(read_txn);
    finish_item(read_txn);

    // Optionally, compare the read data with the written data
    if (read_txn.apb_read_data_out !== write_txn.apb_write_data) begin
      `uvm_error("SEQ", $sformatf("Data mismatch: Written %h, Read %h",1A
                  write_txn.apb_write_data, read_txn.apb_read_data_out))
    end else begin
      `uvm_info("SEQ", $sformatf("Data match: %h", read_txn.apb_read_data_out), UVM_LOW)
    end

  endtask : body

endclass : ApbWriteReadSequence
*/
class ApbWriteReadSequence extends ApbSequence;

  `uvm_object_utils(ApbWriteReadSequence)

  ApbSeqItem txn;

  function new(string name = "ApbWriteReadSequence");
    super.new(name);
  endfunction

  virtual task body();
    repeat (5) begin

      // WRITE
      `uvm_do_with(txn, {
        transfer == 1;
        READ_WRITE == 1; // 1 for WRITE
        apb_write_paddr[8] == 1;
      })
      
      txn.apb_write_paddr.rand_mode(0);
      txn.apb_read_paddr.rand_mode(0);

      // READ
      `uvm_do_with(txn, {
        transfer == 1;
        READ_WRITE == 0; // 0 for READ
        apb_read_paddr == txn.apb_write_paddr;
      })

    end
  endtask

endclass






  












    
