module debounce_better_version (input pb_1, clk, slow_clk_en, output pb_out);

	wire Q1,Q2,Q2_bar,Q0;
	my_dff_en d0(clk,slow_clk_en,pb_1,Q0);

	my_dff_en d1(clk,slow_clk_en,Q0,Q1);
	my_dff_en d2(clk,slow_clk_en,Q1,Q2);
	assign Q2_bar = ~Q2;
	assign pb_out = Q1 & Q2_bar;
	
endmodule

// D-flip-flop with clock enable signal for debouncing module 
module my_dff_en(input DFF_CLOCK, clock_enable,D, output reg Q=0);
    always @ (posedge DFF_CLOCK) begin
  if(clock_enable==1) 
           Q <= D;
    end
endmodule 