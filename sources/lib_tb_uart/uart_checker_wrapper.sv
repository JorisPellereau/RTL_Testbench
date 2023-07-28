//                              -*- Mode: Verilog -*-
// Filename        : uart_checker_wrapper.sv
// Description     : UART Injector Checker
// Author          : JorisP
// Created On      : Sat Apr 17 19:02:36 2021
// Last Modified By: JorisP
// Last Modified On: Sat Apr 17 19:02:36 2021
// Update Count    : 0
// Status          : Unknown, Use with caution!

// Limitation : Same clock for all UART TB Modules

interface uart_checker_intf #(
			      parameter G_NB_UART_CHECKER   = 2,
			      parameter G_DATA_WIDTH        = 8,
			      parameter G_BUFFER_ADDR_WIDTH = 8			      
			      );

   logic clk;   

   // TX UART command
   logic start_tx                     [G_NB_UART_CHECKER - 1 : 0];
   logic [G_DATA_WIDTH - 1:0] tx_data [G_NB_UART_CHECKER - 1 : 0];
   logic 		      tx_done [G_NB_UART_CHECKER - 1 : 0];


   // RX UART command
   logic [G_DATA_WIDTH - 1:0] rx_data     [G_NB_UART_CHECKER - 1 : 0];
   logic 		      rx_done     [G_NB_UART_CHECKER - 1 : 0];
   logic 		      parity_rcvd [G_NB_UART_CHECKER - 1 : 0];

   // BUFFER command from soft
   reg [G_DATA_WIDTH - 1 :0]  s_buffer_rx_soft [G_NB_UART_CHECKER - 1 : 0][2**G_BUFFER_ADDR_WIDTH - 1 :0]; 
   reg [G_BUFFER_ADDR_WIDTH - 1 :0] s_wr_ptr_soft [G_NB_UART_CHECKER - 1 : 0];  
   logic  [G_BUFFER_ADDR_WIDTH - 1 :0]    s_rd_ptr_soft [G_NB_UART_CHECKER - 1 : 0];

   // ALIASES
   int 		      uart_checker_alias [string];
   
endinterface // uart_checker_intf


module uart_checker_wrapper #(

			      parameter G_NB_UART_CHECKER   = 2,
			      parameter G_STOP_BIT_NUMBER   = 1,
			      parameter G_POLARITY          = 1,
			      parameter G_PARITY            = 0,
			      parameter G_BAUDRATE          = 0,
			      parameter G_DATA_WIDTH        = 8,
			      parameter G_FIRST_BIT         = 0,
			      parameter G_CLOCK_FREQ        = 20000000,
			      parameter G_BUFFER_ADDR_WIDTH = 8
   )
   (
    input  clk,
    input  rst_n,

    input  [G_NB_UART_CHECKER - 1 : 0] i_rx,
    output [G_NB_UART_CHECKER - 1 : 0] o_tx, 

    // UART CHECKER INTERFACE
    uart_checker_intf uart_checker_if
    
    );


   // INTERNAL SIGNALS
   reg 			      s_rx_done_p [G_NB_UART_CHECKER - 1 : 0];   
   wire 		      s_rx_done_r_edge [G_NB_UART_CHECKER - 1 : 0];
   


   // TX UART INST
   tx_uart #(
	     .stop_bit_number (G_STOP_BIT_NUMBER),
	     .parity          (G_PARITY),
	     .baudrate        (G_BAUDRATE),
	     .data_size       (G_DATA_WIDTH),
	     .polarity        (G_POLARITY),
	     .first_bit       (G_FIRST_BIT),
	     .clock_frequency (G_CLOCK_FREQ)
	     )
   i_tx_uart_checker [uart_checker_if.G_NB_UART_CHECKER - 1 : 0] (
								  .reset_n  (rst_n),
								  .clock    (clk),
								  .start_tx (uart_checker_if.start_tx),
								  .tx_data  (uart_checker_if.tx_data),						
								  .tx       (o_tx),
								  .tx_done  (uart_checker_if.tx_done)
								  );

   // Assign UART_CHECKER INTERFACE CLOCK - Same clock for all UART instances
   assign uart_checker_if.clk = clk;

   // RX UART INST
   rx_uart #(
	     .stop_bit_number (G_STOP_BIT_NUMBER),
	     .parity          (G_PARITY),
	     .baudrate        (G_BAUDRATE),
	     .data_size       (G_DATA_WIDTH),
	     .polarity        (G_POLARITY),
	     .first_bit       (G_FIRST_BIT),
	     .clock_frequency (G_CLOCK_FREQ)
	     )
   i_rx_uart_checker [uart_checker_if.G_NB_UART_CHECKER - 1 : 0] (
								  .reset_n      (rst_n),
								  .clock        (clk),
								  .rx           (i_rx),
								  .rx_data      (uart_checker_if.rx_data),
								  .rx_done      (uart_checker_if.rx_done),
								  .parity_rcvd  (uart_checker_if.parity_rcvd)
								  );
   
   // Storage of RX Data mnagement
   always @(posedge clk) begin
      if(!rst_n) begin
	 for(int i = 0 ; i < uart_checker_if.G_NB_UART_CHECKER ; i++) begin
	    uart_checker_if.s_wr_ptr_soft[i] <= 0;
	    s_rx_done_p[i] <= 0;
	    
	    for(int j = 0 ; j < 2**G_BUFFER_ADDR_WIDTH ; j++) begin	       
	       uart_checker_if.s_buffer_rx_soft[i][j] <= 0;	       
	    end
	    
	 end
      end
      else begin
	 
	 for(int i = 0 ; i < uart_checker_if.G_NB_UART_CHECKER ; i++) begin
	    s_rx_done_p[i] <= uart_checker_if.rx_done[i];
	    if(s_rx_done_r_edge[i] == 1) begin
	       uart_checker_if.s_buffer_rx_soft[i][uart_checker_if.s_wr_ptr_soft[i]] <= uart_checker_if.rx_data[i];	       
	       uart_checker_if.s_wr_ptr_soft[i] <=  uart_checker_if.s_wr_ptr_soft[i] + 1;	       
	    end
	 end
	 
      end      
   end

   genvar k;
   generate
      for(k = 0 ; k < uart_checker_if.G_NB_UART_CHECKER ; k++) begin
	 assign s_rx_done_r_edge[k] = uart_checker_if.rx_done[k] && !s_rx_done_p[k];
      end
   endgenerate

   
endmodule // uart_checker_wrapper
