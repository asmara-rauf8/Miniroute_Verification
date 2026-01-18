////////////////////////////////////////////////////////////////////////////////
//
// Filename : tx.sv
// Author : Asmara Rauf
// Creation Date : 07/31/2024
//
// No portions of this material may be reproduced in any form without
// the written permission of CoMira solutions Inc.
//
// All information contained in this document is CoMira solutions
// private, proprietary and trade secret.
//
// Description
// ===========
// This module contains MiniRoute transactions extended from uvm_sequence_item base component.
//
// ///////////////////////////////////////////////////////////////////////////////
typedef struct packed {
  bit [7:0] src;
  bit [7:0] dst;
  bit [7:0] checksum;
  bit [7:0] p_type;
  bit [7:0] data0;
  bit [7:0] data1;
  bit [7:0] data2;
  bit [7:0] data3;
} packet;

class tx extends uvm_sequence_item;
  
  // constructor
  function new(string name="tx");
    super.new(name);
  endfunction

  // declarations 
  packet  inp; 
  bit     reset;
  logic [15:0] temp;  
  
  // factory registration & field macros
  `uvm_object_utils_begin(tx)
  `uvm_field_int (reset, UVM_ALL_ON)
  `uvm_field_int (inp, UVM_ALL_ON)
  `uvm_object_utils_end
    
  // function for checksum calculation
  function bit[7:0] calc_checksum (packet inp);
    temp = inp.src + inp.dst + inp.p_type + inp.data0 + inp.data1 + inp.data2 + inp.data3;
    return (temp[15:8] + temp[7:0]);    
  endfunction 
  
  // custom randomization function
  function set_packet(input int src, input int dst, input int ptype);
    inp.src      = src;
    inp.dst      = dst;
    inp.p_type   = ptype;
    inp.data0    = 8'h00;    
    inp.data1    = 8'h00; 
    inp.data2    = 8'h00;    
    inp.data3    = 8'h00;
    inp.checksum = calc_checksum(inp); 
  endfunction
  
  function set_config_packet(input int src, input int dst, input int ptype, input int data1, input int data2);
    inp.src      = src;
    inp.dst      = dst;
    inp.p_type   = ptype;
    inp.data0    = $random;    
    inp.data1    = data1; 
    inp.data2    = data2;    
    inp.data3    = 8'h00;
    inp.checksum = calc_checksum(inp); 
  endfunction 
  
  function set_random_packet(input int ptype);
    inp.src      = $random;
    inp.dst      = $random;
    inp.p_type   = ptype;
    inp.data0    = $random;    
    inp.data1    = $random; 
    inp.data2    = $random;    
    inp.data3    = $random;
    inp.checksum = $random; 
  endfunction
  
  function set_reset_low();
    reset        = 0;
  endfunction  
  
  function set_reset_high();
    reset        = 1;
  endfunction
  
endclass

