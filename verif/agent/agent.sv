////////////////////////////////////////////////////////////////////////////////
//
// Filename : agent.sv
// Author : Asmara Rauf
// Creation Date : 08/01/2024
//
// Description
// ===========
// This module contains miniroute's agent extended from uvm_agent base component.
//
// ///////////////////////////////////////////////////////////////////////////////


class agent#(string T = "temp" ) extends uvm_agent;

  //factory registration
  `uvm_component_param_utils (agent#(T))

  //constructor
  function new (string name="agent",uvm_component parent);
    super.new (name,parent);
  endfunction

  //declarations
  driver  drv;
  uvm_sequencer #(tx) sqr;
  monitor mon;

  //build phase
  function void build_phase(uvm_phase phase);
    sqr  = uvm_sequencer #(tx):: type_id :: create("sqr",this);
    drv  = driver  :: type_id :: create("drv",this);
    mon  = monitor :: type_id :: create("mon",this);
    drv.temp = T;
    mon.temp = T;
  endfunction

  // connect phase
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_warning ("agent","Starting connect phase")
    drv.seq_item_port.connect(sqr.seq_item_export);
  endfunction

endclass
