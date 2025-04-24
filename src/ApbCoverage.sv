`uvm_analysis_imp_decl(_ip_mon)
`uvm_analysis_imp_decl(_op_mon)

class ApbCoverage extends uvm_subscriber #(ApbSeqItem);
  `uvm_component_utils(ApbCoverage)
    
  uvm_analysis_imp_ip_mon#(ApbSeqItem, ApbCoverage) ip_mon_imp;
  uvm_analysis_imp_op_mon#(ApbSeqItem, ApbCoverage) op_mon_imp;

    ApbSeqItem ip_seq;
    ApbSeqItem op_seq;
  
    covergroup fun_cov_in;
      READ_WRITE_CP:coverpoint ip_seq.READ_WRITE {
        bins i_READ_WRITE_0 = {1'b0};
        bins i_READ_WRITE_1 = {1'b1};
      }
      TRANSFER_CP:coverpoint ip_seq.transfer {
         bins i_transfer_0 = {1'b0};
         bins i_transfer_1 = {1'b1};
      }
      APB_WRITE_PADDR_CP:coverpoint ip_seq.apb_write_paddr {
        bins i_apb_write_paddr ={[9'h000:9'h1FF]};
      }
      APB_WRITE_SLAVE_SELECT_CP:coverpoint ip_seq.apb_write_paddr[8] {
        bins i_apb_write_paddr_0 = {1'b0};
        bins i_apb_write_paddr_1 = {1'b1};
        
      }
     
       APB_READ_SLAVE_SELECT_CP:coverpoint ip_seq.apb_read_paddr[8] {
        bins i_apb_read_paddr_0 = {1'b0};
        bins i_apb_read_paddr_1 = {1'b1};
        
      }
      APB_WRITE_DATA_CP: coverpoint ip_seq.apb_write_data {
        bins i_apb_write_data = {[8'h00:8'hFF]};
      }
      
      //cross coverage
        APB_WRITE_DATA_CP_X_APB_WRITE_PADDR_CP: cross APB_WRITE_DATA_CP, APB_WRITE_PADDR_CP;
    endgroup: fun_cov_in
  
  covergroup fun_cov_op;
    
     APB_READ_PADDR_CP:coverpoint ip_seq.apb_read_paddr {
        bins i_apb_read_paddr ={[9'h000:9'h1FF]};
      }
    APB_READ_DATA_OUT_CP: coverpoint ip_seq.apb_read_data_out {
        bins i_apb_read_data_out = {[8'h00:8'hFF]};
      }
    
    //cross coverage
    
    APB_READ_DATA_OUT_CP_X_APB_READ_PADDR_CP: cross APB_READ_DATA_OUT_CP, APB_READ_PADDR_CP;
    
  endgroup
   
    real ip_cov_val, op_cov_val;

    // Constructor
    
    function new(string name="ApbCoverage",uvm_component parent=null);
          super.new(name,parent);
          ip_mon_imp=new("ip_mon_imp",this);
          op_mon_imp=new("op_mon_imp",this);
          fun_cov_in =new();
          fun_cov_op =new();
    endfunction:new

    virtual function void write_ip_mon(ApbSeqItem tr);
      this.ip_seq = tr; 
      fun_cov_in.sample();
    endfunction

    virtual function void write_op_mon(ApbSeqItem tr);
       this.op_seq= tr;
       fun_cov_op.sample();
    endfunction
     

    virtual function void write(ApbSeqItem t);
    endfunction

    virtual  function void extract_phase(uvm_phase phase);
          super.extract_phase(phase);
          
          ip_cov_val = fun_cov_in.get_coverage();
          op_cov_val = fun_cov_op.get_coverage();
        `uvm_info("COVERAGE",$sformatf("\n Input coverage is %f \n output coverage is %f",ip_cov_val,op_cov_val),UVM_LOW);
        endfunction
    

endclass
