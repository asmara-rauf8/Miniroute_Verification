////////////////////////////////////////////////////////////////////////////////
//
// Filename : reset_intf.sv
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

interface reset_intf (input clk);	  
  logic   reset;    
endinterface
