////////////////////////////////////////////////////////////////////////////////
//
// Filename : intf.sv
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
// This module contains interface through which driver communicates wuth dut and dut communicates with monitor.
//
// ///////////////////////////////////////////////////////////////////////////////

interface intf (input clk);	  
  logic        port_in_x_valid;
  logic  [7:0] port_in_x_data;
  logic  [7:0] port_out_x_data;
  logic        port_in_x_success;
  logic        port_in_x_busy;
  logic        port_out_x_valid;  
endinterface
