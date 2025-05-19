interface ApbInterface(input bit pclk, input bit presetn);

  logic [`AW-1:0] apb_read_paddr;       
  logic [`AW-1:0] apb_write_paddr;    
  logic [`DW-1:0] apb_write_data;
  logic [`DW-1:0] apb_read_data_out;      
  logic transfer;      
  logic READ_WRITE;               

  clocking drv_cb @(posedge pclk );
    default input #0 output #0;
    output transfer;
    output  READ_WRITE;
    output apb_read_paddr;
    output apb_write_paddr;
    output  apb_write_data;
  endclocking

  clocking mon_cb @(posedge pclk );
    default input #0 output #0; 
    input transfer;
    input READ_WRITE;
    input apb_read_paddr;
    input apb_write_paddr;
    input apb_write_data;
    input apb_read_data_out;
  endclocking
 
  modport DRV (clocking drv_cb);
  modport MON (clocking mon_cb);
 

//============================================================
// 1. WRITE ADDRESS VALIDITY
// Ensures that during a write transfer, write address is not X or Z
//============================================================
property checkWriteAddressValidity;
  @(posedge pclk) disable iff (!presetn)
    transfer && !READ_WRITE |-> !$isunknown(apb_write_paddr);
endproperty

write_address_validity: assert property (checkWriteAddressValidity)
        $display("WRITE_ADDRESS_VALIDITY: ASSERTION PASS");
  else $error("WRITE_ADDRESS_VALIDITY: ASSERTION FAIL");

//============================================================
// 2. READ ADDRESS VALIDITY
// Ensures that during a read transfer, read address is not X or Z
//============================================================
property checkReadAddressValidity;
  @(posedge pclk) disable iff (!presetn)
    transfer && READ_WRITE |-> !$isunknown(apb_read_paddr);
endproperty

read_address_validity: assert property (checkReadAddressValidity)
       $display("READ_ADDRESS_VALIDITY: ASSERTION PASS");
  else $error("READ_ADDRESS_VALIDITY: ASSERTION FAIL");

//============================================================
// 3. WRITE ADDRESS STABILITY
// Ensures that during a write transfer, the address remains stable
//============================================================
property checkWriteAddressStability;
  @(posedge pclk) disable iff (!presetn)
    transfer && !READ_WRITE |=> $stable(apb_write_paddr);
endproperty

write_address_stability: assert property (checkWriteAddressStability)
       $display("WRITE_ADDRESS_STABILITY: ASSERTION PASS");
  else $error("WRITE_ADDRESS_STABILITY: ASSERTION FAIL");

//============================================================
// 4. TRANSFER VALIDITY (Dynamic)
// Ensures that during any transfer:
//   - If it's a read: read address must be valid
//   - If it's a write: write address must be valid
//============================================================
property checkTransferValidity;
  @(posedge pclk) disable iff (!presetn)
    transfer |-> (READ_WRITE ? !$isunknown(apb_read_paddr) : !$isunknown(apb_write_paddr));
endproperty

transfer_validity: assert property (checkTransferValidity)
       $display("TRANSFER_VALIDITY: ASSERTION PASS");
  else $error("TRANSFER_VALIDITY: ASSERTION FAIL");

endinterface
