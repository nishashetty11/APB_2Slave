

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
    txn = ApbSeqItem::type_id::create("txn");

    repeat(10) begin
      `uvm_do_with(txn, {transfer == 1; READ_WRITE == 0; apb_write_paddr[8] == 0;})
      `uvm_send(txn);
      $display("WRITE ADDRESS == %b", txn.apb_write_paddr);
      $display("SLAVE 1");
    end
  endtask : body

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

      `uvm_do_with(txn, {transfer == 1; READ_WRITE == 0; apb_write_paddr[8] == 1;})
      `uvm_send(txn);
//   $display("----------------------------------------------SEQUENCE-------------------------------------------------------");
  // txn.print();
  $display("WRITE ADDRESS == %b",txn.apb_write_paddr);
    $display("SLAVE 2 ");
  // $display("----------------------------------------------SEQUENCE-------------------------------------------------------");
  
 //    start_item(txn); 

end
  endtask

endclass
//////////////APBREADSLAVE1SEQUENCE/////////////////
/*class ApbReadSlave1Sequence extends ApbSequence;

  `uvm_object_utils(ApbReadSlave1Sequence)

  function new(string name = "ApbReadSlave1Sequence");
    super.new(name);
  endfunction : new

  ApbSeqItem txn;

  virtual task body();
    txn = ApbSeqItem::type_id::create("txn");
repeat(10) begin
      `uvm_do_with(txn, {transfer == 1; READ_WRITE == 1; apb_write_paddr[8] == 0;})
       `uvm_send(txn);
//   $display("----------------------------------------------SEQUENCE-------------------------------------------------------");
  // txn.print();
  $display("READ ADDRESS == %b",txn.apb_read_paddr);
  $display("SLAVE 1");
  // $display("----------------------------------------------SEQUENCE-------------------------------------------------------");
  
end
  endtask

endclass

*/
class ApbReadSlave1Sequence extends ApbSequence;

  `uvm_object_utils(ApbReadSlave1Sequence)

  function new(string name = "ApbReadSlave1Sequence");
    super.new(name);
  endfunction

  ApbSeqItem txn;

  virtual task body();
    txn = ApbSeqItem::type_id::create("txn");

    repeat(10) begin
      `uvm_do_with(txn, {
        transfer        == 1;
        READ_WRITE      == 1;
        apb_read_paddr[8] ==0; // common hold-causing addresses
      })

    //  $display("[SEQ] Issued READ @ time %0t, ADDR = %h", $time, txn.apb_read_paddr);
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
      `uvm_do_with(txn, {transfer == 1; READ_WRITE == 1; apb_read_paddr[8] == 1;})
/*if (!txn.randomize() with {
  txn.transfer == 1;
  txn.READ_WRITE == 1;
  txn.apb_read_paddr[8] == 1;
})
  `uvm_error("SEQ", "Randomization failed");
*/
 // `uvm_send(txn);
//   $display("----------------------------------------------SEQUENCE-------------------------------------------------------");
  // txn.print();
    $display("READ ADDRESS = %b",txn.apb_read_paddr);
    $display("SLAVE 2 ");
 // $display("----------------------------------------------SEQUENCE-------------------------------------------------------");
  
     start_item(txn); 

    finish_item(txn);
end
  endtask

endclass
/*
class ApbWriteReadSequence extends ApbSequence;
  `uvm_object_utils(ApbWriteReadSequence)

  ApbSeqItem txn;
  bit [8:0] addr;

  function new(string name = "ApbWriteReadSequence");
    super.new(name);
  endfunction

  virtual task body();
    repeat (8) begin
      `uvm_do_with(txn, {
        transfer == 1;
        READ_WRITE == 0;               // 0 = WRITE
        apb_write_paddr[8] == 1;
      })
    `uvm_send(txn);
 //    txn.apb_write_paddr.rand_mode(0);
      addr = txn.apb_write_paddr;

      `uvm_do_with(txn, {
        transfer == 1;
        READ_WRITE == 1;               // 1 = READ
        apb_read_paddr == addr;
      })

//     `uvm_send(txn);
    end
  endtask
endclass

*/



class ApbWriteReadSequence extends uvm_sequence #(ApbSeqItem);
  `uvm_object_utils(ApbWriteReadSequence)

  ApbSeqItem txn;
  bit [8:0] addr;
  function new(string name = "ApbWriteReadSequence");
    super.new(name);
  endfunction

  virtual task body();
    repeat (4) begin
      // WRITE transaction
      `uvm_do_with(txn, {
        transfer == 1;
        READ_WRITE == 0;                // 0 = WRITE
        apb_write_paddr[8] == 1;
      })
      addr = txn.apb_write_paddr;


      // READ transaction
      `uvm_do_with(txn, {
        transfer == 1;
        READ_WRITE == 1;                // 1 = READ
        apb_read_paddr == addr;
      })
    end
  endtask
endclass


  












    
