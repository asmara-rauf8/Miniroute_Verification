////////////////////////////////////////////////////////////////////////////////
//
// Filename : config_pkt_seq.sv
// Author : Asmara Rauf
// Creation Date : 08/16/2024
//
// Description
// ===========
// This module contains sequence for configuration packets, extended from uvm_sequence base component.
//
// ///////////////////////////////////////////////////////////////////////////////


class config_pkt_seq extends uvm_sequence #(tx);

  // factory registration
  `uvm_object_utils(config_pkt_seq)

  // constructor
  function new(string name="config_pkt_seq");
    super.new(name);
  endfunction

  // declarations
  tx   txn;
  int  r1;
  int  r2;
  int  src;
  int  dst;
  int  ptype;
  int  data1;
  int  data2;
  
  // for source and dstination addr
  function set_credentials(input bit [7:0] in1, input bit [7:0] in2);
    src = in1;
    dst = in2;
  endfunction
  
  // main task of the sequence
  virtual task body();
    txn   = tx :: type_id :: create("txn");
    r1    = $urandom_range(1,5);
    r2    = $urandom_range(1,5);
    ptype = 8'hF5;
    if (r1 == 1) data1 = $random;    
    else         data1 = 8'hFF;    // device connected
    if (r2 == 2) data2 = $random; 
    else         data2 = 8'hFF;    // broadcast enable
    start_item(txn);
    txn.set_config_packet(src,dst,ptype,data1,data2);
    finish_item(txn); 
  endtask

endclass

