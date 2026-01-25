////////////////////////////////////////////////////////////////////////////////
//
// Filename : reset_intf.sv
// Author : Asmara Rauf
// Creation Date : 08/01/2024
//
// Description
// ===========
// This module contains interface through which driver communicates wuth dut and dut communicates with monitor.
//
// ///////////////////////////////////////////////////////////////////////////////

interface reset_intf (input clk);	  
  logic   reset;    
endinterface
