//                              -*- Mode: Verilog -*-
// Filename        : max7219_checker.sv
// Description     : MAX7219 Checker - Emulator
// Author          : JorisP
// Created On      : Sun Dec 20 18:32:42 2020
// Last Modified By: JorisP
// Last Modified On: Sun Dec 20 18:32:42 2020
// Update Count    : 0
// Status          : Unknown, Use with caution!

`include "max7219_checker_pkg.sv"

module max7219_checker
  #( parameter G_MATRIX_N = 0
   )
  (
   input  clk,
   input  rst_n,

   // MAX7219 I/F
   input  i_max7219_clk,
   input  i_max7219_din,
   input  i_max7219_load,
   output o_max7219_dout,

   input i_display_reg,

   output o_frame_received
   
  );


   // == INTERNAL SIGNALS ==
   logic [15:0]    s_max7219_data;  // Data to latch
   logic [3:0] 	   s_cnt_15;
   logic 	   s_cnt_15_done;
   logic 	   s_frame_received;
   logic 	   s_display_reg;
   

   logic    [15:0] s_max7219_data_dout;      
   
   logic    s_max7219_clk;         // Latch i_max7219_clk
   logic    s_max7219_load;        // Latch i_max7219_load
   logic    s_max7219_dout;
   
   wire     s_max7219_clk_r_edge;
   wire     s_display_reg_r_edge;
   
   logic [7:0] s_max7219_digit_i [7:0];
   
   max7219_register_struct_t max7219_reg;
   // ======================



   // == LATCH INPUTS ==
   always @(posedge clk) begin
      if (!rst_n) begin
	 s_max7219_clk  <= 1'b0;
	 s_max7219_load <= 1'b0;
	 s_display_reg	<= 1'b0;
	 
      end
      else begin
	 s_max7219_clk  <= i_max7219_clk;
	 s_max7219_load <= i_max7219_load;
	 s_display_reg  <= i_display_reg;
	 
      end      
   end
   

   // Rising Edge detection
   assign s_max7219_clk_r_edge  = i_max7219_clk  && ! s_max7219_clk;
   assign s_display_reg_r_edge  = i_display_reg && ! s_display_reg;   
   
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
   
   



   // == MAX7219 REGISTER UPDATE ON LOAD   ==
   always @(posedge clk) begin
      if (!rst_n) begin
	 max7219_reg.REG_NO_OP        <= 8'h00;
	 max7219_reg.REG_DIGIT_0      <= 8'h00;
	 max7219_reg.REG_DIGIT_1      <= 8'h00;
	 max7219_reg.REG_DIGIT_2      <= 8'h00;
	 max7219_reg.REG_DIGIT_3      <= 8'h00;
	 max7219_reg.REG_DIGIT_4      <= 8'h00;
	 max7219_reg.REG_DIGIT_5      <= 8'h00;
	 max7219_reg.REG_DIGIT_6      <= 8'h00;
	 max7219_reg.REG_DIGIT_7      <= 8'h00;
	 max7219_reg.REG_DECODE_MODE  <= 8'h00;
	 max7219_reg.REG_INTENSITY    <= 8'h00;      
	 max7219_reg.REG_SCAN_LIMIT   <= 8'h00;
	 max7219_reg.REG_SHUTDOWN     <= 8'h00;
	 max7219_reg.REG_DISPLAY_TEST <= 8'h00;
	 s_frame_received             <= 1'b0;
	 
      end
      else begin

	 // LATCH DIN in right register
	 if (s_max7219_load_f_edge) begin //i_max7219_load) begin // && !s_max7219_load) begin

	    // DECODAGE
	    case (s_max7219_data[11:8])
	      4'h0 : max7219_reg.REG_NO_OP        <= s_max7219_data[7:0];
	      4'h1 : max7219_reg.REG_DIGIT_0      <= s_max7219_data[7:0];
              4'h2 : max7219_reg.REG_DIGIT_1      <= s_max7219_data[7:0];
              4'h3 : max7219_reg.REG_DIGIT_2      <= s_max7219_data[7:0];
              4'h4 : max7219_reg.REG_DIGIT_3      <= s_max7219_data[7:0];
	      4'h5 : max7219_reg.REG_DIGIT_4      <= s_max7219_data[7:0];
              4'h6 : max7219_reg.REG_DIGIT_5      <= s_max7219_data[7:0];
	      4'h7 : max7219_reg.REG_DIGIT_6      <= s_max7219_data[7:0];
              4'h8 : max7219_reg.REG_DIGIT_7      <= s_max7219_data[7:0];
	      4'h9 : max7219_reg.REG_DECODE_MODE  <= s_max7219_data[7:0];
	      4'hA : max7219_reg.REG_INTENSITY    <= s_max7219_data[7:0];
	      4'hB : max7219_reg.REG_SCAN_LIMIT   <= s_max7219_data[7:0];
	      4'hC : max7219_reg.REG_SHUTDOWN     <= s_max7219_data[7:0];
	      4'hF : max7219_reg.REG_DISPLAY_TEST <= s_max7219_data[7:0];    
	      default :  $display("ERROR in Register @%x", s_max7219_data[11:8]);
	      
	    endcase // case (s_max7219_data[11:8])
	    s_frame_received <= 1'b1;
	 end   
	 else begin
	   s_frame_received <= 1'b0; 
	 end 
	    
      
      end // else: !if(!rst_n)
   end // always @ (posedge clk)

   assign s_max7219_digit_i[0] = max7219_reg.REG_DIGIT_0;
   assign s_max7219_digit_i[1] = max7219_reg.REG_DIGIT_1;
   assign s_max7219_digit_i[2] = max7219_reg.REG_DIGIT_2;
   assign s_max7219_digit_i[3] = max7219_reg.REG_DIGIT_3;
   assign s_max7219_digit_i[4] = max7219_reg.REG_DIGIT_4;
   assign s_max7219_digit_i[5] = max7219_reg.REG_DIGIT_5;
   assign s_max7219_digit_i[6] = max7219_reg.REG_DIGIT_6;
   assign s_max7219_digit_i[7] = max7219_reg.REG_DIGIT_7;
  
   // == DOUT MNGT ==
   always @(posedge clk) begin
      if(!rst_n) begin
	 s_max7219_data_dout <= 16'h0000;
	 s_max7219_dout      <= 1'b0;
	 
      end
      else begin
	 if(s_cnt_15_done) begin
	    s_max7219_data_dout <= s_max7219_data;	    
	 end

	 s_max7219_dout <= s_max7219_data_dout[15];
	 if(s_max7219_clk_r_edge) begin
            s_max7219_data_dout[15:1] <= s_max7219_data_dout[14:0];
	 end	 
      end      
   end

   // == OUTPUTS AFFECTATIONS ==
   assign o_frame_received = s_frame_received;
   assign o_max7219_dout   = s_max7219_dout;




   // == DISPLAY REGISTERS on Demands ==
   always @(posedge clk) begin
      if(!rst_n) begin
	 
      end
      else begin
	 if(s_display_reg_r_edge == 1'b1) begin
	    $display("Matrix : %d", G_MATRIX_N);	    
	    $display("Register @0: No-Op        - Data : %h" , max7219_reg.REG_NO_OP);
	    $display("Register @1: Digit_0      - Data : %h" , max7219_reg.REG_DIGIT_0);
            $display("Register @2: Digit_1      - Data : %h" , max7219_reg.REG_DIGIT_1);
            $display("Register @3: Digit_2      - Data : %h" , max7219_reg.REG_DIGIT_2);
            $display("Register @4: Digit_3      - Data : %h" , max7219_reg.REG_DIGIT_3);
	    $display("Register @5: Digit_4      - Data : %h" , max7219_reg.REG_DIGIT_4);
            $display("Register @6: Digit_5      - Data : %h" , max7219_reg.REG_DIGIT_5);
	    $display("Register @7: Digit_6      - Data : %h" , max7219_reg.REG_DIGIT_6);
            $display("Register @8: Digit_7      - Data : %h" , max7219_reg.REG_DIGIT_7);
	    $display("Register @9: Decode_Mode  - Data : %h" , max7219_reg.REG_DECODE_MODE);
	    $display("Register @A: Intensity    - Data : %h" , max7219_reg.REG_INTENSITY);
	    $display("Register @B: Scan_Limit   - Data : %h" , max7219_reg.REG_SCAN_LIMIT);
	    $display("Register @C: Shutdown     - Data : %h" , max7219_reg.REG_SHUTDOWN);
	    $display("Register @F: Display_Test - Data : %h" , max7219_reg.REG_DISPLAY_TEST);
	    $display("");
	    
	 end	 	 
      end      
   end
   
   
   // ==================================
   
endmodule // max7219_checker
