//------------------------------------------------------------------------------
// Project      : APB
// File Name    : ApbSeqItem.sv
// Developers   :Nisha Shetty
//------------------------------------------------------------------------------
// Copyright    : 2024(c) Manipal Center of Excellence. All rights reserved.
//----------------------------------------------------------------------------

//-----------------------------------------------------------------------------------
//APB_SEQ_ITEM PSEUDOCODE:
//-----------------------------------------------------------------------------------
//ApbSeqItem is a user-defined class which is extended from uvm_sequence_item,
//a predefined UVM base class for sequence items used in sequences
class ApbSeqItem extends uvm_sequence_item

//Randomizable APB transfer signals
rand bit [`AW - 1:0] apb_write_paddr;   // Write address
rand bit [`AW - 1:0] apb_read_paddr;    // Read address
rand bit [`DW - 1:0] apb_write_data;    // Data to be written
rand bit transfer;                     // Transfer enable signal
rand bit READ_WRITE;                   // 0 = write, 1 = read

//Non-random output signal (read data from DUT)
bit [`DW - 1:0] apb_read_data_out;     // Output data from read operation

//Constructor to initialize the object
function new(string name = "ApbSeqItem");
  super.new(name); // Calls parent class constructor
endfunction : new

endclass : ApbSeqItem
------------------------------------------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Project      : APB
// File Name    : ApbSequence.sv
// Developers   :Nisha Shetty
//------------------------------------------------------------------------------
// Copyright    : 2024(c) Manipal Center of Excellence. All rights reserved.
//----------------------------------------------------------------------------

//-----------------------------------------------------------------------------------
//APB_SEQUENCEPSEUDOCODE:
//-----------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------
// ApbSequence is a user-defined class which is extended from uvm_sequence,
// a predefined UVM class used for driving transactions to the driver.
//-----------------------------------------------------------------------------------

class ApbSequence extends uvm_sequence #(ApbSeqItem)

  // Factory registration for enabling object creation using type_id::create
  `uvm_object_utils(ApbSequence)

  // Handle for the transaction item of type ApbSeqItem
  ApbSeqItem txn;

  //---------------------------------------------------------------------------------
  // Constructor
  // Initializes the base class with optional name
  //---------------------------------------------------------------------------------
  function new(string name = "ApbSequence");
    super.new(name);
  endfunction : new

  //---------------------------------------------------------------------------------
  // Task: body
  // Called when sequence is started. This task creates a transaction,
  // randomizes it, and sends it to the driver through sequencer.
  //---------------------------------------------------------------------------------
  virtual task body;
    `uvm_info("SEQUENCE", "Sequence started", UVM_LOW)

    // Create the transaction object
    txn = ApbSeqItem::type_id::create("txn");
    // Wait for the sequencer to grant the sequence
    wait_for_grant();
    // Randomize the transaction
    assert(txn.randomize());
    // Send the request to the driver
    send_request(txn);
    // Wait until driver completes the request
    wait_for_item_done();
  endtask : body

endclass : ApbSequence

//Other sequences bases on testcases

--------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------
// Project      : APB_2Slave
// File Name    :ApbSequencer.sv
// Developers   :Nisha Shetty
//------------------------------------------------------------------------------
// Copyright    : 2024(c) Manipal Center of Excellence. All rights reserved.
//----------------------------------------------------------------------------

// APB_SEQUENCER PSEUDOCODE:
//-----------------------------------------------------------------------------------
// ApbSequencer is a user-defined class which is extended from uvm_sequencer,
// a pre-defined UVM class for managing APB sequence items


