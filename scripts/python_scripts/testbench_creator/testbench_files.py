# STR Constants

testbench_setup_generic_str = """
`timescale 1ps/1ps

// Clock and Reset Configuration - Unit in [ps]
`define C_TB_CLK_HALF_PERIOD {0}
`define C_WAIT_RST           {1}
`define C_TB_CLK_PERIOD      {2}

// SET ALIAS Configuration
`define C_SET_ALIAS_NB {3}
`define C_SET_SIZE     {4}
`define C_SET_WIDTH    {5}

// WAIT EVENT Configuration
`define C_WAIT_ALIAS_NB {6}
`define C_WAIT_WIDTH    {7}

// CHECK LEVEL Configuration
`define C_CHECK_ALIAS_NB {8}
`define C_CHECK_SIZE     {9}
`define C_CHECK_WIDTH    {10}

"""

uart_cst_str = """
// UART TESTBENCH Configuration - {0}
`define C_NB_UART_CHECKER_{1}         {2}
`define C_UART_DATA_WIDTH_{3}         {4}
`define C_UART_BUFFER_ADDR_WIDTH_{5}  {6}
`define C_STOP_BIT_NUMBER_{7}         {8}
`define C_POLARITY_{9}                {10}
`define C_PARITY_{11}                 {12}
`define C_BAUDRATE_{13}               {14}
`define C_FIRST_BIT_{15}              {16}
`define C_CLOCK_FREQ_{17}             {18}

"""

data_collector_str = """
// DATA COLLECTOR Configuration - {0}
`define C_NB_DATA_COLLECTOR_{1}         {2}
`define C_DATA_COLLECTOR_DATA_WIDTH_{3} {4}

"""

data_checker_str = """
// DATA CHECKER Configuration - {0}

"""

clk_gen_str = """
`timescale 1ps/1ps

    module clk_gen
       #(
         parameter int G_CLK_HALF_PERIOD = {0},
         parameter int G_WAIT_RST        = {1}
       )
       (
        output reg clk_tb,
        output reg rst_n
       );

       // Clock generation
       initial begin
         clk_tb <= 1'b0;
         forever begin
           #G_CLK_HALF_PERIOD;	
           clk_tb <= ~ clk_tb;
         end      
       end

       // Reset generation
       initial begin
         rst_n <= 1'b0;
         #G_WAIT_RST;
         rst_n <= 1'b0;
         #G_WAIT_RST;
         rst_n <= 1'b1;
       end     
   
endmodule // clk_gen"""




include_testbench_setup_str = "`include \"{0}/testbench_setup.sv\"\n"
include_sequencer_str       = "`include \"/home/linux-jp/Documents/GitHub/Verilog/Testbench/sources/lib_tb_sequencer/tb_tasks.sv\"\n"


