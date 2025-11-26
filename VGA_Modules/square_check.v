module square_check (
	input [31:0] xi, yi, xf, yf, x_atual, y_atual,
	output esta_dentro
);

	assign esta_dentro = (x_atual >= xi && x_atual <= xf && 
								y_atual >= yi && y_atual <= yf);

endmodule