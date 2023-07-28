//                              -*- Mode: Verilog -*-
// Filename        : max7219_spi_checker.sv
// Description     : MAX7219 SPI Checker
// Author          : JorisP
// Created On      : Sat Jun 19 11:35:03 2021
// Last Modified By: JorisP
// Last Modified On: Sat Jun 19 11:35:03 2021
// Update Count    : 0
// Status          : Unknown, Use with caution!


module max7219_spi_checker
  (
   input  clk,
   input  rst_n,

   // MAX7219 I/F
   input  i_max7219_clk,
   input  i_max7219_din,
   input  i_max7219_load,


   output o_frame_received,
   output o_load_received,
   output [15:0] o_data_received
   
  );

   // == INTERNAL SIGNALS ==
   logic 	 s_max7219_clk;         // Latch i_max7219_clk
   logic 	 s_max7219_load;        // Latch i_max7219_load
   logic 	 s_frame_received;
   

   logic [15:0]  s_max7219_data;  // Data to latch
   logic [3:0] 	 s_cnt_15;
   logic 	 s_cnt_15_done;

   wire 	 s_max7219_clk_r_edge;
   wire 	 s_max7219_load_f_edge;
   
   // ======================

   // == LATCH INPUTS ==
   always @(posedge clk) begin
      if (!rst_n) begin
	 s_max7219_clk  <= 1'b0;
	 s_max7219_load <= 1'b0;
	 s_frame_received <= 1'b0;
	 
      end
      else begin
	 s_max7219_clk  <= i_max7219_clk;
	 s_max7219_load <= i_max7219_load;
	 s_frame_received <= s_cnt_15_done;
	 
      end      
   end // always @ (posedge clk)

   // Rising Edge detection
   assign s_max7219_clk_r_edge  = i_max7219_clk  && ! s_max7219_clk;

   // Falling Edge detection
   assign s_max7219_load_f_edge = ! i_max7219_load && s_max7219_load;

   
   // == DIN LATCH ==
   always @(posedge clk) begin
      if (!rst_n) begin
	 s_max7219_data <= 16'h0000;
	 s_cnt_15       <= 4'h0;
	 s_cnt_15_done  <= 1'b0;
	 
      end
      else begin
         s_cnt_15_done <= 1'b0; // PULSE
	
         // MSB FIRST 
	 if(s_max7219_clk_r_edge) begin
	    s_max7219_data[0]    <= i_max7219_din;
	    s_max7219_data[15:1] <= s_max7219_data[14:0];
	    
	    if(s_cnt_15 < 4'hF) begin
	       s_cnt_15 <= s_cnt_15 + 1;
	    end
	    else begin
	       s_cnt_15      <= 0;
	       s_cnt_15_done <= 1'b1;	       
	    end	    	    
	 end	 	 
      end      
   end // always @ (posedge clk)


   assign o_frame_received = s_frame_received;   
   assign o_data_received  = s_max7219_data;
   assign o_load_received  = s_max7219_load_f_edge;
   
endmodule // max7219_spi_checker

