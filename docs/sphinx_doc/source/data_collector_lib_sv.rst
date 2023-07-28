======================
DATA COLLECTOR LIBRARY
======================

.. todo::
   *  Ajouter les images archi
   *  Code example to do
   *  Check Configuration command
      

Library and files
-----------------

This is the files of the data collector testbench module :

+---------------------------------+--------------------------------------------------------------------------------------+
| Files                           | Description                                                                          |
+=================================+======================================================================================+
| tb_data_collector_class.sv      | A class that contains the tasks for tue utilization of the data_collector module     |
+---------------------------------+--------------------------------------------------------------------------------------+
| data_collector.sv               | The data collector testbench module                                                  |
+---------------------------------+--------------------------------------------------------------------------------------+


Architecture
------------

.. image: toto.png

Testbench Commands
------------------


+--------------+-----------------------------------------------------+----------------------------------------+-----------------------------------------------------------------+
| Commands     | Description                                         | Utilization                            | Informations                                                    |
+--------------+-----------------------------------------------------+----------------------------------------+-----------------------------------------------------------------+
| INIT         | Initialize a collzector file for the data collector | DATA_COLLECTOR[ALIAS] INIT(N FILE)     | Initalize the data collector file of the data_collector index   |
|              | module defined by ALIAS                             |                                        | number N of data check module defined by ALIAS                  |
+--------------+-----------------------------------------------------+----------------------------------------+-----------------------------------------------------------------+
| START        | Start the data collector                            | DATA_COLLECTOR[ALIAS] START(N)         | Start the data collector of the data collectorer index N        |
+--------------+-----------------------------------------------------+----------------------------------------+-----------------------------------------------------------------+
| STOP         | Stop the data collector                             | DATA_COLLECTOR[ALIAS] STOP(N)          | Stop the data collector of the data collectorer index N         |
+--------------+-----------------------------------------------------+----------------------------------------+-----------------------------------------------------------------+
| CLOSE        | Close the data collector file                       | DATA_COLLECTOR[ALIAS] CLOSE(N)         | Close the file of the data collector of the data collector      |
|              |                                                     |                                        | index N of data check module defined by ALIAS                   |
+--------------+-----------------------------------------------------+----------------------------------------+-----------------------------------------------------------------+
| CONFIG       | Configuration of the data format of file            | DATA_COLLECTOR[ALIAS] CONFIG(N FORMAT) | Set the configuration of the data collector format. BIN or HEXA |
+--------------+-----------------------------------------------------+----------------------------------------+-----------------------------------------------------------------+


.. code-block::

   This is an example of the command
