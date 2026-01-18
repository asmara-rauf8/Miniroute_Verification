////////////////////////////////////////////////////////////////////////////////
//
// Filename : sanity_pkt_seq.sv
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
// This module contains correct data packet sequence extended from uvm_sequence base component.
//
// ///////////////////////////////////////////////////////////////////////////////


class sanity_pkt_seq extends uvm_sequence #(tx);

  // factory registration
  `uvm_object_utils(sanity_pkt_seq)

  // constructor
  function new(string name="sanity_pkt_seq");
    super.new(name);
  endfunction

  // declarations
  tx   txn;
  int  random;
  int  src;
  int  dst;
  int  ptype;
  
  // for source and dstination addr
  function set_credentials(input bit [7:0] in1, input bit [7:0] in2);
    src = in1;
    dst = in2;
  endfunction
  
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
    txn.set_packet(src,dst,ptype);
    finish_item(txn); 
  endtask

endclass
