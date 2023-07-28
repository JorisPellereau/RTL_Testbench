===========================================
SystemVerilog Generic Testbench Description
===========================================

.. note::
   Document en cours d'écriture

.. todo::
   *  Chercher outils permettant d'extraire les hierarchy de block VHDL/Verilog



Generic Testbench Modules
-------------------------
This generic testbench uses SystemVerilog modules. Some modules are always instanciated and others are instanciated only if needed (UART for example)

Here is the minimal generic modules that is always instanciated if the testbench :

*  SET_INJECTOR module
*  CHECK_LEVEL module
*  WAIT_EVENT module
*  WAIT_DURATION module


Libraries
---------
.. toctree::
   :titlesonly:
	     
   utiles_lib_sv
   sequencer_lib_sv
   set_injector_lib_sv
   wait_event_lib_sv
   check_level_lib_sv
   uart_lib_sv
   modelsim_cmd_lib_sv
   data_checker_lib_sv
   data_collector_lib_sv