class ApbSequencer extends uvm_sequencer #(ApbSeqItem;
// Factory registration
`uvm_component_utils(ApbSequencer)
// Constructor
// - Accepts component name and parent
// - Calls the super class constructor to register with the UVM factory
function new(string name = "ApbSequencer", uvm_component parent);
  super.new(name, parent);
endfunction
                                           
endclass : ApbSequencer

________________-----------------------------------------------------------------------------------
interface ApbInterface(input bit pclk, input bit presetn)

  logic transfer;                     
  logic READ_WRITE;                     
  logic [8:0] apb_read_paddr;       
  logic [8:0] apb_write_paddr;    
  logic [7:0] apb_write_data;
  logic [7:0] apb_read_data_out;      
  logic transfer;      
  logic READ_WRITE;               

  clocking drv_cb @(posedge pclk );
    default input #1 output #1;
    output transfer;
    output  READ_WRITE;
    output apb_read_paddr;
    output apb_write_paddr;
    output  apb_write_data;
  endclocking

  clocking mon_cb @(posedge pclk);
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
_______________---------------------------------------------------------------

//------------------------------------------------------------------------------
// Project      : APB
// File Name    : ApbIpMonitor.sv
// Developers   :Nisha Shetty
//------------------------------------------------------------------------------
// Copyright    : 2024(c) Manipal Center of Excellence. All rights reserved.
//----------------------------------------------------------------------------


// ApbIpMonitor is a user-defined class which is extended from uvm_monitor 
// which is a pre-defined UVM class. It monitors signals from the DUT IP side.

class ApbIpMonitor extends uvm_monitor

  // Factory registration
  `uvm_component_utils(ApbIpMonitor)

  // Handle to virtual interface
  virtual ApbIntf vif;

  // Declaring a handle of ApbSeqItem to hold transaction data
  ApbSeqItem ip_mon_h;

  // Analysis port to send collected transactions to scoreboard
  uvm_analysis_port#(ApbSeqItem) item_collected_port;

  //--------------------------------------------------------------------------------
// Function: Class constructor
function ApbIpMonitor::new(string name = "ApbIpMonitor", uvm_component parent = null);
  super.new(name, parent);
  // Create analysis port to send collected transactions
  item_collected_port = new("item_collected_port", this);
endfunction : new

