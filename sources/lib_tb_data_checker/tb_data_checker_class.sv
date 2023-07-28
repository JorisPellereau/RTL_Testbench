//                              -*- Mode: Verilog -*-
// Filename        : tb_data_checker_class.sv
// Description     : CLASS for data_checker module
// Author          : Linux-JP
// Created On      : Fri May 27 11:15:52 2022
// Last Modified By: Linux-JP
// Last Modified On: Fri May 27 11:15:52 2022
// Update Count    : 0
// Status          : Unknown, Use with caution!

`include "/home/linux-jp/Documents/GitHub/Verilog/Testbench/sources/lib_tb_utils/tb_utils_class.sv"

class tb_data_checker_class #(
			      parameter G_NB_CHECKER         = 2,
			      parameter G_DATA_CHECKER_WIDTH = 32
			      );
      
   /* ===============
    * == VARIABLES ==
    * ===============
    */

   string DATA_CHECKER_COMMAND_TYPE = "DATA_CHECKER"; // Command Type
   string DATA_CHECKER_ALIAS; // Alias of the current DATA CHECKER Testbench Module
   int 	  data_checker_file [G_NB_CHECKER - 1:0]; // Hold File


   // == UTILS ==
   tb_utils_class utils = new(); // Utils Class   
   // ===========
   
   // == VIRTUAL I/F ==
   // DATA_CHECKER interface
   virtual data_checker_intf #(G_NB_CHECKER, G_DATA_CHECKER_WIDTH) data_checker_vif;   
   // =================
   
   

   // == CONSTRUCTOR ==
   function new(virtual data_checker_intf #(G_NB_CHECKER, G_DATA_CHECKER_WIDTH) data_checker_nif, string DATA_CHECKER_ALIAS);
      this.data_checker_vif   = data_checker_nif;
      this.DATA_CHECKER_ALIAS = DATA_CHECKER_ALIAS;      
   endfunction // new   
   // =================

   // == LIST of DATA CHECKER COMMANDS ==
   // DATA_CHECKER[alias] INIT(i, file)

   // DATA_CHECKER[alias] START(i)

   // DATA_CHECKER[alias] STOP(i)

   // DATA_CHECKER[alias] CLOSE(i)

   // DATA_CHECKER[alias] CONFIG(i, USE_VALID)
   // ===================================


   // List of Command of DATA_CHECKER
   int DATA_CHECKER_CMD_ARRAY [string] = '{
					   "INIT"   : 0,
					   "START"  : 1,
					   "STOP"   : 2,
					   "CLOSE"  : 3,
					   "CONFIG" : 4
					   };

   // Task : Selection of DATA_CHECKER Commands
   task sel_data_checker_command(input string i_data_checker_cmd,
				 input string i_data_checker_alias,
				 input string i_data_checker_cmd_args);
      begin
	 case(i_data_checker_cmd)

	   "INIT": begin
	      DATA_CHECKER_INIT(i_data_checker_alias,
				i_data_checker_cmd_args);	      
	   end

	   "CLOSE": begin
	      DATA_CHECKER_CLOSE(i_data_checker_alias,
				 i_data_checker_cmd_args);
	   end
	   
	      

	   default : $display("Error: wrong DATA_CHECKER Command : %s - len(%s) : %d", i_data_checker_cmd, i_data_checker_alias, i_data_checker_cmd.len());
	 endcase // case (i_data_checker_cmd)
	 
	   
      end
   endtask // sel_data_checker_command


   // Init DATA Checker with a file (open file)
   task DATA_CHECKER_INIT(input string data_checker_alias,
			  input string data_checker_cmd_args);
      begin

	 string index_str;
	 string file_path;
	 int 	data_checker_index = 0;
	 
	 args_t args;
	 
	 args = this.utils.str_2_args(data_checker_cmd_args);

	 index_str          = args[0];          // Get Index str
	 data_checker_index = index_str.atoi(); // Convert STR to int
	 file_path          = args[1];          // Get File Path

	 this.data_checker_vif.s_data_checker_file[data_checker_index] = $fopen(file_path, "r"); // Open if a Read mode
	 this.data_checker_vif.s_file_is_init[data_checker_index] = 1; // File is init

	 $display("DATA_CHECKER[%s] (%d) Initialized with file : %s - %t", data_checker_alias, data_checker_index, file_path, $time);
      end
   endtask // DATA_CHECKER_INIT

   // Clode Data Checker File
   task DATA_CHECKER_CLOSE(input string data_checker_alias,
			   input string data_checker_cmd_args
			   );
      begin
	 int data_checker_index = 0;
	 args_t args;
	 
	 args = this.utils.str_2_args(data_checker_cmd_args);

	 data_checker_index = args[0].atoi(); // Args to index
	 $fclose(this.data_checker_vif.s_data_checker_file[data_checker_index]);
	 this.data_checker_vif.s_file_is_init[data_checker_index] = 0; // File is closed

	 $display("DATA_CHECKER[%s] (%d) Closed at %t", data_checker_alias, data_checker_index, $time);
	 
	 
      end
   endtask // DATA_CHECKER_CLOSE
   
   
   
endclass // tb_data_checker_class
