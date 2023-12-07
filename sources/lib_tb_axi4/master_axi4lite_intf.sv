interface master_axi4lite_intf #(
				 parameter G_AXI4LITE_ADDR_WIDTH = 32,
				 parameter G_AXI4LITE_DATA_WIDTH = 32
				 );
   
   // Configuration signals
   logic start;                                               // Start the transaction
   logic [G_AXI4LITE_ADDR_WIDTH-1:0] addr;                    // Set the ADDR
   logic 			     rnw;                     // Read (1) or write (0)
   logic [(G_AXI4LITE_DATA_WIDTH / 8) - 1 : 0] strobe;        // Strobe Access
   logic [G_AXI4LITE_DATA_WIDTH - 1 : 0]       master_wdata;  // Master Write data
   logic 				       done;          // Access Done
   logic [G_AXI4LITE_DATA_WIDTH - 1 : 0]       master_rdata;  // Master Read data
   logic [1:0] 				       access_status; // Access status
   
endinterface // master_axi4lite_intf
