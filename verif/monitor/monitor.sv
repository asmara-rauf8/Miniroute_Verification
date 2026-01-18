////////////////////////////////////////////////////////////////////////////////
//
// Filename : monitor.sv
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


class monitor extends uvm_monitor;

  // factory registration
  `uvm_component_utils(monitor)
  
  string temp;
  //constructor
  function new(string name="monitor",uvm_component parent);
    super.new(name,parent);
    temp = "temp";
  endfunction

  // declarations
  virtual intf  vif;
  tx  txx_in;
  tx  txx_out;
  int i = 7;
  int j = 7;
  
  uvm_analysis_port #(tx) in_monitor_analysis_port;
  uvm_analysis_port #(tx) out_monitor_analysis_port;

  // build_phase
  function void build_phase(uvm_phase phase);
    if (!(uvm_config_db #(virtual intf)::get(this,"",temp,vif))) begin
      `uvm_fatal("monitor","unable to get interface")
    end   
    txx_in  = tx ::type_id::create("txx_in",this);
    txx_out = tx ::type_id::create("txx_out",this);    
    in_monitor_analysis_port  = new("in_monitor_analysis_port",this);
    out_monitor_analysis_port = new("out_monitor_analysis_port",this);
  endfunction

  // run_phase
  task run_phase(uvm_phase phase);
    forever begin
      @(posedge vif.clk);
      fork
        begin
          in_data();
        end
        begin
          out_data();
        end
      join_none      
    end
  endtask
  
  
  //receive input data from interface
  task in_data;
    if (vif.port_in_x_valid == 1) begin
      if (i>=0) begin
        txx_in.inp[i*8 +: 8] = vif.port_in_x_data;   
        i = i-1;     
        if (i== -1) begin
          in_monitor_analysis_port.write(txx_in);
          i = 7;
        end
      end
    end
  endtask
  
  //receive output data from interface
  task out_data;
    if (vif.port_out_x_valid == 1) begin
      if (j>=0) begin
        txx_out.inp[j*8 +: 8] = vif.port_out_x_data; 
        j = j-1; 
        if (j== -1) begin
          out_monitor_analysis_port.write(txx_out);
          j = 7;
        end      
      end
    end 
  endtask
  
endclass
