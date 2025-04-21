interface ApbInterface(input bit pclk, input bit presetn)

  logic transfer;                     
  logic READ_WRITE;                     
  logic [8:0] apb_read_paddr;       
  logic [8:0] apb_write_paddr;    
  logic [7:0] apb_write_data;
  logic [7:0] apb_read_data_out;      
  logic transfer;      
  logic READ_WRITE;               

  clocking drv_cb @(posedge pclk or negedge presetn);
    default input #1 output #1;
    output transfer;
    output  READ_WRITE;
    output apb_read_paddr;
    output apb_write_paddr;
    output  apb_write_data;
  endclocking

  clocking mon_cb @(posedge pclk or negedge presetn);
    default input #1 output #1; 
    input transfer;
    input READ_WRITE;
    input apb_read_paddr;
    input apb_write_paddr;
    input apb_write_data;
    input apb_read_data_out;
  endclocking
 
  modport DRV (clocking drv_cb);
  modport MON (clocking mon_cb);
 
 

endinterface
