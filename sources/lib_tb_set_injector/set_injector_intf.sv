interface set_injector_intf #(
     parameter SET_SIZE  = 5,
     parameter SET_WIDTH = 32
   );

   string  set_alias [SET_SIZE];
   logic   [SET_WIDTH - 1 : 0] set_signals_asynch_init_value  [SET_SIZE];   
   logic   [SET_WIDTH - 1 : 0] set_signals_asynch             [SET_SIZE];
   logic   [SET_WIDTH - 1 : 0] set_signals_synch              [SET_SIZE];
   
endinterface // set_injector_intf
