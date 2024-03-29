interface i2c_slave_intf #(
			   parameter G_SLAVE_I2C_FIFO_DEPTH = 256
			   );

   reg [7:0] mem_tx_data [0:G_SLAVE_I2C_FIFO_DEPTH-1]; // MEM TX
   reg [7:0] mem_rx_data [0:G_SLAVE_I2C_FIFO_DEPTH-1]; // MEM RX
   logic [$clog2(G_SLAVE_I2C_FIFO_DEPTH)-1:0] ptr_write_tx; // Pointer for Write in fifo TX
   logic [$clog2(G_SLAVE_I2C_FIFO_DEPTH)-1:0] ptr_read_tx;  // Pointer for Read in fifo TX
   logic [$clog2(G_SLAVE_I2C_FIFO_DEPTH)-1:0] ptr_write_rx; // Pointer for Write in fifo RX
   logic [$clog2(G_SLAVE_I2C_FIFO_DEPTH)-1:0] ptr_read_rx;  // Pointer for Read in fifo RX
   
   reg [6:0] i2c_slave_addr; // I2C ADDR
   
   
endinterface // i2c_slave_intf


