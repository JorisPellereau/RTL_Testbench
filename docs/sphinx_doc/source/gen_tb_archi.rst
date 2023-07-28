==============================
Generic Testbench Architecture
==============================

Context
-------

L'idée de ce testbench est de profiter des fonctions objets du SystemVerilog ainsi que de la puissance du Python pour avoir un testbench qui est capable de :

*  Rapidement déployable
*  Réutilisable
*  Générique


Architecture
------------

.. image:: ../../images/archi_tb.svg
   :height: 500px
   :width:  1000 px
   :scale:  100 %
   :alt:    Generic Testbench Architecture
   :align:  center

Description
-----------

This testench is composed of 2 sides :

*  The RTL testbench composed of SystemVerilog files. This is the HDL side executed in the simulator (Modelsim for example)
   The SystemVerilog files read a text file that contains commands. These commands allows to drive the different testbench modules.
*  The Python-Side. This is python script used in order to generated text files which contains textbenhc commands.

   
Commands
---------

Here is an example of a command read by the SystemVerilog sequencer :

.. code-block::

   SET[GPI] (0x55)
   WAIT[] (10 us)
   UART[RPi] TX_START(0x12 0x13 0x14)


Here is an example of python command from a scn.py :

.. code-block::
   
   scn = scn_class.scn_class()

   scn_macros = macros_uart_display_ctrl_class.macros_uart_display_ctrl_class(scn)
   scn.DATA_COLLECTOR_INIT("UART_DISPLAY_CTRL_INPUT_COLLECTOR_0", 0, collect_path)
   scn.DATA_COLLECTOR_START("UART_DISPLAY_CTRL_INPUT_COLLECTOR_0", 0)

   scn.print_step("Wait for Reset")

   scn.WTR("RST_N")
   scn.WAIT(100, "ns")

   scn.print_step("Wait for the end of SPI Configuration")
   scn_macros.check_init_config()


   scn.print_step("Injection of Correct command and then non correct command")

   scn.print_step("Send : INIT_RAM_STATIC")
   scn_macros.send_uart_cmd_and_check_resp(uart_data = "INIT_RAM_STATIC",
                                           main_cmd  = False,
                                           not_rdy   = False)

   scn.DATA_COLLECTOR_STOP("UART_DISPLAY_CTRL_INPUT_COLLECTOR_0", 0)
   scn.DATA_COLLECTOR_CLOSE("UART_DISPLAY_CTRL_INPUT_COLLECTOR_0", 0)
   scn.END_TEST()
