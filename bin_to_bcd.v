module bin_to_bcd (input [4:0] bin_in, output [3:0] bcd_dezena, bcd_unidade);

	buf buf0 (bcd_dezena[3], 1'b0);
	buf buf1 (bcd_dezena[2], 1'b0);

	wire nA, nB, nC, nD;
	not (nA, bin_in[4]);
	not (nB, bin_in[3]);
	not (nC, bin_in[2]);
	not (nD, bin_in[1]);
	
	wire A, B, C, D, E;
	buf (A, bin_in[4]);
	buf (B, bin_in[3]);
	buf (C, bin_in[2]);
	buf (D, bin_in[1]);
	buf (E, bin_in[0]);
	
	wire and_ac, and_ab;
	and and0 (and_ac, A, C);
	and and1 (and_ab, A, B);
	or or0 (bcd_dezena[1], and_ab, and_ac);
	
	wire and_a_nb_nc, and_na_bd, and_na_bc, and_bcd;
	and and2 (and_a_nb_nc, A, nB, nC);
	and and3 (and_na_bd, nA, B, D);
	and and4 (and_na_bc, nA, B, C);
	and and5 (and_bcd, B, C, D);
	or or1 (bcd_dezena[0], and_a_nb_nc, and_na_bd, and_na_bc, and_bcd);
	
	wire and_na_b_nc_nd, and_a_nb_nc_d, and_abc_nd;
	and and6 (and_na_b_nc_nd, nA, B, nC, nD);
	and and7 (and_a_nb_nc_d, A, nB, nC, D);
	and and8 (and_abc_nd, A, B, C, nD);
	or or2 (bcd_unidade[3], and_na_b_nc_nd, and_a_nb_nc_d, and_abc_nd);
	
	wire and_na_nb_c, and_a_nc_nd, and_na_c_d, and_a_b_nc;
	and and9 (and_na_nb_c, nA, nB, C);
	and and10 (and_a_nc_nd, A, nC, nD);
	and and11 (and_na_c_d, nA, C, D);
	and and12 (and_a_b_nc, A, B, nC);
	or or3 (bcd_unidade[2], and_na_nb_c, and_a_nc_nd, and_na_c_d, and_a_b_nc);
	
	wire and_a_nb_nc_nd, and_na_bc_nd, and_ab_nc_d, and_na_nb_d, and_nb_cd;
	and and13 (and_a_nb_nc_nd, A, nB, nC, nD);
	and and14 (and_na_bc_nd, nA, B, C, nD);
	and and15 (and_ab_nc_d, A, B, nC, D);
	and and16 (and_na_nb_d, nA, nB, D);
	and and17 (and_nb_cd, nB, C, D);
	or or4 (bcd_unidade[1], and_a_nb_nc_nd, and_na_bc_nd,and_ab_nc_d, and_na_nb_d, and_nb_cd);
	
	buf buf2 (bcd_unidade[0], E);

endmodule