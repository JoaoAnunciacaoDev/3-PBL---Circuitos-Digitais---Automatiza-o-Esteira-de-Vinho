module debounce_better_version (input pb_1, clk, slow_clk_en, output pb_out);

	reg_mealy_ltp (pb_1, slow_clk_en, pb_out);

endmodule

module reg_mealy_ltp (L, clk, P);

    input L, clk;
    output P;
    
    wire qn_to_and;
    
    my_dff D0 (.DFF_CLOCK(clk), .D(L), .Qn(qn_to_and));
    
    and (P, L, qn_to_and);

endmodule

module my_dff_en(input DFF_CLOCK, clock_enable,D, output reg Q=0);
    always @ (posedge DFF_CLOCK) begin
		 if(clock_enable == 1) 
			Q <= D;
		 end
endmodule 