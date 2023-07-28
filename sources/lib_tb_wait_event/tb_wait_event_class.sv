//                              -*- Mode: Verilog -*-
// Filename        : tb_wait_event_class.sv
// Description     : WAIT Event Testbench Class
// Author          : Linux-JP
// Created On      : Sat Nov 20 13:26:29 2021
// Last Modified By: Linux-JP
// Last Modified On: Sat Nov 20 13:26:29 2021
// Update Count    : 0
// Status          : Unknown, Use with caution!

class tb_wait_event_class #(
			    parameter G_WAIT_SIZE  = 5,
			    parameter G_WAIT_WIDTH = 1,
			    parameter G_CLK_PERIOD = 1000 // Unity : ps
			    );


   /* ===========
    * == TYPES ==
    * ===========
    */
   typedef int alias_list_t [string]; // Associative array of Possible Alias
   
   // == Virtual I/F ==
   virtual wait_event_intf #(G_WAIT_SIZE, G_WAIT_WIDTH) wait_event_vif;
   virtual wait_duration_intf  wait_duration_vif;
   // =================

   // == VARIABLES ==
   alias_list_t wait_event_alias_list; // List of Alias  
   // ===============

   // == CONSTRUCTOR ==
   function new(virtual wait_event_intf #(G_WAIT_SIZE, G_WAIT_WIDTH) wait_event_nif,
		virtual wait_duration_intf  wait_duration_nif);
      this.wait_event_vif    = wait_event_nif;    // Init Interface
      this.wait_duration_vif = wait_duration_nif; // Init Wait duration Interface
      
   endfunction // new   
   // =================

   // Commands
   // WTR[ALIAS]
   // WTF[ALIAS]
   // WTRS[ALIAS]
   // WTFS[ALIAS]
   // WTR[ALIAS] (10 us)
   // WTF[ALIAS] (1 ps)
   // WTRS[ALIAS] (3215 ns)
   // WTFS[ALIAS] (59 ms)
   // WAIT (10 us)  // No Alias for WAIT Command


   // Sel Check Level Command
   task sel_wait_event_command(input string i_cmd,
			       input string i_alias,
			       input string i_args);
      begin

	 case(i_cmd)
	   "WTR": begin
	      wait_event(i_alias, i_args, 1'b0);	      
	   end

	   "WTF": begin
	      wait_event(i_alias, i_args, 1'b1);
	   end

	   "WTRS": begin
	      wait_event_soft(i_alias, i_args, 1'b0);
	   end

	   "WTFS" : begin
	      wait_event_soft(i_alias, i_args, 1'b1);
	   end
	   "WAIT": begin
	      wait_duration(i_args);	      
	   end
	   
	   default: $display("Error: wrong WAIT EVENT Command : %s", i_cmd);	   
	 endcase // case (i_cmd)
	 
      end
   endtask; // sel_check_level_command



   /* TASK WAIT EVENT
    *   Set configuration for WAIT EVENT TB module
    *   Wait for WAIT EVENT TB module response
    */
   task wait_event (
		   input string i_alias,
		   input string i_args,
		   input logic 	i_sel_wtr_wtf
		   );
      begin
	 	 	
	 this.wait_event_vif.sel_wtr_wtf = i_sel_wtr_wtf; // Select Rising/Falling Edge detection

	 if(i_args.len() != 0) begin
	    this.wait_event_vif.max_timeout = DECODE_TIMEOUT(i_args);	    
	 end
	 else begin
	    this.wait_event_vif.max_timeout = 0;
	 end
	            
         this.wait_event_vif.wait_en       = this.wait_event_alias_list[i_alias];
	 this.wait_event_vif.en_wait_event = 1'b1;
	 
         @(posedge this.wait_event_vif.wait_done); // Wait until Wait done
         this.wait_event_vif.en_wait_event = 1'b0;
      end

      $display("");
      
   endtask // wait_event


   // Wait Event - Detect Rising of Falling Edge of selected Alias
   task wait_event_soft (
			 input string i_alias,
			 input string i_args,
			 input logic  i_sel_wtr_wtf			 
			 );
      begin

	 // Command Decod
	 if(i_sel_wtr_wtf == 0) begin  
	    $display("Waiting for a rising edge ...");
	    @(posedge this.wait_event_vif.wait_signals[this.wait_event_alias_list[i_alias]]);
	    $display("WTR detected at %t", $time);
		  
	 end
	 else if(i_sel_wtr_wtf == 1) begin
	    $display("Waiting for a falling edge ...");
	    @(negedge this.wait_event_vif.wait_signals[this.wait_event_alias_list[i_alias]]);
	    $display("WTF detected at %t", $time);
         end	       
         else begin
           $display("Error: Not A Wait soft Command");		  
	 end
	
      end
   endtask // wait_event_soft


   // Wait Duration
   // Wait for a defined duration - No Alias Needed

   task wait_duration (input string i_args
		       );
      
      begin

	 
	 // == INTERNAL VARIABLES ==
	 int           s_max_timeout_cnt;
	 int 	       s_cnt      = 0;	 
	 logic 	       s_cnt_done = 0;
	 
	 //$display("DEBUG - wait_duration");
	 s_max_timeout_cnt = DECODE_TIMEOUT(i_args);

	 // WAIT until end of counter
	 while(s_cnt_done == 1'b0) begin
	    @(posedge this.wait_duration_vif.clk); // WAIT FOR RISING EDRE of CLK
	    if(s_cnt < s_max_timeout_cnt) begin
	       s_cnt = s_cnt + 1;
	    end
	    else begin
	       s_cnt_done = 1'b1;
	       $display("WAIT done at %t", $time);	       
	    end	    
	 end
	 	 	 
      end

      $display("");
   endtask // wait_duration




   // Add Alias function to class and to Interface
   function void ADD_WAIT_EVENT_ALIAS(string alias_str, int alias_index);
      this.wait_event_alias_list[alias_str] = alias_index;  
   endfunction // ADD_WAIT_EVENT_ALIAS


   // Decod Timeout Function
   function logic [31:0] DECODE_TIMEOUT(input string i_args);

      string value_str;
      string unity;
      
      int s_timeout_value = 0;
      int i;                     // Loop index
      int space_position    = 0; // Space between Args
      int s_max_timeout_cnt = 0; // Max Timeout Value Counter
      

      // Get Space position
      for(i = 0 ; i < i_args.len(); i++) begin
	 if(i_args[i] == " ") begin
	    space_position = i;	    
	 end
      end

      value_str = i_args.substr(0, space_position - 1);                // Get Value in String
      unity     = i_args.substr(space_position + 1, i_args.len() - 1); // Get Unity
           
      s_timeout_value = value_str.atoi(); // STR to INT
      	  
      case (unity) 
        "ps": begin
           s_max_timeout_cnt = s_timeout_value / G_CLK_PERIOD;
           $display("Timeout : %d %s",s_timeout_value, unity);
	end
	   
        "ns": begin
	   s_max_timeout_cnt = (1000 * s_timeout_value) / (G_CLK_PERIOD);
	   $display("Timeout : %d %s",s_timeout_value, unity);
        end
	   
        "us": begin
           s_max_timeout_cnt = (1000000 * s_timeout_value) / (G_CLK_PERIOD);
           $display("Timeout : %d %s",s_timeout_value, unity);
        end
	   
        "ms": begin
           s_max_timeout_cnt = (1000000000 * s_timeout_value) / (G_CLK_PERIOD);
           $display("Timeout : %d %s",s_timeout_value, unity);
        end
		    
        default: begin
           $display("Error: wrong unit format");		       
        end
		    
      endcase
   
 
      return s_max_timeout_cnt;
   endfunction // DECODE_TIMEOUT
   

			    
endclass // tb_wait_event_class
