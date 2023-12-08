
module master_axi4lite #(
			 parameter G_AXI4_LITE_ADDR_WIDTH = 32,
			 parameter G_AXI4_LITE_DATA_WIDTH = 32			 
			 )   
   (
    input clk,
    input rst_n
    );

   // == INTERNAL Signals ==
   master_axi4lite_intf master_axi4lite_if; // Interface between wrapper and class
   
   logic  start;                                               // Start the transaction
   logic [G_AXI4_LITE_ADDR_WIDTH-1:0] addr;                    // Set the ADDR
   logic 			      rnw;                     // Read (1) or write (0)
   logic [(G_AXI4_LITE_DATA_WIDTH / 8) - 1 : 0] strobe;        // Strobe Access
   logic [G_AXI4_LITE_DATA_WIDTH - 1 : 0] 	master_wdata;  // Master Write data
   logic 					done;          // Access Done
   logic [G_AXI4_LITE_DATA_WIDTH - 1 : 0] 	master_rdata;  // Master Read data
   logic [1:0] 					access_status; // Access status



   
   // Instanciation of osvvm AXI4 Lite Manager wrapper
   axi4_lite_master  #(				    	   
							   .G_DATA_WIDTH (G_AXI4_LITE_ADDR_WIDTH),
							   .G_ADDR_WIDTH (G_AXI4_LITE_DATA_WIDTH)
							   )
   
   i_axi4_lite_master (
		       .clk     (clk),
		       .rst_n   (rst_n),

		       // Master controller interface
		       .start          (start),
		       .addr           (addr),
		       .rnw            (rnw),
		       .strobe         (strobe),
		       .master_wdata   (master_wdata),
		       .done           (done),
		       .master_rdata   (master_rdata),
		       .access_status  (access_status),

		       // AXI4 Lite Interface
		       .awvalid (awvalid),
		       .awaddr  (awaddr),
		       .awprot  (awprot),
		       .awready (awready),
		       .wvalid  (wvalid),
		       .wdata   (wdata),
		       .wstrb   (wstrb),
		       .wready  (wready),
		       .bready  (bready),
		       .bvalid  (bvalid),
		       .bresp   (bresp),
		       .arvalid (arvalid),
		       .araddr  (araddr),
		       .arprot  (arprot),
		       .arready (arready),
		       .rready  (rready),
		       .rvalid  (rvalid),
		       .rdata   (rdata),
		       .rresp   (rresp)
		       );

   // Interface connection
   assign start        = master_axi4lite_if.start;
   assign addr         = master_axi4lite_if.addr;
   assign rnw          = master_axi4lite_if.rnw;
   assign strobe       = master_axi4lite_if.strobe;
   assign master_wdata = master_axi4lite_if.master_wdata;

   assign master_axi4lite_if.clk           = clk;   
   assign master_axi4lite_if.done          = done;
   assign master_axi4lite_if.master_rdata  = master_rdata;
   assign master_axi4lite_if.access_status = access_status;
       
  endmodule // master_axi4lite
