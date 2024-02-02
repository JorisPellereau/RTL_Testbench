/*
I2C Slave Instanciation 
 
 
*/
module i2c_slave #(
		   parameter G_SLAVE_I2C_FIFO_WIDTH = 256
		   )
   (
    inout sclk,
    inout sda
    );
   
   
   // == INTERNAL Signals ==
   i2c_slave_intf #(
		    .G_SLAVE_I2C_FIFO_WIDTH(G_SLAVE_I2C_FIFO_WIDTH)
		    ) i2c_slave_if(); // I2C Slave Interface
   
   reg   start_condition; // Start Condition detection
   reg   reset_start_condition; // Reset start condition
   
   
   reg   stop_condition; // Stop Condition detection

   logic [3:0] bit_cnt; // Bit Counter - Counter until 9 and reload to 0
   logic       byte_received; // Byte received info

   logic       sack_ctrl_byte_done; // Slave Ack On control Byte is done
   
   
   logic [7:0] sr_rdata; // Data Shift register
   logic       sr_rdata_en; // Enable to shift data

   logic [7:0] sr_wdata; // Write Data shift register

   logic       chip_addr_ok; // Chip Addr OK FLAG
   logic       rw; // I2C Master Read or Write Access

   logic       sda_int;
   logic       sda_en;
   
   

  // Start Detection
   always @(negedge sda_int or posedge reset_start_condition) begin
      if(sclk == 1) begin
	 start_condition <= 1;
      end 
      else if (reset_start_condition == 1) begin
	 start_condition <= 0;
      end
   end

   // Stop Detection
   always @(posedge sda_int) begin
      if(sclk == 1) begin
	 stop_condition <= 1;	 
      end
      else begin
	 stop_condition <= 0;	 
      end
   end

   initial begin
      bit_cnt <= 0;
   end
      
   // 9 bit counters (8bits data + ACK)
   always @(posedge sclk) begin

      // Reset the counter to 1
      if(bit_cnt == 9) begin
	 bit_cnt <= 1;	 
      end
      else begin
	 bit_cnt <= bit_cnt + 1; // Inc the counter	 
      end
   end

   assign sr_rdata_en = bit_cnt < 9 ? 1 : 0; // Enable to SR data only 
   assign byte_received = (bit_cnt == 8) ? 1 : 0; // Set to '1' on the 8th bit received. 0 otherwise
   assign reset_start_condition = byte_received & start_condition ? 1 : 0; // If start condition is stet and 8bit are receieved -> Reset the start condition
   

   // Data shift register
   always @(posedge sclk) begin
      if(sr_rdata_en == 1) begin
	 sr_rdata[0] <= sda_int;
	 sr_rdata[7:1] <= sr_rdata[6:0];	 
      end
   end

   // Chip Addr OK flag
   always @(posedge byte_received) begin

      // Check the chip_addr only on byte_received
      if(byte_received == 1 & start_condition == 1) begin
	 if(sr_rdata[7:1] == i2c_slave_if.i2c_slave_addr) begin
	    chip_addr_ok <= 1;	    
	 end
	 else begin
	    chip_addr_ok <= 0;	    
	 end
      end 
   end // always @ (posedge byte_received)

   // Read or write access management
   always @(posedge byte_received) begin
      // Check the chip_addr only on byte_received and during the start phase
      if(byte_received == 1 & start_condition == 1) begin
	    rw <= sr_rdata[0]; // '1' : Master Read Access - '0' : Master Write Access
      end 
   end
   
   // Read Write on Read access


   initial begin
      sack_ctrl_byte_done <= 0;
   end
   
   // SDA_INT (Write from slave) and SACK Management
   always @(negedge sclk) begin

      // Perform the first SACK after the reception of the ctrl_byte
      if(chip_addr_ok == 1 && sack_ctrl_byte_done == 0) begin
	 sda_int             <= 1;
	 sack_ctrl_byte_done <= 1; // Ack Is done
      end

      // Master Read Access
      else if(chip_addr_ok == 1 && rw == 1) begin
	 sda_int <= sr_wdata[7];	 
      end
      else if(chip_addr_ok == 1 && rw == 0) begin
	 sda_int <= 0;
      end
      else begin
	 sda_int <= 0;
      end
      
   end

   initial begin
      i2c_slave_if.ptr_write_rx <= 0;
      i2c_slave_if.ptr_read_rx <= 0;
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
      i2c_slave_if.ptr_read_tx  <= 0;
      i2c_slave_if.ptr_write_tx <= 0;
   end
   
   // SR Write Data
   always @(posedge sclk) begin

      // Condition perform on rising edge of sclk
      if(byte_received == 1 && rw == 1) begin
	 sr_wdata <= i2c_slave_if.mem_tx_data[i2c_slave_if.ptr_read_tx];
	 i2c_slave_if.ptr_read_tx <= i2c_slave_if.ptr_read_tx + 1; // Inc the pointer	 
      end
      // Otherwise shift the data
      else if (rw == 1) begin
	 sr_wdata[7:1] <= sr_wdata[6:0];	 
      end
   end // always @ (posedge sclk)
   
   // Tristate Management
   assign sda = (sda_en == 1) ? sda_int : 1'bZ;
   
endmodule // i2c_slave

