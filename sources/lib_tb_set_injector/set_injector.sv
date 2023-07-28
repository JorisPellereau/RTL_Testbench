
module set_injector #(
		      parameter ARGS_NB    = 5,
		      parameter SET_SIZE   = 5,
		      parameter SET_WIDTH  = 16
   )
   (
    input clk,
    input rst_n
   );

   set_injector_intf #(
		       .SET_SIZE  (SET_SIZE),
		       .SET_WIDTH (SET_WIDTH)
		       )
   set_injector_if();

   // SET INJECTOR TESTBENCH MODULE INST
   set_injector_tb #(
		     .SET_SIZE   (SET_SIZE),
		     .SET_WIDTH  (SET_WIDTH)
   )
   i_set_injector_tb (
		      .clk    (clk),
		      .rst_n  (rst_n),

		      .i_set_signals_asynch  (set_injector_if.set_signals_asynch),
		      .o_set_signals_synch   (set_injector_if.set_signals_synch)
   );
   
endmodule // set_injector

