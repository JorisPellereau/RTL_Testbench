
module master_axi4lite #(
			 parameter MODEL_ID_NAME = "MASTER_AXI4_Lite_",
			 parameter G_AXI4_LITE_ADDR_WIDTH = 32,
			 parameter G_AXI4_LITE_DATA_WIDTH = 32,
			 parameter tperiod_Clk            = 10000,
			 parameter DEFAULT_DELAY          = 0,
			 parameter tpd_Clk_AWAddr         = 0,
			 parameter tpd_Clk_AWProt         = 0,
			 parameter tpd_Clk_AWValid        = 0,
			 parameter tpd_Clk_WValid         = 0,
			 parameter tpd_Clk_WData          = 0,
			 parameter tpd_Clk_WStrb          = 0,
			 parameter tpd_Clk_BReady         = 0,
			 parameter tpd_Clk_ARValid        = 0,
			 parameter tpd_Clk_ARProt         = 0,
			 parameter tpd_Clk_ARAddr         = 0,
			 parameter tpd_Clk_RReady         = 0
			 )   
   (
    input clk,
    input rst_n
    );

   // == INTERNAL Signals ==
   master_axi4lite_intf master_axi4lite_if; // Interface between wrapper and class   

   // Instanciation of osvvm AXI4 Lite Manager wrapper
   osvvm_axi4lite_manager_wrapper #(				    
				    .MODEL_ID_NAME          (MODEL_ID_NAME),
				    .G_AXI4_LITE_ADDR_WIDTH (G_AXI4_LITE_ADDR_WIDTH),
				    .G_AXI4_LITE_DATA_WIDTH (G_AXI4_LITE_DATA_WIDTH),
				    .tperiod_Clk            (tperiod_clk),
				    .DEFAULT_DELAY          (DEFAULT_DELAY),
				    .tpd_Clk_AWAddr         (tpd_Clk_AWAddr),
				    .tpd_Clk_AWProt         (tpd_Clk_AWProt),
				    .tpd_Clk_AWValid        (tpd_Clk_AWValid),
				    .tpd_Clk_WValid         (tpd_Clk_WValid),
				    .tpd_Clk_WData          (tpd_Clk_WData),
				    .tpd_Clk_WStrb          (tpd_Clk_WStrb),
				    .tpd_Clk_BReady         (tpd_Clk_BReady),
				    .tpd_Clk_ARValid        (tpd_Clk_ARValid),
				    .tpd_Clk_ARProt         (tpd_Clk_ARProt),
				    .tpd_Clk_ARAddr         (tpd_Clk_ARAddr),
				    .tpd_Clk_RReady         (tpd_Clk_RReady)
				    )
   
   i_osvvm_axi4lite_manager_wrapper (
				     .clk     (clk),
				     .rst_n   (rst_n),
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
   assign   i_osvvm_axi4lite_manager_wrapper.start_config = master_axi4lite_if.start_config;
   
   
  endmodule // master_axi4lite
