interface master_axi4lite_intf #(parameter G_AXI4LITE_ADDR_WIDTH = 32,
				 parameter G_AXI4LITE_DATA_WIDTH = 32
				 );

   // Configuration signals
   logic start_config;
   logic config_done;
   integer config_param_int;
   bit config_param_bool;
   integer config_nb;
   

endinterface // master_axi4lite_intf
