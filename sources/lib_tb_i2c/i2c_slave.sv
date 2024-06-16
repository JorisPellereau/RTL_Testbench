/*
I2C Slave verification block
 
 
*/
module i2c_slave #(
		   parameter G_SLAVE_I2C_FIFO_DEPTH = 256,
		   parameter G_NB_DATA              = 256,
		   parameter G_MAX_POLLING          = 10
		   )
   (
    input 			      rst_n, // Testbench Module Reset - LOW Level activation
    input [$clog2(G_NB_DATA) : 0]     nb_data,
    input 			      polling, // Polling during access
    input [$clog2(G_MAX_POLLING) : 0] max_polling,
    inout 			      sclk,
    inout 			      sda
    );
   
   
   // == INTERNAL Signals ==
   i2c_slave_intf #(
		    .G_SLAVE_I2C_FIFO_DEPTH(G_SLAVE_I2C_FIFO_DEPTH)
		    ) i2c_slave_if(); // I2C Slave Interface
   
   reg 	  start_condition; // Start Condition detection
   reg 	  stop_condition; // Stop Condition detection
   logic [3:0] bit_cnt; // Bit Counter - Counter until 9 and reload to 0
   logic       byte_received; // Byte received info
   logic       sack_ctrl_byte_done; // Slave Ack On control Byte is done
   logic [7:0] sr_rdata; // Data Shift register
   logic [7:0] sr_wdata; // Write Data shift register
   logic       chip_addr_ok; // Chip Addr OK FLAG
   logic       rw; // I2C Master Read or Write Access
   wire        sclk_in;
   logic       sda_out;
   logic       sda_in;   
   logic       sda_en;
   logic       i2c_ongoing;
   logic [$clog2(G_NB_DATA):0] cnt_data;
   logic       mack_ongoing; // Master ACK Ongoing   
   logic       cnt_data_done; // Flag that indicates if the counter of all data is reach

   assign cnt_data_done = (cnt_data == (nb_data + 1)) ? 1 : 0; // If cnt_data equals to nb_data + 1 ( +1 for byte_ctrl)
   
   initial begin
      cnt_data = {G_NB_DATA{1'b1}};   // ~0
   end   

   // Count data o each rising edge of byte_received
   always @(negedge byte_received or posedge stop_condition) begin

      if(stop_condition == 1) begin
	 cnt_data <= 0; // Reset it to 0
      end
      else begin
	 cnt_data <= cnt_data + 1;	 
      end
   end

  // Start Detection
   always @(negedge rst_n or negedge sda_in) begin

      // Reset the start condition on TB reset
      if(rst_n == 0) begin
	 start_condition <= 0;	 
      end

      // Start condition detection
      // falling edge of SDA in and SCLK_in == 1
      else if(sclk_in == 1) begin
	 start_condition <= 1;
      end

      // Reset the start condition
      else begin
	 start_condition <= 0;
      end
   end
 

  
   // Stop Detection
   always @(negedge rst_n or posedge sda_in) begin

      // Reset the stop_condition on the TB reset
      if(rst_n == 0) begin
	 stop_condition <= 0;
      end

      // Stop Condition detection
      else if(sclk_in == 1) begin
	 stop_condition <= 1;	 
      end
      else  begin
	 stop_condition <= 0;	 
      end
    
   end

   always @(negedge rst_n or start_condition or stop_condition) begin
      
      if(rst_n == 0) begin
	 i2c_ongoing <= 0;	 
      end
      else if(start_condition == 1) begin
	 i2c_ongoing <= 1;

      end
      else if(stop_condition == 1) begin
	 i2c_ongoing <= 0;	 
      end
   end
   
 
      
   // 9 bit counters (8bits data + ACK)
   always @(negedge rst_n or posedge sclk_in or negedge i2c_ongoing) begin

      if(rst_n == 0) begin
	 bit_cnt <= 0;	 
      end
      // Reset the counter to 1
      else if(bit_cnt == 9) begin
	 bit_cnt <= 1;	 
      end
      else if (i2c_ongoing == 1) begin
	 bit_cnt <= bit_cnt + 1; // Inc the counter	 
      end

      // Reset the counter on bit cnt /= 9 and i2c_ongoing == 0
      else if(stop_condition == 1) begin
	 bit_cnt <= 0;	 
      end
   end

   assign byte_received         = (bit_cnt == 8)                  ? 1 : 0; // Set to '1' on the 8th bit received. 0 otherwise
 
   // Data shift register
   always @(posedge sclk_in) begin
	 sr_rdata[0] <= sda_in;
	 sr_rdata[7:1] <= sr_rdata[6:0];	 
   end

   // Chip Addr OK flag
   always @(negedge rst_n or posedge byte_received or stop_condition) begin

      if(rst_n == 0) begin
	 chip_addr_ok <= 0;	
      end
      
      // Check the chip_addr only on byte_received
      if(byte_received == 1 & chip_addr_ok == 0) begin
	 if(sr_rdata[7:1] == i2c_slave_if.i2c_slave_addr) begin
	    chip_addr_ok <= 1;	    
	 end
	 else begin
	    chip_addr_ok <= 0;	    
	 end
      end

      // Reset the stop_condition
      else if (stop_condition == 1) begin
	 chip_addr_ok <= 0;
      end
      
   end // always @ (posedge byte_received)

   // Read or write access management
   always @(negedge rst_n or posedge byte_received) begin

      if(rst_n == 0) begin
	 rw <= 0;	 
      end
      // Check the chip_addr only on byte_received and on the byte reception (byte_received == 1)
      // and during the 1st data latch (cnt_data == 0) -> Get the rw value
      if(byte_received == 1 && cnt_data == 0 && sack_ctrl_byte_done == 0) begin
	    rw <= sr_rdata[0]; // '1' : Master Read Access - '0' : Master Write Access
      end
   end
   
   // Read Write on Read access
   initial begin
      sack_ctrl_byte_done = 0;
//      sda_en = 0
   end
   
   // SDA_OUT (Write from slave) and SACK Management
   always @(negedge sclk_in or negedge rst_n) begin

      if(rst_n == 0) begin
	 sda_out <= 0;
	 sda_en <= 0;	 
      end

      else  begin

	 // SACK CTRL BYTE == 0
	 if(sack_ctrl_byte_done == 0) begin

	    // Perform the first SACK after the reception of the ctrl_byte
	    if(chip_addr_ok == 1 && bit_cnt == 8) begin
	       sda_out             <= 0; // ACK is '0'
	       sack_ctrl_byte_done <= 1; // Ack ctrl byte Is done
	       sda_en <= 1;	 
	    end
	 end

	 // SACK CTRL BYTE == 1
	 else begin


	    // Perform next SACK during a write access of the I2C Master
	    if(chip_addr_ok == 1 && bit_cnt == 8 && rw == 0) begin
	       sda_out <= 0; // ACK is '0'
	       sda_en  <= 1;
	    end

	    // Master Write Access -> Read access of the slave
	    else if(chip_addr_ok == 1 && rw == 0) begin
	       sda_out <= 0;
	       sda_en <= 0;
	    end

	    // Release the sda_out when the last data was reach 
	    else if(cnt_data_done == 1 && rw == 1 && bit_cnt == 8) begin
	       sda_out <= 0;
	       sda_en  <= 0;	 	 
	    end
	    
	    // During a MASTER READ access (Slave Write) -> Release the SDA_EN ouput in order to get Master ACK (MACK)
	    else if(chip_addr_ok == 1 && bit_cnt == 8 && rw == 1) begin
	       sda_out <= 0;
	       sda_en  <= 0; // Release the SDA Line
	    end
	    
	    // Master Read Access -> Write access of the slave - Provide on sda line the data from the sr_wdata
	    // Data are provided only when bit_counter in lower than 8
	    // or
	    // during the mack_ongoing -> provide the next 1st bit on the sda_line on the falling edge of sclk
	    else if(((chip_addr_ok == 1 && mack_ongoing == 0) || (mack_ongoing == 1 && bit_cnt == 9 && cnt_data_done == 0)) && rw == 1) begin //&& bit_cnt < 8
	       sda_out <= sr_wdata[7];
	       sda_en  <= 1;	 
	    end

	    // On the stop condition reset sack_ctrl_byte_done
	    else if(stop_condition == 1)  begin
	       sack_ctrl_byte_done <= 0; // REset the ack done
	    end
	    
	    // All other case : drive signal to 0
	    else begin
	       sda_out <= 0;
	       sda_en <= 0;	 
	    end
	    	    
	 end
	 
      end
      
     

      

      
 
     
    

      // During a write access fro the Master -> On the 9th bit release the sda line in order to provide the master to generate the MACK
/* -----\/----- EXCLUDED -----\/-----
      else if(chip_addr_ok == 1 && bit_cnt == 9 && sack_ctrl_byte_done == 1 && rw == 1) begin
	 sda_out <= 0;
	 sda_en  <= 0; // Release the SDA Line
      end
 -----/\----- EXCLUDED -----/\----- */

     

     

      
      
     
      
   end

   initial begin
      i2c_slave_if.ptr_write_rx = 0;
      i2c_slave_if.ptr_read_rx = 0;
   end

   // Write data to RX memory
   always @(posedge byte_received) begin

      // On 8 bit received : when different from start condition : Store the data into the FIFO
      if(chip_addr_ok == 1 && start_condition == 0 && rw == 0) begin
	 i2c_slave_if.mem_rx_data[i2c_slave_if.ptr_write_rx] <= sr_rdata;
	 i2c_slave_if.ptr_write_rx <= i2c_slave_if.ptr_write_rx + 1; // Inc the pointer
      end
      
   end

   initial begin
      i2c_slave_if.ptr_read_tx  = 0;
      i2c_slave_if.ptr_write_tx = 0;
   end
   
   // SR Write Data
   always @(posedge sclk_in or negedge rst_n) begin

      // On the reset -> initialized the sr_wdata
      if(rst_n == 0) begin
	 sr_wdata <= 0; // init to 0
      end

      // Load the first data on a start condition
      else if(start_condition == 1 && bit_cnt == 0) begin
	 sr_wdata <= i2c_slave_if.mem_tx_data[i2c_slave_if.ptr_read_tx];
	 i2c_slave_if.ptr_read_tx <= i2c_slave_if.ptr_read_tx + 1; // Inc the pointer
      end
      
      // Condition perform on rising edge of sclk -> Load on the 8th sclk falling edge (byte_received == 1) and only after the byte ctrl
      else if(byte_received == 1 && rw == 1 && (cnt_data != 0 && cnt_data < nb_data)) begin
	 sr_wdata <= i2c_slave_if.mem_tx_data[i2c_slave_if.ptr_read_tx];
	 i2c_slave_if.ptr_read_tx <= i2c_slave_if.ptr_read_tx + 1; // Inc the pointer	 
      end
      // Otherwise shift the data only during a slave write access and when sda_en is set with bit_cnt < 8
      else if (rw == 1 && sda_en == 1 && bit_cnt != 8) begin// && bit_cnt > 1 && bit_cnt < 9) begin
	 sr_wdata[7:1] <= sr_wdata[6:0];	 
      end
   end // always @ (posedge sclk)


   // Master ACK Ongoing management
   always @(posedge sclk_in or negedge rst_n) begin

      // Main reset
      if(rst_n == 0) begin
	 mack_ongoing <= 0;	 
      end

      // On sclk_in rising edge -> if bit_cnt  == 8 (before the 9th bit) -> Mack_ongoing is set to '1'
      else if(rw == 1 && bit_cnt == 8 && sda_in == 1) begin
	 mack_ongoing <= 1;	 
      end

      // Reset it on the 9th bit
      else if(rw == 1 && bit_cnt == 9) begin
	 mack_ongoing <= 0;	 
      end
      
   end // always @ (posedge sclk_in or negedge rst_n)
   
   // Tristate Management
   assign sda     = (sda_en == 1) ? sda_out : 1'bZ;
   assign sda_in  = sda;
   assign sclk_in = sclk;
   
endmodule // i2c_slave

