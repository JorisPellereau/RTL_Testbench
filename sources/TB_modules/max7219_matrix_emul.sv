//`include "max7219_emul.sv"

module max7219_matrix_emul
  #(
    parameter       G_MATRIX_NB      = 2,
    parameter [7:0] G_VERBOSE        = 8'hFF
    )
   (
      input clk,
      input rst_n,
      input i_max7219_clk,
      input i_max7219_din,
      input i_max7219_load
    );
   
   
   typedef struct //packed
   {
       logic [8*8 - 1 : 0]   display_matrix_0 [7:0];
       logic [8*8 - 1 : 0]   display_matrix_1 [7:0];
       logic [8*8 - 1 : 0]   display_matrix_2 [7:0];
       logic [8*8 - 1 : 0]   display_matrix_3 [7:0];
       logic [8*8 - 1 : 0]   display_matrix_4 [7:0];
       logic [8*8 - 1 : 0]   display_matrix_5 [7:0];
       logic [8*8 - 1 : 0]   display_matrix_6 [7:0];
       logic [8*8 - 1 : 0]   display_matrix_7 [7:0];
  
            
   } max7219_display_matrix_t;

   max7219_display_matrix_t max7219_display_matrix;

   

   // == INTERNAL WIRES ==
   wire [G_MATRIX_NB - 1 : 0] s_max7219_din;
   wire [G_MATRIX_NB - 1 : 0] s_max7219_dout;

   wire [8*8 - 1 : 0] 	      s_matrix_2_display [7:0] [G_MATRIX_NB - 1 : 0];
   wire [8*8 - 1 : 0] 	      s_matrix_0 [7:0];
   
   wire [G_MATRIX_NB - 1 : 0] s_matrix_char_val;
   
   wire 		      s_val;
   

   assign max7219_display_matrix.display_matrix_0 = max7219_emul_inst_0.s_matrix_char;
   assign max7219_display_matrix.display_matrix_1 = max7219_emul_inst_1.s_matrix_char;
   assign max7219_display_matrix.display_matrix_2 = max7219_emul_inst_2.s_matrix_char;
   assign max7219_display_matrix.display_matrix_3 = max7219_emul_inst_3.s_matrix_char;
   assign max7219_display_matrix.display_matrix_4 = max7219_emul_inst_4.s_matrix_char;
   assign max7219_display_matrix.display_matrix_5 = max7219_emul_inst_5.s_matrix_char;
   assign max7219_display_matrix.display_matrix_6 = max7219_emul_inst_6.s_matrix_char;
   assign max7219_display_matrix.display_matrix_7 = max7219_emul_inst_7.s_matrix_char;

     // == MATRIX 0 INST ==
     max7219_emul #(
		     .G_MATRIX_I  (0),
                     .G_VERBOSE   (G_VERBOSE[0])
      )
      max7219_emul_inst_0 (
			 .clk             (clk),
			 .rst_n           (rst_n),
			 .i_max7219_clk   (i_max7219_clk),
			 .i_max7219_din   (i_max7219_din),
			 .i_max7219_load  (i_max7219_load),
			 .o_max7219_dout  (s_max7219_dout[0]),
                         .o_matrix_char_val  (s_matrix_char_val[0])
			 
      );

   // == MATRIX 1 INST ==
   max7219_emul #(
		     .G_MATRIX_I  (1),
                     .G_VERBOSE   (G_VERBOSE[1])
      )
      max7219_emul_inst_1 (
			 .clk             (clk),
			 .rst_n           (rst_n),
			 .i_max7219_clk   (i_max7219_clk),
			 .i_max7219_din   (s_max7219_dout[0]),
			 .i_max7219_load  (i_max7219_load),
			 .o_max7219_dout  (s_max7219_dout[1]), 
			 .o_matrix_char_val  ()
			 
      );

   // == MATRIX 2 INST ==
   max7219_emul #(
		     .G_MATRIX_I  (2),
                     .G_VERBOSE   (G_VERBOSE[2])
      )
      max7219_emul_inst_2 (
			 .clk             (clk),
			 .rst_n           (rst_n),
			 .i_max7219_clk   (i_max7219_clk),
			 .i_max7219_din   (s_max7219_dout[1]),
			 .i_max7219_load  (i_max7219_load),
			 .o_max7219_dout  (s_max7219_dout[2]), 
			 .o_matrix_char_val  ()
			 
      );

   // == MATRIX 3 INST ==
   max7219_emul #(
		     .G_MATRIX_I  (3),
                     .G_VERBOSE   (G_VERBOSE[3])
      )
      max7219_emul_inst_3 (
			 .clk             (clk),
			 .rst_n           (rst_n),
			 .i_max7219_clk   (i_max7219_clk),
			 .i_max7219_din   (s_max7219_dout[2]),
			 .i_max7219_load  (i_max7219_load),
			 .o_max7219_dout  (s_max7219_dout[3]), 
			 .o_matrix_char_val  ()
			 
      );

   // == MATRIX 4 INST ==
   max7219_emul #(
		     .G_MATRIX_I  (4),
                     .G_VERBOSE   (G_VERBOSE[4])
      )
      max7219_emul_inst_4 (
			 .clk             (clk),
			 .rst_n           (rst_n),
			 .i_max7219_clk   (i_max7219_clk),
			 .i_max7219_din   (s_max7219_dout[3]),
			 .i_max7219_load  (i_max7219_load),
			 .o_max7219_dout  (s_max7219_dout[4]), 
			 .o_matrix_char_val  ()
			 
      );

   // == MATRIX 5 INST ==
   max7219_emul #(
		     .G_MATRIX_I  (5),
                     .G_VERBOSE   (G_VERBOSE[5])
      )
      max7219_emul_inst_5 (
			 .clk             (clk),
			 .rst_n           (rst_n),
			 .i_max7219_clk   (i_max7219_clk),
			 .i_max7219_din   (s_max7219_dout[4]),
			 .i_max7219_load  (i_max7219_load),
			 .o_max7219_dout  (s_max7219_dout[5]), 
			 .o_matrix_char_val  ()
			 
      );

   // == MATRIX 6 INST ==
   max7219_emul #(
		     .G_MATRIX_I  (6),
                     .G_VERBOSE   (G_VERBOSE[6])
      )
      max7219_emul_inst_6 (
			 .clk             (clk),
			 .rst_n           (rst_n),
			 .i_max7219_clk   (i_max7219_clk),
			 .i_max7219_din   (s_max7219_dout[5]),
			 .i_max7219_load  (i_max7219_load),
			 .o_max7219_dout  (s_max7219_dout[6]), 
			 .o_matrix_char_val  ()
			 
      );

   // == MATRIX 7 INST ==
   max7219_emul #(
		     .G_MATRIX_I  (7),
                     .G_VERBOSE   (G_VERBOSE[7])
      )
      max7219_emul_inst_7 (
			 .clk             (clk),
			 .rst_n           (rst_n),
			 .i_max7219_clk   (i_max7219_clk),
			 .i_max7219_din   (s_max7219_dout[6]),
			 .i_max7219_load  (i_max7219_load),
			 .o_max7219_dout  (s_max7219_dout[7]), 
			 .o_matrix_char_val  ()
			 
      );



   assign s_val = s_matrix_char_val[0];   

   reg [8*8*8-1 : 0] s_line_2_display;
   
   // == DISPLAY MATRIX IN TRANSCRIPT
   always @(posedge clk) begin
      if(!rst_n) begin
	 
      end
      else begin
	 if(s_val) begin
	    for(int j = 0 ; j < G_MATRIX_NB ; j++) begin
	       for(int k = 7 ; k >= 0 ; k--) begin
		  
		  s_line_2_display[511:384] = {max7219_display_matrix.display_matrix_0[k], max7219_display_matrix.display_matrix_1[k]};
		  s_line_2_display[383:256] = {max7219_display_matrix.display_matrix_2[k], max7219_display_matrix.display_matrix_3[k]};
		  s_line_2_display[255:128] = {max7219_display_matrix.display_matrix_4[k], max7219_display_matrix.display_matrix_5[k]};
		  s_line_2_display[127:0]   = {max7219_display_matrix.display_matrix_6[k], max7219_display_matrix.display_matrix_7[k]};

		  $display("%s", s_line_2_display);	  
	       end	       
	    end
	    
	 end	 
      end      
   end
   
  
endmodule // max7219_matrix_emul
