

class ApbTest extends uvm_test;

  `uvm_component_utils(ApbTest)
  ApbEnvironment env_h;

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

endclass

 
