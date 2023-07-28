//                              -*- Mode: Verilog -*-
// Filename        : wait_event_tb.sv
// Description     : Wait Event TestBench Module
// Author          : JorisP
// Created On      : Wed Nov 11 11:56:05 2020
// Last Modified By: JorisP
// Last Modified On: Wed Nov 11 11:56:05 2020
// Update Count    : 0
// Status          : Unknown, Use with caution!


`timescale 1ps/1ps

module wait_event_tb
   #(  
    parameter ARGS_NB    = 5, 
    parameter WAIT_SIZE  = 5,
    parameter WAIT_WIDTH = 1,
    parameter CLK_PERIOD = 1000 // Unity : ps   
  )
  (
   input 		      clk,
   input 		      rst_n,

   input 		      i_en_wait_event,   
   input int 		      i_wait_en, 
   input 		      i_sel_wtr_wtf, 
   input [31:0] 	      i_max_timeout, 
   input [WAIT_WIDTH - 1 : 0] i_wait [WAIT_SIZE],

   output bit 		      o_wait_done
   
   );


   // INTERNAL SIGNALS
   reg [WAIT_WIDTH - 1 : 0]   s_wait [WAIT_SIZE];
   reg [31:0] 		      s_timeout_cnt;

   reg 			      s_timeout_done;
   
   
   

   initial
   //shall print %t with scaled in ns (-9), with 2 precision digits, and would print the " ns" string
   $timeformat(-9, 2, " ns", 20);
   
   // LATCH INPUTS
   always @(posedge clk) begin
      if(!rst_n) begin
	 for(int i = 0 ; i < WAIT_WIDTH ; i++) begin
	    for(int j = 0 ; j < WAIT_SIZE ; j++) begin
	      s_wait[j][i] <= 0;
	    end	    
	 end
      end
      else begin
	 // LATCH WAIT Inputs
	 for(int j = 0 ; j < WAIT_SIZE ; j++) begin
	   s_wait[j] <= i_wait[j];
	 end
      end      
   end

   // EDGE DETECTION
   always @(posedge clk) begin
      if(!rst_n) begin
	 o_wait_done <= 1'b0;
      end
      else begin

	 o_wait_done <= 1'b0;

	 if(i_en_wait_event == 1'b1 && s_timeout_done == 1'b0) begin
	   // WTR selected
	   if(i_sel_wtr_wtf == 1'b0) begin
	      if(i_wait[i_wait_en] == 1'b1 && s_wait[i_wait_en] == 1'b0) begin
	         $display("WTR detected %t", $time);	       
	         o_wait_done <= 1'b1;
	      end	    
	   end
	   // WTF selected
	   else begin
	      if(i_wait[i_wait_en] == 1'b0 && s_wait[i_wait_en] == 1'b1) begin
	         $display("WTF detected %t", $time);
	         o_wait_done <= 1'b1;
	      end	
	   end // else: !if(i_sel_wtr_wtf == 1'b0)
	 end // if (i_en_wait_event == 1'b1 && s_timeout_done == 1'b0)	 
	 else if(s_timeout_done == 1'b1) begin
	    o_wait_done <= 1'b1;
	 end
      end      
   end // always @ (posedge clk)




   // Timeout Management
   always @(posedge clk) begin
      if(!rst_n) begin
	 s_timeout_cnt  <= 32'h00000000;
	 s_timeout_done <= 1'b0;
	 
      end
      else begin


	 if(i_en_wait_event == 1'b1 && i_max_timeout != 0 && s_timeout_done == 1'b0) begin
	     if(s_timeout_cnt < i_max_timeout) begin
		s_timeout_cnt <= s_timeout_cnt + 1; 
	     end
	     else begin
		$display("Error: Timeout reach : %t", $time);
                s_timeout_done <= 1'b1;				
             end
	 end
         else begin
              s_timeout_cnt  <= 32'h00000000;
	      s_timeout_done <= 1'b0;
	 end	 	 
      end      
   end
   
	
   
endmodule // wait_event_tb
