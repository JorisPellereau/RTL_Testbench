import pkg_tb::*;

class tb_i2c_slave_class #(
			   parameter G_SLAVE_I2C_FIFO_DEPTH = 32
			   );


   /* ===============
    * == VARIABLES ==
    * ===============
    */

   string SLAVE_I2C_COMMAND_TYPE = "I2C_SLAVE"; // Commande Type   
   string SLAVE_I2C_ALIAS;                      // Alias of Current I2C Slave Testbench Module

   // == UTILS ==
   tb_utils_class utils = new(); // Utils Class   
   // ===========
   
   
   // == VIRTUAL I/F ==
   // I2C Slave interface
   virtual i2c_slave_intf #(G_SLAVE_I2C_FIFO_DEPTH) i2c_slave_vif;
   // =================


   // == CONSTRUCTOR ==
   function new(virtual i2c_slave_intf #(G_SLAVE_I2C_FIFO_DEPTH) i2c_slave_nif,
		string SLAVE_I2C_ALIAS);
      this.i2c_slave_vif   = i2c_slave_nif;
      this.SLAVE_I2C_ALIAS = SLAVE_I2C_ALIAS;      
   endfunction // new   
   // =================


   // == LIST of I2C Slave COMMANDS ==
   
   // I2C_SLAVE[alias] SET_ADDR(ADDR)
   // I2C_SLAVE[alias] LOAD_TX_DATA(DATA0 DATA1 DATA2 DATAN-1)
   // I2C_SLAVE[alias] CHECK_RX_DATA(EXP_D0 EXP_D1 EXP_2 EXP_Dn-1)
   
   // ================================


   // List of Command of I2C Slave module
   int 		       SLAVE_I2C_CMD_ARRAY [string] = '{
							"SET_ADDR"       : 0,
							"LOAD_TX_DATA"   : 1,
							"CHECK_RX_DATA"  : 2
							};


   // Task : Selection of I2C Slave Commands
   task sel_i2c_slave_command(input string i_i2c_slave_cmd,
			      input string i_i2c_slave_alias, 
			      input string i_i2c_slave_cmd_args);
      begin
	 
	 case(i_i2c_slave_cmd)
	   
	   "SET_ADDR" :  begin
	      SLAVE_I2C_SET_ADDR  (i_i2c_slave_alias,
				   i_i2c_slave_cmd_args
				   );
	      
	   end
	   
	   "LOAD_TX_DATA" : begin
	      SLAVE_I2C_LOAD_TX_DATA (i_i2c_slave_alias,
				      i_i2c_slave_cmd_args
				      );	      
	   end

	   "CHECK_RX_DATA" : begin	
	      SLAVE_I2C_CHECK_RX_DATA (i_i2c_slave_alias,
				       i_i2c_slave_cmd_args
				       );	      
	   end

	   default: $display("Error: wrong SLAVE I2C Command : %s - len(%s) : %d", i_i2c_slave_cmd, i_i2c_slave_cmd, i_i2c_slave_cmd.len());
	 endcase	 
	 
      end
   endtask;



   /* Task : Set the address of the I2C SLAVE
    * * NON BLOCKING COMMAND
    * - 
    */  
   task SLAVE_I2C_SET_ADDR(
			   input string i_i2c_slave_alias,
			   input string i_i2c_slave_cmd_args		       
			   );
      begin

	 // Internal Variables
	 int addr;
	 args_t args;

	 // Get the number of args in i_i2c_slave_cmd_args
	 args = this.utils.str_2_args(i_i2c_slave_cmd_args);

	 // Converts string args into int
	 addr   = this.utils.str_2_int(args[0]); // Convert the string into a int

	 this.i2c_slave_vif.i2c_slave_addr = addr; // Set the addr	 	   	 
	 $display("DEBUG - SLAVE_I2C_SET_ADDR  DONE - %t - addr : %x - %p", $time, addr, args);
      end
      
   endtask

   /* Task : Load data into the I2C SLave TX Memory
    * * Non BLOCKING COMMAND
    * - 
    */  
   task SLAVE_I2C_LOAD_TX_DATA(
			       input string i_i2c_slave_alias,
			       input string i_i2c_slave_cmd_args		       
			       );
      begin

	 // Internal Variables
	 int data_to_load;
	 int i; // Loop index
	 
	 args_t args;
	 
	 // Get an array of string for each arg.
	 args = this.utils.str_2_args(i_i2c_slave_cmd_args);
	 
	 for(i = 0 ; i < args.size() ; i++) begin
	    data_to_load = this.utils.str_2_int(args[i]);                                   // Convert the string into a int
	    this.i2c_slave_vif.mem_tx_data[this.i2c_slave_vif.ptr_write_tx] = data_to_load; // Load the data
	    this.i2c_slave_vif.ptr_write_tx = this.i2c_slave_vif.ptr_write_tx + 1;         // Inc the pointer	    
	 end

	 $display("DEBUG - SLAVE_I2C_LOAD_TX_DATA  DONE - %t", $time);
	
      end
	 
   endtask // SLAVE_I2C_LOAD_TX_DATA

   
   /* Task : Check the data into the I2C Slave RX Memory
    * * Non BLOCKING COMMAND
    * - 
    */  
   task SLAVE_I2C_CHECK_RX_DATA(
				input string i_i2c_slave_alias,
				input string i_i2c_slave_cmd_args		       
				);
      begin

	 // Internal Variables
	 int data_to_check;
	 int rx_data;
	 int i; // Loop index
	 
	 args_t args;
	 
	 // Get an array of string for each arg.
	 args = this.utils.str_2_args(i_i2c_slave_cmd_args);
	 
	 for(i = 0 ; i < args.size() ; i++) begin
	    data_to_check = this.utils.str_2_int(args[i]);                            // Convert the string into a int
	    rx_data = this.i2c_slave_vif.mem_rx_data[this.i2c_slave_vif.ptr_read_rx]; // Get RX Data
	    
	    // Check if the data is equal to the data in the RX Memory
	    if(data_to_check == rx_data) begin
	       $display("SLAVE_I2C_CHECK_RX_DATA[%s] - Data expected n°%d : %x == %x => OK", i_i2c_slave_alias, i, data_to_check, rx_data);
	    end

	    // Otherwise display an error
	    else begin
       	       $display("SLAVE_I2C_CHECK_RX_DATA[%s] - Data expected n°%d : %x != %x => ERROR", i_i2c_slave_alias, i, data_to_check, rx_data);
	    end
	    this.i2c_slave_vif.ptr_read_rx <= this.i2c_slave_vif.ptr_read_rx + 1; // Inc. the ptr	    
	    	    
	 end

	 $display("DEBUG - SLAVE_I2C_CHECK_RX_DATA  DONE - %t", $time);
	
      end
	 
   endtask

endclass // tb_i2c_slave_class

