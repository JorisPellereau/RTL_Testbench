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
   // MASTER_AXI4LITE[alias] CONFIG(PARAM, VALUE)
   
   // MASTER_AXI4LITE[alias] WRITE(DATA, ADDR, RESP)

   // DATA_CHECKER[alias] START(i)

   // DATA_CHECKER[alias] STOP(i)

   // DATA_CHECKER[alias] CLOSE(i)

   // DATA_CHECKER[alias] CONFIG(i, USE_VALID)
   // ===================================


   // List of Command of DATA_CHECKER
   int 		       MASTER_AXI4LITE_CMD_ARRAY [string] = '{
							      "CONFIG" : 0,
							      "WRITE"  : 1,
							      "READ"   : 2
							      };


   // Task : Selection of AXI4 Commands
   task sel_axi4_command(input string i_axi4_cmd,
			 input string i_axi4_alias, 
			 input string i_axi4_cmd_args);
      begin
	 case(i_axi4_cmd)        
	   "CONFIG": begin
	      CONFIG (i_axi4_alias,
		      i_axi4_cmd_args		       
		      );	     

	   end
	   
	   "WRITE" : begin
/* -----\/----- EXCLUDED -----\/-----
	      UART_RX_READ (i_uart_alias,
			    i_uart_cmd_args
			    );
 -----/\----- EXCLUDED -----/\----- */
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



      /* Task : CONFIG - Set the configuration of AXI4 Master
    * * Non BLOCKING COMMAND
    * 
       */
   //  0 : WRITE_ADDRESS_VALID_DELAY_CYCLES    - Value type : integer
   //  1 : WRITE_DATA_VALID_DELAY_CYCLES       - Value type : integer
   //  2 : WRITE_DATA_VALID_BURST_DELAY_CYCLES - Value type : integer
   //  3 : READ_ADDRESS_VALID_DELAY_CYCLES     - Value type : integer
   //  4 : WRITE_RESPONSE_READY_BEFORE_VALID   - Value type : boolean
   //  5 : READ_DATA_READY_BEFORE_VALID        - Value type : boolean
   //  6 : WRITE_RESPONSE_READY_DELAY_CYCLES   - Value type : integer
   //  7 : READ_DATA_READY_DELAY_CYCLES        - Value type : integer
   //  8 : WRITE_ADDRESS_READY_TIME_OUT        - Value type : integer
   //  9 : WRITE_DATA_READY_TIME_OUT           - Value type : integer
   //  10 : READ_ADDRESS_READY_TIME_OUT        - Value type : integer
   //  11 : WRITE_RESPONSE_VALID_TIME_OUT      - Value type : integer
   //  12 : READ_DATA_VALID_TIME_OUT           - Value type : integer
   task CONFIG (input string axi4_alias,
		input string axi4_cmd_args		       
		);
      begin

	 // Internal Variables
	 int data_nb = 0;
	 int i = 0;
	 string data_array [];
	 
	 int 	space_position = 0;
	 int 	start_pos = 0;
	 
	 int 	data_cnt = 0;
	 int 	data_int = 0;
	 	 
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
	 
	 data_array = new [data_nb]; // Create a dynamic array with the number of data
	 

	 // // Store data in an array
	 // for(i = 0 ; i < uart_cmd_args.len() ; i ++) begin
	 //    if(uart_cmd_args.getc(i) == " ") begin	       
	 //       space_position = i;
	 //       if(data_cnt < data_nb) begin
	 // 	  data_array[data_cnt] = uart_cmd_args.substr(start_pos, space_position -1);
	 // 	  data_cnt += 1;
		  
	 //       end
	 //       start_pos = space_position + 1; // Update Start Position       
	 //    end
	 
   	 // end // for (i = 0 ; i < uart_cmd_args.len() ; i ++)

	 // // Fill Last data
	 // data_array[data_nb - 1] = uart_cmd_args.substr(start_pos, uart_cmd_args.len() - 1);

	 
	 // for(i = 0 ; i < data_nb ; i ++) begin

	 //    // Convert STR to int
	 //    if( {data_array[i].getc(0), data_array[i].getc(1)} == "0x") begin

	 //       str_tmp = data_array[i].substr(2, data_array[i].len() - 1); // Remove 0x
	       
	 //       data_tmp = str_tmp.atohex();
	              		 
	 //    end	   
	 //    else begin
	 //       data_tmp = data_array[i].atoi();	       
	 //    end
	    
	    

	 //    // Generation of a pulse of TX UART[alias]
	 //    @(posedge this.uart_checker_vif.clk);

	 //    array_index = this.uart_checker_vif.uart_checker_alias[uart_alias];
 
	 //    this.uart_checker_vif.tx_data[array_index]  = data_tmp;
	 //    this.uart_checker_vif.start_tx[array_index] = 1;

	 //    @(posedge this.uart_checker_vif.clk);

	 //    this.uart_checker_vif.start_tx[array_index] = 0;

	 //    @(posedge this.uart_checker_vif.tx_done[array_index]); // Wait for UART[alias] tx_done

	    
	 // end // for (i = 0 ; i < data_nb ; i ++)
	 
	 
	 
	 $display("MASTER_AXI4Lite CONFIG DONE - %t", $time);
	 
      end
   endtask // CONFIG
   

   
   
endclass // tb_master_axi4_class
