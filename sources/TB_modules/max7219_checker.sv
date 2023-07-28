module max7219_checker 
  # ( parameter G_DIGITS_NB = 2
    )
    (
      input clk,
      input rst_n,
      input i_max7219_clk,
      input i_max7219_data,
      input i_max7219_load
    );


   // STRUCTURE

   typedef enum logic[3:0]
   {
    NO_OP        = 4'h0,
    DIGIT_0      = 4'h1,
    DIGIT_1      = 4'h2,
    DIGIT_2      = 4'h3,
    DIGIT_3      = 4'h4,
    DIGIT_4      = 4'h5,
    DIGIT_5      = 4'h6,
    DIGIT_6      = 4'h7,
    DIGIT_7      = 4'h8,
    DECODE_MODE  = 4'h9,
    INTENSITY    = 4'hA,
    SCAN_LIMIT   = 4'hB,
    SHUTDOWN     = 4'hC,
    DISPLAY_TEST = 4'hF
    } max7219_reg_addr_t;

   typedef struct packed
   {
      logic [7:0] REG_NO_OP;
      logic [7:0] REG_DIGIT_0;
      logic [7:0] REG_DIGIT_1;
      logic [7:0] REG_DIGIT_2;
      logic [7:0] REG_DIGIT_3;
      logic [7:0] REG_DIGIT_4;
      logic [7:0] REG_DIGIT_5;
      logic [7:0] REG_DIGIT_6;
      logic [7:0] REG_DIGIT_7;
      logic [7:0] REG_DECODE_MODE;
      logic [7:0] REG_SCAN_LIMIT;
      logic [7:0] REG_SHUTDOWN;
      logic [7:0] REG_DISPLAY_TEST;
      
   } max7219_register_struct_t;
   
    max7219_register_struct_t matrix_0_reg;
		
   
   // INTERNAL WIRE
   logic    [15:0] s_max7219_data;
   logic    [3:0]  s_cnt_15;

   logic [15:0]    s_config_after_load [G_DIGITS_NB - 1 :0];
   

   logic    s_max7219_clk; // Latch i_max7219_clk
   wire     s_max7219_clk_r_edge;
   logic    s_cnt_15_done;


   // LATCH INPUTS
   always @(posedge clk) begin
      if (!rst_n) begin
	 s_max7219_clk <= 1'b0;
	 
      end
      else begin
	 s_max7219_clk <= i_max7219_clk;
	 
      end      
   end

   // Rising Edge detection
   assign s_max7219_clk_r_edge = i_max7219_clk && ! s_max7219_clk;
   
   // DATA LATCH
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
	    s_max7219_data[0]    <= i_max7219_data;
	    s_max7219_data[15:1] <= s_max7219_data[14:0];
	    
	    if(s_cnt_15 < 4'hF) begin
	       s_cnt_15 <= s_cnt_15 + 1;
	    end
	    else begin
	       s_cnt_15 <= 0;
	       s_cnt_15_done <= 1'b1;	       
	    end	    	    
	 end	 	 
      end      
   end


   // DATA DISPLAY
   always @(posedge clk) begin
      if(!rst_n) begin
	 
      end
      else begin
	 if(s_cnt_15_done) begin
	    $display("MAX7219 FRAME Transmitted");

	    case (s_max7219_data[11:8])
	      
	      4'h0 : $display("Register @0: No-Op        - Data : %h" , s_max7219_data[7:0]);
	      4'h1 : $display("Register @1: Digit_0      - Data : %h" , s_max7219_data[7:0]);
              4'h2 : $display("Register @2: Digit_1      - Data : %h" , s_max7219_data[7:0]);
              4'h3 : $display("Register @3: Digit_2      - Data : %h" , s_max7219_data[7:0]);
              4'h4 : $display("Register @4: Digit_3      - Data : %h" , s_max7219_data[7:0]);
	      4'h5 : $display("Register @5: Digit_4      - Data : %h" , s_max7219_data[7:0]);
              4'h6 : $display("Register @6: Digit_5      - Data : %h" , s_max7219_data[7:0]);
	      4'h7 : $display("Register @7: Digit_6      - Data : %h" , s_max7219_data[7:0]);
              4'h8 : $display("Register @8: Digit_7      - Data : %h" , s_max7219_data[7:0]);
	      4'h9 : $display("Register @9: Decode_Mode  - Data : %h" , s_max7219_data[7:0]);
	      4'hA : $display("Register @A: Intensity    - Data : %h" , s_max7219_data[7:0]);
	      4'hB : $display("Register @B: Scan_Limit   - Data : %h" , s_max7219_data[7:0]);
	      4'hC : $display("Register @C: Shutdown     - Data : %h" , s_max7219_data[7:0]);
	      4'hF : $display("Register @F: Display_Test - Data : %h" , s_max7219_data[7:0]);
	      default : $display("ERROR in Register @");
	      
	    endcase // case (s_max7219_data[11:8])
	    
	 end
	 
      end
      
   end // always @ (posedge clk)


   integer i;
   integer j;   
   // PRINT CONFIG MATRIX
   always @(posedge clk) begin
      if(!rst_n) begin
	 
	 for(i = 0; i < G_DIGITS_NB ; i++) begin
	    s_config_after_load[i] <= 0;
	 end	 
	 matrix_0_reg.REG_NO_OP = 0;
	 
      end
      else begin
	 if(s_cnt_15_done) begin
	    s_config_after_load[G_DIGITS_NB - 1] <= s_max7219_data;
	    s_config_after_load[G_DIGITS_NB - 2] <= s_config_after_load[G_DIGITS_NB - 1];
	    
	 end

	 if(i_max7219_load) begin
	    case (s_config_after_load[11:8])
              //4'h0 : matrix_0_reg.REG_NO_OP = s_max7219_data[7:0];
	      
	      default : $display("Error");
	      
	    endcase // case (s_config_after_load[11:8])
	    
	    
	 end	 	   
	 
      end
      
   end
   
   
   
endmodule
