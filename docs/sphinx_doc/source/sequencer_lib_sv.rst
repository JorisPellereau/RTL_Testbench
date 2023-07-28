================
SEQENCER LIBRARY
================

This is the description of the SEQUENCER library

Library and files
-----------------

All files of the sequencer library are describe in the following table :

+---------------------------------+--------------------------------------------------------------------------------+
| Files                           | Description                                                                    |
+=================================+================================================================================+
| tb_tasks.sv                     | A class that contains the sequencer and an instance of tb_modules_custom_class |
+---------------------------------+--------------------------------------------------------------------------------+
| tb_modules_custom_class.sv      | A class that contains custom testbench modules class                           |
+---------------------------------+--------------------------------------------------------------------------------+


Architecture
------------

.. image: toto.png

Testbench Commands
------------------

Here the list of the command processed by the sequencer :

+--------------+------------------------------------------------+--------------------------------+----------------------+
| Commands     | Description                                    | Utilization                    | Informations         |
+--------------+------------------------------------------------+--------------------------------+----------------------+
| //--         | Display the commentary in the transcript.      | //-- COMMENTARY_TO_DISPLAYED   | Non-blocking command |
+--------------+------------------------------------------------+--------------------------------+----------------------+
| //           | Ingore the command and do not display the line | // COMMENTARY_TO_NOT_DISPLAYED | Non-blocking command |
+--------------+------------------------------------------------+--------------------------------+----------------------+
| --           | Ingore the command and do not display the line | -- COMMENTARY_TO_NOT_DISPLAYED | Non-blocking command |
+--------------+------------------------------------------------+--------------------------------+----------------------+
| END_TEST     | End the test scenario                          | END_TEST                       | Non-blocking command |
+--------------+------------------------------------------------+--------------------------------+----------------------+

.. note::
   A line with the character '\n' is ignored by the sequencer.

.. code-block::

   This is an example of the command
