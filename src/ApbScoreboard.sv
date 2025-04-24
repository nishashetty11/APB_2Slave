
class ApbScoreboard extends uvm_scoreboard;
  `uvm_component_utils(ApbScoreboard)

  `uvm_analysis_imp_decl(_in_mon)
  `uvm_analysis_imp_decl(_out_mon)

    virtual ApbInterface vif;
  
   ApbSeqItem exp_trans;
   ApbSeqItem act_trans;

   uvm_analysis_imp_in_mon #(ApbSeqItem,ApbScoreboard) in_mon_port;
   uvm_analysis_imp_out_mon #(ApbSeqItem, ApbScoreboard) out_mon_port;
  
   ApbSeqItem out_que[$];
   ApbSeqItem in_que[$];

  logic [`DW-1:0] ApbMem [0:511];
  

    int pass = 0, fail = 0;

  function new(string name="ApbScoreboard", uvm_component parent);
     super.new(name, parent);
   endfunction

  
   function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    in_mon_port = new("in_mon_port", this);
    out_mon_port = new("out_mon_port", this);

    if (!uvm_config_db#(virtual ApbInterface)::get(this, "", "vif", vif)) begin
      `uvm_error("build_phase", "Driver virtual interface failed");
    end
  endfunction

  
     virtual function void write_in_mon( ApbSeqItem tr);
    in_que.push_back(tr);
    `uvm_info("SB", $sformatf("Got exp_trans: queue size = %0d  TRANSFER =%b , READ_WRITE = %0b, APB_WRITE_DATA = %0h, APB_WRITE_PADDR = %0h, APB_READ_PADDR = %0h", 
                             in_que.size(), tr.transfer, tr.READ_WRITE, tr.apb_write_data, tr.apb_write_paddr, tr.apb_read_paddr), UVM_LOW);
     $display("----------------------------------------------------------------------------------------------------");  
 
  endfunction
    virtual function void write_out_mon(ApbSeqItem tr);
    out_que.push_back(tr);
    `uvm_info("SB", $sformatf("Got act_trans: queue size = %0d  TRANSFER =%b , READ_WRITE = %0b,  APB_WRITE_PADDR = %0h, APB_READ_DATA_OUT =%h, APB_READ_PADDR = %0h ", 
                             out_que.size(), tr.transfer, tr.READ_WRITE, tr.apb_write_paddr, tr.apb_read_data_out, tr.apb_read_paddr), UVM_LOW);
     $display("----------------------------------------------------------------------------------------------------");  
  endfunction

    task run_phase(uvm_phase phase);
   super.run_phase(phase);
     forever begin
        wait(in_que.size() > 0 && out_que.size() > 0);

            exp_trans = in_que.pop_front();
            act_trans = out_que.pop_front();

            if(exp_trans.transfer ==1)
              begin
               if(exp_trans.READ_WRITE ==1)
                  begin
                     if((exp_trans.apb_write_paddr == act_trans.apb_write_addr) && (exp_trans.apb_write_data == act_trans.apb_write_data))
                          begin
                            
class ApbScoreboard extends uvm_scoreboard;
  `uvm_component_utils(ApbScoreboard)

  `uvm_analysis_imp_decl(_in_mon)
  `uvm_analysis_imp_decl(_out_mon)

    virtual ApbInterface vif;
  
   ApbSeqItem exp_trans;
   ApbSeqItem act_trans;

   uvm_analysis_imp_in_mon #(ApbSeqItem,ApbScoreboard) in_mon_port;
   uvm_analysis_imp_out_mon #(ApbSeqItem, ApbScoreboard) out_mon_port;
  
   ApbSeqItem out_que[$];
   ApbSeqItem in_que[$];

  logic [`DW-1:0] ApbMem [0:511];
  

    int pass = 0, fail = 0;

  function new(string name="ApbScoreboard", uvm_component parent);
     super.new(name, parent);
   endfunction

  
   function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    in_mon_port = new("in_mon_port", this);
    out_mon_port = new("out_mon_port", this);

    if (!uvm_config_db#(virtual ApbInterface)::get(this, "", "vif", vif)) begin
      `uvm_error("build_phase", "Driver virtual interface failed");
    end
  endfunction

  
     virtual function void write_in_mon( ApbSeqItem tr);
    in_que.push_back(tr);
    `uvm_info("SB", $sformatf("Got exp_trans: queue size = %0d  TRANSFER =%b , READ_WRITE = %0b, APB_WRITE_DATA = %0h, APB_WRITE_PADDR = %0h, APB_READ_PADDR = %0h", 
                             in_que.size(), tr.transfer, tr.READ_WRITE, tr.apb_write_data, tr.apb_write_paddr, tr.apb_read_paddr), UVM_LOW);
     $display("----------------------------------------------------------------------------------------------------");  
 
  endfunction
    virtual function void write_out_mon(ApbSeqItem tr);
    out_que.push_back(tr);
    `uvm_info("SB", $sformatf("Got act_trans: queue size = %0d  TRANSFER =%b , READ_WRITE = %0b,  APB_WRITE_PADDR = %0h, APB_READ_DATA_OUT =%h, APB_READ_PADDR = %0h ", 
                             out_que.size(), tr.transfer, tr.READ_WRITE, tr.apb_write_paddr, tr.apb_read_data_out, tr.apb_read_paddr), UVM_LOW);
     $display("----------------------------------------------------------------------------------------------------");  
  endfunction

task run_phase(uvm_phase phase);
   super.run_phase(phase);
     forever begin
        wait(in_que.size() > 0 && out_que.size() > 0);

            exp_trans = in_que.pop_front();
            act_trans = out_que.pop_front();

            if(exp_trans.transfer ==1)
              begin
               if(exp_trans.READ_WRITE ==1)
                  begin
                    ApbMem[exp_trans.apb_write_paddr] =exp_trans.apb_write_data;
                   end      
               else
                  begin
                    exp_trans.apb_read_out =  ApbMem[exp_trans.apb_read_paddr]
                  end
              end
       compare(exp_trans,act_trans);
     end
    endtask

  virtual function void compare(ApbSeqItem exp_trans,ApbSeqItem act_trans);
    if(exp_trans.READ_WRITE)
      begin
        if((exp_trans.apb_write_data == act_trans.apb_write_data) && (exp_trans.apb_write_paddr == act_trans.apb_write_paddr))
          begin
            `uvm_info("compare", $sformatf("-------------Test: PASS------------\n Expected apb_write_data = %0h Actual apb_write_data = %0h  expected apb_write_paddr =%0h actual apb_write_apddr = %0h ", exp_trans.apb_write_data, act_trans.apb_write_data, exp_trans.apb_write_paddr, act_trans.apb_write_paddr), UVM_LOW);
             pass++;
          end
        else
          begin
            `uvm_info("compare", $sformatf("-------------Test: FAIL------------\n Expected apb_write_data = %0h Actual apb_write_data = %0h  expected apb_write_paddr =%0h actual apb_write_apddr = %0h ", exp_trans.apb_write_data, act_trans.apb_write_data, exp_trans.apb_write_paddr, act_trans.apb_write_paddr), UVM_LOW);
             fail++;
          end
      end
    
    else
      begin
             if((exp_trans.apb_read_data_out == act_trans.apb_read_data_out) && (exp_trans.apb_read_paddr == act_trans.apb_read_paddr))
          begin
            `uvm_info("compare", $sformatf("-------------Test: PASS------------\n Expected apb_read_data = %0h Actual apb_w_data = %0h  expected apb_write_paddr =%0h actual apb_write_apddr = %0h ", exp_trans.apb_write_data, act_trans.apb_write_data, exp_trans.apb_write_paddr, act_trans.apb_write_paddr), UVM_LOW);
             pass++;
          end
        else
          begin
            `uvm_info("compare", $sformatf("-------------Test: FAIL------------\n Expected apb_write_data = %0h Actual apb_write_data = %0h  expected apb_write_paddr =%0h actual apb_write_apddr = %0h ", exp_trans.apb_write_data, act_trans.apb_write_data, exp_trans.apb_write_paddr, act_trans.apb_write_paddr), UVM_LOW);
             fail++;
          end
      end
  endfunction
            
            
    function void report_phase(uvm_phase phase);
    super.report_phase(phase);

    if (fail > 0) begin
      `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE);
      `uvm_info(get_type_name(), $sformatf("----       TEST FAIL COUNTS  %0d     ----", fail), UVM_NONE);
      `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE);
    end

    if (pass > 0) begin
      `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE);
      `uvm_info(get_type_name(), $sformatf("----       TEST PASS COUNTS  %0d     ----", pass), UVM_NONE);
      `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE);
    end
  endfunction: report_phase
                  
    
   
endclass
