

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
   repeat(5) begin
if (!txn.randomize() with {
  txn.transfer == 1;
  txn.READ_WRITE == 1;
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

 repeat(5) begin
if (!txn.randomize() with {
  txn.transfer == 1;
  txn.READ_WRITE == 1;
  txn.apb_write_paddr[8] == 1;
});
end
  `uvm_error("SEQ", "Randomization failed");
   $display("----------------------------------------------SEQUENCE-------------------------------------------------------");

        txn.print();
   $display("----------------------------------------------SEQUENCE-------------------------------------------------------");
    // Start and finish transaction
    start_item(txn);
    finish_item(txn);
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
repeat(5) begin
if (!txn.randomize() with {
  txn.transfer == 1;
  txn.READ_WRITE == 0;
  txn.apb_write_paddr[8] == 0;
});
end
  `uvm_error("SEQ", "Randomization failed");
   $display("----------------------------------------------SEQUENCE-------------------------------------------------------");
        txn.print();
   $display("----------------------------------------------SEQUENCE-------------------------------------------------------");
    // Start and finish transaction
    start_item(txn);
    finish_item(txn);
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
repeat(5) begin
if (!txn.randomize() with {
  txn.transfer == 1;
  txn.READ_WRITE == 0;
  txn.apb_write_paddr[8] == 1;
});
end
  `uvm_error("SEQ", "Randomization failed");
   $display("----------------------------------------------SEQUENCE-------------------------------------------------------");

      txn.print();
   $display("----------------------------------------------SEQUENCE-------------------------------------------------------");
    // Start and finish transaction
    start_item(txn);
    finish_item(txn);
  endtask

endclass



  





  












    
