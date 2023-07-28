//                              -*- Mode: Verilog -*-
// Filename        : i2c_slave_checker.sv
// Description     : Simple I2C Slave checker
// Author          : JorisP
// Created On      : Sun Jul 11 14:42:04 2021
// Last Modified By: JorisP
// Last Modified On: Sun Jul 11 14:42:04 2021
// Update Count    : 0
// Status          : Unknown, Use with caution!

module i2c_slave_checker (
			  input        clk,
			  input        rst_n,
			  
			  input [7:0]  i_nb_data,
			  input [6:0]  i_chip_addr,
			  input [7:0]  i_wdata,
			  output       o_wdata_valid, 

			  output [7:0] o_rdata,
			  output       o_rdata_valid,

			  // STATUS
			  output       o_chip_addr_ok,

			  // I2C I/F
			  inout        scl,
			  inout        sda
			  
			  );


   // == TYPDEF ==
   typedef enum 		       {IDLE, CTRL_BYTE_CHK, WR_DATA, RD_DATA, SACK, MACK} t_states;
   
		
   // == INTERNAL SIGNALS ==
   t_states s_current_state;
   t_states s_next_state;
   
		
   logic 			       s_scl; // Latch SCL
   logic 			       s_scl_r_edge;
   logic 			       s_scl_f_edge;   

   logic 			       s_sda;
   logic 			       s_sda_f_edge;
   

   logic 			       s_chip_addr_ok;
   logic 			       s_chip_addr_chk;
   
   logic 			       s_read_or_write;

   logic 			       s_start_detected;
   logic 			       s_stop_detected;

   logic 			       s_stop_en;
   

   logic [6:0] 			       s_chip_addr;
   reg [3:0] 			       s_cnt_9;
   logic 			       s_cnt_9_done;

   reg [3:0] 			       s_cnt_rdata;
   
   
   logic 			       s_en_sda;
   logic 			       s_sda_out;

   logic 			       s_sack_done;

   reg [7:0] 			       s_rdata;
   logic 			       s_rdata_valid;
   logic 			       s_rdata_valid_p;
   logic 			       s_rdata_valid_r_edge;
   

   logic 			       s_state_ctrl_byte_chk_done;
   reg [7:0] 			       s_cnt_nb_data;
   reg [7:0] 			       s_nb_data;
   
   
   
   
   
   
   

   // == LATCH INPUTS ==
   always @(posedge clk) begin
      if(!rst_n) begin
	 s_scl <= 0;
	 s_sda <= 0;
	 s_rdata_valid_p <= 0;
	 
      end
      else begin
	 s_scl <= scl;
	 s_sda <= sda;
	 s_rdata_valid_p <= s_rdata_valid;
	 
      end      
   end // always @ (posedge clk)

   // Rising - Falling Edge detection
   assign s_scl_r_edge = scl && ! s_scl;
   assign s_scl_f_edge = ! scl && s_scl;   
   assign s_sda_f_edge = ! sda && s_sda;
   assign s_rdata_valid_r_edge = s_rdata_valid && ! s_rdata_valid_p;   


   
   // == START DETECTION ==
   always @(posedge clk) begin
      if(!rst_n) begin
	 s_start_detected <= 0;

      end
      else begin
	 if(s_sda_f_edge == 1) begin
	    if(scl == 1) begin
	       s_start_detected <= 1;	       
	    end	    
	 end
	 else begin
	    s_start_detected <= 0;	    
	 end
      end      
   end

   // == STOP DETECTION ==
   always @(posedge clk) begin
      if(!rst_n) begin
	 s_stop_detected <= 0;	 
      end
      else begin	 
	 if(s_current_state == SACK) begin
	    if(s_scl_r_edge == 1) begin
	       if(sda == 0) begin
		  s_stop_detected <= 1;		  
	       end 
	    end
	 end
	 else begin
	    s_stop_detected <= 0;	    
	 end
      end
   end

   // == CONTROL BYTE DECODE ==
   always @(posedge clk) begin
      if(!rst_n) begin
	 s_chip_addr_ok  <= 0;
	 s_read_or_write <= 0;
	 s_chip_addr     <= 0;	
	 s_chip_addr_ok  <= 0;
	 s_chip_addr_chk <= 0;
	 
      end
      else begin
	 
	 if(s_current_state == CTRL_BYTE_CHK) begin
	    if(s_scl_r_edge == 1) begin

	       if(s_cnt_9 < 7) begin
		  s_chip_addr[0]   <= sda;
		  s_chip_addr[6:1] <= s_chip_addr[5:0];
		  
	       end
	       else if(s_cnt_9 < 8) begin
		  
		  s_read_or_write <= sda;
		  		  		  
	       end
	       else if(s_cnt_9 == 8) begin
		  

		  //s_chip_addr_chk <= 1;
	       end

	    end // if (s_scl_r_edge == 1)
	  
	    if(s_chip_addr == i_chip_addr) begin
	       s_chip_addr_ok <= 1;	     
	    end
	    
	    if(s_scl_f_edge == 1 && s_cnt_9 == 8) begin
	       s_chip_addr_chk <= 1;
	    end
  
	 end // if (s_current_state == CTRL_BYTE_CHK)
	 else if(s_current_state == IDLE) begin
	    s_chip_addr_ok <= 0;
	    s_chip_addr_chk <= 0;
	 end // else: !if(s_current_state == CTRL_BYTE_CHK)

      
      end      
   end // always @ (posedge clk)

   
   // == CNT 9 MNGT ==
   always @(posedge clk) begin
      if(!rst_n) begin
	 s_cnt_9      <= 0;
	 s_cnt_9_done <= 0;	 
      end
      else begin

	 // Count Only In a state diffrent of IDLE
	 if(s_current_state != IDLE) begin
	    if(s_scl_r_edge == 1) begin

	       if(s_cnt_9 < 9) begin
		  s_cnt_9 <= s_cnt_9 + 1; // Inc Counter
	       end
	       else begin
		  s_cnt_9      <= 1;
		  s_cnt_9_done <= 1;	       
	       end
	    end
	    else begin
	       s_cnt_9_done <= 0;	    
	    end // else: !if(s_scl_r_edge == 1)
	    
	 end
	 else begin
	    s_cnt_9      <= 0;
	    s_cnt_9_done <= 0;
	 end // else: !if(s_scl_r_edge == 1)
	    
	 
      end
   end


   // == SLAVE ACK MNGT ==
   // SDA
   always @(posedge clk) begin
      if(!rst_n) begin
	 s_sda_out <= 0;
	 s_en_sda  <= 0;
	 s_sack_done <= 0;
	 
      end
      else begin

	 if(s_current_state == SACK) begin


	    // SACK After CTRL BYTE DECODE
	    if(s_state_ctrl_byte_chk_done == 1) begin
	       // Correct ADDR CHIP
	       if(s_chip_addr_ok == 1) begin
		  s_en_sda    <= 1;
		  if(s_scl_f_edge == 1) begin
		     
		     s_sack_done <= 1;		  
		  end
	       end

	       // Wrong ADDR CHIP
	       else begin
		  s_en_sda  <= 0;
	          if(s_scl_f_edge == 1) begin
		     s_sack_done <= 1;       	  
		  end
	       end // else: !if(s_chip_addr_ok == 1)
	    end // if (s_state_ctrl_byte_chk_done == 1)

	    
	    else begin
	       //if(s_rdata_valid == 1) begin
		 
		  if(s_scl_f_edge == 1 && s_cnt_9 == 8) begin
		     s_en_sda <= 1;

		  end
		  else if(s_scl_f_edge == 1 && s_cnt_9 == 9) begin
		     s_sack_done <= 1;     
  		     s_en_sda <= 0;
		     
		  end
	       //end
	    end
	    
	 end // if (s_current_state == SACK)

	 else begin
	    s_sack_done <= 0;
	    s_en_sda    <= 0;
	    
	 end
	 
      end
   end
      

   // == Outputs affectation
   assign sda            = (s_en_sda == 1) ? s_sda_out : 1'bz;
   assign o_rdata        = s_rdata;
   assign o_rdata_valid  = s_rdata_valid;
   assign o_chip_addr_ok = s_chip_addr_ok;
   

   // == RD_DATA MNGT ==
   always @(posedge clk) begin
      if(!rst_n) begin
	 s_rdata       <= 0;
	 s_rdata_valid <= 0;
	 s_cnt_rdata <= 0;
	 
      end
      else begin
	 
	 if(s_current_state == RD_DATA) begin
	    if(s_scl_r_edge == 1) begin

	       // Store Data on 8 1st clock period
	       if(s_cnt_rdata < 8 ) begin
		  s_rdata[0]   <= s_sda;
		  s_rdata[7:1] <= s_rdata[6:0]; // Shift - MSB First
		  s_cnt_rdata <= s_cnt_rdata + 1;
 		  
	       end
	       else begin
	//	  s_rdata_valid <= 1;
		  
	       end
	    end // if (s_scl_r_edge == 1)
	    if(s_cnt_rdata == 8) begin
	       s_rdata_valid <= 1;
	    end
	    
	 end // if (s_current_state == RD_DATA)
	 else if(s_current_state == SACK) begin
	    s_rdata_valid <= 0; // Reset RDATA Valid
	    s_cnt_rdata <= 0; 	    
	 end	 

      end
   end


   // == STOP EN MNGT ==
   always @(posedge clk) begin
      if(!rst_n) begin
	 s_stop_en <= 0;
	 s_cnt_nb_data <= 0;
	 s_nb_data <= 0;
	 
      end
      else begin

	 // Save nb_data
	 if(s_current_state == IDLE) begin
	    if(s_start_detected == 1) begin
	       s_nb_data <= i_nb_data; // Number of data to read or write	       	     
	    end
	 end

	 // RAZ
	 if(s_sack_done == 1) begin
	    if(s_stop_detected == 1 && s_stop_en == 1) begin
	       s_stop_en <= 0;
	       s_cnt_nb_data <= 0;
	    end
	 end

	 if(s_rdata_valid_r_edge == 1) begin
	    if(s_cnt_nb_data < s_nb_data - 1) begin
	       s_cnt_nb_data <= s_cnt_nb_data + 1;
	       s_stop_en <= 0;
	       
	    end
	    else begin
	       s_stop_en <= 1;
	       
	    end
	 end
	 
      end // else: !if(!rst_n)      
   end


   // Current State Mngt
   always @(posedge clk) begin
      if(!rst_n) begin
	 s_current_state <= IDLE;	 
      end
      else begin
	 s_current_state <= s_next_state;	 
      end
   end


   // Next State Mngt
   always @(posedge clk) begin
      if(!rst_n) begin
	 s_next_state <= IDLE;
	 s_state_ctrl_byte_chk_done <= 0;
      end
      else begin
	 
	 case (s_current_state)

	   IDLE: begin
	      s_state_ctrl_byte_chk_done <= 0;
	      if(s_start_detected == 1) begin
		 s_next_state <= CTRL_BYTE_CHK;		 
	      end
	   end

	   CTRL_BYTE_CHK : begin
	      s_state_ctrl_byte_chk_done <= 1;
	      if(s_chip_addr_chk == 1) begin
		 s_next_state <= SACK;		 
	      end
	      
	   end
	   
	   
	   

	   SACK : begin
	      if(s_sack_done == 1) begin

		 

		 // 1st SACK after CTRL BYTE DECODE
		 if(s_chip_addr_ok == 1 && s_state_ctrl_byte_chk_done == 1) begin
		    s_state_ctrl_byte_chk_done <= 0;
		    // Read Access
		    if(s_read_or_write == 1) begin
		       s_next_state <= WR_DATA; // Read Access request => Write Data on SDA		       
		    end
		    
		    // Write Access
		    else begin
		       s_next_state <= RD_DATA; // Write Access request => Read Data on SDA		       
		    end
		 end // if (s_chip_addr_ok == 1)

		  // Case Go to Stop
		 else if(s_stop_detected == 1 && s_stop_en == 1) begin
		    s_next_state <= IDLE;		    
		 end

		 else if(s_cnt_nb_data < s_nb_data - 1) begin
		    if(s_read_or_write == 1) begin
		       s_next_state <= WR_DATA; // Read Access request => Write Data on SDA		       
		    end
		    
		    // Write Access
		    else begin
		       s_next_state <= RD_DATA; // Write Access request => Read Data on SDA		       
		    end
		 end
		 
		 // Case transfer not ended	        
		 else /*if(s_stop_detected == 0 && s_stop_en == 0)*/ begin
		    // Read Access
		    // if(s_read_or_write == 1) begin
		    //    s_next_state <= WR_DATA; // Read Access request => Write Data on SDA		       
		    // end
		    
		    // // Write Access
		    // else begin
		    //    s_next_state <= RD_DATA; // Write Access request => Read Data on SDA		       
		    // end
		 end
		    
		 
	      end // if (s_sack_done == 1)		 		 		 
	      
	   end // case: SACK
	   
	   RD_DATA : begin
	      if(s_rdata_valid_r_edge == 1) begin
		 s_next_state <= SACK;		 
	      end
	   end

	   WR_DATA : begin
	   end

	   
	   default:  begin
	      s_next_state <= IDLE;
	   end
	   
	 endcase
	   
      end // else: !if(!rst_n)
      
   end // always @ (posedge clk)
   

  
endmodule // i2c_slave_checker
