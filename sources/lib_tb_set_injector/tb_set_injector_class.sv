//                              -*- Mode: Verilog -*-
// Filename        : tb_set_injector_class.sv
// Description     : Testbench Set Injector Class
// Author          : Linux-JP
// Created On      : Sun Nov 21 11:23:02 2021
// Last Modified By: Linux-JP
// Last Modified On: Sun Nov 21 11:23:02 2021
// Update Count    : 0
// Status          : Unknown, Use with caution!

class tb_set_injector_class #(
			      parameter G_SET_SIZE  = 5,
			      parameter G_SET_WIDTH = 32);


   /* ===========
    * == TYPES ==
    * ===========
    */
   typedef int alias_list_t [string]; // Associative array of Possible Alias
   
   // == Virtual I/F ==
   virtual set_injector_intf    #(G_SET_SIZE, G_SET_WIDTH)   set_injector_vif;
   // =================

   // == VARIABLES ==
   alias_list_t set_injector_alias_list; // List of Alias  
   // ===============

   // == CONSTRUCTOR ==
   function new(virtual set_injector_intf #(G_SET_SIZE, G_SET_WIDTH) set_injector_nif);
      this.set_injector_vif = set_injector_nif; // Init Interface
   endfunction // new   
   // =================

   // Commands
   // SET[ALIAS] (0x30)
   // SET[ALIAS] (3)
   // SET[ALIAS] (z)


   // Sel Set Injector Command
   task sel_set_injector_command(input string i_cmd,
				 input string i_alias,
				 input string i_args);
      begin

	 case(i_cmd)
	   "SET": begin
	      set_injector(i_alias, i_args); // TBD	      
	   end

	   default: $display("Error: wrong SET Injector Command : %s", i_cmd);	   
	 endcase // case (i_cmd)
	 
      end
   endtask; // sel_set_injector_command


   /* SET INJECTOR INIT TASK
    *  SET initial valueto the SET INJECTOR outputs
    * 
    * 
    */
   task set_injector_init();
      begin
	 this.set_injector_vif.set_signals_asynch = this.set_injector_vif.set_signals_asynch_init_value; 
      end
   endtask // set_injector_init




   /* SET INJECTOR TASK
    * Read Args From Decoder task and set output as combinational
    * 
    */
   task set_injector(
		     input string i_alias,
		     input string i_args
		     );
      begin

	 // LOCAL VARIABLES
         int     s_str_len;
	 string  s_str;

	 
	 // Case : 0x at the beginning of the Args
	 if( {i_args.getc(0),  i_args.getc(1)} == "0x") begin
		  
           s_str_len = i_args.len();                    // Find Length		  
           s_str     = i_args.substr(2, s_str_len - 1); // Remove 0x	

	   this.set_injector_vif.set_signals_asynch[this.set_injector_alias_list[i_alias]] = s_str.atohex();	  
	 end
	 
	 // Decimal args
	 else begin
	   this.set_injector_vif.set_signals_asynch[this.set_injector_alias_list[i_alias]]  = i_args.atoi();	  
	 end

      end
      
      $display("");      
      	 
   endtask // set_injector

   // Add Alias function to class and to Interface
   function void ADD_SET_INJECTOR_ALIAS(string alias_str, int alias_index);
      this.set_injector_alias_list[alias_str] = alias_index;  
   endfunction
   
endclass // tb_set_injector_class
