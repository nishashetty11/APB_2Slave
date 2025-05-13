

class ApbTest extends uvm_test;

  `uvm_component_utils(ApbTest)
  ApbEnvironment env_h;
  ApbSequence seq_h;

  function new(string name = "ApbTest",uvm_component parent=null);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env_h = ApbEnvironment::type_id::create("env_h", this);
  endfunction

  virtual function void end_of_elaboration();
     uvm_top.print_topology();
  endfunction
  

  task run_phase (uvm_phase phase);
    phase.raise_objection (this);
    seq_h = ApbSequence::type_id::create("seq_h");
    phase.drop_objection (this);
  endtask: run_phase


endclass


class ApbWriteSlave1Test extends ApbTest;

  `uvm_component_utils(ApbWriteSlave1Test)
  ApbEnvironment env_h;
  ApbWriteSlave1Sequence seq_h;

  function new(string name = "ApbWriteSlave1Test",uvm_component parent);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
   super.build_phase(phase);
    env_h = ApbEnvironment::type_id::create("env_h", this);
  endfunction

  virtual function void end_of_elaboration();
     uvm_top.print_topology();
  endfunction


  task run_phase (uvm_phase phase);
    phase.raise_objection (this);
    seq_h = ApbWriteSlave1Sequence::type_id::create("seq_h");
   // repeat(5) begin
    seq_h.start(env_h.act_h.seqr_h); 
  // end
   phase.drop_objection (this);
  endtask: run_phase


endclass
 
class ApbWriteSlave2Test extends ApbTest;

  `uvm_component_utils(ApbWriteSlave2Test)
  ApbEnvironment env_h;
  ApbWriteSlave2Sequence seq_h;

  function new(string name = "ApbWriteSlave2Test",uvm_component parent);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env_h = ApbEnvironment::type_id::create("env_h", this);
  endfunction

  virtual function void end_of_elaboration();
     uvm_top.print_topology();
  endfunction


  task run_phase (uvm_phase phase);
    phase.raise_objection (this);
    seq_h = ApbWriteSlave2Sequence::type_id::create("seq_h");
    seq_h.start(env_h.act_h.seqr_h); 
    phase.drop_objection (this);
  endtask: run_phase


endclass
 
class ApbReadSlave1Test extends ApbTest;

  `uvm_component_utils(ApbReadSlave1Test)
  ApbEnvironment env_h;
  ApbReadSlave1Sequence seq_h;

  function new(string name = "ApbReadSlave1Test",uvm_component parent);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env_h = ApbEnvironment::type_id::create("env_h", this);
  endfunction

  virtual function void end_of_elaboration();
     uvm_top.print_topology();
  endfunction


  task run_phase (uvm_phase phase);
    phase.raise_objection (this);
    seq_h = ApbReadSlave1Sequence::type_id::create("seq_h");
    seq_h.start(env_h.act_h.seqr_h);
    phase.drop_objection (this);
  endtask: run_phase


endclass
 class ApbReadSlave2Test extends ApbTest;

  `uvm_component_utils(ApbReadSlave2Test)
  ApbEnvironment env_h;
  ApbReadSlave2Sequence seq_h;

  function new(string name = "ApbReadSlave2Test",uvm_component parent);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env_h = ApbEnvironment::type_id::create("env_h", this);
  endfunction

  virtual function void end_of_elaboration();
     uvm_top.print_topology();
  endfunction


  task run_phase (uvm_phase phase);
    phase.raise_objection (this);
    seq_h = ApbReadSlave2Sequence::type_id::create("seq_h");
    seq_h.start(env_h.act_h.seqr_h); 
    phase.drop_objection (this);
  endtask: run_phase


endclass


class ApbWriteReadSlave2Test extends uvm_test;

  `uvm_component_utils(ApbWriteReadSlave2Test)
  ApbEnvironment env_h;
  ApbWriteReadSequence seq_h;

  function new(string name = "ApbWriteReadSlave2Test",uvm_component parent);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
   super.build_phase(phase);
    env_h = ApbEnvironment::type_id::create("env_h", this);
  endfunction

  virtual function void end_of_elaboration();
     uvm_top.print_topology();
  endfunction


  task run_phase (uvm_phase phase);
    phase.raise_objection (this);
    seq_h = ApbWriteReadSequence::type_id::create("seq_h");
   // repeat(5) begin
    seq_h.start(env_h.act_h.seqr_h); 
  // end
   phase.drop_objection (this);
phase.phase_done.set_drain_time(this,100);
  endtask: run_phase


endclass




