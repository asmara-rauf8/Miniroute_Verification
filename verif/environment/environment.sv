////////////////////////////////////////////////////////////////////////////////
//
// Filename : environment.sv
// Author : Asmara Rauf
// Creation Date : 08/02/2024
//
// No portions of this material may be reproduced in any form without
// the written permission of CoMira solutions Inc.
//
// All information contained in this document is CoMira solutions
// private, proprietary and trade secret.
//
// Description
// ===========
// This module contains miniroute's environment extended from uvm_env base component.
//
// ///////////////////////////////////////////////////////////////////////////////


class environment extends uvm_env;
  
  //factory registration 
  `uvm_component_utils(environment)

  //constructor
  function new(string name="environment",uvm_component parent);
    super.new(name,parent);
  endfunction

  //declaration
  scoreboard        scb;
  agent #("vif0")   agent_port0;
  agent #("vif1")   agent_port1;
  agent #("vif2")   agent_port2;
  agent #("vif3")   agent_port3;
  agent_reset       agent_rst;

  // build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agent_port0 = agent#("vif0") :: type_id :: create("agent_port0",this);
    agent_port1 = agent#("vif1") :: type_id :: create("agent_port1",this);
    agent_port2 = agent#("vif2") :: type_id :: create("agent_port2",this);
    agent_port3 = agent#("vif3") :: type_id :: create("agent_port3",this);
    agent_rst   = agent_reset    :: type_id :: create("agent_rst",this);
    scb         = scoreboard     :: type_id :: create("scb",this);
  endfunction

  //connect phase
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    agent_rst.rst_mon.rst_monitor_analysis_port.connect(scb.reset_analysis_fifo.analysis_export);
    agent_port0.mon.in_monitor_analysis_port.connect(scb.port0_analysis_fifo.analysis_export);
    agent_port1.mon.in_monitor_analysis_port.connect(scb.port1_analysis_fifo.analysis_export);
    agent_port2.mon.in_monitor_analysis_port.connect(scb.port2_analysis_fifo.analysis_export);
    agent_port3.mon.in_monitor_analysis_port.connect(scb.port3_analysis_fifo.analysis_export);
    agent_port0.mon.out_monitor_analysis_port.connect(scb.port0_out_monitor_export);
    agent_port1.mon.out_monitor_analysis_port.connect(scb.port1_out_monitor_export);
    agent_port2.mon.out_monitor_analysis_port.connect(scb.port2_out_monitor_export);
    agent_port3.mon.out_monitor_analysis_port.connect(scb.port3_out_monitor_export);
  endfunction

endclass
