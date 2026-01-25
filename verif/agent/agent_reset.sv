////////////////////////////////////////////////////////////////////////////////
//
// Filename : agent_reset.sv
// Author : Asmara Rauf
// Creation Date : 09/12/2024
//
// Description
// ===========
// This module contains miniroute's agent extended from uvm_agent base component.
//
// ///////////////////////////////////////////////////////////////////////////////


class agent_reset extends uvm_agent;

  //factory registration
  `uvm_component_param_utils (agent_reset)

  //constructor
  function new (string name="agent_reset",uvm_component parent);
    super.new (name,parent);
  endfunction

  //declarations
  reset_driver  rst_drv;
  uvm_sequencer #(tx) sqr;
  reset_monitor rst_mon;

  //build phase
  function void build_phase(uvm_phase phase);
    sqr      = uvm_sequencer #(tx):: type_id :: create("sqr",this);
    rst_drv  = reset_driver  :: type_id :: create("rst_drv",this);
    rst_mon  = reset_monitor :: type_id :: create("rst_mon",this);
  endfunction

  // connect phase
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_warning ("reset agent","Starting connect phase")
    rst_drv.seq_item_port.connect(sqr.seq_item_export);
  endfunction

endclass
