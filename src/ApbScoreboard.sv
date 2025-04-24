
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
  

    int pass = 0, fail = 0;
   function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    in_mon_port = new("in_mon_port", this);
    out_mon_port = new("out_mon_port", this);

    if (!uvm_config_db#(virtual ApbInterface)::get(this, "", "vif", vif)) begin
      `uvm_error("build_phase", "Driver virtual interface failed");
    end
  endfunction

    function new(string name="ApbScoreboard", uvm_component parent);
     super.new(name, parent);
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
                           $display("---------------TEST PASS--------------------------------");
                           pass++;
                         end
                     else 
                        begin
                           $display("---------------TEST FAIL--------------------------------");
                           fail++;
                        end
                  end
            else
                begin
                  if((exp_trans.apb_read_paddr == act_trans.apb_read_addr) && (exp_trans.apb_read_data_out == act_trans.apn_read_data_out))
                          begin
                           $display("---------------TEST PASS--------------------------------");
                           pass++;
                         end
                     else 
                        begin
                           $display("---------------TEST FAIL--------------------------------");
                           fail++;
                        end
                  end
             end
         end
    endtask
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
