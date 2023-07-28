module max7219_display_n_matrix
  #(
    parameter G_NB_MATRIX = 2
    )
   (
      input 		 clk,
      input 		 rst_n,
      input 		 line_val,

      input [8*8 - 1 :0] line_char_matrix [0 : 7]
      /*input [8*8 - 1 :0] line_char_matrix_1,
      input [8*8 - 1 :0] line_char_matrix_2,
      input [8*8 - 1 :0] line_char_matrix_3,
      input [8*8 - 1 :0] line_char_matrix_4,
      input [8*8 - 1 :0] line_char_matrix_5,
      input [8*8 - 1 :0] line_char_matrix_6,
      input [8*8 - 1 :0] line_char_matrix_7,*/
    );


   wire [G_NB_MATRIX*8*8 - 1 : 0] lines;
   
/* -----\/----- EXCLUDED -----\/-----
   genvar 			  i;
   -----/\----- EXCLUDED -----/\----- */
   genvar 			  i;
   
    for(i = 0; i < G_NB_MATRIX; i++) begin
	assign       lines[i*8*8 + 8*8 - 1 : 8*8*i] = line_char_matrix[i];
	       
    end	
   
   
   // PRINT MATRIX
   always @(posedge clk) begin
      if(!rst_n) begin
	 
      end
      else begin
	 if(line_val) begin
/* -----\/----- EXCLUDED -----\/-----
	    for(int i = 0; i < G_NB_MATRIX; i++) begin
	       lines[i*8*8 + 8*8 - 1 : 8*8*i] = line_char_matrix[i];
	       
	    end	
   -----/\----- EXCLUDED -----/\----- */
	    $display("MATRIX DISPLAY :");
            $display("%s", lines);   
	 end
	 
      end      
   end
   
   
endmodule // max7219_display_n_matrix
