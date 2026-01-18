////////////////////////////////////////////////////////////////////////////////
//
// Filename : driver.sv
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
// This module contains driver extended from uvm_driver base component.
//
// ///////////////////////////////////////////////////////////////////////////////


class driver extends uvm_driver #(tx);

  //factory registration
  `uvm_component_utils(driver)
  
  string temp;  
  //constructor
  function new(string name="driver",uvm_component parent);
    super.new(name,parent);
    temp = "temp";
  endfunction

  //declarations
  virtual intf  vif;
  tx   txn;
  int x = 7;

  //build phase
  function void build_phase(uvm_phase phase);
    if (!(uvm_config_db #(virtual intf)::get(this,"",temp,vif))) begin
      `uvm_fatal("driver","unable to get interface")
    end
  endfunction

  //run phase
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    vif.port_in_x_valid <= 0;
    vif.port_in_x_data  <= 0;
    repeat(25)  @(posedge vif.clk);
    forever begin
      seq_item_port.get_next_item(txn);    
      data_transfer(); 
      vif.port_in_x_valid <= 0;
      vif.port_in_x_data  <= 0;       
      seq_item_port.item_done();         
    end
  endtask
  
  
  task data_transfer();
    while (~vif.port_in_x_success) begin
      if (vif.port_in_x_busy || vif.port_in_x_success) begin
        vif.port_in_x_valid <= 0;
        vif.port_in_x_data  <= 0;
      end
      else begin
        vif.port_in_x_valid <= 1;
        vif.port_in_x_data  <= txn.inp[x*8 +: 8];
        x <= x-1;
        if (x == 0) begin          
          x <= 7;   
        end
      end
      @(posedge vif.clk);
    end
  endtask
  
endclass
