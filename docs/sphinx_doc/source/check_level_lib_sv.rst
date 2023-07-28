===================
CHECK LEVEL LIBRARY
===================

.. todo::
   *  Ajouter les images archi
   *  Faire un check d'un entier
      
Library and files
-----------------

This is the Libray and files

+---------------------------------+--------------------------------------------------------------------------------------+
| Files                           | Description                                                                          |
+=================================+======================================================================================+
| tb_check_level_class.sv         | A class that contains the tasks for tue utilization of the Check level modules       |
+---------------------------------+--------------------------------------------------------------------------------------+
| check_level_intf.sv             | The check level interface. It is the communication between the class and the module  |
+---------------------------------+--------------------------------------------------------------------------------------+
| check_level.sv                  | The check level HDL module                                                           |
+---------------------------------+--------------------------------------------------------------------------------------+

Architecture
------------

.. image: toto.png

Testbench Commands
------------------

+--------------+------------------------------------------------+-----------------------------+----------------------------------------------------+
| Commands     | Description                                    | Utilization                 | Informations                                       |
+--------------+------------------------------------------------+-----------------------------+----------------------------------------------------+
| CHK          | Check the value of the signal defined by ALIAS | CHK[ALIAS] (VALUE EXPECTED) | Check the Value of the bit or bus defined by ALIAS |
|              |                                                |                             | VALUE is a hexadecimal number begining with '0x'   |
|              |                                                |                             | EXPECTED is the expected result : OK or ERROR      |
+--------------+------------------------------------------------+-----------------------------+----------------------------------------------------+

.. note::
   The CHK is a non-blocking command. It is executed immediatly when the sequencer read this command.


.. code-block::

   Check the value of a signal defined by the ALIAS TOTO. Expected the value 0xABCD. It prints if the check is succes or not. If note it display an ERROR:
   CHECK[TOTO] (0xABCD OK)
   
   Check the value of a signal defined by the ALIAS TOTO. Expected a value different from 0xABCD. It prints if the check is succes or not. If note it display an ERROR:
   CHECK[TOTO] (0xABCD ERROR)
