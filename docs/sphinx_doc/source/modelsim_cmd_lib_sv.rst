========================
MODELSIM COMMAND LIBRARY
========================

.. todo::
   *  Ajouter les images archi
   *  Limitation des commands comprenant '"'
   *  Modelsim command examples


Library and files
-----------------

This is the Libray and files of the MODELSIM COMMAND testbench module :

+---------------------------------+--------------------------------------------------------------------------------------+
| Files                           | Description                                                                          |
+=================================+======================================================================================+
| tb_modelsim_cmd_class.sv        | A class that contains the tasks for the utilization of the modelsim commands         |
+---------------------------------+--------------------------------------------------------------------------------------+


Architecture
------------

.. image: toto.png

Testbench Commands
------------------

+--------------+-------------------------------------------------+--------------------------+--------------------------------------+
| Commands     | Description                                     | Utilization              | Informations                         |
+--------------+-------------------------------------------------+--------------------------+--------------------------------------+
| MODELSIM_CMD | Execute a MODELSIM command defined in arguments | MODELSIM_CMD[] (STR_CMD) | Execute the modelsim command STR_CMD |
+--------------+-------------------------------------------------+--------------------------+--------------------------------------+

.. code-block::

   
   MODELSIM_CMD[] ()
