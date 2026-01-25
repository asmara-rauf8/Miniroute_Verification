////////////////////////////////////////////////////////////////////////////////
//
// Filename : invalid_req_seq.sv
// Author : Asmara Rauf
// Creation Date : 08/20/2024
//
// Description
// ===========
// This module contains invalid request packet sequence for simulation extended from uvm_sequence base component.
//
// ///////////////////////////////////////////////////////////////////////////////


class invalid_req_seq extends uvm_sequence #(tx);

  // factory registration
  `uvm_object_utils(invalid_req_seq)

  // constructor
  function new(string name="invalid_req_seq");
    super.new(name);
  endfunction

  // declarations
  tx   txn;
  bit [7:0] ptype;
  
  // main task of the sequence
  virtual task body();
    txn   = tx :: type_id :: create("txn");
    ptype = 8'hF4;
    start_item(txn);
    txn.set_random_packet(ptype);
    finish_item(txn); 
  endtask

endclass
