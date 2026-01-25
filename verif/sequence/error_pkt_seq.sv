////////////////////////////////////////////////////////////////////////////////
//
// Filename : error_pkt_seq.sv
// Author : Asmara Rauf
// Creation Date : 08/20/2024
//
// Description
// ===========
// This module contains invalid packet sequence for simulation extended from uvm_sequence base component.
//
// ///////////////////////////////////////////////////////////////////////////////


class error_pkt_seq extends uvm_sequence #(tx);

  // factory registration
  `uvm_object_utils(error_pkt_seq)

  // constructor
  function new(string name="error_pkt_seq");
    super.new(name);
  endfunction

  // declarations
  tx   txn;
  int  random;
  int  ptype;
  
  // main task of the sequence
  virtual task body();
    txn    = tx :: type_id :: create("txn");
    random = $urandom_range(1,3);
    case(random)
    	1: ptype = 8'hF1;
    	2: ptype = 8'hF2;
    	3: ptype = 8'hF3;
    endcase
    start_item(txn);
    txn.set_random_packet(ptype);
    finish_item(txn); 
  endtask

endclass
