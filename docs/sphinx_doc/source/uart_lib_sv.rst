============
UART LIBRARY
============

.. todo::
   *  Ajouter les images archi
   *  Envoie de donnée integer ou hexadecimal string representation 0x
   *  Checker l'envoie et la reception multiple des données
   *  Timeout du wait ? en dur ?

      
Library and files
-----------------

This is the Libray and files of the UART testbench module :

+---------------------------------+--------------------------------------------------------------------------------------+
| Files                           | Description                                                                          |
+=================================+======================================================================================+
| tb_uart_class.sv                | A class that contains the tasks for tue utilization of the UART module               |
+---------------------------------+--------------------------------------------------------------------------------------+
| uart_checker_wrapper.sv         | The UART check wrapper                                                               |
+---------------------------------+--------------------------------------------------------------------------------------+


Architecture
------------

.. image: toto.png

PARAMETERS
^^^^^^^^^^

The UART testbench module is hard configured.

Testbench Commands
------------------

+--------------+----------------------------------------------------+---------------------------------------------+----------------------------------------------------------------------------------+
| Commands     | Description                                        | Utilization                                 | Informations                                                                     |
+--------------+----------------------------------------------------+---------------------------------------------+----------------------------------------------------------------------------------+
| TX_START     | Send one or multiple data on the TX interface      | UART[ALIAS] TX_START(DATA)                  | Send a data on the TX interface.                                                 |
|              | of the UART module defined by its ALIAS            | UART[ALIAS] TX_START(DATA0 DATA1 DATAn)     | Send multiple data on the TX interface in this order : data0, data1 datan        |
+--------------+----------------------------------------------------+---------------------------------------------+----------------------------------------------------------------------------------+
| RX_READ      | Check the last received data on the RX interface   | UART[ALIAS] RX_START(DATA)                  | Check the last data received on the RX interface. Non-blocking command           |
|              | of the UART module defined by its ALIAS            | UART[ALIAS] RX_START(DATA0 DATA1 DATAn)     | Check last data received of the RX interface.                                    |
+--------------+----------------------------------------------------+---------------------------------------------+----------------------------------------------------------------------------------+
| RX_WAIT_DATA | Wait for the reception of data on the RX interface | UART[ALIAS] RX_WAIT_DATA(DATA)              | Wait until the reception of a data. Compare it with DATA Blocking command        |
|              | of the UART module defined by its ALIAS            | UART[ALIAS] RX_WAIT_DATA(DATA0 DATA1 DATAn) | Wait until the reception of data0, data1, datan. Compare it with data0, data1 .. |
|              | of the UART module defined by its ALIAS            | UART[ALIAS] RX_WAIT_DATA(DATA0 DATA1 DATAn) | Blocking command                                                                 |
+--------------+----------------------------------------------------+---------------------------------------------+----------------------------------------------------------------------------------+

.. note::
   A timeout is defined for the RX_WAIT_DATA command.

   
.. code-block::

   Send 2 data on the TX interface of the UART RPi :
   UART[RPi] TX_START(0x12 0x13)

   Check the last received data on the RX interface of the UART TOTO. If the expected data is incorrect, it displays an ERROR:
   UART[TOTO] RX_READ(0xBB)

   Wait until the reception of a data on the RX interface of the UART TITI and compare it with its expected value. An ERROR is displayed if the data is uncorrect. A timeout occurs if the data
   is not correctly received
   UART[TITI] RX_WAIT_DATA(0x00 0x11 0x22)
   
