//                              -*- Mode: Verilog -*-
// Filename        : tb_utils.sv
// Description     : Useful Function and tasks for Testbench
// Author          : JorisP
// Created On      : Sun Apr 18 16:38:09 2021
// Last Modified By: JorisP
// Last Modified On: Sun Apr 18 16:38:09 2021
// Update Count    : 0
// Status          : Unknown, Use with caution!

// == TYPE DEF ==
typedef int space_position_t []; // Dynamics Array of int
typedef string args_t [];        // Dynamics Array of string   
// ==============

class tb_utils_class;

   
   
   int data_size;
      
   function new ();     
   endfunction // new
   
      
   // Convert an input string into an integer
   function int str_2_int (input string str, output int result);
      
      int s_str_len;
      
      string s_str;
      int    s_value;
      
      
      result = 0;
      
      if( {str.getc(0),  str.getc(1)} == "0x") begin
	 
	 s_str_len     = str.len(); // Find Length		  
         s_str         = str.substr(2, s_str_len - 1); // Remove 0x
         s_value       = s_str.atohex(); // Set Correct Hex value
      end
      // DECIMAL ARGS
      else begin
         s_value = str.atoi;
	 
      end // else: !if( {i_args[2].getc(0),  i_args[2].getc(1)} == "0x")
      
      result = s_value;
      
      return result;
      
   endfunction // str_2_int
   
   
   
   
   // Get SPACE position(s) in a string
   function space_position_t str_2_space_positions(input string str);
      
      int i = 0;
      space_position_t space_position; // Create Dynamic int array
      
      // Get space position
      for(i = 0; i < str.len(); i++) begin

	 //$display("DEBUG : str[%d] : %s", i, str[i]);
	 
	 if(str[i] == " ") begin

	    // Create Array
	    if(space_position.size() == 0) begin
	       space_position    = new [1]; // Create Array with 1st element
	       space_position[0] = i;       // 1st Space position
	       
	    end
	    else begin
	       space_position                            = new [space_position.size() + 1] (space_position); // Add 1 element
	       space_position[space_position.size() - 1] = i;	       
	    end      
	 end
      end // for (i = 0; i < str.len(); i++)

      return space_position;      
      
   endfunction // str_2_space_positions



   // Get several args from an input string
   function args_t str_2_args(input string str);

      // Local Variables
      int i       = 0;
      int str_len = 0;
      int args_nb = 0;
      
      
      space_position_t space_positions;
      args_t args;
      
      str_len         = str.len();                       // Get STR len()
      space_positions = this.str_2_space_positions(str); // Get Space Positions
      $display("space_positions : %p", space_positions);

      args_nb = space_positions.size() + 1; // Number of space position + 1
      
      for(i = 0 ; i < args_nb ; i++) begin

	 // Case 1st args
	 if(args.size() == 0) begin
	    args    = new [1];                              // Create Array
	    args[0] = str.substr(0, space_positions[i] - 1); // Get 1st ARGS	    
	 end
	 else begin

	    // Case last space position => End of STR
	    if(i == args_nb - 1)  begin
	       args                  = new [args.size() + 1] (args); // Add 1 element
	       args[args.size() - 1] = str.substr(space_positions[i-1] + 1, str_len - 1);
	       
	    end
	    // Case between 2 space position, not at the beginning nor the end of str
	    else begin
	       args                  = new [args.size() + 1] (args); // Add 1 element
	       args[args.size() - 1] = str.substr(space_positions[i-1] + 1, space_positions[i] - 1);	       
	    end
	 end
      end // for (i = 0 ; i < space_positions.size() ; i++)

      return args;      
      
   endfunction // str_2_args
   


   // Get the line, remove \n, padd with space at the end
   function string resize_line(input string str, input int max_len);

      int i; // Loop index      
      string str_resize = str.substr(0,str.len() - 2); // Init with the input string and remove \n
      int    str_len = str_resize.len(); // Length of the string

      // If the string is lower than the maximal length
      if(str_len <= max_len) begin

	 // Loop until the max length is reached
	 // Append " " (space)
	 for(i = str_len; i < max_len ; i++) begin
	    str_resize = {str_resize," "};   
	 end
	 //$display("debug resize_line , before : %d - after : %d", str.len(), str_resize.len());
	 
      end
      else begin
	 $display("Info: the length of the string is greater than %d", max_len);	 
      end
	      
      return str_resize;
   
   endfunction // resize_line
   
     
endclass // tb_utils_class

