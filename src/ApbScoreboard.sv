class ApbScoreboard extends uvm_scoreboard;
  `uvm_component_utils(ApbScoreboard)

  `uvm_analysis_imp_decl(_in_mon)
  `uvm_analysis_imp_decl(_out_mon)

  virtual ApbInterface vif;

  ApbSeqItem exp_trans;
  ApbSeqItem act_trans;

  uvm_analysis_imp_in_mon #(ApbSeqItem, ApbScoreboard) in_mon_port;
  uvm_analysis_imp_out_mon #(ApbSeqItem, ApbScoreboard) out_mon_port;

  ApbSeqItem out_que[$];
  ApbSeqItem in_que[$];

  logic [`DW-1:0] ApbMem [0:255];
  int pass = 0, fail = 0;

  function new(string name="ApbScoreboard", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    in_mon_port = new("in_mon_port", this);
    out_mon_port = new("out_mon_port", this);

    if (!uvm_config_db#(virtual ApbInterface)::get(this, "", "vif", vif)) begin
      `uvm_error("build_phase", "Driver virtual interface failed")
    end
  endfunction

  virtual function void write_in_mon(ApbSeqItem tr);
    in_que.push_back(tr);
    `uvm_info("SB", $sformatf(
      "EXPECTED TRANSACTION: size = %0d | TRANSFER = %0b | RW = %0b | WDATA = %0h | WPADDR = %0h | RPADDR = %0h",
      in_que.size(), tr.transfer, tr.READ_WRITE, tr.apb_write_data, tr.apb_write_paddr, tr.apb_read_paddr), UVM_LOW)
  endfunction

  virtual function void write_out_mon(ApbSeqItem tr);
    out_que.push_back(tr);
    `uvm_info("SB", $sformatf(
      "ACTUAL TRANSACTION: size = %0d | TRANSFER = %0b | RW = %0b | WPADDR = %0h | WDATA = %0h | RDATA = %0h | RPADDR = %0h",
      out_que.size(), tr.transfer, tr.READ_WRITE, tr.apb_write_paddr, tr.apb_write_data, tr.apb_read_data_out, tr.apb_read_paddr), UVM_LOW)
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);

//    foreach (ApbMem[i])
//      ApbMem[i] = i;

    forever begin
      wait (in_que.size() > 0 && out_que.size() > 0);

      exp_trans = in_que.pop_front();
      act_trans = out_que.pop_front();

      if (exp_trans.transfer) begin
        if (exp_trans.READ_WRITE == 0) begin
          ApbMem[exp_trans.apb_write_paddr] = exp_trans.apb_write_data;
         // compare(exp_trans, act_trans);
        end
          else begin
            exp_trans.apb_read_data_out = ApbMem[exp_trans.apb_read_paddr];
            
           // compare(exp_trans, act_trans);
          end
     $display("FOR COMPARING : WRITE DATA =%h READ DATA OUT =%h", exp_trans.apb_write_data, ApbMem[exp_trans.apb_read_paddr]);
     compare(exp_trans, act_trans);
        end
    end
  endtask

  virtual function void compare(ApbSeqItem exp_trans, ApbSeqItem act_trans);
    if (exp_trans.READ_WRITE == 0) begin
      if (exp_trans.apb_write_data == act_trans.apb_write_data &&
          exp_trans.apb_write_paddr == act_trans.apb_write_paddr) begin
        pass++;
        $display("---------------------------------------------------------------------PASS---------------------------------------------------------------------");
         `uvm_info("COMPARE", $sformatf("WRITE PASS | EXPECTED WDATA = %0h  ACTUAL WDATA =%0h |EXPECTED  WRITE ADDR = %0h ACTUAL WRITE ADDR =%0h",
                    exp_trans.apb_write_data,act_trans.apb_write_data,exp_trans.apb_write_paddr,act_trans.apb_write_paddr ), UVM_LOW)
      end
      else begin
        fail++;
    $display("-------------------------------------------------------------------------FAIL---------------------------------------------------------------------");
   `uvm_error("COMPARE", $sformatf("WRITE FAIL | EXPECTED WDATA = %0h, EXPECTED ADDR = %0h | ACTUAL WDATA = %0h, ACTUAL ADDR = %0h",
                    exp_trans.apb_write_data, exp_trans.apb_write_paddr,
                    act_trans.apb_write_data, act_trans.apb_write_paddr))

      end
    end
    else begin
      if (exp_trans.apb_read_data_out === act_trans.apb_read_data_out &&
          exp_trans.apb_read_paddr == act_trans.apb_read_paddr) begin
        pass++;
        `uvm_info("COMPARE", $sformatf("READ PASS | EXPECTED RDATA = %0h  ACTUAL RDATA =%0h |EXPECTED  READ ADDR = %0h ACTUAL READ ADDR =%0h",
                    exp_trans.apb_read_data_out,act_trans.apb_read_data_out,exp_trans.apb_read_paddr,act_trans.apb_read_paddr ), UVM_LOW)
      end
      else begin
        fail++;
 `uvm_error("COMPARE", $sformatf("READ FAIL | EXPECTED  RDATA = %0h,EXPECTED  ADDR = %0h | ACTUAL RDATA = %0h,ACTUAL ADDR = %0h",
                    exp_trans.apb_read_data_out, exp_trans.apb_read_paddr,
                    act_trans.apb_read_data_out, act_trans.apb_read_paddr))

      end
    end
  endfunction

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("SCOREBOARD", "-----------------------------", UVM_NONE)
    `uvm_info("SCOREBOARD", $sformatf("PASSED: %0d", pass), UVM_NONE)
    `uvm_info("SCOREBOARD", $sformatf("FAILED: %0d", fail), UVM_NONE)
    `uvm_info("SCOREBOARD", "-----------------------------", UVM_NONE)
  endfunction

endclass

