

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
  ApbWriteSlave1Sequence seq_h;

  function new(string name = "ApbWriteSlave1Test",uvm_component parent);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
   super.build_phase(phase);
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
  ApbWriteSlave2Sequence seq_h;

  function new(string name = "ApbWriteSlave2Test",uvm_component parent);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
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
  ApbReadSlave1Sequence seq_h;

  function new(string name = "ApbReadSlave1Test",uvm_component parent);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
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
  ApbReadSlave2Sequence seq_h;

  function new(string name = "ApbReadSlave2Test",uvm_component parent);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
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

class ApbWriteReadSlave1Test extends ApbTest;

  `uvm_component_utils(ApbWriteReadSlave1Test)
  ApbWriteReadSlave1Sequence seq_h;

  function new(string name = "ApbWriteReadSlave1Test",uvm_component parent);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
   super.build_phase(phase);
  endfunction

  virtual function void end_of_elaboration();
     uvm_top.print_topology();
  endfunction


  task run_phase (uvm_phase phase);
    phase.raise_objection (this);
    seq_h = ApbWriteReadSlave1Sequence::type_id::create("seq_h");
    seq_h.start(env_h.act_h.seqr_h); 
   phase.drop_objection (this);
phase.phase_done.set_drain_time(this,100);
  endtask: run_phase


endclass

class ApbWriteReadSlave2Test extends ApbTest;

  `uvm_component_utils(ApbWriteReadSlave2Test)
  ApbWriteReadSlave2Sequence seq_h;

  function new(string name = "ApbWriteReadSlave2Test",uvm_component parent);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
   super.build_phase(phase);
  endfunction

  virtual function void end_of_elaboration();
     uvm_top.print_topology();
  endfunction

  task run_phase (uvm_phase phase);
    phase.raise_objection (this);
    seq_h = ApbWriteReadSlave2Sequence::type_id::create("seq_h");
    seq_h.start(env_h.act_h.seqr_h); 
   phase.drop_objection (this);
phase.phase_done.set_drain_time(this,100);
  endtask: run_phase


endclass

class ApbContinuousWRSlave1Test extends ApbTest;

  `uvm_component_utils(ApbContinuousWRSlave1Test)
  ApbContinuousWRSlave1Sequence seq_h;

  function new(string name = "ApbContinuousWRSlave1Test",uvm_component parent);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
   super.build_phase(phase);
  endfunction

  virtual function void end_of_elaboration();
     uvm_top.print_topology();
  endfunction

  task run_phase (uvm_phase phase);
    phase.raise_objection (this);
    seq_h = ApbContinuousWRSlave1Sequence::type_id::create("seq_h");
    seq_h.start(env_h.act_h.seqr_h); 
   phase.drop_objection (this);
phase.phase_done.set_drain_time(this,100);
  endtask: run_phase

endclass
class ApbContinuousWRSlave2Test extends ApbTest;

  `uvm_component_utils(ApbContinuousWRSlave2Test)
  ApbContinuousWRSlave2Sequence seq_h;

  function new(string name = "ApbContinuousWRSlave2Test",uvm_component parent);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
   super.build_phase(phase);
  endfunction

  virtual function void end_of_elaboration();
     uvm_top.print_topology();
  endfunction

  task run_phase (uvm_phase phase);
    phase.raise_objection (this);
    seq_h = ApbContinuousWRSlave2Sequence::type_id::create("seq_h");
    seq_h.start(env_h.act_h.seqr_h); 
   phase.drop_objection (this);
phase.phase_done.set_drain_time(this,100);
  endtask: run_phase

endclass


class ApbRegressionTest extends ApbTest;
  `uvm_component_utils(ApbRegressionTest)

  ApbWriteSlave1Sequence       writeseq1_h;
  ApbWriteSlave2Sequence       writeseq2_h;
   //ApbReadSlave1Sequence     readseq1_h;
  // ApbReadSlave2Sequence     readseq2_h;
  ApbWriteReadSlave1Sequence   writereadseq1_h;
  ApbWriteReadSlave2Sequence   writereadseq2_h;
 ApbContinuousWRSlave1Sequence continuouswrseq1_h;
 ApbContinuousWRSlave2Sequence continuouswrseq2_h;
  function new(string name = "ApbRegressionTest", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    writeseq1_h      = ApbWriteSlave1Sequence::type_id::create("writeseq1_h");
    writeseq2_h      = ApbWriteSlave2Sequence::type_id::create("writeseq2_h");
   //  readseq1_h    = ApbReadSlave1Sequence::type_id::create("readseq1_h");
   //  readseq2_h    = ApbReadSlave2Sequence::type_id::create("readseq2_h");
    writereadseq1_h  = ApbWriteReadSlave1Sequence::type_id::create("writereadseq1_h");
    writereadseq2_h  = ApbWriteReadSlave2Sequence::type_id::create("writereadseq2_h");
    continuouswrseq1_h  = ApbContinuousWRSlave1Sequence::type_id::create("continuouswrseq1_h");
    continuouswrseq2_h  = ApbContinuousWRSlave2Sequence::type_id::create("continuouswrseq2_h");
  endfunction

  virtual function void end_of_elaboration();
    print();
  endfunction

  task run_phase(uvm_phase phase);
  /*  phase.raise_objection(this);
    repeat (5) begin
      readseq1_h.start(env_h.act_h.seqr_h);
    end
    phase.drop_objection(this);

    phase.raise_objection(this);
    repeat (5) begin
      readseq2_h.start(env_h.act_h.seqr_h);
    end
    phase.drop_objection(this);
   */
   phase.raise_objection(this);
    repeat (1) begin
      writereadseq1_h.start(env_h.act_h.seqr_h);
    end
    phase.drop_objection(this);
phase.phase_done.set_drain_time(this,100);

    phase.raise_objection(this);
    repeat (1) begin
      writereadseq2_h.start(env_h.act_h.seqr_h);
    end
    phase.drop_objection(this); 
phase.phase_done.set_drain_time(this,100);
 
    phase.raise_objection(this);
    repeat (1) begin
     continuouswrseq1_h.start(env_h.act_h.seqr_h);
    end
    phase.drop_objection(this);  
phase.phase_done.set_drain_time(this,100);
      phase.raise_objection(this);
    repeat (1) begin
     continuouswrseq2_h.start(env_h.act_h.seqr_h);
    end
    phase.drop_objection(this);  
phase.phase_done.set_drain_time(this,100);
  

    phase.raise_objection(this);
   repeat (1) begin
      writeseq1_h.start(env_h.act_h.seqr_h);
    end
    phase.drop_objection(this);

phase.phase_done.set_drain_time(this,100);
    phase.raise_objection(this);
    repeat (1) begin
      writeseq2_h.start(env_h.act_h.seqr_h);
    end
    phase.drop_objection(this);
phase.phase_done.set_drain_time(this,100);
    

  endtask


endclass






