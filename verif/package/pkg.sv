////////////////////////////////////////////////////////////////////////////////
//
// Filename : pkg.sv
// Author : Asmara Rauf
// Creation Date : 07/31/2024
//
// Description
// ===========
// This module is a package file which contains all the required components for the verification of miniroute, macros and uvm package.
//
// ///////////////////////////////////////////////////////////////////////////////

package pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  `include "../sequence_item/tx.sv"  
  `include "../sequence/reset_low_seq.sv"
  `include "../sequence/reset_high_seq.sv"
  `include "../sequence/config_req_seq.sv"
  `include "../sequence/config_pkt_seq.sv"
  `include "../sequence/sanity_pkt_seq.sv" 
  `include "../sequence/invalid_req_seq.sv"
  `include "../sequence/invalid_config_seq.sv"
  `include "../sequence/error_pkt_seq.sv"  
  `include "../driver/driver.sv" 
  `include "../driver/reset_driver.sv"  
  `include "../monitor/monitor.sv"  
  `include "../monitor/reset_monitor.sv"
  `include "../agent/agent_reset.sv"
  `include "../agent/agent.sv" 
  `include "../scoreboard/scoreboard.sv"  
  `include "../environment/environment.sv"  
  `include "../test/sanity_test.sv"
  `include "../test/random_reset_test.sv"
  `include "../test/configuration_test.sv"  
  `include "../test/random_pkt_test.sv"
endpackage : pkg