tb_top_str = """

`timescale 1ps/1ps

// INCLUDES
{0}

// TB TOP
module tb_top
  #(
    parameter SCN_FILE_PATH = "scenario.txt"
   )
   ();

   // == INTERNAL SIGNALS ==   
   wire clk;
   wire rst_n;

   wire set_injector_0;  // To complete
   wire check_level_0;



  // == CLK GEN INST ==
   clk_gen #(
	.G_CLK_HALF_PERIOD  (`C_TB_CLK_HALF_PERIOD),
	.G_WAIT_RST         (`C_WAIT_RST)
   )
   i_clk_gen (
	      .clk_tb (clk),
              .rst_n  (rst_n)	      
   );
   // ==================


   // == TESTBENCH GENERIC INTERFACE SIGNALS DECLARATIONS ==
   wait_event_intf #( .WAIT_SIZE   (`C_WAIT_ALIAS_NB),
                      .WAIT_WIDTH  (`C_WAIT_WIDTH)
		      ) 
   s_wait_event_if();
   
   set_injector_intf #( .SET_SIZE   (`C_SET_ALIAS_NB),
			.SET_WIDTH  (`C_SET_WIDTH)
			)
   s_set_injector_if();
   
   wait_duration_intf s_wait_duration_if();
   
   assign s_wait_duration_if.clk = clk;
   

   check_level_intf #( .CHECK_SIZE   (`C_CHECK_ALIAS_NB),
		       .CHECK_WIDTH  (`C_CHECK_WIDTH)
		       )
   s_check_level_if();
   // ======================================================

   // == HDL GENERIC TESTBENCH MODULES ==

   // WAIT EVENT TB WRAPPER INST
   wait_event_wrapper #(.CLK_PERIOD (`C_TB_CLK_PERIOD)
			)
   i_wait_event_wrapper (
			 .clk            (clk),
			 .rst_n          (rst_n),
			 .wait_event_if  (s_wait_event_if)			 
			 );
   
   
   // SET INJECTOR TB WRAPPER INST
   set_injector_wrapper #()
   i_set_injector_wrapper (
			   .clk              (clk),
			   .rst_n            (rst_n),
			   .set_injector_if  (s_set_injector_if)			   
			   );
   // =====================================================

   // == TESTBENCH SIGNALS AFFECTATION ==

   // SET WAIT EVENT SIGNALS
   assign s_wait_event_if.wait_signals[0] = rst_n;
   assign s_wait_event_if.wait_signals[1] = clk;
   
   // SET SET_INJECTOR SIGNALS
   assign set_injector_0            = s_set_injector_if.set_signals_synch[0];
  
   // SET SET_INJECTOR INITIAL VALUES
   assign s_set_injector_if.set_signals_asynch_init_value[0]  = 0;
  
   // SET CHECK_SIGNALS
   assign s_check_level_if.check_signals[0] = check_level_0;
 
   // =====================================================

   {1}

   // CREATE Handle and object CLASS - Configure Parameters
   {2}

   initial begin
      // Add Alias of Generic TB Modules
      tb_class_inst.ADD_ALIAS("SET_INJECTOR", "SET_INJECTOR_ALIAS_0",    0);
        
      // ADD ALias of WAIT Module        
      tb_class_inst.ADD_ALIAS("WAIT_EVENT", "RST_N",                 0);
      tb_class_inst.ADD_ALIAS("WAIT_EVENT", "CLK",                   1);      
     
      // Check Level Alias
      tb_class_inst.ADD_ALIAS("CHECK_LEVEL", "CHECK_LEVEL_ALIAS_0",            0);
     
      /*	
      ADD Custom TB odule Instanciation HERE
      tb_class_inst.tb_modules_custom_inst.init_uart_custom_class(uart_checker_if,   "UART_RPi");
      tb_class_inst.tb_modules_custom_inst.init_uart_custom_class(uart_checker_if_2, "UART_RPi_TEST");

     
      tb_class_inst.tb_modules_custom_inst.init_data_collector_custom_class(s_data_collector_if, "UART_DISPLAY_CTRL_INPUT_COLLECTOR_0");
      */
            
      // RUN Testbench Sequencer
      tb_class_inst.tb_sequencer(SCN_FILE_PATH);
   end


   // == DUT ==

endmodule // tb_top
"""


sequencer_class_str = """
   static tb_class #( .G_SET_SIZE        (`C_SET_SIZE),
                      .G_SET_WIDTH       (`C_SET_WIDTH),
                      .G_WAIT_SIZE       (`C_WAIT_ALIAS_NB),
                      .G_WAIT_WIDTH      (`C_WAIT_WIDTH), 
                      .G_CLK_PERIOD      (`C_TB_CLK_PERIOD),
                      .G_CHECK_SIZE      (`C_CHECK_SIZE),
                      .G_CHECK_WIDTH     (`C_CHECK_WIDTH)/*,
		      
                      // ADD HERE CUSTUM TB MODULES PARAMETERS
		      .G_NB_UART_CHECKER        (`C_NB_UART_CHECKER),
		      .G_UART_DATA_WIDTH        (`C_UART_DATA_WIDTH),
		      .G_UART_BUFFER_ADDR_WIDTH (`C_UART_DATA_WIDTH),

		      .G_NB_COLLECTOR          (`C_NB_DATA_COLLECTOR), 	     
		      .G_DATA_COLLECTOR_WIDTH  (`C_DATA_COLLECTOR_DATA_WIDTH)*/
		      )
   
   tb_class_inst = new (s_wait_event_if, 
			s_set_injector_if, 
			s_wait_duration_if,
			s_check_level_if);
"""


