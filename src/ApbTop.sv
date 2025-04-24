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
 ApbIntf intf(pclk,presetn);
initial begin
       uvm_config_db #(virtual ApbInterface)::set(uvm_root::get(),"*","vif",intf);
     end*
initial begin
  run_test("ApbWriteSlave1Test");

end
endmodule
