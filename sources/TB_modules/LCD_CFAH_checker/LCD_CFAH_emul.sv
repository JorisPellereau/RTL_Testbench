//                              -*- Mode: Verilog -*-
// Filename        : LCD_CFAH_emul.sv
// Description     : LCD FAH Emulator-Checker
// Author          : Linux-JP
// Created On      : Sat Nov 19 22:29:42 2022
// Last Modified By: Linux-JP
// Last Modified On: Sat Nov 19 22:29:42 2022
// Update Count    : 0
// Status          : Unknown, Use with caution!

`timescale 1ps/1ps

module LCD_CFAH_emul #(
		       parameter G_RECEIVED_CMD_BUFFER_SIZE = 256
		       )
   (
    input 	     clk,
    input 	     rst_n,

    // Physical Interface
    input 	     i_rs,
    input 	     i_rw,
    input 	     i_en,
    inout [7:0]      io_data,

    // Check Interface
    input [7:0]      i_busy_flag_duration, // Busy flag duration before set flag to '0'
    input [7:0]      i_wdata, // Wdata for read operation
    input 	     i_wdata_sel, // If 0 return autonomously busy flag after the busy flag duration, if 1 return i_wdata value
    output reg [7:0] o_rdata, // Data received
    output reg 	     o_rdata_val
    );


   // == Internal signals =================
   int 		     i,j;
   
   logic   s_en;
   wire    s_en_f_edge;

   // Store 40 Char
   reg [40*8-1:0] s_received_cmds [0:G_RECEIVED_CMD_BUFFER_SIZE-1];
   int 	   s_received_cmds_ptr = 0;

   logic   s_cmd_read_busy_detected;
   logic   s_set_cgram_addr_detected;
   logic   s_set_ddram_addr_detected;
   logic   s_wr_data_detected;
      
   logic [7:0] s_busy_flag_duration_counter;   
   logic   s_busy_flag;
   logic [5:0] s_cgram_addr;
   logic [7:0] s_cgram_buffer [0:63]; // TBD
   logic [7:0] s_ddram_addr;
   logic [7:0] s_ddram_buffer [0:1][0:15]; // 2 Lines of 16 char of bytes   
   logic       s_sel_ddram_or_cgram;

   logic [7:0] s_cgrom [0:255] = {"" , "" , ""  , "" , ""  , "" , "`" , "" , "" , "" , "" , "" , "" , "" , "" , "" , 
				  "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , 
				  "" , "!" , "\"", "#" , "$" , "%" , "&" , "'" , "(" , ")" , "*" , "+" , "," , "-" , "." , "/" , 
				  "0" , "1" , "2" , "3" , "4" , "5" , "6" , "7" , "8" , "9" , ":" , ";" , "<" , "=" , ">" , "?" , 
				  "" , "A" , "B" , "C" , "D" , "E" , "F" , "G" , "H" , "I" , "J" , "K" , "L" , "M" , "N" , "O" , 
				  "P" , "Q" , "R" , "S" , "T" , "U" , "V" , "W" , "X" , "Y" , "Z" , "[" , "" , "]" , "^" , "_" , 
				  "`" , "a" , "b" , "c" , "d" , "e" , "f" , "g" , "h" , "i" , "j" , "k" , "l" , "m" , "n" , "o" , 
				  "p" , "q" , "r" , "s" , "t" , "u" , "v" , "w" , "x" , "y" , "z" , "{" , "|" , "}" , "" , "" , 
				  "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , 
				  "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , 
				  "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , 
				  "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , 
				  "" , "" , "" , "" , "" , ""  , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , 
				  "" , "" , "-" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , 
				  "" , "" , "." , "" , "" , "" , "" , ""  , "" , "" , "" , "" , "" , "" , "" , "" , 
				  "" , "" , "/" , "" , "" , "" , "" , ""  , "" , "" , "" , "" , "" , "" , "" , ""
				  };

   logic [8-1:0] s_lcd_display [0:1][0:15];
   logic 	    s_update_lcd_display;
   logic [16*8-1:0] s_lcd_display_concat [0:1];
   
   
   // ======================================

   // Pipe signal on clk
   always @(posedge clk) begin
      if(!rst_n) begin
	 s_en <= 0;	 
      end
      else begin
	 s_en <= i_en;	 
      end
   end

   // Falling edge detection
   assign s_en_f_edge = ! s_en && i_en;
      
   // Read data during Write operation
   always @(posedge clk) begin
      if(!rst_n) begin
	 o_rdata <= 0;
	 o_rdata_val <= 0;
	 
      end
      else begin
	 if(s_en_f_edge == 1) begin
	    o_rdata <= io_data;
	    o_rdata_val <= 1;	    
	 end
	 else begin
	    o_rdata_val <= 0;	    
	 end
      end
   end // always @ (posedge clk)

   // Write data during Read operation
   assign io_data = (i_rw) ? (i_wdata_sel ? i_wdata : {s_busy_flag, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0} ) : 8'bz;
   