//--------------------------------------------------------------------------------
// Function: Build phase
function void ApbIpMonitor::build_phase(uvm_phase phase);
  super.build_phase(phase);

  // Create a new transaction object using factory
  // This object will be used to store monitored signal values
  ip_mon_h = ApbSeqItem::type_id::create("ip_mon_h");

  // Get the virtual interface from the configuration database
  // The testbench top or environment must have set this interface earlier
  // If it fails to get the interface, it throws a fatal error
  if (!uvm_config_db#(virtual ApbIntf)::get(this, "", "vif", vif))
    `uvm_fatal("NOVIF", {"virtual interface must be set for: ", get_full_name(), ".vif"});
endfunction : build_phase

//--------------------------------------------------------------------------------
// Task: Run phase
task ApbIpMonitor::run_phase(uvm_phase phase);
  
endtask : run_phase
  

endclass: ApbIpMonitor
_-----------------------------------------------------------------------------------------
//------------------------------------------------------------------------------
// Project      : APB
// File Name    : ApbDriver.sv
// Developers   :Nisha Shetty
//------------------------------------------------------------------------------
// Copyright    : 2024(c) Manipal Center of Excellence. All rights reserved.
//----------------------------------------------------------------------------
//-----------------------------------------------------------------------------------
// APB_DRIVER PSEUDOCODE:
//-----------------------------------------------------------------------------------
// ApbDriver is a user-defined class which extends from uvm_driver #(ApbSeqItem),
// used to drive stimulus to the DUT through the APB interface.
class ApbDriver extends uvm_driver #(ApbSeqItem)

// Factory registration for ApbDriver
`uvm_component_utils(ApbDriver)

// Constructor of the class
function new(string name = "ApbDriver", uvm_component parent)
  super.new(name, parent)
endfunction: new

// Virtual interface handle to connect to DUT
virtual ApbIntf vif

// Build phase: Get the virtual interface from config DB
function void build_phase(uvm_phase phase)
  super.build_phase(phase)
  if (!uvm_config_db#(virtual ApbIntf)::get(this, "", "vif", vif))
    `uvm_fatal("No vif", {"Set virtual interface to: ", get_full_name(), ".vif"})
endfunction: build_phase

// Handle to sequence item (transaction)
ApbSeqItem txn

// run_phase: Continuously waits for reset to deassert, gets sequence item,
// calls the drive task to send signals to DUT, and completes the item.
task run_phase(uvm_phase phase)
  forever begin
    wait(vif.presetn) // Wait until reset is released
    seq_item_port.get_next_item(txn) // Get transaction from sequence
    drive() // Call drive task to apply txn to interface
    seq_item_port.item_done() // Notify UVM that item is done
  end
endtask: run_phase

// drive task: Drives the transaction signals to the DUT using the virtual interface
task drive()
  // Logic to check READ/WRITE and drive corresponding signals on interface
endtask: drive

endclass: ApbDriver
//-----------------------------------------------------------------------------------
___________________________________________________________________________________________________
//------------------------------------------------------------------------------
// Project      : APB 
// File Name    : ApbOpMonitor.sv
// Developers   : Nisha Shetty
//------------------------------------------------------------------------------
// Copyright    : 2024(c) Manipal Center of Excellence. All rights reserved.
//------------------------------------------------------------------------------

class ApbOpMonitor extends uvm_monitor;

  // Factory registration
  `uvm_component_utils(ApbOpMonitor)

  // Handle to the virtual interface
  virtual ApbIntf vif;

  // Declaring a handle of ApbSeqItem to hold transaction data
  ApbSeqItem op_mon_h;

  // Analysis port to send collected transactions to scoreboard
  uvm_analysis_port #(ApbSeqItem) item_collected_port;

  //--------------------------------------------------------------------------------
  // Function: Constructor
  // Initializes the class and creates the analysis port for collecting transactions
  function new (string name="ApbOpMonitor", uvm_component parent);
    super.new(name, parent);
    // Create the analysis port which will be used to send monitored items to scoreboard
    item_collected_port = new("item_collected_port", this);
  endfunction

  //--------------------------------------------------------------------------------
  // Function: Build phase
  // This phase initializes necessary components like transaction object and interface.
  // Create a new transaction object (op_mon_h) to hold monitored signal values.
  //  Retrieve the virtual interface (vif) from the UVM config database.
  // If retrieval fails, a fatal error is raised.
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Create a new transaction object using the factory
    // This object will hold the monitored signal values for APB operations
    op_mon_h = ApbSeqItem::type_id::create("op_mon_h");

    // Retrieve the virtual interface from the UVM config database
    // The top-level environment should have set the virtual interface before.
    // If it cannot be retrieved, a fatal error is thrown.
    if (!uvm_config_db#(virtual ApbIntf)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", {"virtual interface must be set for: ", get_full_name(), ".vif"});
  endfunction

  //--------------------------------------------------------------------------------
  // Task: Run phase
  virtual task run_phase(uvm_phase phase);
    // Monitoring logic can be added here (currently empty).
  endtask

endclass
__________________________________________________________________________________________
//------------------------------------------------------------------------------
// Project      : APB 
// File Name    : ApbActiveAgent.sv
// Developers   : Nisha Shetty
//------------------------------------------------------------------------------
// Copyright    : 2024(c) Manipal Center of Excellence. All rights reserved.
//------------------------------------------------------------------------------

class ApbActiveAgent extends uvm_agent;

  // Factory registration macro
  `uvm_component_utils(ApbActiveAgent)

  // Declare handles for sequencer, driver, and monitor
  ApbSequencer seqr_h;
  ApbDriver drv_h;
  ApbIpMonitor ip_mon_h;

  // Constructor to initialize the agent
  function new(string name, uvm_component parent);
    super.new(name, parent); // Call parent constructor
  endfunction

  //--------------------------------------------------------------------------------
  // Build phase: Initialize the agent components like driver, sequencer, and monitor
  // Only if the agent is active
  function void build_phase(uvm_phase phase);
    if (get_is_active() == UVM_ACTIVE) begin
      // Create the driver (drv_h) and sequencer (seqr_h) only if the agent is active
      drv_h = ApbDriver::type_id::create("drv_h", this);
      seqr_h = ApbSequencer::type_id::create("seqr_h", this);
    end

    // Create the monitor (ip_mon_h) in all cases
    ip_mon_h = ApbIpMonitor::type_id::create("ip_mon_h", this);
  endfunction : build_phase

  //--------------------------------------------------------------------------------
  // Connect phase: Connect the sequencer and driver
  // Ensures that the sequencer and driver are properly connected
  function void connect_phase(uvm_phase phase);
    if (get_is_active() == UVM_ACTIVE) begin
      // Connect the sequencer's seq_item_export to the driver's seq_item_port
      drv_h.seq_item_port.connect(seqr_h.seq_item_export);
    end
  endfunction : connect_phase

endclass
__________________________________________________________________________
//------------------------------------------------------------------------------
// Project      : APB 
// File Name    : ApbPassiveAgent.sv 
// Developers   : Nisha Shetty
//------------------------------------------------------------------------------
// Copyright    : 2024(c) [Your Organization]. All rights reserved.
//------------------------------------------------------------------------------

class ApbPassiveAgent extends uvm_agent;

  // Factory registration macro for the component
  `uvm_component_utils(ApbPassiveAgent)

  // Declare handles for the monitor and sequencer
  ApbOpMonitor op_mon_h;  
  ApbSequencer seqr_h;    

  // Constructor for initializing the ApbPassiveAgent
  function new(string name="ApbPassiveAgent", uvm_component parent);
    super.new(name, parent);  
  endfunction

  //--------------------------------------------------------------------------------
  // Build phase: Initializes the components for the passive agent
  function void build_phase(uvm_phase phase);
    // Create the APB Operation Monitor
    // This component will monitor APB read and write transactions
    op_mon_h = ApbOpMonitor::type_id::create("op_mon_h", this);

  endfunction : build_phase

endclass
____________________________________________________________________________________
//------------------------------------------------------------------------------
// Project      : APB
// File Name    : ApbEnvironment.sv
// Developers   : Nisha Shetty
//------------------------------------------------------------------------------
// Copyright    : 2024(c) Manipal Center of Excellence. All rights reserved.
//------------------------------------------------------------------------------

class ApbEnvironment extends uvm_env;

  // Factory registration for the environment class
  `uvm_component_utils(ApbEnvironment)

  // Declare handles for the active and passive agents, scoreboard, and coverage collector
  ApbActiveAgent act_h;   
  ApbPassiveAgent pass_h; 
  ApbScoreboard scb_h;    
  ApbCoverage cov_h;      

  // Constructor for initializing the ApbEnvironment
  function new(string name = "ApbEnvironment", uvm_component parent);
    super.new(name, parent);  
  endfunction

  //--------------------------------------------------------------------------------
  // Build phase: Initializes the environment components
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase); 
    // Create the active agent to generate transactions
    act_h = ApbActiveAgent::type_id::create("act_h", this);
    // Create the passive agent to monitor transactions
    pass_h = ApbPassiveAgent::type_id::create("pass_h", this);
    // Create the scoreboard to verify the transactions
    scb_h = ApbScoreboard::type_id::create("scb_h", this);
    // Create the coverage collector to track coverage
    cov_h = ApbCoverage::type_id::create("cov_h", this);
  endfunction : build_phase

  //--------------------------------------------------------------------------------
  // Connect phase: Connects the components within the environment
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);  
    // Connect the item_collected_port of the active agent to the scoreboard's input port
    act_h.mon.item_collected_port.connect(scb_h.in_mon_port);
    //Connect the item_collected_port of the passive agent to the scoreboard's output port
    pass_h.mon.item_collected_port.connect(scb_h.out_mon_port);
    //Connect the active agent's monitor to the coverage collector's input
    act_h.mon.item_collected_port.connect(cov_h.ip_mon_imp);
    // Connect the passive agent's monitor to the coverage collector's output
    pass_h.mon.item_collected_port.connect(cov_h.op_mon_imp);
  endfunction : connect_phase

endclass: ApbEnvironment
