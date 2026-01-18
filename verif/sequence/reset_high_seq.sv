////////////////////////////////////////////////////////////////////////////////
//
// Filename : reset_high_seq.sv
// Author : Asmara Rauf
// Creation Date : 03/09/2024
//
// No portions of this material may be reproduced in any form without
// the written permission of CoMira solutions Inc.
//
// All information contained in this document is CoMira solutions
// private, proprietary and trade secret.
//
// Description
// ===========
// This module contains reset sequence extended from uvm_sequence base component.
//
// ///////////////////////////////////////////////////////////////////////////////


class reset_high_seq extends uvm_sequence #(tx);

  // factory registration
  `uvm_object_utils(reset_high_seq)

  // constructor
  function new(string name="reset_high_seq");
    super.new(name);
  endfunction

  // declarations
  tx   txn;
  
  // main task of the sequence
  virtual task body();
    txn  = tx  :: type_id :: create("txn");
    start_item(txn);
    txn.set_reset_high();
    finish_item(txn);
  endtask

endclass

