////////////////////////////////////////////////////////////////////////////////
//
// Filename : reset_driver.sv
// Author : Asmara Rauf
// Creation Date : 08/01/2024
//
// Description
// ===========
// This module contains driver extended from uvm_driver base component.
//
// ///////////////////////////////////////////////////////////////////////////////


class reset_driver extends uvm_driver #(tx);

  //factory registration
  `uvm_component_utils(reset_driver)
  //constructor
  function new(string name="reset_driver",uvm_component parent);
    super.new(name,parent);
  endfunction

  //declarations
  virtual reset_intf rst_vif;
  tx   txn;

  //build phase
  function void build_phase(uvm_phase phase);
    if (!(uvm_config_db #(virtual reset_intf)::get(this,"","rst_vif",rst_vif))) begin
      `uvm_fatal("driver","unable to get interface")
    end
  endfunction

  //run phase
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      seq_item_port.get_next_item(txn);    
      @(posedge rst_vif.clk);
      rst_vif.reset <= txn.reset;      
      seq_item_port.item_done();          
    end
  endtask
  
endclass
