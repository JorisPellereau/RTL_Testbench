//                              -*- Mode: Verilog -*-
// Filename        : tb_tasks.sv
// Description     : TestBench TASKS
// Author          : JorisP
// Created On      : Sat Nov  7 11:46:18 2020
// Last Modified By: JorisP
// Last Modified On: Sat Nov  7 11:46:18 2020
// Update Count    : 0
// Status          : Unknown, Use with caution!


`include "/home/linux-jp/Documents/GitHub/Verilog/Testbench/sources/lib_tb_sequencer/tb_modules_custom_class.sv"


class tb_class #(
		 // SET INJECTOR PARAMETERS
		 parameter G_SET_SIZE  = 5,
		 parameter G_SET_WIDTH = 32,
		 
		 // WAIT EVENT PARAMETERS
		 parameter G_WAIT_SIZE  = 5,
		 parameter G_WAIT_WIDTH = 1,
		 parameter G_CLK_PERIOD = 1000, // Unity : ps
		 
		 // CHECK LEVEL PARAMETER
		 parameter G_CHECK_SIZE  = 5,
		 parameter G_CHECK_WIDTH = 32,

		 // == UART Modules PARAMETER ==
		 parameter G_NB_UART_CHECKER        = 2,
		 parameter G_UART_DATA_WIDTH        = 8,
		 parameter G_UART_BUFFER_ADDR_WIDTH = 8,

		 // == DATA COLLECTOR PARAMETERS ==
		 parameter G_NB_COLLECTOR         = 2,
		 parameter G_DATA_COLLECTOR_WIDTH = 32,

		 // == DATA CHECKER PARAMETERS ==
		 parameter G_NB_CHECKER         = 2,
		 parameter G_DATA_CHECKER_WIDTH = 32,

		 // == MASTER AXI4LITE PARAMETERS ==
		 parameter G_NB_MASTER_AXI4LITE  = 2,
		 parameter G_AXI4LITE_ADDR_WIDTH = 32,
		 parameter G_AXI4LITE_DATA_WIDTH = 32
		 );


   // == CUSTOM TESTBENCH MODULES CLASS ==
   tb_modules_custom_class #(G_SET_SIZE,
			     G_SET_WIDTH,
			     G_WAIT_SIZE,
			     G_WAIT_WIDTH,
			     G_CLK_PERIOD, 
			     G_CHECK_SIZE,
		             G_CHECK_WIDTH,
			     G_NB_UART_CHECKER,
			     G_UART_DATA_WIDTH,
			     G_UART_BUFFER_ADDR_WIDTH,
			     G_NB_COLLECTOR,
			     G_DATA_COLLECTOR_WIDTH,
			     G_NB_CHECKER,
			     G_DATA_CHECKER_WIDTH,
			     G_NB_MASTER_AXI4LITE,
			     G_AXI4LITE_ADDR_WIDTH,
			     G_AXI4LITE_DATA_WIDTH 
			     ) tb_modules_custom_inst;  // Create Handle
   // ====================================


   // == VIRTUAL I/F ==

   // == GENERIC VIRTUAL I/F ==
   virtual wait_event_intf     #(G_WAIT_SIZE, G_WAIT_WIDTH)     wait_event_vif;
   virtual set_injector_intf   #(G_SET_SIZE, G_SET_WIDTH)       set_injector_vif;
   virtual wait_duration_intf  wait_duration_vif;
   virtual check_level_intf    #(G_CHECK_SIZE, G_CHECK_WIDTH)   check_level_vif;
   // =========================

 
   // =================

   

   // == Interface passed in Virtual I/F ==
   function new(virtual wait_event_intf     #(G_WAIT_SIZE, G_WAIT_WIDTH)    wait_nif, 
                virtual set_injector_intf #(G_SET_SIZE, G_SET_WIDTH) set_nif, 
                virtual wait_duration_intf wait_duration_nif,
                virtual check_level_intf #(G_CHECK_SIZE, G_CHECK_WIDTH) check_level_nif
		);

      this.tb_modules_custom_inst = new(set_nif, wait_nif, wait_duration_nif, check_level_nif); // Init Object

   endfunction // new

   // ====================================



   // INIT tb_modules_custom_class extend
   
   // == TASKS ==   

   /* SEQUENCER Task
    * Read The Scenario File
    * Send Args to the Decoder
   */
   task tb_sequencer(
        input string scn_file_path
      );
      
      begin
			 
	 // LOCAL VARIABLES
	 int 	   scn_file;      
	 string    line;
	 string    line_tmp = ""; // Temporary Line for Modelsim Command execution
	 
	 // Flag from Custom Testbench Modules
	 logic 	   s_cmd_custom_exists;
	 logic 	   s_cmd_custom_done;

	 // Flag from Generic Testbench Modules
	 logic 	   cmd_exists;      
      
	 logic 	   end_test;
	 int 	   line_status;

	 // INIT Variables
	 end_test    = 1'b0;
	 line_status = 0;

	 // Get Alias Info. of Regular Testbench Modules
	 this.tb_modules_custom_inst.REGULAR_TB_MODULES_ADD_INFO();

	 // Display Info of regular_tb_modules
	 this.tb_modules_custom_inst.DISPLAY_REGULAR_TB_MODULES_INFO();	 
	 
	 // Display Info on tb_modules_custom_class
	 this.tb_modules_custom_inst.DISPLAY_CUSTOM_TB_MODULES_INFO();	 

	 // Initialization of Custom TB Modules if needed
	 this.tb_modules_custom_inst.init_tb_modules();	 
       
	 
	 
      
	 // OPEN File
	 $display("# == Beginning of Sequencer == #");
	 scn_file = $fopen(scn_file_path, "r");

      
	 // While END_TEST not Reach
	 while(end_test == 1'b0) begin
	    
	    // READ SCENARIO LINE and return status
	    line_status = $fgets(line, scn_file);


	    // Display if special commentary
	    if( {line.getc(0), line.getc(1), line.getc(2), line.getc(3)}  == "//--") begin
	       $display("%s", line);	    
	    end

	    // Filter Commentary
	    else if( {line.getc(0), line.getc(1)} == "//" || {line.getc(0), line.getc(1)} == "--") begin
	       // Ignore Line   
	    end
       
	    // Line empty 
	    else if(line.getc(0) == "\n") begin
	       // Ignore Line if line empty
	    end	 

	    // End of Test detected
	    else if( {line.getc(0), line.getc(1), line.getc(2), line.getc(3), line.getc(4), line.getc(5), line.getc(6), line.getc(7)} == "END_TEST") begin
	       $display("# == End of Test == #");
               $fclose(scn_file);
	       end_test = 1'b1;
	       
	       $finish;
	    end
	 
	    // Send line to Command Decoder
	    else begin
	       
	       this.tb_modules_custom_inst.seq_custom_tb_modules(line); // Decode SCN Line
	    end // while (end_test == 1'b0)
	    
	 end // while (end_test == 1'b0)
      end      
      
   endtask // tb_sequencer





   // == FUNCTIONS ==

   // ADD Alias function
   function void ADD_ALIAS(string tb_module_name, string alias_str, int alias_index);
      
      case(tb_module_name)
	"SET_INJECTOR" : begin
	   tb_modules_custom_inst.tb_set_injector_inst.ADD_SET_INJECTOR_ALIAS(alias_str, alias_index);	   
	end

	"WAIT_EVENT" : begin
	   tb_modules_custom_inst.tb_wait_event_inst.ADD_WAIT_EVENT_ALIAS(alias_str, alias_index);
	end

	"CHECK_LEVEL" : begin
	   tb_modules_custom_inst.tb_check_level_inst.ADD_CHECK_LEVEL_ALIAS(alias_str,  alias_index);
	end	

	default: $display("Error: %s  does not exists !", tb_module_name);
	
      endcase // case (tb_module_name)
      
   endfunction // ADD_ALIAS   
	
   // ===============
   
endclass
