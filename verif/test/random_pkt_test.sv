////////////////////////////////////////////////////////////////////////////////
//
// Filename : random_pkt_test.sv
// Author : Asmara Rauf
// Creation Date : 08/20/2024
//
// No portions of this material may be reproduced in any form without
// the written permission of CoMira solutions Inc.
//
// All information contained in this document is CoMira solutions
// private, proprietary and trade secret.
//
// Description
// ===========
// This module contains Error/random packets, to test dut in case of invalid random packets, extended from uvm_test base component.
//
// ///////////////////////////////////////////////////////////////////////////////


class random_pkt_test extends uvm_test;

  `uvm_component_utils(random_pkt_test)

  // constructor
  function new(string name="random_pkt_test",uvm_component parent);
    super.new(name,parent);
  endfunction

  // declarations
  environment     env;
  tx              item_0;
  tx              item_1;
  tx              item_2;
  tx              item_3;
  reset_low_seq   reset_0;		
  reset_high_seq  reset_1;  
  config_req_seq  req_seq0;
  config_req_seq  req_seq1;
  config_req_seq  req_seq2;
  config_req_seq  req_seq3;
  config_pkt_seq  pkt_seq0;
  config_pkt_seq  pkt_seq1;
  config_pkt_seq  pkt_seq2;
  config_pkt_seq  pkt_seq3;  
  sanity_pkt_seq  flit0;
  sanity_pkt_seq  flit1;
  sanity_pkt_seq  flit2;
  sanity_pkt_seq  flit3;
  
  error_pkt_seq       flit0_err;
  error_pkt_seq       flit1_err;
  error_pkt_seq       flit2_err;
  error_pkt_seq       flit3_err;
  invalid_req_seq     err_req0;
  invalid_req_seq     err_req1;
  invalid_req_seq     err_req2;
  invalid_req_seq     err_req3;
  invalid_config_seq  err_cfg0;
  invalid_config_seq  err_cfg1;
  invalid_config_seq  err_cfg2;
  invalid_config_seq  err_cfg3;
  
  logic [7:0] addr_0;
  logic [7:0] addr_1;
  logic [7:0] addr_2;
  logic [7:0] addr_3; 
  logic [7:0] dst;
  
  bit done_config0;
  bit done_config1;
  bit done_config2;
  bit done_config3;

  int random;
  int temp; 
  

  uvm_tlm_analysis_fifo #(tx) rsp_analysis_fifo_0;
  uvm_tlm_analysis_fifo #(tx) rsp_analysis_fifo_1;
  uvm_tlm_analysis_fifo #(tx) rsp_analysis_fifo_2;
  uvm_tlm_analysis_fifo #(tx) rsp_analysis_fifo_3;

  // build phase
  function void build_phase(uvm_phase phase);
    env      = environment :: type_id :: create("env",this);
    item_0   = tx :: type_id   :: create("item_0",this);
    item_1   = tx :: type_id   :: create("item_1",this);
    item_2   = tx :: type_id   :: create("item_2",this);
    item_3   = tx :: type_id   :: create("item_3",this);
    reset_0  = reset_low_seq   :: type_id :: create("reset_0",this);
    reset_1  = reset_high_seq  :: type_id :: create("reset_1",this);
    flit0    = sanity_pkt_seq  :: type_id :: create("flit0",this);
    flit1    = sanity_pkt_seq  :: type_id :: create("flit1",this);
    flit2    = sanity_pkt_seq  :: type_id :: create("flit2",this);
    flit3    = sanity_pkt_seq  :: type_id :: create("flit3",this);
    req_seq0 = config_req_seq  :: type_id :: create("req_seq0",this);
    req_seq1 = config_req_seq  :: type_id :: create("req_seq1",this);
    req_seq2 = config_req_seq  :: type_id :: create("req_seq2",this);
    req_seq3 = config_req_seq  :: type_id :: create("req_seq3",this);
    pkt_seq0 = config_pkt_seq  :: type_id :: create("pkt_seq0",this);
    pkt_seq1 = config_pkt_seq  :: type_id :: create("pkt_seq1",this);
    pkt_seq2 = config_pkt_seq  :: type_id :: create("pkt_seq2",this);
    pkt_seq3 = config_pkt_seq  :: type_id :: create("pkt_seq3",this);
    
    flit0_err = error_pkt_seq  :: type_id :: create("flit0_err",this);
    flit1_err = error_pkt_seq  :: type_id :: create("flit1_err",this);
    flit2_err = error_pkt_seq  :: type_id :: create("flit2_err",this);
    flit3_err = error_pkt_seq  :: type_id :: create("flit3_err",this);
    err_req0 = invalid_req_seq :: type_id :: create("err_req0",this);
    err_req1 = invalid_req_seq :: type_id :: create("err_req1",this);
    err_req2 = invalid_req_seq :: type_id :: create("err_req2",this);    
    err_req3 = invalid_req_seq :: type_id :: create("err_req3",this);
    err_cfg0 = invalid_config_seq :: type_id :: create("err_cfg0",this);
    err_cfg1 = invalid_config_seq :: type_id :: create("err_cfg1",this);
    err_cfg2 = invalid_config_seq :: type_id :: create("err_cfg2",this);
    err_cfg3 = invalid_config_seq :: type_id :: create("err_cfg3",this);
    
    rsp_analysis_fifo_0 = new("port0_analysis_fifo", this);
    rsp_analysis_fifo_1 = new("port1_analysis_fifo", this);
    rsp_analysis_fifo_2 = new("port2_analysis_fifo", this);
    rsp_analysis_fifo_3 = new("port3_analysis_fifo", this);
    
    addr_0 = 8'hFA;
    addr_1 = 8'hFB;
    addr_2 = 8'hFC;
    addr_3 = 8'hFD;
    done_config0 = 1;
    done_config1 = 1;
    done_config2 = 1;
    done_config3 = 1;
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    env.scb.response_analysis_port_out0.connect(rsp_analysis_fifo_0.analysis_export);
    env.scb.response_analysis_port_out1.connect(rsp_analysis_fifo_1.analysis_export);    
    env.scb.response_analysis_port_out2.connect(rsp_analysis_fifo_2.analysis_export);    
    env.scb.response_analysis_port_out3.connect(rsp_analysis_fifo_3.analysis_export);
  endfunction
  
  // run phase
  virtual task run_phase(uvm_phase phase);
  super.run_phase(phase);
  phase.raise_objection(this);  
  repeat(20) begin                                      
	  reset_0.start(env.agent_rst.sqr);  
  end 
  reset_1.start(env.agent_rst.sqr);
	
  port0_test();
  port1_test();
  port2_test();
  port3_test();
	
  //error tasks
  repeat($urandom_range(1,2000)) begin
    fork 
      begin
	error_test_port0();
      end
      begin
	error_test_port1();
      end
      begin
	error_test_port2();
      end
      begin
	error_test_port3(); 
      end
    join
  end
	
  //sanity test
  repeat($urandom_range(1,10)) begin
    temp = $urandom_range(1,4);
    case (temp)
      1: port2_test(); 
      2: port3_test(); 
      3: port1_test(); 
      4: port0_test(); 
    endcase
  end
	
  //error tasks
  repeat($urandom_range(1,2000)) begin
    temp = $urandom_range(1,4);
    case (temp)
      1: error_test_port2();
      2: error_test_port3(); 
      3: error_test_port0();
      4: error_test_port1();
    endcase
  end
 
  #100000; 
  wait fork;
  phase.drop_objection(this);
  endtask   
   
  
  //Sanity Tasks 
  //port 0  
  task port0_test();  
    if (done_config0 == 1) begin    
      req_seq0.set_credentials(addr_0,8'hFF);
      req_seq0.start(env.agent_port0.sqr);                 
    end                                                 
    done_config0 = 0;
    rsp_analysis_fifo_0.get(item_0);  	
  		
    if (item_0.inp.p_type == 8'hF6) begin                 
      done_config0 = 1;
      pkt_seq0.set_credentials(addr_0,8'hFF);
      pkt_seq0.start(env.agent_port0.sqr);                 
     
      while (item_0.inp.p_type != 8'hF7) begin
  	rsp_analysis_fifo_0.get(item_0);
        if (item_0.inp.p_type == 8'hF8) begin
  	  pkt_seq0.set_credentials(addr_0,8'hFF);
      	  pkt_seq0.start(env.agent_port0.sqr);           
        end
      end
      	
      if (item_0.inp.p_type == 8'hF7) begin                      
        addr_0 = item_0.inp.dst;
	repeat($urandom_range(1,5)) begin 
	  random   = $urandom_range(1,4);
	  case(random)
    	    1: dst = addr_0;
    	    2: dst = addr_3;
    	    3: dst = addr_1;
    	    4: dst = addr_2;
   	  endcase
   	  flit0.set_credentials(addr_0,dst);
   	  flit0.start(env.agent_port0.sqr);               
	end
      end
    end
    else begin
      done_config0 = 1;
    end
  endtask
  
  //port 1  
  task port1_test();   
    if (done_config1 == 1) begin    
      req_seq1.set_credentials(addr_1,8'hFF);
      req_seq1.start(env.agent_port1.sqr);
    end 
    done_config1 = 0;                                              
    rsp_analysis_fifo_1.get(item_1);
 
    if (item_1.inp.p_type == 8'hF6) begin                         
      done_config1 = 1;
      pkt_seq1.set_credentials(addr_1,8'hFF);
      pkt_seq1.start(env.agent_port1.sqr);
      	
      while (item_1.inp.p_type != 8'hF7) begin
        rsp_analysis_fifo_1.get(item_1);
      	if (item_1.inp.p_type == 8'hF8) begin
      	  pkt_seq1.set_credentials(addr_1,8'hFF);
      	  pkt_seq1.start(env.agent_port1.sqr); 
      	end      		
      end          
            	
      if (item_1.inp.p_type == 8'hF7) begin                     
        addr_1 = item_1.inp.dst;  
	repeat($urandom_range(1,5)) begin 
	  random   = $urandom_range(1,4);	
	  case(random)
    	    1: dst = addr_0;
    	    2: dst = addr_3;
    	    3: dst = addr_1;
    	    4: dst = addr_2;
   	  endcase
   	  flit1.set_credentials(addr_1,dst);
   	  flit1.start(env.agent_port1.sqr);
	end
      end
    end
    else begin
      done_config1 = 1;
    end
  endtask
  
  
  //port 2  
  task port2_test();
    if (done_config2 == 1) begin 
      req_seq2.set_credentials(addr_2,8'hFF);
      req_seq2.start(env.agent_port2.sqr);                     
    end
    done_config2 = 0; 
    rsp_analysis_fifo_2.get(item_2);
 
    if (item_2.inp.p_type == 8'hF6) begin                         
      done_config2 = 1;
      pkt_seq2.set_credentials(addr_2,8'hFF);
      pkt_seq2.start(env.agent_port2.sqr); 
      	
      while (item_2.inp.p_type != 8'hF7) begin
        rsp_analysis_fifo_2.get(item_2);
      	if (item_2.inp.p_type == 8'hF8) begin
      	  pkt_seq2.set_credentials(addr_2,8'hFF);
      	  pkt_seq2.start(env.agent_port2.sqr);  
      	end    		
      end      	
      
      if (item_2.inp.p_type == 8'hF7) begin                       
  	addr_2 = item_2.inp.dst;
	repeat($urandom_range(1,5)) begin 
	  random   = $urandom_range(1,4);	
	  case(random)
    	    1: dst = addr_0;
    	    2: dst = addr_3;
    	    3: dst = addr_1;
    	    4: dst = addr_2;
   	  endcase
   	  flit2.set_credentials(addr_2,dst);
   	  flit2.start(env.agent_port2.sqr);
	end
      end
    end
    else begin
      done_config2 = 1;
    end
  endtask
  
  
  //port 3 
  task port3_test();
    if (done_config3 == 1) begin 
      req_seq3.set_credentials(addr_3,8'hFF);
      req_seq3.start(env.agent_port3.sqr);                      
    end
    done_config3 = 0; 
    rsp_analysis_fifo_3.get(item_3);
  		
    if (item_3.inp.p_type == 8'hF6) begin 
      done_config3 = 1;                                      
      pkt_seq3.set_credentials(addr_3,8'hFF);
      pkt_seq3.start(env.agent_port3.sqr); 
      	
      while (item_3.inp.p_type != 8'hF7) begin
      	rsp_analysis_fifo_3.get(item_3);
      	if (item_3.inp.p_type == 8'hF8) begin 
      	  pkt_seq3.set_credentials(addr_3,8'hFF);
      	  pkt_seq3.start(env.agent_port3.sqr); 
      	end    		
      end 
             	
      if (item_3.inp.p_type == 8'hF7) begin                      
        addr_3 = item_3.inp.dst;  
	repeat($urandom_range(1,5)) begin 	
	  random   = $urandom_range(1,4);
	  case(random)
    	    1: dst = addr_0;
    	    2: dst = addr_3;
    	    3: dst = addr_1;
    	    4: dst = addr_2;
   	  endcase
   	  flit3.set_credentials(addr_3,dst);
   	  flit3.start(env.agent_port3.sqr);
	end
      end
    end
    else begin
      done_config3 = 1;   
    end
  endtask
   
   
  //Error/Random Packets Tasks
  //port0  
  task error_test_port0();
    if (done_config0 == 1) begin 
      temp = $urandom_range(1,4); 
      if (temp == 1) begin
    	req_seq0.set_credentials(addr_0,8'hFF);
    	req_seq0.start(env.agent_port0.sqr); 
      end
      else begin
    	err_req0.start(env.agent_port0.sqr);
      end
    end
    done_config0 = 0;
    rsp_analysis_fifo_0.get(item_0); 
          
    if (item_0.inp.p_type == 8'hF6) begin   
      done_config0 = 1;
      temp = $urandom_range(1,4); 
      if (temp == 1)  begin
        pkt_seq0.set_credentials(addr_0,8'hFF);
      	pkt_seq0.start(env.agent_port0.sqr);
      end 
      else  begin
        err_cfg0.start(env.agent_port0.sqr);
      end
      while (item_0.inp.p_type != 8'hF7) begin
        rsp_analysis_fifo_0.get(item_0);
  	if (item_0.inp.p_type == 8'hF8) begin
  	  temp = $urandom_range(1,4); 
  	  if (temp == 2)  begin
      	    pkt_seq0.set_credentials(addr_0,8'hFF);
      	    pkt_seq0.start(env.agent_port0.sqr);
      	  end 
      	  else  begin
            err_cfg0.start(env.agent_port0.sqr);
      	  end
  	end
      end
      
      if (item_0.inp.p_type == 8'hF7) begin
	addr_0 = item_0.inp.dst;
    	repeat($urandom_range(1,500)) begin
    	  flit0_err.start(env.agent_port0.sqr); 
    	  random     = $urandom_range(1,4);
	  case(random)
    	    1: dst = addr_0;
    	    2: dst = addr_3;
    	    3: dst = addr_1;
    	    4: dst = addr_2;
   	  endcase
   	  flit0.set_credentials(addr_0,dst);
   	  flit0.start(env.agent_port0.sqr);
        end
      end
    end
    else begin
      done_config0 = 1;   
    end
  endtask
    
  // port1  
  task error_test_port1(); 
    if (done_config1 == 1) begin 
      temp = $urandom_range(1,4); 
      if (temp == 2) begin
    	req_seq1.set_credentials(addr_1,8'hFF);
    	req_seq1.start(env.agent_port1.sqr); 
      end
      else begin
    	err_req1.start(env.agent_port1.sqr);
      end   
    end
    done_config1 = 1;   
    rsp_analysis_fifo_1.get(item_1);
           
    if (item_1.inp.p_type == 8'hF6) begin
      done_config1 = 1;  
      temp = $urandom_range(1,4); 
      if (temp == 2)  begin
      	pkt_seq1.set_credentials(addr_1,8'hFF);
      	pkt_seq1.start(env.agent_port1.sqr);
      end 
      else  begin
        err_cfg1.start(env.agent_port1.sqr);
      end
      while (item_1.inp.p_type != 8'hF7) begin
        rsp_analysis_fifo_1.get(item_1);
  	if (item_1.inp.p_type == 8'hF8) begin
  	  temp = $urandom_range(1,4); 
  	  if (temp == 3)  begin
      	    pkt_seq1.set_credentials(addr_1,8'hFF);
      	    pkt_seq1.start(env.agent_port1.sqr);
      	  end 
      	  else  begin
            err_cfg1.start(env.agent_port1.sqr);
      	  end
  	end
      end
      
      if (item_1.inp.p_type == 8'hF7) begin
	addr_1 = item_1.inp.dst;
    	repeat($urandom_range(1,500)) begin
    	  flit1_err.start(env.agent_port1.sqr); 
    	  random     = $urandom_range(1,4);
	  case(random)
    	    1: dst = addr_0;
    	    2: dst = addr_3;
    	    3: dst = addr_1;
    	    4: dst = addr_2;
   	  endcase
   	  flit1.set_credentials(addr_1,dst);
   	  flit1.start(env.agent_port1.sqr);
        end
      end 
    end 
    else begin
      done_config1 = 1;   
    end
  endtask
  
  // port2
  task error_test_port2(); 
    if (done_config2 == 1) begin 
      temp = $urandom_range(1,4); 
      if (temp == 3) begin
        req_seq2.set_credentials(addr_2,8'hFF);
    	req_seq2.start(env.agent_port2.sqr); 
      end
      else begin
    	err_req2.start(env.agent_port2.sqr);
      end   
    end
    done_config2 = 1;
    rsp_analysis_fifo_2.get(item_2); 
          
    if (item_2.inp.p_type == 8'hF6) begin
      done_config2 = 1;
      temp = $urandom_range(1,4); 
      if (temp == 3)  begin
      	pkt_seq2.set_credentials(addr_2,8'hFF);
      	pkt_seq2.start(env.agent_port2.sqr);
      end 
      else  begin
        err_cfg2.start(env.agent_port2.sqr);
      end
      while (item_2.inp.p_type != 8'hF7) begin
  	rsp_analysis_fifo_2.get(item_2);
  	if (item_2.inp.p_type == 8'hF8) begin
  	  temp = $urandom_range(1,4); 
  	  if (temp == 4)  begin
      	    pkt_seq2.set_credentials(addr_2,8'hFF);
      	    pkt_seq2.start(env.agent_port2.sqr);
      	  end 
      	  else  begin
            err_cfg2.start(env.agent_port2.sqr);
      	  end
  	end
      end
      
      if (item_2.inp.p_type == 8'hF7) begin
	addr_2 = item_2.inp.dst;
    	repeat($urandom_range(1,500)) begin
    	  flit2_err.start(env.agent_port2.sqr);
    	  random     = $urandom_range(1,4);
	  case(random)
    	    1: dst = addr_0;
    	    2: dst = addr_3;
    	    3: dst = addr_1;
    	    4: dst = addr_2;
   	  endcase
   	  flit2.set_credentials(addr_2,dst);
   	  flit2.start(env.agent_port2.sqr);
        end
      end 
    end 
    else begin
      done_config2 = 1;   
    end
  endtask
  
  //port 3
  task error_test_port3(); 
    if (done_config3 == 1) begin 
      temp = $urandom_range(1,4); 
      if (temp == 4) begin
        req_seq3.set_credentials(addr_3,8'hFF);
    	req_seq3.start(env.agent_port3.sqr); 
      end
      else begin
    	err_req3.start(env.agent_port3.sqr);
      end  
    end
    done_config3 = 1;
    rsp_analysis_fifo_3.get(item_3); 
           
    if (item_3.inp.p_type == 8'hF6) begin
      done_config3 = 1;
      temp = $urandom_range(1,4); 
      if (temp == 4)  begin
      	pkt_seq3.set_credentials(addr_3,8'hFF);
      	pkt_seq3.start(env.agent_port3.sqr);
      end 
      else  begin
        err_cfg3.start(env.agent_port3.sqr);
      end
      while (item_3.inp.p_type != 8'hF7) begin
  	rsp_analysis_fifo_3.get(item_3);
  	if (item_3.inp.p_type == 8'hF8) begin
  	  temp = $urandom_range(1,4); 
  	  if (temp == 1)  begin
      	    pkt_seq3.set_credentials(addr_3,8'hFF);
      	    pkt_seq3.start(env.agent_port3.sqr);
      	  end 
      	  else  begin
            err_cfg3.start(env.agent_port3.sqr);
      	  end
  	end
      end
      
      if (item_3.inp.p_type == 8'hF7) begin
	addr_3 = item_3.inp.dst;
    	repeat($urandom_range(1,500)) begin
    	  flit3_err.start(env.agent_port3.sqr);
    	  random     = $urandom_range(1,4);
	  case(random)
    	    1: dst = addr_0;
    	    2: dst = addr_3;
    	    3: dst = addr_1;
    	    4: dst = addr_2;
   	  endcase
   	  flit3.set_credentials(addr_3,dst);
   	  flit3.start(env.agent_port3.sqr);
      	end
      end
    end 
    else begin
      done_config3 = 1;   
    end
  endtask
    
endclass
