module divisor_frequencia (L, clk, P, rst);

    input L, clk, rst;
    output P;
    
    wire rst_n;
    not (rst_n, rst);
    
    reg_mealy (.L(L), .clk(clk), .P(P));

endmodule

module reg_mealy (L, clk, P);

    input L, clk;
    output P;

    reg flag_capturada = 1'b0;

    always @(posedge clk) begin
        flag_capturada <= L;
    end

	 or (P, flag_capturada, L);

endmodule

module ckt5_CA (
    input clk, rst_n, j, k,
    output [24:0] q, q_bar,
	 output clk_lento
);

    flipflop_jk jk1(clk, rst_n, j, k, q[0], q_bar[0]);
    
    flipflop_jk jk2(q_bar[0], rst_n, j, k, q[1], q_bar[1]);
    flipflop_jk jk3(q_bar[1], rst_n, j, k, q[2], q_bar[2]);
    flipflop_jk jk4(q_bar[2], rst_n, j, k, q[3], q_bar[3]);
    flipflop_jk jk5(q_bar[3], rst_n, j, k, q[4], q_bar[4]);
    flipflop_jk jk6(q_bar[4], rst_n, j, k, q[5], q_bar[5]);
    flipflop_jk jk7(q_bar[5], rst_n, j, k, q[6], q_bar[6]);
    flipflop_jk jk8(q_bar[6], rst_n, j, k, q[7], q_bar[7]);
    flipflop_jk jk9(q_bar[7], rst_n, j, k, q[8], q_bar[8]);
    flipflop_jk jk10(q_bar[8], rst_n, j, k, q[9], q_bar[9]);
    flipflop_jk jk11(q_bar[9], rst_n, j, k, q[10], q_bar[10]);
    flipflop_jk jk12(q_bar[10], rst_n, j, k, q[11], q_bar[11]);
    flipflop_jk jk13(q_bar[11], rst_n, j, k, q[12], q_bar[12]);
    flipflop_jk jk14(q_bar[12], rst_n, j, k, q[13], q_bar[13]);
    flipflop_jk jk15(q_bar[13], rst_n, j, k, q[14], q_bar[14]);
    flipflop_jk jk16(q_bar[14], rst_n, j, k, q[15], q_bar[15]);
    flipflop_jk jk17(q_bar[15], rst_n, j, k, q[16], q_bar[16]);
    flipflop_jk jk18(q_bar[16], rst_n, j, k, q[17], q_bar[17]);
    flipflop_jk jk19(q_bar[17], rst_n, j, k, q[18], q_bar[18]);
    flipflop_jk jk20(q_bar[18], rst_n, j, k, q[19], q_bar[19]);
    flipflop_jk jk21(q_bar[19], rst_n, j, k, q[20], q_bar[20]);
    flipflop_jk jk22(q_bar[20], rst_n, j, k, q[21], q_bar[21]);
	 flipflop_jk jk23(q_bar[21], rst_n, j, k, q[22], q_bar[22]);
    flipflop_jk jk24(q_bar[22], rst_n, j, k, q[23], q_bar[23]);
    flipflop_jk jk25(q_bar[23], rst_n, j, k, q[24], q_bar[24]);
	 
	 assign clk_lento = q[24];

endmodule

module flipflop_jk (
    input clk, rst_n,
    input j,k,
    output reg q, 
     output wire q_bar
);

    always@(posedge clk or negedge rst_n)
		 begin
			  if(!rst_n) q <= 0;
			  else begin
					case({j,k})
					2'b00: q <= q;
					2'b01: q <= 1'b0;
					2'b10: q <= 1'b1;
					2'b11: q <= ~q;
					endcase
			  end
		 end
     
    assign q_bar = ~q;
     
endmodule