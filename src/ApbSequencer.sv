//------------------------------------------------------------------------------
// Project      : APB_2Slave
// File Name    :ApbSequencer.sv
// Developers   :Nisha Shetty
//------------------------------------------------------------------------------
// Copyright    : 2024(c) Manipal Center of Excellence. All rights reserved.
//----------------------------------------------------------------------------

// APB_SEQUENCER PSEUDOCODE:
//-----------------------------------------------------------------------------------
// ApbSequencer is a user-defined class which is extended from uvm_sequencer,
// a pre-defined UVM class for managing APB sequence items


class ApbSequencer extends uvm_sequencer #(ApbSeqItem);
// Factory registration
`uvm_component_utils(ApbSequencer)
// Constructor
// - Accepts component name and parent
// - Calls the super class constructor to register with the UVM factory
function new(string name = "ApbSequencer", uvm_component parent);
  super.new(name, parent);
endfunction
                                           
endclass : ApbSequencer

