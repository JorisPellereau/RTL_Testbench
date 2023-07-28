//                              -*- Mode: Verilog -*-
// Filename        : tb_modelsim_cmd_class.sv
// Description     : Testbench Modelsim Command Class
// Author          : Linux-JP
// Created On      : Sun Nov 21 18:50:16 2021
// Last Modified By: Linux-JP
// Last Modified On: Sun Nov 21 18:50:16 2021
// Update Count    : 0
// Status          : Unknown, Use with caution!

// Add package - Not necessary
package fli;
    import "DPI-C" function mti_Cmd(input string cmd);
endpackage // fli

   
class tb_modelsim_cmd_class;

   // == CONSTRUCTOR ==
   function new();
   endfunction // new   
   // =================


   // Sel Check Level Command
   task sel_modelsim_command(input string i_cmd,
			     input string i_args);
      begin

	 case(i_cmd)
	   "MODELSIM_CMD": begin
	      modelsim_cmd_exec(i_args);
	   end
	  	   
	   default: $display("Error: wrong MODELSIM Command : %s", i_cmd);	   
	 endcase // case (i_cmd)
	 
      end
   endtask; // sel_check_level_command

   /*
    *
    * Task : get line in double quote
    * 
    */
   task extract_line_double_quote (
                                  input string i_args,
				  output string line_in_double_quote
      );
      begin
	 int first_guillemet  = 0;
	 int i;

	 // == Fin Guillemet Position ==
	 for(i = 0 ; i < i_args.len() ; i++) begin // Find guillemet position
	    if(i_args[i] == "\"") begin
	       if(first_guillemet == 0) begin
		  first_guillemet = i; 	  
	       end	       	       
	    end	    
	 end // for (i == 0 ; i < line_length ; i++)

	 $display("DEBUG - first_guillement : %d", first_guillemet);
	 
	 // Remove '"' in string (End of line fill with \n and ")
         line_in_double_quote = i_args.substr( first_guillemet + 1, i_args.len() - 4);
	 $display("Line in double quote : %s", line_in_double_quote);
	 
      end
   endtask // extract_line_double_quote
   
      

   /*
    * Task : Execute a Modelsim Command when command is executed
    *
    * */
   task modelsim_cmd_exec (
			   input string line
			   );
      begin

	 int 	status;
	 string line_tmp = "";

	 
	 line = line.substr(1, line.len() - 2);	 // Remove first " and " + \n
	 $display("Modelsim Command Exec. : %s", line); 
	 status = mti_fli::mti_Cmd(line);

      end
   endtask // modelsim_cmd_exec

endclass // tb_modelsim_cmd_class
