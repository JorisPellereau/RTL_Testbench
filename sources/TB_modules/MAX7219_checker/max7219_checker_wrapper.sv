//                              -*- Mode: Verilog -*-
// Filename        : max7219_checker_wrapper.sv
// Description     : MAX7219 Checker/Emulator - Wrapper for Daisy chain Matrix
// Author          : JorisP
// Created On      : Sun Dec 20 18:57:47 2020
// Last Modified By: JorisP
// Last Modified On: Sun Dec 20 18:57:47 2020
// Update Count    : 0
// Status          : Unknown, Use with caution!

`include "max7219_checker_pkg.sv"

module max7219_checker_wrapper #(
				 parameter G_NB_MATRIX = 8
				 )
   (
      input  clk,
      input  rst_n,

      // MAX7219 I/F - 1st Matrix
     input  i_max7219_clk,
     input  i_max7219_din,
     input  i_max7219_load,

     input [G_NB_MATRIX - 1 : 0] i_display_reg_matrix_n,
     input                       i_display_screen_matrix
    
    );

   genvar 			 i;  // Genvar for Generater MAX7219_Checker modules
   genvar 			 j;
   
   


   // == INTERNALS SIGNALS ==
   wire [G_NB_MATRIX - 1 : 0] 	 s_max7219_din;
   wire [G_NB_MATRIX - 1 : 0] 	 s_max7219_dout;
   wire [G_NB_MATRIX - 1 : 0] 	 s_frame_received;

   logic 			 s_display_screen_matrix;
   wire 			 s_display_screen_matrix_r_edge;
   
   max7219_register_struct_t max7219_screen_matrix [G_NB_MATRIX - 1 : 0];
   
   logic [G_NB_MATRIX*8 - 1 : 0] 	 s_matrix_row_i [7:0]; // MATRIX Row - LSB First
/*   logic [G_NB_MATRIX*8 - 1] 	 s_matrix_row_1;
   logic [G_NB_MATRIX*8 - 1] 	 s_matrix_row_2;
   logic [G_NB_MATRIX*8 - 1] 	 s_matrix_row_3;
   logic [G_NB_MATRIX*8 - 1] 	 s_matrix_row_4;
   logic [G_NB_MATRIX*8 - 1] 	 s_matrix_row_5;
   logic [G_NB_MATRIX*8 - 1] 	 s_matrix_row_6;
   logic [G_NB_MATRIX*8 - 1] 	 s_matrix_row_7;
  */ 
   // =======================

   // Latch Inputs
   always @(posedge clk) begin
      if(!rst_n) begin
	 s_display_screen_matrix <= 1'b0;	 
      end
      else begin
	 s_display_screen_matrix <= i_display_screen_matrix;	 
      end      
   end

   // Rising Edge detection
   assign s_display_screen_matrix_r_edge = i_display_screen_matrix && ! s_display_screen_matrix;
   
   // == GENERATES MATRIX CHECKER and ROUTE I/Os ==
   generate
     for(i = 0 ; i < G_NB_MATRIX ; i++) begin : gen_max7219_checker

	// MAX7219 Checker Instanciation
	max7219_checker #(
			  .G_MATRIX_N  (i)
        )
        i_max7219_checker_0 (
					       .clk    (clk),
					       .rst_n  (rst_n),
					     
					       .i_max7219_clk    (i_max7219_clk),
					       .i_max7219_din    (s_max7219_din[i]),
					       .i_max7219_load   (i_max7219_load),
					       .o_max7219_dout   (s_max7219_dout[i]),

					       .i_display_reg     (i_display_reg_matrix_n[i]),
					       .o_frame_received  (s_frame_received[i])
					     );

	if(i == 0) begin
	  assign s_max7219_din[0] = i_max7219_din; // Din From MAX7219 I/F
	end
	else if(i > 0 && i < G_NB_MATRIX) begin
	   assign s_max7219_din[i] = s_max7219_dout[i - 1];
	end

	// Connected to Internal registers of each MAX7219 checkers
        assign max7219_screen_matrix[i] = gen_max7219_checker[i].i_max7219_checker_0.max7219_reg;
	       	
     end	      
   endgenerate
   // =============================================


   wire [8*G_NB_MATRIX - 1 : 0] s_line_vector [0:7]; // Line [0] == TOP Line
   

   wire [7:0] 		       s_line_vector_matrix [0:G_NB_MATRIX-1][0:7];


  
   //
   generate
      for(i = 0 ; i < G_NB_MATRIX ; i++) begin : gen_ii

	 // Loop on each line
	 for(j = 0 ; j < 8 ; j++) begin : gen_jj
	    assign s_line_vector_matrix[i][7-j] = {
						   gen_max7219_checker[i].i_max7219_checker_0.max7219_reg.REG_DIGIT_7[j],
						   gen_max7219_checker[i].i_max7219_checker_0.max7219_reg.REG_DIGIT_6[j],
						   gen_max7219_checker[i].i_max7219_checker_0.max7219_reg.REG_DIGIT_5[j],
						   gen_max7219_checker[i].i_max7219_checker_0.max7219_reg.REG_DIGIT_4[j],
						   gen_max7219_checker[i].i_max7219_checker_0.max7219_reg.REG_DIGIT_3[j],
						   gen_max7219_checker[i].i_max7219_checker_0.max7219_reg.REG_DIGIT_2[j],
						   gen_max7219_checker[i].i_max7219_checker_0.max7219_reg.REG_DIGIT_1[j],
						   gen_max7219_checker[i].i_max7219_checker_0.max7219_reg.REG_DIGIT_0[j]
						   };

	    
	    
	 end // block: gen_jj

	 assign s_line_vector[0][8*(j + 1) - 1 : 8*j] = s_line_vector_matrix[i]; // TOP Line
	 
	 // Loop on each line
	 /*for(j = 0 ; j < 8 ; j++) begin :
	  assign s_line_vector[j] = gen_max7219_checker[i].i_max7219_checker_0.max7219_reg.REG_DIGIT_0[j]
	end*/
      end            
   endgenerate
   
	     

   // == OLD ==

   reg [8*8*G_NB_MATRIX - 1 : 0] line_char;
   
   reg [8*G_NB_MATRIX - 1 : 0] line;
   int 			       k;
   int 			       l;
   int 			       m;
   int 			       n;
   
   
   
   // == DISPLAY SCREEN MATRIX ==
   always @(posedge clk) begin
      if(!rst_n) begin
	 line      <= 0;
	 line_char <= 0;
	 
      end
      else begin
	 if(s_display_screen_matrix_r_edge == 1'b1) begin

	    for(n = 0; n < 8*G_NB_MATRIX ; n++) begin	         		      
	       line_char[n*8 +: /*n*8 +*/ 7] = "_";		  
	    end
	    $display("%s", line_char);
	    
	    for(k = 0 ; k < 8 ; k++) begin
	       for(l = 0 ; l < G_NB_MATRIX ; l++) begin
		  for(m = 0 ; m < 8 ; m++) begin
		     
		     if(m == 7) begin
  			line[(8*G_NB_MATRIX - 1) - (m+l*8)] = max7219_screen_matrix[l].REG_DIGIT_7[7 - k];
		     end
		     else if(m == 6) begin
		        line[(8*G_NB_MATRIX - 1) - (m+l*8)] = max7219_screen_matrix[l].REG_DIGIT_6[7 - k];	
		     end
		     else if(m == 5) begin
		        line[(8*G_NB_MATRIX - 1) - (m+l*8)] = max7219_screen_matrix[l].REG_DIGIT_5[7 - k];	
		     end
		     else if(m == 4) begin
		        line[(8*G_NB_MATRIX - 1) - (m+l*8)] = max7219_screen_matrix[l].REG_DIGIT_4[7 - k];	
		     end
		     else if(m == 3) begin
		        line[(8*G_NB_MATRIX - 1) - (m+l*8)] = max7219_screen_matrix[l].REG_DIGIT_3[7 - k];	
		     end
		     else if(m == 2) begin
		        line[(8*G_NB_MATRIX - 1) - (m+l*8)] = max7219_screen_matrix[l].REG_DIGIT_2[7 - k];	
		     end
		     else if(m == 1) begin
		        line[(8*G_NB_MATRIX - 1) - (m+l*8)] = max7219_screen_matrix[l].REG_DIGIT_1[7 - k];	
		     end
		     else if(m == 0) begin
		        line[(8*G_NB_MATRIX - 1) - (m+l*8)] = max7219_screen_matrix[l].REG_DIGIT_0[7 - k];	
		     end
		     
		  end
		  
	       end // for (l = 0 ; l < G_NB_MATRIX ; l++)
	       //$display("%B", line);
	       
	       for(n = 0; n < 8*G_NB_MATRIX ; n++) begin	         
		  if(line[n] == 1'b1) begin		     
		     line_char[n*8 +: /*n*8 +*/ 7] = "0";		     
		  end
		  else begin		     
		     line_char[n*8 +: /*n*8 +*/ 7] = " ";
		  end		  		  
	       end
	       
	       $display("%s", line_char);
	       
	       
	       line      <= 0;
	       line_char <= 0;
	       
	       
	    end // for (k = 0 ; k < 8 ; k++)

	    for(n = 0; n < 8*G_NB_MATRIX ; n++) begin	         		      
	       line_char[n*8 +: /*n*8 +*/ 7] = "_";
	  
	    end
	    $display("%s", line_char);
	    
	 end	 
      end      
   end
   
   // ===========================
   
   
   logic [7:0] s_row_0_tmp [G_NB_MATRIX - 1 : 0];
   genvar      row_k;
   logic [8*8*G_NB_MATRIX - 1 : 0] s_line_row_i [7:0];
   
   generate
      // For 8 Rows
      for(row_k = 0 ; row_k < 8 ; row_k++) begin
	 for(i = 0; i < G_NB_MATRIX ; i++) begin 

	    // For 8 digits
	    for (j = 0 ; j < 8 ; j++) begin
	       
	       assign s_matrix_row_i[row_k][j + 8*i] = gen_max7219_checker[i].i_max7219_checker_0.s_max7219_digit_i[j] >> (8 - row_k - 1);
	    
	    end
	 end
      end
   endgenerate

   genvar ii, jj;
   
   generate
   //always @(*) begin
      for(ii = 0 ; ii < 8*G_NB_MATRIX ; ii++) begin
	 for(jj = 0 ; jj < 8 ; jj++) begin

	    assign s_line_row_i[jj][8*8*G_NB_MATRIX - ii*8 - 1: 8*8*G_NB_MATRIX - ii*8 - 8] = s_matrix_row_i[jj][ii] ? "X" : "B";
	    /*if(s_matrix_row_i[jj][ii] == 1'b0) begin
	       /*assign*/ //s_line_row_i[jj][8*8*G_NB_MATRIX - ii*8 : 8*8*G_NB_MATRIX - ii*8 - 8] = " ";	       
	    //end
	    //else begin
	       /*assign*/ //s_line_row_i[jj][8*8*G_NB_MATRIX - ii*8 : 8*8*G_NB_MATRIX - ii*8 - 8] = "*";
	    //end	
	 end
      end
   //end
   endgenerate
   
   
  
endmodule // max7219_checker_wrapper
