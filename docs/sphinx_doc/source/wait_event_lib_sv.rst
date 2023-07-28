==================
WAIT EVENT LIBRARY
==================

.. todo::
   *  Ajouter les images archi
      
This is the description of the WAIT EVENT testbench module

Library and files
-----------------

This is the Libray and files


+---------------------------------+--------------------------------------------------------------------------------------+
| Files                           | Description                                                                          |
+=================================+======================================================================================+
| tb_wait_event_class.sv          | A class that contains the tasks for tue utilization of the WAIT modules              |
+---------------------------------+--------------------------------------------------------------------------------------+
| wait_event_intf.sv              | The wait event interface. It is the communication between the class and the module   |
+---------------------------------+--------------------------------------------------------------------------------------+
| wait_event_tb.sv                | The wait event HDL module                                                            |
+---------------------------------+--------------------------------------------------------------------------------------+
| wait_event.sv                   | The HDL wrapper of the interface and the wait_event_tb module                        |
+---------------------------------+--------------------------------------------------------------------------------------+
| wait_duration_intf.sv           | The interface of the wait_duration module                                            |
+---------------------------------+--------------------------------------------------------------------------------------+
| wait_duration.sv                | The GSL wait duration module                                                         |
+---------------------------------+--------------------------------------------------------------------------------------+


Architecture
------------

.. image: toto.png

Testbench Commands
------------------

+--------------+-----------------------------------------------------------------+------------------------------+-------------------------------------------------------------+
| Commands     | Description                                                     | Utilization                  | Informations                                                |
+--------------+-----------------------------------------------------------------+------------------------------+-------------------------------------------------------------+
| WTR          | Wait until the rising edge of the signal defined by the ALIAS   | WTR[ALIAS] ()                | Wait until the rising edge of the signal. NO TIMEOUT        |
|              | A timeout can be set. This signal use the wait_event module and | WTR[ALIAS] (TIMEOUT, UNITY)  | Wait until the rising edge of the signal. A timeout is set  |
|              | it is syncrhonized on its clock                                 |                              | Timeout possible UNITY : ps - ns - us - ms                  |
+--------------+-----------------------------------------------------------------+------------------------------+-------------------------------------------------------------+
| WTF          | Wait until the falling edge of the signal defined by the ALIAS  | WTF[ALIAS] ()                | Wait until the falling edge of the signal. NO TIMEOUT       |
|              | A timeout can be set. This signal use the wait_event module and | WTF[ALIAS] (TIMEOUT, UNITY)  | Wait until the falling edge of the signal. A timeout is set |
|              | it is syncrhonized on its clock                                 |                              | Timeout possible UNITY : ps - ns - us - ms                  |
+--------------+-----------------------------------------------------------------+------------------------------+-------------------------------------------------------------+
| WTRS         | Wait until the rising edge of the signal defined by the ALIAS   | WTRS[ALIAS] ()               | Wait until the rising edge of the signal. NO TIMEOUT        |
|              | A timeout can be set.                                           | WTRS[ALIAS] (TIMEOUT, UNITY) | Wait until the rising edge of the signal. A timeout is set  |
|              | The rising edge is detected asynchronously                      |                              | Timeout possible UNITY : ps - ns - us - ms                  |
+--------------+-----------------------------------------------------------------+------------------------------+-------------------------------------------------------------+
| WTFS         | Wait until the falling edge of the signal defined by the ALIAS  | WTFS[ALIAS] ()               | Wait until the falling edge of the signal. NO TIMEOUT       |
|              | A timeout can be set.                                           | WTFS[ALIAS] (TIMEOUT, UNITY) | Wait until the falling edge of the signal. A timeout is set |
|              | The falling edge is detected asynchronously                     |                              | Timeout possible UNITY : ps - ns - us - ms                  |
+--------------+-----------------------------------------------------------------+------------------------------+-------------------------------------------------------------+
| WAIT         | Wait an amout of time defined by the UNITY                      | WAIT[] (VALUE UNITY)         | Wait for the amout a time defined by VALUE and UNITY        |
+--------------+-----------------------------------------------------------------+------------------------------+-------------------------------------------------------------+

.. note::
   These commands are blocking command. It is executed immediatly when the sequencer read this command and no other commands are executed until the edge detection
   or the timeout detection.

.. code-block::

   Wait until the detection of a rising edge on the signal defined by the alias TOTO (No Timeout) :
   WTR[TOTO] ()

   Wait until the detection of a rising edge on the signal defined by the alias TOTO. A timeout of 10 µs is set. If a timeout occurs, an error is displayed:
   WTR[TOTO] (10, us)

   Wait until the detection of a falling edge on the signal defined by the alias TOTO (No Timeout) :
   WTF[TOTO] ()

   Wait until the detection of a falling edge on the signal defined by the alias TOTO. A timeout of 10 µs is set. If a timeout occurs, an error is displayed:
   WTF[TOTO] (10, us)

   Wait until the detection of a rising edge on the signal defined by the alias TOTO (No Timeout). The detection is done asynchronously :
   WTRS[TOTO] ()

   Wait until the detection of a rising edge on the signal defined by the alias TOTO. A timeout of 10 µs is set. If a timeout occurs, an error is displayed The detection is done asynchronously :
   WTRS[TOTO] (10, us)

   Wait until the detection of a falling edge on the signal defined by the alias TOTO (No Timeout). The detection is done asynchronously :
   WTFS[TOTO] ()

   Wait until the detection of a falling edge on the signal defined by the alias TOTO. A timeout of 10 µs is set. If a timeout occurs, an error is displayed. The detection is done asynchronously :
   WTFS[TOTO] (10, us)

   Wait for 222 ns :
   WAIT[] (222 ns)
