//                              -*- Mode: Verilog -*-
// Filename        : max7219_checker_pkg.sv
// Description     : MAX7219 Checker Package
// Author          : JorisP
// Created On      : Sun Dec 20 22:50:13 2020
// Last Modified By: JorisP
// Last Modified On: Sun Dec 20 22:50:13 2020
// Update Count    : 0
// Status          : Unknown, Use with caution!

   // == MAX7219 TYPES ==
   typedef struct packed
   {
      logic [7:0] REG_NO_OP;
      logic [7:0] REG_DIGIT_0;
      logic [7:0] REG_DIGIT_1;
      logic [7:0] REG_DIGIT_2;
      logic [7:0] REG_DIGIT_3;
      logic [7:0] REG_DIGIT_4;
      logic [7:0] REG_DIGIT_5;
      logic [7:0] REG_DIGIT_6;
      logic [7:0] REG_DIGIT_7;
      logic [7:0] REG_DECODE_MODE;
      logic [7:0] REG_INTENSITY;
      logic [7:0] REG_SCAN_LIMIT;
      logic [7:0] REG_SHUTDOWN;
      logic [7:0] REG_DISPLAY_TEST;
      
   } max7219_register_struct_t;
