//                              -*- Mode: Verilog -*-
// Filename        : set_injector_tb.sv
// Description     : SET INJECTOR TESTBENCH MODULE
// Author          : JorisP
// Created On      : Sat Nov 21 11:56:22 2020
// Last Modified By: JorisP
// Last Modified On: Sat Nov 21 11:56:22 2020
// Update Count    : 0
// Status          : Unknown, Use with caution!

module set_injector_tb #(
     parameter SET_SIZE  = 5,
     parameter SET_WIDTH = 32
   )
   (
     input clk,        
     input rst_n,

     input      [SET_WIDTH - 1 : 0] i_set_signals_asynch [SET_SIZE],
     output reg [SET_WIDTH - 1 : 0] o_set_signals_synch  [SET_SIZE]        
   );
   

   // RESYNCH INPUTS
   always @(posedge clk) begin
      if(!rst_n) begin
	 for(int i = 0 ; i < SET_WIDTH ; i++) begin
	    o_set_signals_synch[i] <= 0;	    
	 end	 
      end
      else begin
	 o_set_signals_synch <= i_set_signals_asynch; // Resynch signals	 
      end     
   end
   
endmodule // set_injector_tb
