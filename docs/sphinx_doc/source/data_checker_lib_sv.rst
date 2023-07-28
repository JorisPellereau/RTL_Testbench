====================
DATA CHECKER LIBRARY
====================

.. todo::
   *  Ajouter les images archi
   *  Code example to do
      
Library and files
-----------------

This is the files of the DATA CHECKER testbench module :

+---------------------------------+--------------------------------------------------------------------------------------------+
| Files                           | Description                                                                                |
+=================================+============================================================================================+
| tb_data_checker_class.sv        | A class that contains the tasks for tue utilization of the set_injectordata_checker module |
+---------------------------------+--------------------------------------------------------------------------------------------+
| data_checker.sv                 | The data checker testbench module                                                          |
+---------------------------------+--------------------------------------------------------------------------------------------+


Architecture
------------

.. image: toto.png

Testbench Commands
------------------

+--------------+-----------------------------------------------------+--------------------------------------+----------------------------------------------------------------+
| Commands     | Description                                         | Utilization                          | Informations                                                   |
+--------------+-----------------------------------------------------+--------------------------------------+----------------------------------------------------------------+
| INIT         | Initialize a check file for the data checker module | DATA_CHECKER[ALIAS] INIT(N FILE)     | Initalize the data check file of the data_check index number N |
|              | defined by ALIAS                                    |                                      | of data check module defined by ALIAS                          |
+--------------+-----------------------------------------------------+--------------------------------------+----------------------------------------------------------------+
| START        | Start the data check                                | DATA_CHECKER[ALIAS] START(N)         | Start the data check of the data checker index N               |
+--------------+-----------------------------------------------------+--------------------------------------+----------------------------------------------------------------+
| STOP         | Stop the data check                                 | DATA_CHECKER[ALIAS] STOP(N)          | Stop the data check of the data checker index N                |
+--------------+-----------------------------------------------------+--------------------------------------+----------------------------------------------------------------+
| CLOSE        | Close the data check file                           | DATA_CHECKER[ALIAS] CLOSE(N)         | Close the file of the data check of the data checker index N   |
+--------------+-----------------------------------------------------+--------------------------------------+----------------------------------------------------------------+
| CONFIG       | Configuration of the data format of file            | DATA_CHECKER[ALIAS] CONFIG(N FORMAT) | Set the configuration of the data check format. BIN or HEXA    |
+--------------+-----------------------------------------------------+--------------------------------------+----------------------------------------------------------------+

.. code-block::

   This is an example of the command
