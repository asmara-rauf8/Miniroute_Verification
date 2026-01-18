////////////////////////////////////////////////////////////////////////////////
//
// Filename : scoreboard.sv
// Author : Asmara Rauf
// Creation Date : 08/02/2024
//
// No portions of this material may be reproduced in any form without
// the written permission of CoMira solutions Inc.
//
// All information contained in this document is CoMira solutions
// private, proprietary and trade secret.
//
// Description
// ===========
// This module contains miniroute's scoreboard extended from uvm_scb base component.
//
// ///////////////////////////////////////////////////////////////////////////////

`uvm_analysis_imp_decl(_out0_monitor)
`uvm_analysis_imp_decl(_out1_monitor)
`uvm_analysis_imp_decl(_out2_monitor)
`uvm_analysis_imp_decl(_out3_monitor)

typedef struct packed {
  bit [7:0] src;
  bit [7:0] dst;
  bit [7:0] checksum;
  bit [7:0] p_type;
  bit [7:0] data0;
  bit [7:0] data1;
  bit [7:0] data2;
  bit [7:0] data3;
} out_packet;


class scoreboard extends uvm_scoreboard;

  //factory registration
  `uvm_component_utils(scoreboard)
  
  //declarations 
  tx          item;
  out_packet  pkt;
  
  uvm_tlm_analysis_fifo #(tx) reset_analysis_fifo;
  uvm_tlm_analysis_fifo #(tx) port0_analysis_fifo;
  uvm_tlm_analysis_fifo #(tx) port1_analysis_fifo;
  uvm_tlm_analysis_fifo #(tx) port2_analysis_fifo;
  uvm_tlm_analysis_fifo #(tx) port3_analysis_fifo;
  
  uvm_analysis_imp_out0_monitor #(tx, scoreboard) port0_out_monitor_export;
  uvm_analysis_imp_out1_monitor #(tx, scoreboard) port1_out_monitor_export;
  uvm_analysis_imp_out2_monitor #(tx, scoreboard) port2_out_monitor_export;
  uvm_analysis_imp_out3_monitor #(tx, scoreboard) port3_out_monitor_export;
  
  
  uvm_analysis_port #(tx) response_analysis_port_out0;
  uvm_analysis_port #(tx) response_analysis_port_out1;
  uvm_analysis_port #(tx) response_analysis_port_out2;
  uvm_analysis_port #(tx) response_analysis_port_out3;
  
  logic [64-1:0] queue_out_p0 [$];
  logic [64-1:0] queue_out_p1 [$];
  logic [64-1:0] queue_out_p2 [$];
  logic [64-1:0] queue_out_p3 [$];
  
  logic [7:0] src_i;
  logic [7:0] dst_i;
  logic [7:0] checksum_i;
  logic [7:0] p_type_i;
  logic [7:0] data0_i;
  logic [7:0] data1_i;
  logic [7:0] data2_i;
  logic [7:0] data3_i;
  
  logic [7:0] src_o;
  logic [7:0] dst_o;
  logic [7:0] checksum_o;
  logic [7:0] p_type_o;
  logic [7:0] data0_o;
  logic [7:0] data1_o;
  logic [7:0] data2_o;
  logic [7:0] data3_o;
  
  logic [7:0] checksum_new;
  logic [7:0] out_checksum_new;
  
  logic [7:0] addr_port0;
  logic [7:0] addr_port1;
  logic [7:0] addr_port2;
  logic [7:0] addr_port3;
  
  logic bct_en0;
  logic bct_en1;
  logic bct_en2;
  logic bct_en3;
  logic dvc0_conn;
  logic dvc1_conn;
  logic dvc2_conn;
  logic dvc3_conn;
  logic error_flag;
  logic config_err0;
  logic config_err1;
  logic config_err2;
  logic config_err3;
  
  logic [15:0] temp; 
  
  int  rst_counter  = 0;
  int  total_mon    = 0;
  int  total_bct    = 0;
  int  total_mct    = 0;
  int  total_oto    = 0;
  int  total_config = 0;
  int  total_errors = 0;
  int  pass_oto     = 0;
  int  fail_oto     = 0; 
  int  pass_bct     = 0;
  int  fail_bct     = 0;
  int  pass_mct     = 0;
  int  fail_mct     = 0;
  int  pass_src_err = 0;
  int  fail_src_err = 0;
  int  pass_dst_err = 0;
  int  fail_dst_err = 0;
  int  pass_cks_err = 0;
  int  fail_cks_err = 0;
  int  pass_pkt_err = 0;
  int  fail_pkt_err = 0;
  int  pass_config  = 0;
  int  fail_config  = 0;

  //-----------------------------
  //constructor
  //-----------------------------
  function new(string name="scoreboard",uvm_component parent);
    super.new(name,parent);    
  endfunction
  
  //-----------------------------
  //build phase
  //-----------------------------
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    port0_out_monitor_export = new("port0_out_monitor_export", this);
    port1_out_monitor_export = new("port1_out_monitor_export", this);
    port2_out_monitor_export = new("port2_out_monitor_export", this);
    port3_out_monitor_export = new("port3_out_monitor_export", this);
    
    response_analysis_port_out0 = new("response_analysis_port_out0", this);
    response_analysis_port_out1 = new("response_analysis_port_out1", this);
    response_analysis_port_out2 = new("response_analysis_port_out2", this);
    response_analysis_port_out3 = new("response_analysis_port_out3", this);
    // creating analysis fifo
    reset_analysis_fifo = new("reset_analysis_fifo", this);
    port0_analysis_fifo = new("port0_analysis_fifo", this);
    port1_analysis_fifo = new("port1_analysis_fifo", this);
    port2_analysis_fifo = new("port2_analysis_fifo", this);
    port3_analysis_fifo = new("port3_analysis_fifo", this);
    
    dvc0_conn   = 1;
    dvc1_conn   = 1;   
    dvc2_conn   = 1;
    dvc3_conn   = 1;
    bct_en0     = 1;
    bct_en1     = 1;
    bct_en2     = 1;
    bct_en3     = 1;
    error_flag  = 0;
    config_err0 = 0;
    config_err1 = 0;
    config_err2 = 0;
    config_err3 = 0;
    addr_port0  = 8'hFA;
    addr_port1  = 8'hFB;
    addr_port2  = 8'hFC;
    addr_port3  = 8'hFD;
  endfunction 
    
  //---------------------------------------
  // run_phase 
  //---------------------------------------
  task run_phase(uvm_phase  phase);
    forever begin 
      #10;       
      //Getting trans from FIFO     
      // get from reset fifo
      if (reset_analysis_fifo.used() > 0) begin
        reset_analysis_fifo.get(item);      
        if (~item.reset) begin
          dvc0_conn   = 1;
          dvc1_conn   = 1;
          dvc2_conn   = 1;
          dvc3_conn   = 1;
          bct_en0     = 1;
    	  bct_en1     = 1;
    	  bct_en2     = 1;
    	  bct_en3     = 1;
    	  config_err0 = 0;
    	  config_err1 = 0;
    	  config_err2 = 0;
    	  config_err3 = 0;
          error_flag  = 0;
          addr_port0  = 8'hFA;
          addr_port1  = 8'hFB;
          addr_port2  = 8'hFC;
          addr_port3  = 8'hFD;
          rst_counter++;
          if (rst_counter > 10) begin
            queue_out_p0.delete();
            queue_out_p1.delete();
            queue_out_p2.delete();
            queue_out_p3.delete();
           end
        end
        else begin
          rst_counter = 0; 
        end
      end
      
      //port0      
      if (port0_analysis_fifo.used() > 0) begin
        port0_analysis_fifo.get(item); 
        {src_i, dst_i, checksum_i, p_type_i, data0_i, data1_i, data2_i, data3_i} = item.inp;
        calc_checksum_inp();
        
        pkt.src      = 8'hFF;
        pkt.dst      = addr_port0;
        pkt.p_type   = 8'hF8;
        pkt.data0    = 8'h00;
        pkt.data2    = 8'h00;
        pkt.data1    = 8'h00;
        pkt.data3    = 8'h00;

        error_check_before_push();
      end
      
      //port1
      if (port1_analysis_fifo.used() > 0) begin      
        port1_analysis_fifo.get(item);
        {src_i, dst_i, checksum_i, p_type_i, data0_i, data1_i, data2_i, data3_i} = item.inp; 
        calc_checksum_inp();
        
        pkt.src      = 8'hFF;
        pkt.dst      = addr_port1;
        pkt.p_type   = 8'hF8;
        pkt.data0    = 8'h00;
        pkt.data2    = 8'h00;
        pkt.data1    = 8'h00;
        pkt.data3    = 8'h00;

        error_check_before_push();
      end
      
      //port2
      if (port2_analysis_fifo.used() > 0) begin      
        port2_analysis_fifo.get(item); 
        {src_i, dst_i, checksum_i, p_type_i, data0_i, data1_i, data2_i, data3_i} = item.inp;
        calc_checksum_inp();
        
        pkt.src      = 8'hFF;
        pkt.dst      = addr_port2;
        pkt.p_type   = 8'hF8;
        pkt.data0    = 8'h00;
        pkt.data2    = 8'h00;
        pkt.data1    = 8'h00;
        pkt.data3    = 8'h00;          

        error_check_before_push();
      end
      
      //port3
      if (port3_analysis_fifo.used() > 0) begin
        port3_analysis_fifo.get(item); 
        {src_i, dst_i, checksum_i, p_type_i, data0_i, data1_i, data2_i, data3_i} = item.inp;
        calc_checksum_inp();
        
        pkt.src      = 8'hFF;
        pkt.dst      = addr_port3;
        pkt.p_type   = 8'hF8;
        pkt.data0    = 8'h00;
        pkt.data2    = 8'h00;
        pkt.data1    = 8'h00;
        pkt.data3    = 8'h00;
 
        error_check_before_push();
      end
    end
  endtask 
  
  
  ///checksum calculation
  function bit[7:0] calc_checksum (out_packet pkt);
    temp = pkt.src + pkt.dst + pkt.p_type + pkt.data0 + pkt.data1 + pkt.data2 + pkt.data3;
    return (temp[15:8] + temp[7:0]);    
  endfunction 
  
  function calc_checksum_inp();
    temp = src_i + dst_i + p_type_i + data0_i + data1_i + data2_i + data3_i;
    checksum_new = temp[15:8] + temp[7:0];    
  endfunction
  
  function calc_checksum_out();
    temp = src_o + dst_o + p_type_o + data0_o + data1_o + data2_o + data3_o;
    out_checksum_new = temp[15:8] + temp[7:0];    
  endfunction
  
  
  // error checking in input packets 
  task error_check_before_push();
  
    if ((pkt.dst  == addr_port3 && src_i != addr_port3) || (pkt.dst  == addr_port2 && src_i != addr_port2) || (pkt.dst  == addr_port1 && src_i != addr_port1) || (pkt.dst  == addr_port0 && src_i != addr_port0)) begin
      pkt.data0[7:4] = 4'hF;
      error_flag     = 1;
      pkt.checksum = calc_checksum(pkt); 
    end
  
    if (((dst_i != addr_port0 && dst_i != addr_port1 && dst_i != addr_port2 && dst_i != addr_port3) && (p_type_i == 8'hF1 || p_type_i == 8'hF2 || p_type_i == 8'hF3)) || (dst_i != 8'hFF && (p_type_i == 8'hF4 || p_type_i ==8'hF5))) begin
      pkt.data0[3:0] = 4'hF;
      error_flag     = 1;
      pkt.checksum = calc_checksum(pkt);
    end
     
    if (checksum_new != checksum_i)  begin
      pkt.data1    = 8'hFF;
      error_flag   = 1;
      pkt.checksum = calc_checksum(pkt);
    end
          
    if (((pkt.dst  == addr_port0 && (data0_i == addr_port1 || data0_i == addr_port2 || data0_i == addr_port3)) || (pkt.dst  == addr_port1 && (data0_i == addr_port0 || data0_i == addr_port2 || data0_i == addr_port3)) || (pkt.dst  == addr_port2 && (data0_i == addr_port0 || data0_i == addr_port1 || data0_i == addr_port3)) || (pkt.dst  == addr_port3 && (data0_i == addr_port0 || data0_i == addr_port1 || data0_i == addr_port2 ))|| data0_i == 8'hFF) && p_type_i == 8'hF5)  begin 
      pkt.data3    = 8'hFF;
      error_flag   = 1;
      pkt.checksum = calc_checksum(pkt);
    end
    
    push_pkts_super();
  endtask
  
  
  // push super task
  task push_pkts_super();
    if (error_flag  == 1) begin
      push_child_task();
      error_flag = 0;
    end        
    else begin  
      push();
    end
  endtask
  
  
  //push function for normal packets F1,F2,F3
  task push();
    case (p_type_i)
      8'hF1: begin
        if (bct_en0) begin
          if (dvc0_conn)   queue_out_p0.push_back(item.inp);
        end
        if (bct_en1) begin
          if (dvc1_conn)   queue_out_p1.push_back(item.inp);
        end
        if (bct_en2) begin
          if (dvc2_conn)   queue_out_p2.push_back(item.inp);
        end
        if (bct_en3) begin
          if (dvc3_conn)   queue_out_p3.push_back(item.inp);
        end
      end
      8'hF2: begin
        if (src_i == addr_port0 ) begin
          if (dvc1_conn)   queue_out_p1.push_back(item.inp);
          if (dvc2_conn)   queue_out_p2.push_back(item.inp);
          if (dvc3_conn)   queue_out_p3.push_back(item.inp);
        end
        else if (src_i == addr_port1) begin
          if (dvc0_conn)   queue_out_p0.push_back(item.inp);
          if (dvc2_conn)   queue_out_p2.push_back(item.inp);
          if (dvc3_conn)   queue_out_p3.push_back(item.inp);
        end
        else if (src_i == addr_port2) begin
          if (dvc0_conn)   queue_out_p0.push_back(item.inp);
          if (dvc1_conn)   queue_out_p1.push_back(item.inp);
          if (dvc3_conn)   queue_out_p3.push_back(item.inp);
        end
        else if (src_i == addr_port3) begin
          if (dvc0_conn)   queue_out_p0.push_back(item.inp);
          if (dvc1_conn)   queue_out_p1.push_back(item.inp);
          if (dvc2_conn)   queue_out_p2.push_back(item.inp);
        end
      end
      8'hF3: begin  
        if (dst_i == addr_port0 && dvc0_conn == 1) begin
          queue_out_p0.push_back(item.inp);
        end
        else if (dst_i == addr_port1 && dvc1_conn == 1) begin
          queue_out_p1.push_back(item.inp);
        end
        else if (dst_i == addr_port2 && dvc2_conn == 1) begin
          queue_out_p2.push_back(item.inp);
        end
        else if (dst_i == addr_port3 && dvc3_conn == 1) begin
          queue_out_p3.push_back(item.inp);
        end
      end
      8'hF4,8'hF5: begin
        if (src_i == addr_port0 ) begin
          queue_out_p0.push_back(item.inp);
          if (p_type_i == 8'hF5) begin
            addr_port0 = item.inp.data0;
            bct_en0    = (item.inp.data2 == 8'hFF) ? 1:0; 
            dvc0_conn  = (item.inp.data1 == 8'hFF) ? 1:0;
          end
        end
        else if (src_i == addr_port1) begin
          queue_out_p1.push_back(item.inp);
          if (p_type_i == 8'hF5) begin
            addr_port1 = item.inp.data0;
            bct_en1    = (item.inp.data2 == 8'hFF) ? 1:0; 
            dvc1_conn  = (item.inp.data1 == 8'hFF) ? 1:0;
          end
        end
        else if (src_i == addr_port2) begin
          queue_out_p2.push_back(item.inp);
          if (p_type_i == 8'hF5) begin
            addr_port2 = item.inp.data0;
            bct_en2    = (item.inp.data2 == 8'hFF) ? 1:0; 
            dvc2_conn  = (item.inp.data1 == 8'hFF) ? 1:0;
          end
        end
        else if (src_i == addr_port3) begin
          queue_out_p3.push_back(item.inp);
          if (p_type_i == 8'hF5) begin
            addr_port3 = item.inp.data0;
            bct_en3    = (item.inp.data2 == 8'hFF) ? 1:0; 
            dvc3_conn  = (item.inp.data1 == 8'hFF) ? 1:0;
          end
        end
      end
    endcase
  endtask
  
  // push task for error packets
  task push_child_task();
    if (pkt.dst == addr_port0) begin 
      queue_out_p0.push_back(pkt);
      if (p_type_i == 8'hF4 || p_type_i == 8'hF5) begin
        config_err0 = 1;
      end
    end
    else if (pkt.dst == addr_port1) begin
      queue_out_p1.push_back(pkt);
      if (p_type_i == 8'hF4 || p_type_i == 8'hF5) begin
        config_err1 = 1;
      end
    end
    else if (pkt.dst == addr_port2) begin
      queue_out_p2.push_back(pkt);
      if (p_type_i == 8'hF4 || p_type_i == 8'hF5) begin
        config_err2 = 1;
      end
    end
    else if (pkt.dst == addr_port3) begin
      queue_out_p3.push_back(pkt);
      if (p_type_i == 8'hF4 || p_type_i == 8'hF5) begin
        config_err3 = 1;
      end
    end
  endtask
    
  // analysis port write function : for port0 output transaction
  virtual function void write_out0_monitor(tx  item_out0);
    total_mon++;
    {src_o, dst_o, checksum_o, p_type_o, data0_o, data1_o, data2_o, data3_o} = item_out0.inp;
    {src_i, dst_i, checksum_i, p_type_i, data0_i, data1_i, data2_i, data3_i} = queue_out_p0.pop_front();
    calc_checksum_out();

    if (p_type_o == 8'hF6 || p_type_o == 8'hF7) begin
      response_analysis_port_out0.write(item_out0);  
    end
    else if ((p_type_o == 8'hF8 && config_err0 == 1) || data2_o == 8'hFF) begin
      response_analysis_port_out0.write(item_out0);  
      config_err0 = 0;
    end
    
    pop();
  endfunction
    
  // analysis port write function : for port1 output transaction
  virtual function void write_out1_monitor(tx  item_out1);
    total_mon++;
    {src_o, dst_o, checksum_o, p_type_o, data0_o, data1_o, data2_o, data3_o} = item_out1.inp;
    {src_i, dst_i, checksum_i, p_type_i, data0_i, data1_i, data2_i, data3_i} = queue_out_p1.pop_front();
    calc_checksum_out();

    if (p_type_o == 8'hF6 || p_type_o == 8'hF7) begin
      response_analysis_port_out1.write(item_out1);      
    end
    else if ((p_type_o == 8'hF8 && config_err1 == 1) || data2_o == 8'hFF) begin
      response_analysis_port_out1.write(item_out1);  
      config_err1 = 0;
    end    
    
    pop();
    
  endfunction
 
  // analysis port write function : for port2 output transaction
  virtual function void write_out2_monitor(tx  item_out2);
    total_mon++;
    {src_o, dst_o, checksum_o, p_type_o, data0_o, data1_o, data2_o, data3_o} = item_out2.inp;
    {src_i, dst_i, checksum_i, p_type_i, data0_i, data1_i, data2_i, data3_i} = queue_out_p2.pop_front();
    calc_checksum_out();

    if (p_type_o == 8'hF6 || p_type_o == 8'hF7) begin
      response_analysis_port_out2.write(item_out2);      
    end
    else if ((p_type_o == 8'hF8 && config_err2 == 1) || data2_o == 8'hFF) begin
      response_analysis_port_out2.write(item_out2);  
      config_err2 = 0;
    end
    
    pop();
    
  endfunction
    
  // analysis port write function : for port3 output transaction
  virtual function void write_out3_monitor(tx  item_out3);
    total_mon++;
    {src_o, dst_o, checksum_o, p_type_o, data0_o, data1_o, data2_o, data3_o} = item_out3.inp;
    {src_i, dst_i, checksum_i, p_type_i, data0_i, data1_i, data2_i, data3_i} = queue_out_p3.pop_front();
    calc_checksum_out();

    if (p_type_o == 8'hF6 || p_type_o == 8'hF7) begin
      response_analysis_port_out3.write(item_out3);      
    end
    else if ((p_type_o == 8'hF8 && config_err3 == 1) || data2_o == 8'hFF) begin
      response_analysis_port_out3.write(item_out3);  
      config_err3 = 0;
    end
    
    pop();
    
  endfunction
  
// Pop from queues
  task pop();     
    if (p_type_o == 8'hF1) begin
      comparison_bct();  
    end    
    if (p_type_o == 8'hF2) begin
      comparison_mct();  
    end    
    if (p_type_o == 8'hF3) begin
      comparison_oto();  
    end   
    if (p_type_o == 8'hF6 || p_type_o == 8'hF7) begin
      config_comparison();       
    end   
    if (p_type_o == 8'hF8) begin
      comparison_error_pkt();
    end
  endtask
  
  
  
  //-------------------------------
  // comparison of results
  //-------------------------------
  
  // configuration packets comparison
  task config_comparison();
    total_config++;
    if (p_type_i == 8'hF4 && p_type_o == 8'hF6) begin
      if (src_i == dst_o && dst_i == src_o && out_checksum_new == checksum_o) begin
        pass_config++;
      end
      else begin
      	`uvm_info("Scoreboard", $sformatf("Error: Port %h failed to recieve Configuration Response packet!!",dst_o), UVM_LOW)
        fail_config++;
        `uvm_fatal("Scoreboard","Request Error")
      end
    end
    else begin
      if (p_type_i == 8'hF5 && p_type_o == 8'hF7 && dst_i == src_o  && dst_o == data0_i && out_checksum_new == checksum_o) begin
        pass_config++;
      end
      else begin
      	`uvm_info("Scoreboard", $sformatf("Error: Port: %h failed to recieve Configuration Confirmation packet!!",dst_o), UVM_LOW)
        fail_config++;
        `uvm_fatal("Scoreboard","Configuration packet error")
      end
    end
    prints();
  endtask
  
  // Error packet
  task comparison_error_pkt();
    total_errors++;
      if (data0_o[3:0] == 4'hF) begin
        if (src_o == 8'hFF && data0_i[3:0] == data0_o[3:0] && out_checksum_new == checksum_o) begin
          pass_dst_err++;
        end
        else begin
          `uvm_info("Scoreboard", $sformatf("Invalid Error packet: For Invalid Destination Address Recieved by Port: %h!!",dst_o), UVM_LOW)
          fail_dst_err++;
          `uvm_fatal("Scoreboard","Destination Error Invalid")
        end
      end
      if (data0_o[7:4] == 4'hF) begin
        if (src_o == 8'hFF && data0_i[7:4] == data0_o[7:4] && out_checksum_new == checksum_o) begin
          pass_src_err++;
        end
        else begin
          `uvm_info("Scoreboard", $sformatf("Invalid Error packet: For Invalid Source Address Recieved by Port: %h!!",dst_o), UVM_LOW)
          fail_src_err++;
          `uvm_fatal("Scoreboard","Source Error Invalid")
        end
      end
      if (data1_o == 8'hFF) begin
        if (src_o == 8'hFF && out_checksum_new == checksum_o) begin
          pass_cks_err++;
        end
        else begin
          `uvm_info("Scoreboard", $sformatf("Invalid Error packet: For Invalid Checksum Recieved by Port: %h!!",dst_o), UVM_LOW)
          fail_cks_err++;
          `uvm_fatal("Scoreboard","Checksum Error Invalid")
        end
      end
      if (data2_o == 8'hFF && out_checksum_new == checksum_o) begin
      	`uvm_info("Scoreboard", $sformatf("Error packet: For Unsuccessful Configuration Request Recieved by Port: %h!!",dst_o), UVM_LOW)
      end
      if (data3_o == 8'hFF) begin
        if (src_o == src_i && dst_i == dst_o && out_checksum_new == checksum_o) begin
          pass_pkt_err++;
        end
        else begin
          `uvm_info("Scoreboard", $sformatf("Invalid Error packet: For Invalid Configuration Packet Recieved by Port: %h!!",dst_o), UVM_LOW)
          fail_pkt_err++;
          `uvm_fatal("Scoreboard","Configuration Error Invalid")
        end
      end
      prints();
  endtask
  
  // Broadcast Packets
  task comparison_bct();
    total_bct++;
    if ({src_i, dst_i, checksum_i, p_type_i, data0_i, data1_i, data2_i, data3_i} == {src_o, dst_o, checksum_o, p_type_o, data0_o, data1_o, data2_o, data3_o}) begin
      pass_bct++;
    end
    else begin
      `uvm_info("Scoreboard", $sformatf("Error: Port %h failed to recieve Broadcast packet sent by Port %h!",dst_o,src_o), UVM_LOW)
      fail_bct++;
      `uvm_fatal("Scoreboard","Broadcast Packet Error")
    end
    prints();
  endtask
  
  // Multicast Packets  
  task comparison_mct();
    total_mct++;
    if ({src_i, dst_i, checksum_i, p_type_i, data0_i, data1_i, data2_i, data3_i} == {src_o, dst_o, checksum_o, p_type_o, data0_o, data1_o, data2_o, data3_o}) begin
      pass_mct++;
    end
    else begin
     `uvm_info("Scoreboard", $sformatf("Error: Port %h failed to recieve Multicast packet sent by Port %h!",dst_o,src_o), UVM_LOW)
      fail_mct++;
      `uvm_fatal("Scoreboard","Multicast Packet Error")
    end 
    prints();   
  endtask
  
  // one to one packets
  task comparison_oto();
    total_oto++;
    if ({src_i, dst_i, checksum_i, p_type_i, data0_i, data1_i, data2_i, data3_i} == {src_o, dst_o, checksum_o, p_type_o, data0_o, data1_o, data2_o, data3_o}) begin
      pass_oto++;
    end
    else begin
      `uvm_info("Scoreboard", $sformatf("Error: One_to_one packet sent by Port %h not recieved at Port %h!",src_o,dst_o), UVM_LOW)
      fail_oto++;
      `uvm_fatal("Scoreboard","One to one error")
    end 
    prints();
  endtask
  
  //prints
  function prints();
    `uvm_info("Scoreboard", $sformatf("PORT 0 ADDRESS: %h, PORT 1 ADDRESS: %h, PORT 2 ADDRESS: %h, PORT 3 ADDRESS: %h",addr_port0,addr_port1,addr_port2,addr_port3), UVM_LOW)
  	
    `uvm_info("RESULTS", $sformatf("============================================================================================================================================================="), UVM_LOW)
    `uvm_info("TOTAL PASS", $sformatf("ONE_TO_ONE TEST = %0d    BROADCAST TEST = %0d    MULTICAST TEST = %0d   CONFIGURATION TEST = %0d   SOURCE ERROR TEST = %0d   DESTINATION ERROR TEST = %0d   CHECKSUM ERROR TEST = %0d   CONFIGURATION PACKET ERROR TEST = %0d", pass_oto,pass_bct,pass_mct,pass_config,pass_src_err,pass_dst_err,pass_cks_err,pass_pkt_err), UVM_LOW)
    
    `uvm_info("TOTAL FAIL", $sformatf("ONE_TO_ONE TEST = %0d    BROADCAST TEST = %0d    MULTICAST TEST = %0d   CONFIGURATION TEST = %0d   SOURCE ERROR TEST = %0d   DESTINATION ERROR TEST = %0d   CHECKSUM ERROR TEST = %0d   CONFIGURATION PACKET ERROR TEST = %0d", fail_oto,fail_bct,fail_mct,fail_config,fail_src_err,fail_dst_err,fail_cks_err,fail_pkt_err), UVM_LOW)
    
    `uvm_info("RESULTS", $sformatf("TOTAL MONITORED  = %0d  | TOTAL BROADCAST PACKETS = %0d  | TOTAL ONE_TO_ONE PACKETS = %0d  | TOTAL MULTICAST PACKETS = %0d | TOTAL CONFIG PACKETS = %0d | TOTAL ERROR PACKETS = %0d", total_mon,total_bct,total_oto,total_mct,total_config,total_errors), UVM_LOW)
   
    `uvm_info("RESULTS", $sformatf("============================================================================================================================================================="), UVM_LOW)
  endfunction
  
 
endclass

