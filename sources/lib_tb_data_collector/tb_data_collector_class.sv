//                              -*- Mode: Verilog -*-
// Filename        : tb_data_collector_class.sv
// Description     : CLASS for data_collector module
// Author          : Linux-JP
// Created On      : Sun Nov  7 12:50:43 2021
// Last Modified By: Linux-JP
// Last Modified On: Sun Nov  7 12:50:43 2021
// Update Count    : 0
// Status          : Unknown, Use with caution!

class tb_data_collector_class #(
				parameter G_NB_COLLECTOR           = 2,
				parameter G_DATA_COLLECTOR_WIDTH   = 32
				);

   /* ===============
    * == VARIABLES ==
    * ===============
    */

   string DATA_COLLECTOR_COMMAND_TYPE = "DATA_COLLECTOR"; // Commande Type   
   string DATA_COLLECTOR_ALIAS;                 // Alias of Current UART Testbench Module 

   int 	  data_collector_file [G_NB_COLLECTOR-1 : 0]; // Hold file
   
   // == VIRTUAL I/F ==
   // DATA_COLLECTOR interface
   virtual data_collector_intf #(G_NB_COLLECTOR, G_DATA_COLLECTOR_WIDTH) data_collector_vif;   
   // =================

   
   // == Interface passed in Virtual I/F ==
   function new(virtual data_collector_intf #(G_NB_COLLECTOR, G_DATA_COLLECTOR_WIDTH) data_collector_nif, string DATA_COLLECTOR_ALIAS);
      this.data_collector_vif = data_collector_nif; // New Virtual Interface

      this.DATA_COLLECTOR_ALIAS = DATA_COLLECTOR_ALIAS; // Add Alias
      
    
      
   endfunction // new   
   // =====================================


  
   // == LIST of DATA COLLECTOR COMMANDS ==
   // DATA_COLLECTOR[alias] INIT(i, File) // Init collect file for alias index i

   // DATA_COLLECTOR[alias] START(i)      // Start collect file for alias index i

   // DATA_COLLECTOR[alias] STOP(i)       // Stop collect file for alias index i

   // DATA_COLLECTOR[alias] CLOSE(i)      // Close collect file for alias index i
   // =====================================

     
   // List of Command of DATA_COLLECTOR
   int 	   DATA_COLLECTOR_CMD_ARRAY [string] = '{
						 "INIT"  : 0,
						 "START" : 1,
						 "STOP"  : 2,
						 "CLOSE" : 3
						 };


   // Task : Selection of DATA_COLLECTOR Commands
   task sel_data_collector_command(input string i_data_collector_cmd,
				   input string i_data_collector_alias,
				   input string i_data_collector_cmd_args
				   );
      begin
	 case(i_data_collector_cmd)

	   "INIT": begin
	      DATA_COLLECTOR_INIT(i_data_collector_alias,
				  i_data_collector_cmd_args);
	   end

	   "START": begin
	      DATA_COLLECTOR_START(i_data_collector_alias,
				   i_data_collector_cmd_args);	      
	   end

	   "STOP": begin
	      DATA_COLLECTOR_STOP(i_data_collector_alias,
				  i_data_collector_cmd_args);
	   end

	   "CLOSE": begin
	      DATA_COLLECTOR_CLOSE(i_data_collector_alias,
				   i_data_collector_cmd_args);	      
	   end

	   default: $display("Error: wrong DATA_COLLECTOR Command : %s - len(%s) : %d", i_data_collector_cmd, i_data_collector_cmd, i_data_collector_cmd.len());
	   
	 endcase // case (i_data_collector_cmd)
	 
      end
   endtask // sel_data_collector_command
   


   // Init DAta collector with a file (open file)
   task DATA_COLLECTOR_INIT(input string data_collector_alias,
			    input string data_collector_cmd_args);
      begin
	 // Internal Variables
	 int    data_collector_index; // Index of data_collector
	 string file_path;            // file path
	 int 	i;                    // Loop Index
	 int 	space_position = 0;   // Space position between args
	 string index_str;
	 int 	args_len;

	 //$display("DEBUG - DATA_COLLECTOR_INIT task");
	 
	 
	 // Get space position
	 for(i = 0; i < data_collector_cmd_args.len(); i++) begin
	    if(data_collector_cmd_args[i] == " ") begin
	       space_position = i;	       
	    end
	 end

	 args_len  = data_collector_cmd_args.len();                         // Get len of Args	 
	 index_str = data_collector_cmd_args.substr(0, space_position - 1); // Get index in string
	 data_collector_index = index_str.atoi();                           // String to Int

	 file_path = data_collector_cmd_args.substr(space_position +1, args_len - 1);

	 // Open file in interface
	 this.data_collector_vif.s_data_collector_file[data_collector_index] = $fopen(file_path, "w"); // Open it as Write mode
	 this.data_collector_vif.s_file_is_init[data_collector_index]        = 1;                      // File is init
	 
	 $display("DATA_COLLECTOR[%s] (%d) Initialiazed with file : %s - %t", data_collector_alias, data_collector_index,file_path, $time);
	 
      end
   endtask // DATA_COLLECTOR_INIT

   
   // Close Data Collector File
   task DATA_COLLECTOR_CLOSE(input string data_collector_alias,
			     input string data_collector_cmd_args);
      begin

	 // Internal Variables
	 int    data_collector_index; // Index of data_collector
	 // 	 
	 data_collector_index = data_collector_cmd_args.atoi();	 
	 $fclose(this.data_collector_vif.s_data_collector_file[data_collector_index]); // Close file in interface
	 this.data_collector_vif.s_file_is_init[data_collector_index] = 0;             // File is Closed
	 
	 $display("DATA_COLLECTOR[%s] (%d) Closed at %t" ,data_collector_alias, data_collector_index, $time);	 
      end
   endtask // DATA_COLLECTOR_CLOSE
   

   // Start Data Collector
   task DATA_COLLECTOR_START(input string data_collector_alias,
			     input string data_collector_cmd_args);
      begin
	 // Internal Variables
	 int    data_collector_index; // Index of data_collector
	  	 
	 data_collector_index = data_collector_cmd_args.atoi();
	 if(this.data_collector_vif.s_file_is_init[data_collector_index] == 1) begin
	    this.data_collector_vif.s_start_collect[data_collector_index] = 1; // Start Selected Interface
	    $display("DATA_COLLECTOR[%s] START(%d) at %t", data_collector_alias, data_collector_index, $time);
	 end
	 else begin
	    $display("Error: DATA_COLLECTOR[%s] (%d) is not initialiazed ! - %t", data_collector_alias, data_collector_index, $time);	    
	 end
      end
   endtask // DATA_COLLECTOR_START
   
   // Stop Data Collector
   task DATA_COLLECTOR_STOP(input string data_collector_alias,
			    input string data_collector_cmd_args);
      begin
	 // Internal Variables
	 int    data_collector_index; // Index of data_collector
	  	 
	 data_collector_index = data_collector_cmd_args.atoi();
	 this.data_collector_vif.s_start_collect[data_collector_index] = 0; // Stop Selected interface
	 $display("DATA_COLLECTOR[%s] STOP(%d) at %t", data_collector_alias, data_collector_index, $time);
	 
      end
   endtask // DATA_COLLECTOR_STOP
   
   
   // Config Data Collector
   task DATA_COLLECTOR_CONFIG(input string data_collector_alias,
			    input string data_collector_cmd_args);
      begin
	 // Internal Variables
	 int    data_collector_index; // Index of data_collector
	  	 
	 data_collector_index = data_collector_cmd_args.atoi();
	 
      end
   endtask // DATA_COLLECTOR_CONFIG
   
   

endclass // tb_data_collector_class
