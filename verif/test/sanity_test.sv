////////////////////////////////////////////////////////////////////////////////
//
// Filename : sanity_test.sv
// Author : Asmara Rauf
// Creation Date : 08/16/2024
//
// Description
// ===========
// This module contains basic sanity test, extended from uvm_test base component.
//
// ///////////////////////////////////////////////////////////////////////////////


class sanity_test extends uvm_test;

  `uvm_component_utils(sanity_test)

  // constructor
  function new(string name="sanity_test",uvm_component parent);
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

  uvm_tlm_analysis_fifo #(tx) rsp_analysis_fifo_0;
  uvm_tlm_analysis_fifo #(tx) rsp_analysis_fifo_1;
  uvm_tlm_analysis_fifo #(tx) rsp_analysis_fifo_2;
  uvm_tlm_analysis_fifo #(tx) rsp_analysis_fifo_3;

  // build phase
  function void build_phase(uvm_phase phase);
    item_0   = tx :: type_id  :: create("item_0",this);
    item_1   = tx :: type_id  :: create("item_1",this);
    item_2   = tx :: type_id  :: create("item_2",this);
    item_3   = tx :: type_id  :: create("item_3",this);
    env      = environment    :: type_id :: create("env",this);
    reset_0  = reset_low_seq  :: type_id :: create("reset_0",this);
    reset_1  = reset_high_seq :: type_id :: create("reset_1",this);
    flit0    = sanity_pkt_seq :: type_id :: create("flit0",this);
    flit1    = sanity_pkt_seq :: type_id :: create("flit1",this);
    flit2    = sanity_pkt_seq :: type_id :: create("flit2",this);
    flit3    = sanity_pkt_seq :: type_id :: create("flit3",this);
    req_seq0 = config_req_seq :: type_id :: create("req_seq0",this);
    req_seq1 = config_req_seq :: type_id :: create("req_seq1",this);
    req_seq2 = config_req_seq :: type_id :: create("req_seq2",this);
    req_seq3 = config_req_seq :: type_id :: create("req_seq3",this);
    pkt_seq0 = config_pkt_seq :: type_id :: create("pkt_seq0",this);
    pkt_seq1 = config_pkt_seq :: type_id :: create("pkt_seq1",this);
    pkt_seq2 = config_pkt_seq :: type_id :: create("pkt_seq2",this);
    pkt_seq3 = config_pkt_seq :: type_id :: create("pkt_seq3",this);
    
    rsp_analysis_fifo_0 = new("rsp_analysis_fifo_0", this);
    rsp_analysis_fifo_1 = new("rsp_analysis_fifo_1", this);
    rsp_analysis_fifo_2 = new("rsp_analysis_fifo_2", this);
    rsp_analysis_fifo_3 = new("rsp_analysis_fifo_3", this);
    
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
  repeat(20) begin                                             //reset
    reset_0.start(env.agent_rst.sqr);  
  end 
  reset_1.start(env.agent_rst.sqr);
  
  port0_test();
  port1_test();
  port2_test();
  port3_test();
	
  repeat(100) begin
    fork 
      begin 
	port0_test();
      end
      begin
	port1_test();
      end
      begin
	port2_test();
      end
      begin
	port3_test();
      end
    join
  end
	
  repeat(50) begin
    fork 
      begin
	port2_test();
      end
      begin
	port3_test();
      end
    join
  end
  
  repeat(50) begin
    fork 
      begin
	port0_test();
      end
      begin
	port1_test();
      end
    join
  end

  repeat(30) begin
    fork 
      begin
	port1_test();
      end
      begin
	port3_test();
      end
    join
  end
  
  repeat(30) begin
    fork 
      begin
	port0_test();
      end
      begin
	port2_test();
      end
    join
  end

  repeat(10) begin
    fork 
      begin
	port1_test();
      end
      begin
	port2_test();
      end
    join
  end
  
  repeat(10) begin
    fork 
      begin
	port0_test();
      end
      begin
	port3_test();
      end
    join
  end
 
  #100000; 
  wait fork;
  phase.drop_objection(this);
  endtask  
    
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
	repeat($urandom_range(1,1000)) begin 
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
	repeat($urandom_range(1,1000)) begin 
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
	repeat($urandom_range(1,1000)) begin 
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
	repeat($urandom_range(1,1000)) begin 	
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
    
endclass
