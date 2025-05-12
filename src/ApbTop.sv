`include "ApbPackage.sv"

module top;
 bit pclk,presetn;
 always #5 pclk=~pclk;
 initial begin
     pclk=0;
     presetn =0;
     #20;
     presetn=1;
    end
 APB_Protocol dut (
    .PCLK(pclk),
    .PRESETn(presetn),
    .transfer(intf.transfer),
    .READ_WRITE(intf.READ_WRITE),
    .apb_write_paddr(intf.apb_write_paddr),
    .apb_write_data(intf.apb_write_data),
    .apb_read_paddr(intf.apb_read_paddr),
    .apb_read_data_out(intf.apb_read_data_out)
  );
 ApbInterface   intf(pclk,presetn);
initial begin
      
     uvm_config_db #(virtual ApbInterface)::set(null,"*","vif",intf);
     end
initial begin
  run_test("ApbWriteReadSlave2Test");

end
endmodule
