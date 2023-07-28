//                              -*- Mode: Verilog -*-
// Filename        : data_collector.sv
// Description     : Data collector
// Author          : Linux-JP
// Created On      : Sun Nov  7 11:40:39 2021
// Last Modified By: Linux-JP
// Last Modified On: Sun Nov  7 11:40:39 2021
// Update Count    : 0
// Status          : Unknown, Use with caution!

interface data_collector_intf #(
				parameter G_NB_COLLECTOR = 2,
				parameter G_DATA_WIDTH   = 32
				);

   // == DATA COLLECTOR Inputs ==
   logic                        clk                   [G_NB_COLLECTOR - 1 : 0];
   logic [G_DATA_WIDTH - 1 : 0] data_collector_inputs [G_NB_COLLECTOR - 1 : 0];
   // ===========================

   // == File Interface ==
   int    s_data_collector_file [G_NB_COLLECTOR - 1 : 0]; // File Handler
   logic  s_file_is_init        [G_NB_COLLECTOR - 1 : 0]; // File is init
   logic  s_start_collect       [G_NB_COLLECTOR - 1 : 0]; // Start collect when '1'
  
endinterface // data_collector_intf

   
module data_collector #(
			parameter G_NB_COLLECTOR = 2,
			parameter G_DATA_WIDTH   = 32
			)
   (
    input  clk [G_NB_COLLECTOR - 1 : 0],
    input  rst_n [G_NB_COLLECTOR - 1 : 0],

    input [G_DATA_WIDTH - 1 : 0] i_data [G_NB_COLLECTOR - 1 : 0],

    // DATA COLECTOR INTERFACE
    data_collector_intf data_collector_if
    );

   genvar 			   i;
  

   // == Interface Connection Management ==
   generate
      for(i = 0 ; i < G_NB_COLLECTOR ; i++) begin : g_interface_connection
	 assign data_collector_if.clk[i]                   = clk[i];
	 assign data_collector_if.data_collector_inputs[i] = i_data[i];	 
      end      
   endgenerate
   // ==============================

   // == Start Collect Management ==
   generate
      for(i = 0 ; i < G_NB_COLLECTOR ; i++) begin : g_collect_management
	 
	 always @(posedge clk[i]) begin
	    // Collect Only if file is Init and if Start is enable
	    if(data_collector_if.s_start_collect[i] == 1 && data_collector_if.s_file_is_init[i] == 1) begin	    
	       $fwrite(data_collector_if.s_data_collector_file[i], "%h\n", i_data[i]);	       
	    end
	    
	 end
      end      
   endgenerate
   // ==============================

endmodule // data_collector

