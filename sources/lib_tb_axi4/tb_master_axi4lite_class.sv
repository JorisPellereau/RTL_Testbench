//`include "/home/linux-jp/Documents/GitHub/Verilog/Testbench/sources/lib_tb_utils/tb_utils_class.sv"

class tb_master_axi4lite_class #(
				 parameter G_NB_MASTER_AXI4LITE  = 2,
				 parameter G_AXI4LITE_ADDR_WIDTH = 32,
				 parameter G_AXI4LITE_DATA_WIDTH = 32
		      );


   /* ===============
    * == VARIABLES ==
    * ===============
    */

   string MASTER_AXI4LITE_COMMAND_TYPE = "MASTER_AXI4LITE"; // Commande Type   
   string MASTER_AXI4LITE_ALIAS;                 // Alias of Current Master AXI4LITE Testbench Module

   // == UTILS ==
//   tb_utils_class utils = new(); // Utils Class   
   // ===========
   
   
   // == VIRTUAL I/F ==
   // DATA_COLLECTOR interface
   virtual master_axi4lite_intf #(G_AXI4LITE_ADDR_WIDTH, G_AXI4LITE_DATA_WIDTH) master_axi4lite_vif;   
   // =================


   // == CONSTRUCTOR ==
   function new(virtual master_axi4lite_intf #(G_AXI4LITE_ADDR_WIDTH, G_AXI4LITE_DATA_WIDTH) master_axi4lite_nif,
		string MASTER_AXI4LITE_ALIAS);
      this.master_axi4lite_vif   = master_axi4lite_nif;
      this.MASTER_AXI4LITE_ALIAS = MASTER_AXI4LITE_ALIAS;      
   endfunction // new   
   // =================


   // == LIST of DATA CHECKER COMMANDS ==
   
   // MASTER_AXI4LITE[alias] WRITE(DATA, ADDR, STROBE, EXPC)
   // MASTER_AXI4LITE[alias] READ(DATA, ADDR, RESP, EXPC)
   
   // ===================================


   // List of Command of DATA_CHECKER
   int 		       MASTER_AXI4LITE_CMD_ARRAY [string] = '{
							      "WRITE"  : 0,
							      "READ"   : 1
							      };


   // Task : Selection of AXI4 Commands
   task sel_axi4_command(input string i_axi4_cmd,
			 input string i_axi4_alias, 
			 input string i_axi4_cmd_args);
      begin
	 case(i_axi4_cmd)        
/* -----\/----- EXCLUDED -----\/-----
	   "CONFIG": begin
	      CONFIG (i_axi4_alias,
		      i_axi4_cmd_args		       
		      );	     

	   end
 -----/\----- EXCLUDED -----/\----- */
	   
	   "WRITE" :  begin
	      MASTER_AXI4_LITE_WRITE  (i_axi4_alias,
				       i_axi4_cmd_args
				       );

	   end
	   
	   "READ" : begin
/* -----\/----- EXCLUDED -----\/-----
	      UART_RX_WAIT_DATA (i_uart_alias,
				 i_uart_cmd_args
				 );
 -----/\----- EXCLUDED -----/\----- */
	   end
	   

	   default: $display("Error: wrong AXI4 Master Command : %s - len(%s) : %d", i_axi4_cmd, i_axi4_cmd, i_axi4_cmd.len());
	 endcase // case (i_axi4_cmd)	 
	 
      end
   endtask; // sel_uart_command



      /* Task : Execute an AXI4 Master Write access
       * * BLOCKING COMMAND
       * - 
       */
  
   task MASTER_AXI4_LITE_WRITE(
			       input string axi4_alias,
			       input string axi4_cmd_args		       
			       );
      begin

	 // Internal Variables
	 int data_nb        = 0;
	 int i              = 0;
	 int space_position = 0;
	 int start_pos      = 0;
	 int data_cnt       = 0;
	 int data_int       = 0;
	 int data_tmp;
	 string str_tmp;
	 int 	array_index = 0;

	 $display("Run MASTER_AXI4LITE[%s] CONFIG(%s) ... - %t", axi4_alias, axi4_cmd_args, $time);
	 	 
	 // Get the number of data in uart_cmd_args
	 for(i = 0 ; i < axi4_cmd_args.len() ; i ++) begin
	    if(axi4_cmd_args.getc(i) == " ") begin
	       data_nb += 1;	       
	    end	    	    
	 end

	 data_nb += 1; // Number of space + 1
	 
	 
	 $display("MASTER_AXI4Lite CONFIG DONE - %t", $time);
	 
      end
   endtask // CONFIG
   

   
   
endclass // tb_master_axi4_class
