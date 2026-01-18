////////////////////////////////////////////////////////////////////////////////
//
// Filename : invalid_config_seq.sv
// Author : Asmara Rauf
// Creation Date : 08/20/2024
//
// No portions of this material may be reproduced in any form without
// the written permission of CoMira solutions Inc.
//
// All information contained in this document is CoMira solutions
// private, proprietary and trade secret.
//
// Description
// ===========
// This module contains invalid configuration packet sequence for simulation extended from uvm_sequence base component.
//
// ///////////////////////////////////////////////////////////////////////////////

class invalid_config_seq extends uvm_sequence #(tx);

  // factory registration
  `uvm_object_utils(invalid_config_seq)

  // constructor
  function new(string name="invalid_config_seq");
    super.new(name);
  endfunction

  // declarations
  tx   txn;
  bit [7:0] ptype;
  
  // main task of the sequence
  virtual task body();
    txn   = tx :: type_id :: create("txn");
    ptype = 8'hF5;
    start_item(txn);
    txn.set_random_packet(ptype);
    finish_item(txn); 
  endtask

endclass

