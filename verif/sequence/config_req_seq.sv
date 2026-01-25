////////////////////////////////////////////////////////////////////////////////
//
// Filename : config_req_seq.sv
// Author : Asmara Rauf
// Creation Date : 08/16/2024
//
// Description
// ===========
// This module contains sequence for configuration request packets, extended from uvm_sequence base component.
//
// ///////////////////////////////////////////////////////////////////////////////


class config_req_seq extends uvm_sequence #(tx);

  // factory registration
  `uvm_object_utils(config_req_seq)

  // constructor
  function new(string name="config_req_seq");
    super.new(name);
  endfunction

  // declarations
  tx   txn;
  bit [7:0] src;
  bit [7:0] dst;
  bit [7:0] ptype;
  
  // for source and dstination addr
  function set_credentials(input bit [7:0] in1, input bit [7:0] in2);
    src  = in1;
    dst  = in2;
  endfunction
  
  // main task of the sequence
  virtual task body();
    txn   = tx :: type_id :: create("txn");
    ptype = 8'hF4;
    start_item(txn);
    txn.set_packet(src,dst,ptype);
    finish_item(txn); 
  endtask

endclass

