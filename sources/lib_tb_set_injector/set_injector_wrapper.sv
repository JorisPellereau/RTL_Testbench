//                              -*- Mode: Verilog -*-
// Filename        : set_injector_wrapper.sv
// Description     : SET INJECTOR WRAPPER
// Author          : JorisP
// Created On      : Sat Nov 21 11:58:23 2020
// Last Modified By: JorisP
// Last Modified On: Sat Nov 21 11:58:23 2020
// Update Count    : 0
// Status          : Unknown, Use with caution!
/* -----\/----- EXCLUDED -----\/-----

interface set_injector_intf #(
     parameter SET_SIZE  = 5,
     parameter SET_WIDTH = 32
   );

   string  set_alias [SET_SIZE];
   logic   [SET_WIDTH - 1 : 0] set_signals_asynch_init_value  [SET_SIZE];   
   logic   [SET_WIDTH - 1 : 0] set_signals_asynch             [SET_SIZE];
   logic   [SET_WIDTH - 1 : 0] set_signals_synch              [SET_SIZE];
   
endinterface // set_injector_intf
 -----/\----- EXCLUDED -----/\----- */


module set_injector_wrapper #(
     parameter ARGS_NB = 5
   )
   (
    input 	      clk,
    input 	      rst_n,

    set_injector_intf set_injector_if

   );
   

   // SET INJECTOR TESTBENCH MODULE INST
   set_injector_tb #(
		     .SET_SIZE   (set_injector_if.SET_SIZE),
		     .SET_WIDTH  (set_injector_if.SET_WIDTH)
   )
   i_set_injector_tb (
		      .clk    (clk),
		      .rst_n  (rst_n),

		      .i_set_signals_asynch  (set_injector_if.set_signals_asynch),
		      .o_set_signals_synch   (set_injector_if.set_signals_synch)
   );
   
endmodule // set_injector_wrapper
