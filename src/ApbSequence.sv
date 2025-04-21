//------------------------------------------------------------------------------
// Project      : APB
// File Name    : ApbSequence.sv
// Developers   :Nisha Shetty
//------------------------------------------------------------------------------
// Copyright    : 2024(c) Manipal Center of Excellence. All rights reserved.
//----------------------------------------------------------------------------

//-----------------------------------------------------------------------------------
//APB_SEQUENCEPSEUDOCODE:
//-----------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------
// ApbSequence is a user-defined class which is extended from uvm_sequence,
// a predefined UVM class used for driving transactions to the driver.
//-----------------------------------------------------------------------------------

class ApbSequence extends uvm_sequence #(ApbSeqItem)

  // Factory registration for enabling object creation using type_id::create
  `uvm_object_utils(ApbSequence)

  // Handle for the transaction item of type ApbSeqItem
  ApbSeqItem txn;

  //---------------------------------------------------------------------------------
  // Constructor
  // Initializes the base class with optional name
  //---------------------------------------------------------------------------------
  function new(string name = "ApbSequence");
    super.new(name);
  endfunction : new

  //---------------------------------------------------------------------------------
  // Task: body
  // Called when sequence is started. This task creates a transaction,
  // randomizes it, and sends it to the driver through sequencer.
  //---------------------------------------------------------------------------------
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

//Other sequences bases on testcases


