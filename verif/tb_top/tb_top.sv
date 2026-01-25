////////////////////////////////////////////////////////////////////////////////
//
// Filename : tb_top.sv
// Author : Asmara Rauf
// Creation Date : 08/01/2024
//
// Description
// ===========
// This module is the top testbench module used for the verification of MiniRoute. 
//
// ///////////////////////////////////////////////////////////////////////////////
module tb_top;

  // import packages
  import uvm_pkg::*;
  import pkg::*;

  //declarations
  bit clk;
  
  initial begin
    clk = 0;
  end
  always #5 clk = !clk;
  
  // create interface
  intf        pif0(clk);
  intf        pif1(clk);
  intf        pif2(clk);
  intf        pif3(clk);
  reset_intf  rst_pif(clk);


  //dut instantiation
  top  DUT (
    .clk               (clk),
    .reset             (rst_pif.reset),                   
    //port0
    .port_in_0_valid   (pif0.port_in_x_valid  ),
    .port_in_0_data    (pif0.port_in_x_data   ),
    .port_in_0_success (pif0.port_in_x_success),
    .port_in_0_busy    (pif0.port_in_x_busy   ),
    .port_out_0_data   (pif0.port_out_x_data  ),
    .port_out_0_valid  (pif0.port_out_x_valid ),
    //port1
    .port_in_1_valid   (pif1.port_in_x_valid  ),
    .port_in_1_data    (pif1.port_in_x_data   ),
    .port_in_1_success (pif1.port_in_x_success),
    .port_in_1_busy    (pif1.port_in_x_busy   ),
    .port_out_1_data   (pif1.port_out_x_data  ),
    .port_out_1_valid  (pif1.port_out_x_valid ),
    //port2
    .port_in_2_valid   (pif2.port_in_x_valid  ),
    .port_in_2_data    (pif2.port_in_x_data   ),
    .port_in_2_success (pif2.port_in_x_success),
    .port_in_2_busy    (pif2.port_in_x_busy   ),
    .port_out_2_data   (pif2.port_out_x_data  ),
    .port_out_2_valid  (pif2.port_out_x_valid ),
    //port3
    .port_in_3_valid   (pif3.port_in_x_valid  ),
    .port_in_3_data    (pif3.port_in_x_data   ),
    .port_in_3_success (pif3.port_in_x_success),
    .port_in_3_busy    (pif3.port_in_x_busy   ),
    .port_out_3_data   (pif3.port_out_x_data  ),
    .port_out_3_valid  (pif3.port_out_x_valid )
  );
   

  // set interface in config db
  initial begin
    uvm_config_db #(virtual intf)::set(uvm_root::get(),"","vif0",pif0);
    uvm_config_db #(virtual intf)::set(uvm_root::get(),"","vif1",pif1);
    uvm_config_db #(virtual intf)::set(uvm_root::get(),"","vif2",pif2);
    uvm_config_db #(virtual intf)::set(uvm_root::get(),"","vif3",pif3);
    uvm_config_db #(virtual reset_intf)::set(uvm_root::get(),"","rst_vif",rst_pif);
  end

  // run test
  initial begin
    run_test();
  end

endmodule
