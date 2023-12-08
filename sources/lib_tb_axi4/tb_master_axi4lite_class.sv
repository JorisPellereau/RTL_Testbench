import pkg_tb::*;

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
   string MASTER_AXI4LITE_ALIAS;                            // Alias of Current Master AXI4LITE Testbench Module

   // == UTILS ==
   tb_utils_class utils = new(); // Utils Class   
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
   
   // MASTER_AXI4LITE[alias] WRITE(DATA DATA STROBE EXPC TIMEOUT_VALUE TIMEOUT_UNITY)
   // MASTER_AXI4LITE[alias] READ(DATA DATA STROBE EXPC TIMEOUT_VALUE TIMEOUT_UNITY)
   
   // ===================================


   // List of Command of MASTER AXI4 Lite
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
	   
	   "WRITE" :  begin
	      MASTER_AXI4_LITE_WRITE  (i_axi4_alias,
				       i_axi4_cmd_args
				       );
	      
	   end
	   
	   "READ" : begin
	      MASTER_AXI4_LITE_READ (i_axi4_alias,
				     i_axi4_cmd_args
				     );
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
	 int addr;
	 int wdata;
	 int strobe;
	 int rdata;
	 int access_status;	 
	 int expc;
	 int timeout_value;
	 string timeout_unity;
	 longint timeout_ps;
	 bit 	 timeout;
	 	 
	 args_t args;

	 //$display("Run MASTER_AXI4LITE[%s] CONFIG(%s) ... - %t", axi4_alias, axi4_cmd_args, $time);
	 	 
	 // Get the number of data in uart_cmd_args
	 args = this.utils.str_2_args(axi4_cmd_args);

	 // Converts string args into int
	 addr   = this.utils.str_2_int(args[0]); // Convert the string into a int
	 wdata  = this.utils.str_2_int(args[1]); // Convert the string into a int
	 strobe = this.utils.str_2_int(args[2]); // Convert the string into a int
	 expc   = this.utils.str_2_int(args[3]); // Convert the string into a int

	 // Check if TIMEOUT_VALUE and TIMEOUT_UNITY are present in the string
	 // If yes -> Update timeout_value and timeout_unity
	 if(args.len() == 6) begin
	    timeout_value = this.utils.str_2_int(args[4]);
	    timeout_unity = args[5];
	    timeout_ps    = this.utils.DECODE_TIMEOUT(timeout_value, timeout_unity);
	 end	 	 

	 @(negedge this.data_checker_vif.clk); // Wait for the falling edge for synchronization
	 this.data_checker_vif.addr         = addr;
	 this.data_checker_vif.master_wdata = wdata;
	 this.data_checker_vif.strobe       = strobe;
	 this.data_checker_vif.rnw          = 0; // 0 -> Write access
	 this.data_checker_vif.start        = 1; // Start the access
	 
	 @(negedge this.data_checker_vif.clk); // Wait for the next falling edge and reset signal
	 this.data_checker_vif.addr   = 0;
	 this.data_checker_vif.data   = 0;
	 this.data_checker_vif.strobe = 0;
	 this.data_checker_vif.rnw    = 0;
	 this.data_checker_vif.start  = 0;


	 // No Timeout Case
	 if(args.len() != 6) begin
	    // Wait until the end of the access
	    @(posedge this.data_checker_vif.done);
	    
	 end

	 // Timeout Case
	 else begin

	    fork begin
	       fork begin
		  #timeout_ps;		  
		  timeout = '1;
	       end // else: !if(args.len() != 6)
	       join_none
	       wait(this.data_checker_vif.done == 1 || timeout);
	       disable fork;
	    end join // else: !if(args.len() != 6)
	    
	 end

	 // After the detection of the done signal or after the timeout -> Get status
	 rdata         = this.data_checker_vif.master_rdata;
	 access_status = this.data_checker_vif.access_status;

	 
	 // Perform the check of the status
	 // NO TIMEOUT Case
	 if(access_status != expc && timeout == 0) begin
	    $display("Error: MASTER_AXI4LITE WRITE[%s] expected %x != %x", axi4_alias, expc, access_status);
	 end

	 // TIMEOUT Case
	 else if(timeout == 1) begin
	    $display("Error: MASTER_AXI4LITE WRITE[%s] timeout occurs at %t", $time);
	 end

	 // NO Error
	 else begin
	    $display("MASTER_AXI4LITE WRITE[%s] expected %x == %x -> OK", axi4_alias, expc, access_status);
	 end
	 
      end
  	 
      $display("DEBUG MASTER_AXI4Lite WRITE DONE - %t", $time);
	 
   endtask

   /* Task : Execute an AXI4 Master READ access
    * * BLOCKING COMMAND
    * - 
    */  
   task MASTER_AXI4_LITE_READ(
			       input string axi4_alias,
			       input string axi4_cmd_args		       
			       );
      begin

	 // Internal Variables
	 int addr;
	 int expc_rdata;
	 int rdata;
	 int access_status;	 
	 int expc;
	 int timeout_value;
	 string timeout_unity;
	 longint timeout_ps;
	 bit 	 timeout;
	 	 
	 args_t args;

	 //$display("Run MASTER_AXI4LITE[%s] CONFIG(%s) ... - %t", axi4_alias, axi4_cmd_args, $time);
	 	 
	 // Get the number of data in uart_cmd_args
	 args = this.utils.str_2_args(axi4_cmd_args);

	 // Converts string args into int
	 addr       = this.utils.str_2_int(args[0]); // Convert the string into a int
	 expc_rdata = this.utils.str_2_int(args[1]); // Convert the string into a int
	 expc       = this.utils.str_2_int(args[2]); // Convert the string into a int

	 // Check if TIMEOUT_VALUE and TIMEOUT_UNITY are present in the string
	 // If yes -> Update timeout_value and timeout_unity
	 if(args.len() == 5) begin
	    timeout_value = this.utils.str_2_int(args[3]);
	    timeout_unity = args[4];
	    timeout_ps    = this.utils.DECODE_TIMEOUT(timeout_value, timeout_unity);
	 end	 	 

	 @(negedge this.data_checker_vif.clk); // Wait for the falling edge for synchronization
	 this.data_checker_vif.addr         = addr;
	 this.data_checker_vif.master_wdata = 0;
	 this.data_checker_vif.strobe       = 0;
	 this.data_checker_vif.rnw          = 1; // 1 -> Write access
	 this.data_checker_vif.start        = 1; // Start the access
	 
	 @(negedge this.data_checker_vif.clk); // Wait for the next falling edge and reset signal
	 this.data_checker_vif.addr   = 0;
	 this.data_checker_vif.data   = 0;
	 this.data_checker_vif.strobe = 0;
	 this.data_checker_vif.rnw    = 0;
	 this.data_checker_vif.start  = 0;


	 // No Timeout Case
	 if(args.len() != 6) begin
	    // Wait until the end of the access
	    @(posedge this.data_checker_vif.done);
	    
	 end

	 // Timeout Case
	 else begin

	    fork begin
	       fork begin
		  #timeout_ps;		  
		  timeout = '1;
	       end // else: !if(args.len() != 6)
	       join_none
	       wait(this.data_checker_vif.done == 1 || timeout);
	       disable fork;
	    end join // else: !if(args.len() != 6)
	    
	 end

	 // After the detection of the done signal or after the timeout -> Get status
	 rdata         = this.data_checker_vif.master_rdata;
	 access_status = this.data_checker_vif.access_status;

	 
	 // Perform the check of the status
	 // RDATA == Expected_rdata and access_status == expected and NO TIMEOUT
	 if(rdata == expc_rdata && access_status == expc && timeout == 0) begin
	    $display("MASTER_AXI4LITE READ[%s] @(0x%x) == %x (expected %x) - Status %x == %x -> OK", axi4_alias, addr, expc, expc_rdata, access_status);
	 end

	 // RDATA != Expected_rdata and access_status == expected and NO TIMEOUT
	 else if(rdata != expc_rdata && access_status == expc && timeout == 0) begin
	    $display("Error : MASTER_AXI4LITE READ[%s] @(0x%x) == %x (expected %x) - Status %x == %x -> ERROR", axi4_alias, addr, expc, expc_rdata, access_status);
	 end

	 // RDATA == Expected_rdata and access_status != expected and NO TIMEOUT
	 else if(rdata == expc_rdata && access_status != expc && timeout == 0) begin
	    $display("MASTER_AXI4LITE READ[%s] @(0x%x) == %x (expected %x) - Status %x != %x -> ERROR", axi4_alias, addr, expc, expc_rdata, access_status);
	 end

	 // RDATA != Expected_rdata and access_status != expected and NO TIMEOUT
	 else if(rdata != expc_rdata && access_status == expc && timeout == 0) begin
	    $display("Error : MASTER_AXI4LITE READ[%s] @(0x%x) == %x (expected %x) - Status %x != %x -> ERROR", axi4_alias, addr, expc, expc_rdata, access_status);
	 end
	 
	 // TIMEOUT Case
	 else if(timeout == 1) begin
	    $display("Error: MASTER_AXI4LITE READ[%s] @(0x%x) timeout occurs at %t", axi4_alias, addr, $time);
	 end

	 // NO Error
	 else begin
	    
	 end
	 
      end
  	 
      $display("DEBUG MASTER_AXI4Lite READ DONE - %t", $time);
	 
   endtask

endclass // tb_master_axi4_class
