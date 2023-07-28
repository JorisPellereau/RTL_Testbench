interface check_level_intf #(
     parameter CHECK_SIZE = 5,
     parameter CHECK_WIDTH = 32
     );

   string 	       check_alias [CHECK_SIZE];   
   logic [CHECK_WIDTH - 1 : 0] check_signals [CHECK_SIZE];  
endinterface // check_level_intf

   
