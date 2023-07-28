==============
UTILES LIBRARY
==============

This is the description of the utils library.

Library and files
-----------------

This is the Libray and files


+------------------------+-----------------------------------------------------------+
| File                   | Description                                               |
+========================+===========================================================+
| tb_utils_class.sv      | A class that contains functions for the generic testbench |
+------------------------+-----------------------------------------------------------+


Architecture
------------

.. image: toto.png

Utiles Methods
--------------

.. code-block:: Verilog

    tb_utils_class


Method List:

*  function int str_2_int (input string str, output int result);
*  function space_position_t str_2_space_positions(input string str);
*  function args_t str_2_args(input string str);
   
