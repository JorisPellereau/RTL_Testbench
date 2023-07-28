====================
SET INJECTOR LIBRARY
====================

.. todo::
   *  gestion du 'Z'
   *  gestion des état HDL('-' 'L' ...)
   *  Ajouter les images archi
   
SET_INJECTOR testbench module description

Library and files
-----------------

This is the Libray and files

+---------------------------------+--------------------------------------------------------------------------------------+
| Files                           | Description                                                                          |
+=================================+======================================================================================+
| tb_set_injector_class.sv        | A class that contains the tasks for tue utilization of the set_injector module       |
+---------------------------------+--------------------------------------------------------------------------------------+
| set_injector_intf.sv            | The set injector interface. It is the communication between the class and the module |
+---------------------------------+--------------------------------------------------------------------------------------+
| set_injector_tb.sv              | The HDL module that drive the set outputs                                            |
+---------------------------------+--------------------------------------------------------------------------------------+
| set_injector.sv                 | The wrapper of the interface and the set_injector_tb module                          |
+---------------------------------+--------------------------------------------------------------------------------------+


Architecture
------------

.. image: toto.png

Testbench Commands
------------------

+--------------+-----------------------------------------------+--------------------+------------------------------------------------+
| Commands     | Description                                   | Utilization        | Informations                                   |
+--------------+-----------------------------------------------+--------------------+------------------------------------------------+
| SET          | Set a single bit or a bus to a specific value | SET[ALIAS] (VALUE) | VALUE can be a integer or a hexadecimal string |
|              | Bit or bus is selected via an ALIAS           |                    | which begin with '0x'                          |
+--------------+-----------------------------------------------+--------------------+------------------------------------------------+

.. note::
   'Z' value are possible ?

.. code-block::
   
   Set the value 0xBABA on the alias TOTO of the set_injector module :
   SET[TOTO] (0xBABA)
