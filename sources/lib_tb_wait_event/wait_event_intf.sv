interface wait_event_intf #(
     parameter WAIT_SIZE  = 5,
     parameter WAIT_WIDTH = 1
   );

   logic en_wait_event;   
   int 	 wait_en;  
   logic sel_wtr_wtf;
   logic [31:0] max_timeout;   
   string 	wait_alias [WAIT_SIZE];   
   logic [WAIT_WIDTH - 1 : 0] wait_signals [WAIT_SIZE];  
   logic 		      wait_done;
   
   
endinterface // wait_event_int
