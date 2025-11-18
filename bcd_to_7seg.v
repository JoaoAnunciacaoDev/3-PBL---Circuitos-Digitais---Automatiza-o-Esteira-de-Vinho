module bcd_to_7seg (input [3:0] bcd, output sa, sb, sc, sd, se, sf, sg);

	wire nS3, nS2, nS1, nS0;
	not (nS3, bcd[3]);
	not (nS2, bcd[2]);
	not (nS1, bcd[1]);
	not (nS0, bcd[0]);
	
	// sA = S3' * S2' * S1' * S0 + S2 * S1' * S0'
	wire and_1a, and_2a;
	and (and_1a, nS3, nS2, nS1, bcd[0]);
	and (and_2a, bcd[2], nS1, nS0);
	or (sa, and_1a, and_2a);
	
	// sB = S2 * S1' * S0 + S2 * S1 * S0'
	wire and_1b, and_2b;
	and (and_1b, bcd[2], nS1, bcd[0]);
	and (and_2b, bcd[2], bcd[1], nS0);
	or (sb, and_1b, and_2b);
	
	// sC = S2' * S1 * S0'
	and (sc, nS2, bcd[1], nS0);
	
	// sD = S3' * S2' * S1' * S0 + S2 * S1' * S0' + S2 * S1 * S0
	wire and_1d, and_2d, and_3d;
	and (and_1d, nS3, nS2, nS1, bcd[0]);
	and (and_2d, bcd[2], nS1, nS0);
	and (and_3d, bcd[2], bcd[1], bcd[0]);
	or (sd, and_1d, and_2d, and_3d);
	
	// sE = S2 * S1' + S3' * S0 + S1' * S0
	wire and_1e, and_2e, and_3e;
	and (and_1e, bcd[2], nS1);
	and (and_2e, nS3, bcd[0]);
	and (and_3e, nS1, bcd[0]);
	or (se, and_1e, and_2e, and_3e);
	
	// sF = S3' * S2' * S0 + S2' * S1 + S1 * S0
	wire and_1f, and_2f, and_3f;
	and (and_1f, nS3, nS2, bcd[0]);
	and (and_2f, nS2, bcd[1]);
	and (and_3f, bcd[1], bcd[0]);
	or (sf, and_1f, and_2f, and_3f);
	
	// sG = S3' * S2' * S1' + S2 * S1 * S0
	wire and_1g, and_2g;
	and (and_1g, nS3, nS2, nS1);
	and (and_2g, bcd[2], bcd[1], bcd[0]);
	or (sg, and_1g, and_2g);
	
endmodule