data_collector_intf_str = """

   // DATA COLLECTOR INTERFACE
   data_collector_intf #(
			 .G_NB_COLLECTOR (`C_NB_DATA_COLLECTOR_{0}),
			 .G_DATA_WIDTH   (`C_DATA_COLLECTOR_DATA_WIDTH_{1})
			 )
   s_data_collector_if_{2}();

"""

data_collector_wrapper_str = """

   // DATA COLLECTOR WIRES
   wire clk_data_collector_{0}   [`C_NB_DATA_COLLECTOR_{1} - 1:0];
   wire rst_n_data_collector_{2} [`C_NB_DATA_COLLECTOR_{3} - 1:0];

   // DATA COLLECTOR MODULE
   data_collector #(
		    .G_NB_COLLECTOR (`C_NB_DATA_COLLECTOR_{4}),
		    .G_DATA_WIDTH   (`C_DATA_COLLECTOR_DATA_WIDTH_{5})
		    )
   i_data_collector_{6} (
		         .clk                  (clk_data_collector),
		         .rst_n                (rst_n_data_collector),
		         .i_data               (s_data_collector),
		         .data_collector_if    (s_data_collector_if_{7})
		         ); 
      
   assign clk_data_collector_{8}[0]   = clk;
   assign rst_n_data_collector_{9}[0] = rst_n;
   /*assign s_data_collector_{10}[0]  = s_tx_uart[0]; ASSIGN HERE BUS TO COLLECT ! TBD !!*/

"""

uart_checker_intf_str = """

   // UART CHECKER INTERFACE
   uart_checker_intf #(
		       .G_NB_UART_CHECKER    (`C_NB_UART_CHECKER_{0}),
		       .G_DATA_WIDTH         (`C_UART_DATA_WIDTH_{1}),
		       .G_BUFFER_ADDR_WIDTH  (`C_UART_BUFFER_ADDR_WIDTH_{2})
		       ) 
   uart_checker_if_{3}();

"""


uart_checker_wrapper_str = """

   // UART CHECKER WIRES
   wire [`C_NB_UART_CHECKER_{0} - 1 : 0] s_rx_uart;
   wire [`C_NB_UART_CHECKER_{1} - 1 : 0] s_tx_uart;

   // UART CHECKER WRAPPER
   uart_checker_wrapper #(

			      .G_NB_UART_CHECKER    (`C_NB_UART_CHECKER_{2}),
			      .G_STOP_BIT_NUMBER    (`C_STOP_BIT_NUMBER_{3}),
			      .G_POLARITY           (`C_POLARITY_{4}),
			      .G_PARITY             (`C_PARITY_{5}),
			      .G_BAUDRATE           (`C_BAUDRATE_{6}),
			      .G_DATA_WIDTH         (`C_UART_DATA_WIDTH_{7}),
			      .G_FIRST_BIT          (`C_FIRST_BIT_{8}),
			      .G_CLOCK_FREQ         (`C_CLOCK_FREQ_{9}),
			      .G_BUFFER_ADDR_WIDTH  (`C_UART_BUFFER_ADDR_WIDTH_{10})
   )
   i_uart_checker_wrapper_{11} (
			   .clk    (clk),
			   .rst_n  (rst_n),			  

			   .i_rx  (s_rx_uart_{12}),
			   .o_tx  (s_tx_uart_{13}),

			   .uart_checker_if (uart_checker_if_{14})
    );

"""
