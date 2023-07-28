//                              -*- Mode: Verilog -*-
// Filename        : check_level_wrapper.sv
// Description     : CHECK LEVEL TESTBENCH MODULE WRAPPER
// Author          : JorisP
// Created On      : Sun Nov 22 10:58:35 2020
// Last Modified By: JorisP
// Last Modified On: Sun Nov 22 10:58:35 2020
// Update Count    : 0
// Status          : Unknown, Use with caution!

interface check_level_intf #(
     parameter CHECK_SIZE = 5,
     parameter CHECK_WIDTH = 32
     );

   string 	       check_alias [CHECK_SIZE];   
   logic [CHECK_WIDTH - 1 : 0] check_signals [CHECK_SIZE];  
endinterface // check_level_intf

   
