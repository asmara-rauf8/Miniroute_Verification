////////////////////////////////////////////////////////////////////////////////
//
// Filename : reset_monitor.sv
// Author : Asmara Rauf
// Creation Date : 08/01/2024
//
// No portions of this material may be reproduced in any form without
// the written permission of CoMira solutions Inc.
//
// All information contained in this document is CoMira solutions
// private, proprietary and trade secret.
//
// Description
// ===========
// This module contains minirout's monitor extended from uvm_monitor base component.
//
// ///////////////////////////////////////////////////////////////////////////////


class reset_monitor extends uvm_monitor;

  // factory registration
  `uvm_component_utils(reset_monitor)
  
  //constructor
  function new(string name="reset_monitor",uvm_component parent);
    super.new(name,parent);
  endfunction

  // declarations
  virtual reset_intf rst_vif;
  tx  txx_rst;  
  uvm_analysis_port #(tx) rst_monitor_analysis_port;

  // build_phase
  function void build_phase(uvm_phase phase);
    if (!(uvm_config_db #(virtual reset_intf)::get(this,"","rst_vif",rst_vif))) begin
      `uvm_fatal("driver","unable to get interface")
    end    
    txx_rst = tx ::type_id::create("txx_rst",this);
    rst_monitor_analysis_port = new("rst_monitor_analysis_port",this);
  endfunction

  // run_phase
  task run_phase(uvm_phase phase);
    forever begin
      @(posedge rst_vif.clk);
      rst_transfer();     
    end
  endtask
  
  // receive reset signal from interface
  task rst_transfer;
    txx_rst.reset = rst_vif.reset;
    rst_monitor_analysis_port.write(txx_rst);
  endtask
  
endclass
