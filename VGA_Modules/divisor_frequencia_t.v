module divisor_frequencia_t (
	input clk, output clk_1hz
	);
	
	fliflopT (.clk(clk), .t(1), .q(q0));
	fliflopT (.clk(q0), .t(1), .q(q1));
	fliflopT (.clk(q1), .t(1), .q(q2));
	fliflopT (.clk(q2), .t(1), .q(q3));
	fliflopT (.clk(q3), .t(1), .q(q4));
	fliflopT (.clk(q4), .t(1), .q(q5));
	fliflopT (.clk(q5), .t(1), .q(q6));
	fliflopT (.clk(q6), .t(1), .q(q7));
	fliflopT (.clk(q7), .t(1), .q(q8));
	fliflopT (.clk(q8), .t(1), .q(q9));
	fliflopT (.clk(q9), .t(1), .q(q10));
	fliflopT (.clk(q10), .t(1), .q(q11));
	fliflopT (.clk(q11), .t(1), .q(q12));
	fliflopT (.clk(q12), .t(1), .q(q13));
	fliflopT (.clk(q13), .t(1), .q(q14));
	fliflopT (.clk(q14), .t(1), .q(q15));
	fliflopT (.clk(q15), .t(1), .q(q16));
	fliflopT (.clk(q16), .t(1), .q(q17));
	fliflopT (.clk(q17), .t(1), .q(q18));
	fliflopT (.clk(q18), .t(1), .q(q19));
	fliflopT (.clk(q19), .t(1), .q(q20));
	fliflopT (.clk(q20), .t(1), .q(q21));
	fliflopT (.clk(q21), .t(1), .q(q22));
	fliflopT (.clk(q22), .t(1), .q(q23));
	fliflopT (.clk(q23), .t(1), .q(clk_1hz));

endmodule

module fliflopT ( 	
	input clk,
   input rst,
   input t,
   output reg q
	);

  always @ (posedge clk) begin
    if (rst)
      q <= 0;
    else
    	if (t)
      		q <= ~q;
    	else
      		q <= q;
  end
  
endmodule