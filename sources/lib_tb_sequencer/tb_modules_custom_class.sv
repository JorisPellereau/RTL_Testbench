//                              -*- Mode: Verilog -*-
// Filename        : tb_modules_custom_class.sv
// Description     : A Class which will contain Custom Testbench Block
// Author          : JorisP
// Created On      : Tue Apr 20 20:15:47 2021
// Last Modified By: JorisP
// Last Modified On: Tue Apr 20 20:15:47 2021
// Update Count    : 0
// Status          : Unknown, Use with caution!

//`include "/home/jorisp/GitHub/Verilog/lib_tb_uart/tb_uart_class.sv"

// == REGULAR TESTBENCH CLASS ==
`include "/home/linux-jp/Documents/GitHub/Verilog/Testbench/sources/lib_tb_set_injector/tb_set_injector_class.sv"
`include "/home/linux-jp/Documents/GitHub/Verilog/Testbench/sources/lib_tb_wait_event/tb_wait_event_class.sv"
`include "/home/linux-jp/Documents/GitHub/Verilog/Testbench/sources/lib_tb_check_level/tb_check_level_class.sv"
`include "/home/linux-jp/Documents/GitHub/Verilog/Testbench/sources/lib_tb_modelsim_cmd/tb_modelsim_cmd_class.sv"
// =============================

// == CUSTOM TESTBENCH CLASS ==
`include "/home/linux-jp/Documents/GitHub/Verilog/Testbench/sources/lib_tb_uart/tb_uart_class.sv"
`include "/home/linux-jp/Documents/GitHub/Verilog/Testbench/sources/lib_tb_data_collector/tb_data_collector_class.sv"
`include "/home/linux-jp/Documents/GitHub/Verilog/Testbench/sources/lib_tb_data_checker/tb_data_checker_class.sv"
`include "/home/linux-jp/Documents/GitHub/Verilog/Testbench/sources/lib_tb_axi4/tb_master_axi4lite_class.sv"
// ============================

