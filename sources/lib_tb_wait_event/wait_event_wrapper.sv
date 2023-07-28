//                              -*- Mode: Verilog -*-
// Filename        : wait_event_wrapper.sv
// Description     : Wait Event TB Module Wrapper
// Author          : JorisP
// Created On      : Fri Nov 13 19:57:26 2020
// Last Modified By: JorisP
// Last Modified On: Fri Nov 13 19:57:26 2020
// Update Count    : 0
// Status          : Unknown, Use with caution!


interface wait_event_intf #(
     parameter WAIT_SIZE  = 5,
     parameter WAIT_WIDTH = 1
   );

   logic en_wait_event;   
   int 	 wait_en;  
   logic sel_wtr_wtf;
   logic [31:0] max_timeout;   
   string 	wait_alias [WAIT_SIZE];   
   logic [WAIT_WIDTH - 1 : 0] wait_signals [WAIT_SIZE];  
   logic 		      wait_done;
   
   
endinterface // wait_event_int


module wait_event_wrapper #(
     parameter ARGS_NB = 5,
     parameter CLK_PERIOD = 2000		    			    
   )
   (
      input clk,
      input rst_n,
      wait_event_intf wait_event_if    
   );
   
   // WAIT EVENT TB Module INST
   wait_event_tb #(
		.ARGS_NB    (ARGS_NB),		
		.WAIT_SIZE  (wait_event_if.WAIT_SIZE),
		.WAIT_WIDTH (wait_event_if.WAIT_WIDTH),
		.CLK_PERIOD (CLK_PERIOD)   
   )
   i_wait_event_tb (
       .clk         (clk),
       .rst_n       (rst_n),
	
       .i_en_wait_event (wait_event_if.en_wait_event),	    
       .i_wait_en       (wait_event_if.wait_en),
       .i_sel_wtr_wtf   (wait_event_if.sel_wtr_wtf),
       .i_max_timeout   (wait_event_if.max_timeout),
       .i_wait          (wait_event_if.wait_signals),
       .o_wait_done     (wait_event_if.wait_done)		    
   );
   
endmodule // wait_event_wrapper
