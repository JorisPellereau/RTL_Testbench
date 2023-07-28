// Wait Event Testbench Block

/* -----\/----- EXCLUDED -----\/-----

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
 -----/\----- EXCLUDED -----/\----- */


module wait_event #(
		    parameter ARGS_NB = 5,
		    parameter CLK_PERIOD = 2000,
		    parameter WAIT_SIZE = 1,
		    parameter WAIT_WIDTH = 1
		    )
   (
    input clk,
    input rst_n    
    );

   // Internal interface
   wait_event_intf #(
		     .WAIT_SIZE   (WAIT_SIZE),
		     .WAIT_WIDTH  (WAIT_WIDTH)
		     )
   wait_event_if();

 
   
   
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
