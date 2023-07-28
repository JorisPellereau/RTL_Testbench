module check_level #(parameter CHECK_SIZE  = 5,
		     parameter CHECK_WIDTH = 32
		     )
   ();
   
   
   
   check_level_intf #(.CHECK_SIZE  (CHECK_SIZE),
		      .CHECK_WIDTH (CHECK_WIDTH)
		      )  check_level_if();
   
endmodule // check_level
