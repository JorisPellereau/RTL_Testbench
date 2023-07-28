//                              -*- Mode: Verilog -*-
// Filename        : data_checker.sv
// Description     : DAta checker interface and Module
// Author          : Linux-JP
// Created On      : Fri May 27 11:40:56 2022
// Last Modified By: Linux-JP
// Last Modified On: Fri May 27 11:40:56 2022
// Update Count    : 0
// Status          : Unknown, Use with caution!

interface data_checker_intf #(
			      parameter G_NB_CHECKER         = 2,
			      parameter G_CHECKER_DATA_WIDTH = 32
			      );

   // == DATA CHECKER Info ==
   string s_alias;   
   // =======================

   // == DATA CHECKER Inputs ==
   logic clk [G_NB_CHECKER - 1 :0];
   logic [G_CHECKER_DATA_WIDTH - 1 : 0] data_checker_inputs [G_NB_CHECKER - 1 :0];   
   // =========================

   // == File Interface ==
   int s_data_checker_file [G_NB_CHECKER - 1 :0]; // File Handler
   logic s_file_is_init [G_NB_CHECKER - 1 :0];    // File is init
   logic s_start_checker [G_NB_CHECKER - 1 :0];   // Start checker when '1'
   logic s_use_valid [G_NB_CHECKER - 1 :0];       // Check data in valid when '1'
   
endinterface // data_checker_intf



module data_checker #(
		      parameter G_NB_CHECKER         = 2,
		      parameter G_CHECKER_DATA_WIDTH = 32
		      )
   (
    input 				 clk [G_NB_CHECKER - 1 :0],
    input 				 rst_n [G_NB_CHECKER - 1 :0],

    input [G_CHECKER_DATA_WIDTH - 1 : 0] i_data [G_NB_CHECKER - 1 :0],

    input 				 i_data_valid [G_NB_CHECKER - 1 :0]

    
    
    );

   genvar 				 i;
   
   string 				 line [G_NB_CHECKER-1:0];
   int 					 s_data_to_check [G_NB_CHECKER-1:0];
   
   
   // Data checker INTERFACE
   data_checker_intf #(
		       .G_NB_CHECKER         (G_NB_CHECKER),
		       .G_CHECKER_DATA_WIDTH (G_CHECKER_DATA_WIDTH)
		       ) data_checker_if(); // Interna Interface


 
   // == Interface Connection Management ==
   generate
      for(i = 0 ; i < G_NB_CHECKER ; i++) begin : g_interface_connection
	 assign data_checker_if.clk[i]                 = clk[i];
	 assign data_checker_if.data_checker_inputs[i] = i_data[i];	 
      end      
   endgenerate
   
   // =====================================


   // == Start Check Management ==
   generate
      for(i = 0 ; i < G_NB_CHECKER ; i++) begin : g_check_management

	 always @(posedge clk[i]) begin

	    // If CHECKER is ON and file is init => Start Checker
	    if(data_checker_if.s_start_checker[i] == 1 && data_checker_if.s_file_is_init[i] == 1) begin

	       // Valid Not used => Check data
	       if(data_checker_if.s_use_valid[i] == 0) begin
		  $fgets(line[i], data_checker_if.s_data_checker_file[i]);
		  s_data_to_check[i] = line[i].atohex(); // Line to HEX
		  
		  if(i_data[i] == s_data_to_check[i]) begin
		     $display("Checker[%s] (%d) - i_data : %X - expected data : %X => OK", s_alias, i, i_data[i], s_data_to_check[i]);		     
		  end
	       end
	       else begin

		  // Valid Use and in Valid input is '1' => Check data
		  if(i_data_valid[i] == 1) begin
		     
		  end
	       end
	    end
	 end	 
      end      
   endgenerate
   // ============================

endmodule // data_checker