class tb_modules_custom_class #(// == SET INJECTOR PARAMETERS ==
				parameter G_SET_SIZE  = 5,
				parameter G_SET_WIDTH = 32,
				
				// == WAIT EVENT PARAMETERS ==
				parameter G_WAIT_SIZE  = 5,
				parameter G_WAIT_WIDTH = 1,
				parameter G_CLK_PERIOD = 1000, // Unity : ps
				
				// == CHECK LEVEL PARAMETERS ==
				parameter G_CHECK_SIZE  = 5,
				parameter G_CHECK_WIDTH = 32,

				// == UART PARAMETERS ==
				parameter G_NB_UART_CHECKER   = 2,
				parameter G_DATA_WIDTH        = 8,
				parameter G_BUFFER_ADDR_WIDTH = 8,

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
   

   /* ===========
    * == TYPES ==
    * ===========
    */
   typedef int alias_list_t [string]; // Associative array of Possible Alias
   typedef int cmd_list_t   [string]; // Associative array of Possible Command (Ex : TX_START - COLLECT_STOP etc..)
   typedef string regular_cmd_list_t [int]; // Associative array of Regular Commands
   
   /* ============
    * == STRUCT ==
    * ============
    */
   typedef struct {
      string 	  cmd_type;           // Type of Commande
      alias_list_t alias_list;        // List of Alias of Commande Type
      cmd_list_t cmd_list;            // List of Commande of Commande type
      int 	  alias_list_ptr = 0; // Alias List Pointer
      bit 	  is_regular_cmd = 0; // Regular Command (CHK-WAIT-SET ..) or Custom command (UART - DATA_COLLECTOR ..)
   } tb_modules_infos_st;

   /* ================
    * == CONSTANTES ==
    * ================
    */
   const int regular_cmd_nb = 8;
   tb_modules_infos_st regular_tb_modules_infos[8-1:0];

   regular_cmd_list_t regular_cmd_list = '{0         : "SET",
					   1         : "WTR",
					   2         : "WTF",
					   3         : "WTRS",
					   4         : "WTFS",
					   5         : "CHK" ,
					   6         : "WAIT",
					   7         : "MODELSIM_CMD"
					   };

   
   /* ===============
    * == VARIABLES ==
    * ===============
    */

   
   tb_modules_infos_st tb_modules_infos [*]; // TB Infos of Custom Testbench Modules - Dynamic Struct
   int 	       tb_infos_ptr = 0;   
   int 	       i;                  // Index

   
   

   /* =====================================    
    * == GENERIC Testbench Modules Class ==
    * =====================================
    */

   // Set Injector Testbench Module
   tb_set_injector_class #(G_SET_SIZE,
			   G_SET_WIDTH
			   )
   tb_set_injector_inst;   

   // Wait Event Testbench Module
   tb_wait_event_class #(G_WAIT_SIZE,
			 G_WAIT_WIDTH,
			 G_CLK_PERIOD // Unity : ps
			 )
   tb_wait_event_inst;   

   // Check Level Testbench Module
   tb_check_level_class #(G_CHECK_SIZE,
			  G_CHECK_WIDTH
			  )
   tb_check_level_inst;

   // Modelsim Command
   tb_modelsim_cmd_class tb_modelsim_cmd_inst;   
   
   
   /* ======================================    
    * == Array of Testbench Modules Class ==
    * ======================================
    */

   // == UART TESTBENCH CLASS ==
   tb_uart_class #(G_NB_UART_CHECKER  ,
		   G_DATA_WIDTH       ,
		   G_BUFFER_ADDR_WIDTH
		   )
   tb_uart_class_custom_inst [*];
   
    int 	   uart_checker_vif_ptr = 0; // Virtual interface pointer   
   
   // INIT UART TESTBENCH CLASS and Add Info
   function void init_uart_custom_class(virtual uart_checker_intf #(G_NB_UART_CHECKER, 
								    G_DATA_WIDTH, 
								    G_BUFFER_ADDR_WIDTH) uart_checker_nif, 
					string UART_ALIAS);
  
      this.tb_uart_class_custom_inst[this.uart_checker_vif_ptr]  = new(uart_checker_nif, UART_ALIAS);

      // Add Info Of current Instantiated class
      ADD_INFO(this.tb_uart_class_custom_inst[this.uart_checker_vif_ptr].UART_COMMAND_TYPE,
	       this.tb_uart_class_custom_inst[this.uart_checker_vif_ptr].UART_CMD_ARRAY,
	       this.tb_uart_class_custom_inst[this.uart_checker_vif_ptr].UART_ALIAS);
      
      this.uart_checker_vif_ptr += 1; // Inc Pointer
            
   endfunction // init_uart_class
  
   // ===============================


   // == DATA COLLECTOR TESTBENCH CLASS ==
   tb_data_collector_class #(G_NB_COLLECTOR,
		             G_DATA_COLLECTOR_WIDTH
			     )
   tb_data_collector_inst [*];
   int 					       data_collector_vif_ptr = 0; // Pointer of DATA_COLLECTOR Instances
   
   
   // Init DATA COLLECTOR TESTBENCH CLASS and Add Info
   function void init_data_collector_custom_class(virtual data_collector_intf #(G_NB_COLLECTOR, 
										G_DATA_COLLECTOR_WIDTH) 
						  data_collector_nif,
						  string DATA_COLLECTOR_ALIAS);
      
      this.tb_data_collector_inst[this.data_collector_vif_ptr] = new(data_collector_nif, DATA_COLLECTOR_ALIAS);

      ADD_INFO(this.tb_data_collector_inst[this.data_collector_vif_ptr].DATA_COLLECTOR_COMMAND_TYPE,
	       this.tb_data_collector_inst[this.data_collector_vif_ptr].DATA_COLLECTOR_CMD_ARRAY,
	       this.tb_data_collector_inst[this.data_collector_vif_ptr].DATA_COLLECTOR_ALIAS);
      
      this.data_collector_vif_ptr += 1; // Inc. Pointer
            
   endfunction // init_data_collector_custom_class
   // ==========================================

   // == DATA CHECKER TESTBENCH CLASS ==
   tb_data_checker_class #( 
			    .G_NB_CHECKER         (G_NB_CHECKER),
			    .G_DATA_CHECKER_WIDTH (G_DATA_CHECKER_WIDTH)
			   )
   tb_data_checker_inst [*];
   int 							 data_checker_vif_ptr = 0; // Point of DATA_CHECKER Instances

   // Init DATA CHECKER TESTBENCH CLASS and Add Info
   function void init_data_checker_custom_class(virtual data_checker_intf #(G_NB_CHECKER,
									    G_DATA_CHECKER_WIDTH)
						data_checker_nif,
						string DATA_CHECKER_ALIAS
						);

      this.tb_data_checker_inst[this.data_checker_vif_ptr] = new(data_checker_nif, DATA_CHECKER_ALIAS);

      ADD_INFO(this.tb_data_checker_inst[this.data_checker_vif_ptr].DATA_CHECKER_COMMAND_TYPE,
	       this.tb_data_checker_inst[this.data_checker_vif_ptr].DATA_CHECKER_CMD_ARRAY,
	       this.tb_data_checker_inst[this.data_checker_vif_ptr].DATA_CHECKER_ALIAS);
      
      this.data_checker_vif_ptr += 1; // Inc. Pointer
      
   endfunction // init_data_checker_custom_class         
   // ==================================


   // == MASTER AXI4LITE TESTBENCH CLASS ==
   tb_master_axi4lite_class #(
			      .G_NB_MASTER_AXI4LITE  (G_NB_MASTER_AXI4LITE),
			      .G_AXI4LITE_ADDR_WIDTH (G_AXI4LITE_ADDR_WIDTH),
			      .G_AXI4LITE_DATA_WIDTH (G_AXI4LITE_DATA_WIDTH)
			      )
   tb_master_axi4lite_inst [*];
   int 						       master_axi4lite_vif_ptr = 0; // Pointer of MASTER_AXI4LITE Instances

   // INIT MASTER AXI4LITE TESTBENCH CLASS and Add Info
   function void init_master_axi4lite_custom_class(virtual master_axi4lite_intf #(G_AXI4LITE_ADDR_WIDTH,
										  G_AXI4LITE_DATA_WIDTH)
						   master_axi4lite_nif,
						   string MASTER_AXI4LITE_ALIAS
						   );
      
      this.tb_master_axi4lite_inst[this.master_axi4lite_vif_ptr] = new(master_axi4lite_nif, MASTER_AXI4LITE_ALIAS);
      ADD_INFO(this.tb_master_axi4lite_inst[this.master_axi4lite_vif_ptr].MASTER_AXI4LITE_COMMAND_TYPE,
	       this.tb_master_axi4lite_inst[this.master_axi4lite_vif_ptr].MASTER_AXI4LITE_CMD_ARRAY,
	       this.tb_master_axi4lite_inst[this.master_axi4lite_vif_ptr].MASTER_AXI4LITE_ALIAS);
      this.master_axi4lite_vif_ptr += 1; // Inc. Pointer
            
   endfunction // init_master_axi4lite_custom_class
   
   
   // =====================================
   
   
   /* =================
    * == CONSTRUCTOR ==
    * =================
    */

   // Initialize Generic Testbench Modules
   function new (virtual set_injector_intf #(G_SET_SIZE, G_SET_WIDTH)     set_injector_nif,
		 virtual wait_event_intf #(G_WAIT_SIZE, G_WAIT_WIDTH) wait_event_nif,
		 virtual wait_duration_intf  wait_duration_vif,
		 virtual check_level_intf #(G_CHECK_SIZE, G_CHECK_WIDTH) check_level_nif);

      this.tb_set_injector_inst = new(set_injector_nif);                    // Init Class Oblect Set Injector
      this.tb_wait_event_inst   = new(wait_event_nif, wait_duration_vif);   // Init Class Object Wait Event      
      this.tb_check_level_inst  = new(check_level_nif);                     // Init Class Object Check Level
      this.tb_modelsim_cmd_inst = new();                                    // Init Modelsim Command
      

      // Init Regular TB Modules Infos
      for(i = 0; i < this.regular_cmd_list.size(); i++) begin
	 this.regular_tb_modules_infos[i].cmd_type       = this.regular_cmd_list[i];
	 this.regular_tb_modules_infos[i].is_regular_cmd = 1;                       // Regular Command	 
      end
   endfunction // new

   
   /* ===============
    * == FUNCTIONS ==
    * ===============
    */
 
  
   // Add Info of Current Custom TB Module to GLobal Info
   function void ADD_INFO(string cmd_type, cmd_list_t tb_module_cmd_list, string TB_MODULE_ALIAS);
            
      // Internal Variables
      int      cmd_type_already_exists = 0;
      int      cmd_type_index          = 0;
      bit      is_regular = 0;
      
      
      //$display("DEBUG - ADD_INFO function !");
      $display("this.tb_infos_ptr : %d", this.tb_infos_ptr);
      
      // == Check if cmd_type is already stored in tb_modules_infos
      for(i = 0 ; i < this.tb_infos_ptr; i++) begin	 
	 if(cmd_type_already_exists == 0) begin
	    if(this.tb_modules_infos[i].cmd_type == cmd_type) begin
	       cmd_type_already_exists = 1; // Command Already Exists
	       cmd_type_index          = i; // Save the index
	       //$display("DEBUG - tb_modules_custom_class : Command Type already exists - index : %d !", cmd_type_index);
	       
	    end
	 end
      end

      // == Check if cmd_type is a regular command or not ==
      // if(this.regular_cmd_list.exists(cmd_type) == 1) begin
      // 	 is_regular = 1;	 
      // end
      // else begin
      // 	 is_regular = 0;	 
      // end
      // ===================================================

      // If cmd_type doesnt exists, add it to array of struct
      if(cmd_type_already_exists == 0) begin
	 /*$display("cmd_type_already_exists == 0");	
	 $display("cmd_type : %s - tb_module_cmd_list : %p", cmd_type, tb_module_cmd_list);
	 */
	 // Add Command type
	 this.tb_modules_infos[this.tb_infos_ptr].cmd_type = cmd_type;
	 
	 // Add Alias
	 this.tb_modules_infos[this.tb_infos_ptr].alias_list[TB_MODULE_ALIAS] = this.tb_modules_infos[this.tb_infos_ptr].alias_list_ptr;
	 this.tb_modules_infos[this.tb_infos_ptr].alias_list_ptr += 1; // Inc Alias Pointer
	 
	 // Add Command List
	 this.tb_modules_infos[this.tb_infos_ptr].cmd_list = tb_module_cmd_list; // Same List of command for cmd_type

	 // Add info of regular cmd
	 this.tb_modules_infos[this.tb_infos_ptr].is_regular_cmd = is_regular;
	 
	 /*$display("this.tb_modules_infos[this.tb_infos_ptr].cmd_type : %s", this.tb_modules_infos[this.tb_infos_ptr].cmd_type);
	 $display("this.tb_modules_infos[this.tb_infos_ptr].alias_list : %p", this.tb_modules_infos[this.tb_infos_ptr].alias_list);
	 $display("this.tb_modules_infos[this.tb_infos_ptr].is_regular_cmd : %d", this.tb_modules_infos[this.tb_infos_ptr].is_regular_cmd);
	 */
	 this.tb_infos_ptr += 1; // Inc Pointer	
	 //$display("this.tb_infos_ptr : %d\n", this.tb_infos_ptr);
	 
	 
//  
      end // if (cmd_type_already_exists == 0)
      // If cmd_already exists - Check if Alias is not already in the list, if not add it to struct
      else begin

	 // Check if Alias already exists in the list 
	 if(this.tb_modules_infos[cmd_type_index].alias_list.exists(TB_MODULE_ALIAS) == 0) begin
	    $display("Alias does not exists : %s", TB_MODULE_ALIAS);
	    
	    this.tb_modules_infos[cmd_type_index].alias_list[TB_MODULE_ALIAS] = this.tb_modules_infos[cmd_type_index].alias_list_ptr;
	    this.tb_modules_infos[cmd_type_index].alias_list_ptr += 1; // Inc Alias Pointer
	 end
	 else begin
	    $display("Error: %s already exists in tb_modules_infos !", TB_MODULE_ALIAS);	    
	 end
      end

      //$display("this.tb_modules_infos : %p\n\n", this.tb_modules_infos);
            
   endfunction // ADD_INFO
   
   // REGULAR_TB_MODULE_ADD_INFO
   function void REGULAR_TB_MODULES_ADD_INFO();
      this.regular_tb_modules_infos[0].alias_list = this.tb_set_injector_inst.set_injector_alias_list; // Get Alias List of SET
      this.regular_tb_modules_infos[1].alias_list = this.tb_wait_event_inst.wait_event_alias_list;     // Get Alias List of WTR
      this.regular_tb_modules_infos[2].alias_list = this.tb_wait_event_inst.wait_event_alias_list;     // Get Alias List of WTF
      this.regular_tb_modules_infos[3].alias_list = this.tb_wait_event_inst.wait_event_alias_list;     // Get Alias List of WTRS
      this.regular_tb_modules_infos[4].alias_list = this.tb_wait_event_inst.wait_event_alias_list;     // Get Alias List of WTFS
      this.regular_tb_modules_infos[5].alias_list = this.tb_check_level_inst.check_level_alias_list;   // Get ALias List of Check Level
//      this.regular_tb_modules_infos[6].alias_list = this.tb_check_level_inst.check_level_alias_list;   // Get ALias List of Check Level
      
            
   endfunction // REGULAR_TB_MODULES_ADD_INFO

   // Display Regular TB Module Info
   function void DISPLAY_REGULAR_TB_MODULES_INFO();
      $display("# ================================ #");           
      $display("Regular TB Infos : ");
      for(i = 0; i < this.regular_cmd_nb; i++) begin
	 $display("cmd_type   : %s", this.regular_tb_modules_infos[i].cmd_type);
	 $display("alias_list : %p\n", this.regular_tb_modules_infos[i].alias_list);
      end	 	 
      $display("# ================================ #");
   endfunction // DISPLAY_REGULAR_TB_MODULES_INFO
   
   
   // Display Custom TB Module Info
   function void DISPLAY_CUSTOM_TB_MODULES_INFO();
      $display("# ================================ #");           
      $display("TB Infos : ");
      for(i = 0 ; i < this.tb_infos_ptr ; i++) begin
	 $display("cmd_type   : %s", this.tb_modules_infos[i].cmd_type);
	 $display("alias_list : %p", this.tb_modules_infos[i].alias_list);
	 $display("cmd_list   : %p\n", this.tb_modules_infos[i].cmd_list);
      end      	 
      $display("# ================================ #");
   endfunction // DISPLAY_CUSTOM_TB_MODULES_INFO


  
   
   /* ==========================================
    * == COMMON FUNCTIONS AND TASK to CHILDS  ==
    * ==========================================
    */

   // Sequencer of scenario command lines
   virtual task seq_custom_tb_modules(input string line);
      begin
	 string cmd_type;  // Type of the command (UART, DATA_COLLECTOR etc..)
	 string alias_str; // Alias of the Type of Command
	 string cmd;	   // Command of the type of command
	 string cmd_args;  // Args of the command
	 logic 	check_ok;  // Check OK "1" or KO "0"
	 logic 	is_regular_cmd; // Regular command when  == '1'	  
	 
	 decod_scn_line(line, cmd_type, alias_str, cmd, cmd_args);                 // Decode Scenarii lines
	 check_commands(cmd_type, alias_str, check_ok, is_regular_cmd);            // Check if Command type exists and if Alias exists

	 if(check_ok == 1) begin
	    routed_commands(cmd_type, alias_str, cmd, cmd_args, is_regular_cmd);   // Route commands to corect Testbench Modules
	 end	 	 
      end
   endtask // seq_custom_tb_modules
   

   // Get Line from scenario and :
   // Extract from line : cmd_type - alias and args
   virtual task decod_scn_line(input string line,
			       
			       output string o_cmd_type,
			       output string o_alias_str,
			       output string o_cmd,
			       output string o_cmd_args);
      begin
	 // == INTERNAL Variables ==
	 int line_length          = 0; // Length of the line
	 int pos_0                = 0; // Position of [ character
	 int pos_1                = 0; // Position of ] character
	 int pos_parenthesis_0    = 0; // Position of ( character
	 int pos_parenthesis_1    = 0; // Position of ) character
	 int first_space_position = 0; // First position of " " character

	 bit pos_0_find = 0; // 1 if first position of [ char. is find
	 bit pos_1_find = 0; // 1 if first position of ] char. is find	 
	 
	 int i; // Loop Index

	 string cmd_type;  // Command between beginning of line and "["	 
	 string alias_str; // Extracted Alias of the line
	 string cmd;       // Command of the commande type	 
	 string cmd_args;  // Extract char. between "(" and ")"	 
	 // ========================

	 // Prin Line
	 $display("%s", line.substr(0,line.len() - 2)); // Print line and Remove "\n" character
	 

	 // Get the length of the line
	 line_length = line.len();

	 // Get info. of the line
	 // Get The type of Command (UART - DATA_COLLECTOR - etc..)
	 for(i = 0; i < line_length; i++) begin

	    // Get "[" position
	    if(line.getc(i) == "["  && pos_0_find == 0) begin
	       pos_0      = i;
	       pos_0_find = 1;	       
	    end

	    // Get "]" position
	    if(line.getc(i) == "]" && pos_1_find == 0) begin
	       pos_1      = i;
	       pos_1_find = 1;
	    end

	    // Get "(" position
	    if(line.getc(i) == "(") begin
	       pos_parenthesis_0 = i;	       
	    end

	    // Get ")" position
	    if(line.getc(i) == ")") begin
	       pos_parenthesis_1 = i;	       
	    end
	    
	 end

	 // Get Commande Type
	 cmd_type = line.substr(0, pos_0 - 1);
	 
	 // Get Alias
	 alias_str = line.substr(pos_0 + 1, pos_1 - 1); // RM "[" and "]"

	 // Get First space position
	 first_space_position = pos_1 + 1;
	 cmd = line.substr(first_space_position + 1, pos_parenthesis_0 - 1);	 

	 // Get Commands Args
	 cmd_args = line.substr(pos_parenthesis_0 + 1 , pos_parenthesis_1 - 1); // RM "(" and ")"

	 
	 //$display("DEBUG - cmd_type : %s - alias_str : %s - cmd : %s - cmd_args : %s", cmd_type, alias_str, cmd, cmd_args);
	 
	 // Output affectation
	 o_cmd_type  = cmd_type;
	 o_alias_str = alias_str;
	 o_cmd       = cmd;	 
	 o_cmd_args  = cmd_args;
	 
      end      
   endtask // seq_custom_tb_modules

   // Check if extracted commands exists
   virtual task check_commands(input string i_cmd_type,
			       input string i_alias_str,
			       output logic o_check_ok,
			       output logic o_is_regular_cmd);
      begin
	 
	 // Internal variables
	 int i                   = 0; // Loop index
	 logic i_cmd_type_exists = 0; // Command Type exists flag
	 int   cmd_type_index    = 0; // Index of command type if exists	 
	 int   is_regular_cmd    = 0; // Regular Command
	 
	 
	 // By default check is not ok
	 o_check_ok   = 0;

	 // == Check if i_cmd_type is a regular command or not
	 for(i = 0; i < this.regular_cmd_nb ; i ++) begin
	    if(this.regular_tb_modules_infos[i].cmd_type == i_cmd_type) begin
	       is_regular_cmd    = 1;
	       i_cmd_type_exists = 1; // Set flag to 1
	       cmd_type_index    = i; // Get index
	    end
	 end
	 
	 // == Check if i_cmd_type is in tb_modules_info only if it is not a regular cmd ==
	 if(is_regular_cmd == 0) begin
	    for(i = 0; i < this.tb_infos_ptr; i++) begin
	       if(this.tb_modules_infos[i].cmd_type == i_cmd_type) begin
		  i_cmd_type_exists = 1; // Set flag to 1
		  cmd_type_index    = i; // Get index
	       end
	    end
	 end
	 // ===============================================
	 
	 if(i_cmd_type_exists == 0) begin
	    $display("Error: cmd_type %s does not exists !", i_cmd_type);
	    o_check_ok = 0;
	 end
	 // Case i_cmd_type exists
	 else begin

	    // Check if Alias exists in regular cmd type
	    if(is_regular_cmd == 1) begin
	       if(this.regular_tb_modules_infos[cmd_type_index].alias_list.exists(i_alias_str)) begin
		  o_check_ok = 1;		  
	       end
	       // Special Case for "WAIT" Command => No Alias needed for this command
	       // Special Case for "MODELSIM_CMD" Command => No Alias needed
	       else if(i_cmd_type == "WAIT" || i_cmd_type == "MODELSIM_CMD") begin
		  o_check_ok = 1;		  
	       end
	       
	       else begin
		  $display("Error: Alias %s does not exists !", i_alias_str);
	       end
	    end // if (is_regular_cmd == 1)
	    
	    else begin
	       // Check if Alias exists in cmd_type (not a regular cmd)
	       if(this.tb_modules_infos[cmd_type_index].alias_list.exists(i_alias_str)) begin
		  o_check_ok = 1; // Commad type and Alias Exists
	       end
	       else begin
		  $display("Error: Alias %s does not exists !", i_alias_str);	       
	       end
	    end
	 end // else: !if(i_cmd_type_exists == 0)

	 //$display("DEBUG - check_commands : o_check_ok : %d", o_check_ok);

	 o_is_regular_cmd = is_regular_cmd;	 
      end
   endtask; // check_commands


   // Routed Commands
   // Run route_commands method of selected testbench modules
   virtual task routed_commands(input string i_cmd_type,
				input string i_alias_str,
				input string i_cmd,
				input string i_cmd_args,
				input logic  i_is_regular_cmd);
      begin

	 // Internal variables
	 int i = 0; // Loop index

	 if(i_is_regular_cmd == 0) begin
	    // Loop on all possible commands
	    for (i = 0; i < this.tb_infos_ptr ; i++) begin
	    
	       // Check if Commands are "UART" Types
	       if(this.tb_modules_infos[i].cmd_type == "UART" && i_cmd_type == "UART") begin
		  this.tb_uart_class_custom_inst[this.tb_modules_infos[i].alias_list[i_alias_str]].sel_uart_command(i_cmd, 
														    i_alias_str, 
														    i_cmd_args);
	       end
	       
	       // Check if Commands are "DATA_COLLECTOR" Types
	       else if(this.tb_modules_infos[i].cmd_type == "DATA_COLLECTOR" && i_cmd_type == "DATA_COLLECTOR") begin
		  this.tb_data_collector_inst[this.tb_modules_infos[i].alias_list[i_alias_str]].sel_data_collector_command(i_cmd, 
															   i_alias_str, 
															   i_cmd_args);
	       end
	    end // for (i = 0; i < this.tb_infos_ptr ; i++)
	 end // if (i_is_regular_cmd == 0)

	 
	 else begin
	    // Loop For REGULAR Commands
	    for(i = 0; i < this.regular_cmd_nb ; i++) begin

	       // Check Commands
	       if(this.regular_tb_modules_infos[i].cmd_type == "CHK" && i_cmd_type == "CHK") begin
		  this.tb_check_level_inst.sel_check_level_command(i_cmd_type,
								   i_alias_str,
								   i_cmd_args);
	       end
	       // Wait Event Command
	       else if(
		       (this.regular_tb_modules_infos[i].cmd_type == "WTR" && i_cmd_type == "WTR")   ||
		       (this.regular_tb_modules_infos[i].cmd_type == "WTF" && i_cmd_type == "WTF")   ||
		       (this.regular_tb_modules_infos[i].cmd_type == "WTRS" && i_cmd_type == "WTRS") || 
		       (this.regular_tb_modules_infos[i].cmd_type == "WTFS" && i_cmd_type == "WTFS") || 
		       (this.regular_tb_modules_infos[i].cmd_type == "WAIT" && i_cmd_type == "WAIT") ) begin
		  this.tb_wait_event_inst.sel_wait_event_command(i_cmd_type,
								 i_alias_str,
								 i_cmd_args);
		  
	       end
	       else if(this.regular_tb_modules_infos[i].cmd_type == "SET" && i_cmd_type == "SET") begin
		  this.tb_set_injector_inst.sel_set_injector_command(i_cmd_type,
								     i_alias_str,
								     i_cmd_args);
		  
	       end
	       else if(this.regular_tb_modules_infos[i].cmd_type == "MODELSIM_CMD" && i_cmd_type == "MODELSIM_CMD") begin
		  this.tb_modelsim_cmd_inst.sel_modelsim_command(i_cmd_type,
								 i_cmd_args);
	       end
	       else begin
		 //$display("Error: Routed command failed");		  
	       end
	    end
	 end
	 
      end
   endtask; // routed_commands
   
   

   // Initialization of Enabled Testbench Modules
   virtual task init_tb_modules(); 
      begin       
	 // INIT SET INJECTOR
	 this.tb_set_injector_inst.set_injector_init();
      end      
   endtask // init_tb_modules

endclass // tb_modules_custom_class