//i_wdata : 8'bz;

   // == TIMING CHECKER ==
   time time_rs;
   time time_en_r_edge;
   time time_en_r_edge_p; // Last Timing
   time time_en_f_edge;
   
   always @(posedge i_rs or negedge i_rs) begin
      time_rs = $time;      
   end

   // tAS check and tcycE check
   always @(posedge i_en) begin

      if(!rst_n) begin
 	 time_en_r_edge_p <= 0;	 
      end
      else begin
	 time_en_r_edge = $time;
	 if((time_en_r_edge - time_rs) < 40) begin
	    $display("Error: tAS timing < 40 : %t" %(time_en_r_edge - time_rs));	 
	 end

	 // Check when second r edge and next are detected
	 if(time_en_r_edge_p != 0) begin
	    if( (time_en_r_edge_p - time_en_r_edge) < 500)   begin
	       $display("Error: tAS timing < 500 : %t" %(time_en_r_edge_p - time_en_r_edge));	       
	    end
	 end
	 time_en_r_edge_p = time_en_r_edge; // update
	 
      end
   end

   // PWEH Check
   always @(negedge i_en) begin
      time_en_f_edge = $time;
      if((time_en_f_edge - time_en_r_edge) < 230) begin
	 $display("Error: tPWEH timing < 230 : %t" %(time_en_f_edge - time_en_r_edge));	 
      end
   end

   // tAH check
   always @(negedge i_en) begin

      @(posedge i_rs or negedge i_rs);
      if(($time - time_en_f_edge) < 10) begin
	 $display("Error: tAH timing < 10 : %t" %($time - time_en_f_edge));	 
      end      
   end

   // 
   // ====================




   // == Commands detection ==

   // On falling edge of i_en detects the commands and store it in a buffer
   always @(posedge clk) begin

      if(!rst_n) begin
	 s_received_cmds_ptr       <= 0;
	 s_cmd_read_busy_detected  <= 0;
	 s_set_cgram_addr_detected <= 0; // Pulse
	 s_set_ddram_addr_detected <= 0; // Pulse
	 s_wr_data_detected        <= 0; // Pulse
	 
      end
      else begin

	 s_cmd_read_busy_detected  <= 0; // Pulse
	 s_set_cgram_addr_detected <= 0; // Pulse
	 s_set_ddram_addr_detected <= 0; // Pulse
	 s_wr_data_detected        <= 0; // Pulse
	 if(s_en_f_edge) begin
	    $display("Info: LCD_CFAH_Emul - i_en falling edge occurs at %t", $time);
	    

	    
	    
	    if(i_rs == 1) begin
	       if(i_rw == 1) begin
		  s_received_cmds[s_received_cmds_ptr] = "RD_DATA cmd !";
	       end
	       else begin
		  s_received_cmds[s_received_cmds_ptr] = "WR_DATA cmd !";
		  s_wr_data_detected <= 1;
		  
	       end
	    end	 
	    else begin
	    
	    
	       if(i_rw == 1) begin
		  s_received_cmds[s_received_cmds_ptr] = "Read_Busy_flag_and_address cmd !";
		  s_cmd_read_busy_detected <= 1;	       
	       end
	       else begin
		  if(io_data[7] == 1) begin	    
		     s_received_cmds[s_received_cmds_ptr] = "Set_DDRAM_Addr cmd !";
		     s_set_ddram_addr_detected <= 1;
		     
		  end
		  else if(io_data[6] == 1) begin
		     s_received_cmds[s_received_cmds_ptr] = "Set_CGRAM_Addr cmd !";
		     s_set_cgram_addr_detected <= 1;
		     
		  end
		  else if(io_data[5] == 1) begin
		     s_received_cmds[s_received_cmds_ptr] = "FUNCTION_SET cmd !";
		  end
		  else if(io_data[4] == 1) begin
		     s_received_cmds[s_received_cmds_ptr] = "Cursor_or_display_shift cmd !";
		  end
		  else if(io_data[3] == 1) begin
		     s_received_cmds[s_received_cmds_ptr] = "Display_on_off_ctrl cmd !";
		  end
		  else if(io_data[2] == 1) begin
		     s_received_cmds[s_received_cmds_ptr] = "Entry_mode_set cmd !";
		  end
		  else if(io_data[1] == 1) begin
		     s_received_cmds[s_received_cmds_ptr] = "Return_home cmd !";
		  end
		  else if(io_data[0] == 1) begin
		     s_received_cmds[s_received_cmds_ptr] = "Clear_display cmd !";
		  end
		  else begin
		     s_received_cmds[s_received_cmds_ptr] = "Command not recognized !";	       
		  end
	       end
	    end // else: !if(i_rs == 1)

	    if(s_received_cmds_ptr < G_RECEIVED_CMD_BUFFER_SIZE - 1) begin
	       s_received_cmds_ptr <=  s_received_cmds_ptr + 1;
	    end
	    else begin
	       $display("Warning: PTR Max reach at %t - reset PTR", $time);
	       s_received_cmds_ptr       <= 0;
	    end

	    
	 end // if (s_en_f_edge)	 
         
      end // else: !if(!rst_n)      
   end
   // ========================


   // Busy Response management
   always @(posedge clk) begin
      if(!rst_n) begin
	 s_busy_flag_duration_counter <= 0;
	 s_busy_flag <= 1; // Busy by default
	 
      end
      else begin

	 if(s_cmd_read_busy_detected) begin
	    if(s_busy_flag_duration_counter < i_busy_flag_duration) begin
	       s_busy_flag_duration_counter <= s_busy_flag_duration_counter + 1;
	       s_busy_flag <= 1;	       
	    end
	    else begin
	       s_busy_flag <= 0;
	       s_busy_flag_duration_counter <= 0;
	    end
	 end	 	 
      end
   end
   // ========================

   // CGRAM Addr Management
   always @(posedge clk) begin
      if(!rst_n) begin
	 s_cgram_addr <= 0;

	 for(i = 0 ; i < 64 ; i++) begin
	    s_cgram_buffer[i] <= 0;	    
	 end
      end
      else begin

	 // If set cgram detected -> update CGRAM ADDR
	 if(s_set_cgram_addr_detected) begin
	    s_cgram_addr <= o_rdata & 6'h3F;	    
	 end

	 // When command is detected and sel is activated (CGRAM selected)
	 if(s_sel_ddram_or_cgram && s_wr_data_detected) begin

	    s_cgram_buffer[s_cgram_addr] <= io_data & 5'h1F;	    	    
	    // Inc CGRAM Addr
	    s_cgram_addr <= s_cgram_addr + 1;
	    
	 end
	 
      end
	
   end


   // DDRAM Addr Management and data management
   always @(posedge clk) begin
      if(!rst_n) begin
	 s_ddram_addr <= 0;
	 for(i = 0; i < 2; i++) begin
	    for(j = 0; j < 16 ; j++) begin
	       s_ddram_buffer[i][j] <= 0;	       
	    end
	 end
	 s_update_lcd_display <= 0;
	 
      end
      else begin
	 
	 s_update_lcd_display <= 0; // Pulse
	 // If detected -> Update DDRAM ADDR
	 if(s_set_ddram_addr_detected) begin
	    s_ddram_addr <= o_rdata & 7'h7F; // Bit 7 not unsed in DDRAM Addr
	 end

	 // When command is detected and sel is not activated
	 if(!s_sel_ddram_or_cgram && s_wr_data_detected) begin

	    if(s_ddram_addr < 16) begin
	       s_ddram_buffer[0][s_ddram_addr] <= o_rdata; // Update line 0
	       $display("Info: DDRAM Buffer update at %t - DDRAM addr : 0x%X", $time, s_ddram_addr);	 
	       s_update_lcd_display <= 1;
	    end
	    else if(s_ddram_addr >= 64 && s_ddram_addr < (64+16)) begin
	       s_ddram_buffer[1][s_ddram_addr-8'h40] <= o_rdata; // Update line 1
	       $display("Info: DDRAM Buffer update at %t - DDRAM addr : 0x%X", $time, s_ddram_addr);
	       s_update_lcd_display <= 1;
	    end
	    else begin
	       $display("Error: DDRAM ADDR not in correct address : 0x%X - %t", s_ddram_addr, $time);
	    end
	    
	    s_ddram_addr <= s_ddram_addr + 1; // Inc Counter
	    $display("Info: LCD DDRAM Addr updated at %t" %($time));	    
	 end
      end
	
   end // always @ (posedge clk)


   // SEL DDRAM or CGRAM
   always @(posedge clk) begin
      if(!rst_n) begin
	 s_sel_ddram_or_cgram <= 0; // DDRAM By default	 
      end
      else begin

	 if(s_set_ddram_addr_detected) begin
	    s_sel_ddram_or_cgram <= 0;
	 end
	 else if(s_set_cgram_addr_detected) begin
	    s_sel_ddram_or_cgram <= 1;
	 end
      end
   end // always @ (posedge clk)


   // Update and display LCD
   always @(posedge clk) begin
      if(!rst_n) begin
	 for(i = 0; i < 2; i++) begin
	    for(j = 0; j < 16 ; j++) begin
	       s_lcd_display[i][j] <= 0;	       
	    end
	 end

      end
      else begin

	 // Update and display LCD on this pulse
	 if(s_update_lcd_display) begin

	    for(j = 0 ; j < 2 ; j++) begin
	       for(i = 0; i < 16 ; i++) begin
		  s_lcd_display[j][i] = s_cgrom[s_ddram_buffer[j][i]];		  
	       end
	    end	    
	 end	 
      end
   end // always @ (posedge clk)

   assign s_lcd_display_concat[0] = {s_lcd_display[0][0],  s_lcd_display[0][1],  s_lcd_display[0][2],  s_lcd_display[0][3],
				     s_lcd_display[0][4],  s_lcd_display[0][5],  s_lcd_display[0][6],  s_lcd_display[0][4],
				     s_lcd_display[0][8],  s_lcd_display[0][9],  s_lcd_display[0][10], s_lcd_display[0][11],
				     s_lcd_display[0][12], s_lcd_display[0][13], s_lcd_display[0][14], s_lcd_display[0][15]
				     };

   assign s_lcd_display_concat[1] = {s_lcd_display[1][0],  s_lcd_display[1][1],  s_lcd_display[1][2],  s_lcd_display[1][3],
				     s_lcd_display[1][4],  s_lcd_display[1][5],  s_lcd_display[1][6],  s_lcd_display[1][4],
				     s_lcd_display[1][8],  s_lcd_display[1][9],  s_lcd_display[1][10], s_lcd_display[1][11],
				     s_lcd_display[1][12], s_lcd_display[1][13], s_lcd_display[1][14], s_lcd_display[1][15]
				     };
   
   
endmodule // LCD_CFAH_emul
