module top (
	input CLK, RESET, KEY_START, KEY_VEDAR, KEY_ENTER_CQ, KEY_LACRE_CONTA, SW_ADD_ROLHA, SW_QUALIDADE_OK,
    SENSOR_POS_ENCHIMENTO, SENSOR_POS_CQ, SENSOR_POS_LACRE, SENSOR_GARRAFA_CHEIA, 

   output LED_MOTOR, LED_ALARME_ROLHA, LED_DESCARTE, VALVULA_ENCHIMENTO, ATUADOR_VEDACAO, DISPENSADOR_ROLHAS,
   output [6:0] HEX0, HEX1, HEX4, HEX5, HEX2, HEX3,
	output [2:0] Estado_Atual,
	
   //////////// VGA SIGNALS //////////
   output reg [3:0]    VGA_R,
   output reg [3:0]    VGA_G,
   output reg [3:0]    VGA_B,
   output reg          VGA_HS,
   output reg          VGA_VS
);

	parameter PARADO                  = 3'b000, 
				 AGUARDANDO_ENCHIMENTO   = 3'b001, 
				 AGUARDANDO_VEDACAO      = 3'b010,
				 FALTA_ROLHA             = 3'b011,
				 AGUARDANDO_CQ           = 3'b100, 
				 AGUARDANDO_LACRE        = 3'b101;

	// Signals for drawing to the display. 
	wire [31:0]    col, row;
	wire [3:0]     red, green, blue;

	// Timing signals - don't touch these.
	wire           h_sync, v_sync;
	wire           disp_ena;
	wire           vga_clk;
	wire clk_lento;
	wire reset_negado;
	
	not (reset_negado, reset);

	Automatizacao_Esteira_Vinho (
		.CLK(CLK), 
		.RESET(RESET), 
		.KEY_START(KEY_START), 
		.KEY_VEDAR(KEY_VEDAR), 
		.KEY_ENTER_CQ(KEY_ENTER_CQ), 
		.KEY_LACRE_CONTA(KEY_LACRE_CONTA), 
		.SW_ADD_ROLHA(SW_ADD_ROLHA), 
		.SW_QUALIDADE_OK(SW_QUALIDADE_OK),
		.SENSOR_POS_ENCHIMENTO(SENSOR_POS_ENCHIMENTO), 
		.SENSOR_POS_CQ(SENSOR_POS_CQ), 
		.SENSOR_POS_LACRE(SENSOR_POS_LACRE), 
		.SENSOR_GARRAFA_CHEIA(SENSOR_GARRAFA_CHEIA),
		.LED_MOTOR(w_led_motor), 
		.LED_ALARME_ROLHA(w_alarme), 
		.LED_DESCARTE(LED_DESCARTE), 
		.VALVULA_ENCHIMENTO(w_val_enchimento), 
		.ATUADOR_VEDACAO(ATUADOR_VEDACAO), 
		.DISPENSADOR_ROLHAS(DISPENSADOR_ROLHAS),
		.HEX0(HEX0), 
		.HEX1(HEX1), 
		.HEX4(HEX4), 
		.HEX5(HEX5), 
		.HEX2(HEX2), 
		.HEX3(HEX3),
		.Estado_Atual(Estado_Atual),
		.Motor_Parado_Pos_Enchimento(Motor_Parado_Pos_Enchimento),
		.Motor_Parado_Pos_CQ(Motor_Parado_Pos_CQ),
		.Motor_Parado_Pos_Lacre(Motor_Parado_Pos_Lacre)
	);
	
	wire w_led_motor, w_alarme, w_val_enchimento;
	
	assign LED_MOTOR = w_led_motor;
	assign LED_ALARME_ROLHA = w_alarme;
	assign VALVULA_ENCHIMENTO = w_val_enchimento;
	
	divisor_frequencia_t (.clk(CLK), .clk_1hz(clk_lento));
	
	reg [31:0] x_inicial, x_final;
	wire cabeca_enchimento,
	parte_baixo_enchimento,
	cabeca_cq,
	parte_baixo_cq,
	cabeca_lacre,
	parte_baixo_lacre,
	
	garrafa_amarela_inferior1, garrafa_amarela_superior1,
	garrafa_amarela_inferior2, garrafa_amarela_superior2,
	garrafa_amarela_inferior3, garrafa_amarela_superior3,
	garrafa_amarela_inferior4, garrafa_amarela_superior4,
	garrafa_amarela_inferior5, garrafa_amarela_superior5,
	garrafa_amarela_inferior6, garrafa_amarela_superior6,
	garrafa_amarela_inferior7, garrafa_amarela_superior7,
	garrafa_amarela_inferior8, garrafa_amarela_superior8,
	garrafa_amarela_inferior9, garrafa_amarela_superior9,
	
	liquido_superior1, liquido_superior2, liquido_superior3,
	liquido_superior4, liquido_superior5, liquido_superior6, 
	liquido_superior7,
	
	liquido_inferior1, liquido_inferior2, liquido_inferior3,
	liquido_inferior4, liquido_inferior5, liquido_inferior6, 
	liquido_inferior7,
	
	garrafa_aguard_enchimento1, garrafa_aguard_enchimento2,
	garrafa_pos_enchimento;
	
	// Desenho torneira de enchimento
	square_check (.xi(94), .yi(131), .xf(145), .yf(163), .x_atual(col), .y_atual(row), .esta_dentro(cabeca_enchimento));
	square_check (.xi(101), .yi(164), .xf(138), .yf(173), .x_atual(col), .y_atual(row), .esta_dentro(parte_baixo_enchimento));
	
	// Desenho torneira de CQ
	square_check (.xi(293), .yi(131), .xf(344), .yf(163), .x_atual(col), .y_atual(row), .esta_dentro(cabeca_cq));
	square_check (.xi(300), .yi(164), .xf(337), .yf(173), .x_atual(col), .y_atual(row), .esta_dentro(parte_baixo_cq));
	
	// Desenho torneira de Lacre
	square_check (.xi(489), .yi(131), .xf(540), .yf(163), .x_atual(col), .y_atual(row), .esta_dentro(cabeca_lacre));
	square_check (.xi(496), .yi(164), .xf(533), .yf(173), .x_atual(col), .y_atual(row), .esta_dentro(parte_baixo_lacre));
	
	// Desenho Garrafa vazia movendo - Sprite 1
	square_check (.xi(35), .yi(246), .xf(63), .yf(276), .x_atual(col), .y_atual(row), .esta_dentro(garrafa_amarela_superior1));
	square_check (.xi(35), .yi(276), .xf(63), .yf(319), .x_atual(col), .y_atual(row), .esta_dentro(garrafa_amarela_inferior1));
	
	// Desenho Garrafa vazia movendo - Sprite 2
	square_check (.xi(55), .yi(246), .xf(83), .yf(276), .x_atual(col), .y_atual(row), .esta_dentro(garrafa_amarela_superior2));
	square_check (.xi(55), .yi(276), .xf(83), .yf(319), .x_atual(col), .y_atual(row), .esta_dentro(garrafa_amarela_inferior2));
	
	// Desenho Garrafa vazia parada - Sprite 3
	square_check (.xi(105), .yi(246), .xf(133), .yf(276), .x_atual(col), .y_atual(row), .esta_dentro(garrafa_amarela_superior3));
	square_check (.xi(101), .yi(276), .xf(137), .yf(319), .x_atual(col), .y_atual(row), .esta_dentro(garrafa_amarela_inferior3));
	
	// Desenho Garrafa vazia movendo - Sprite 4
	square_check (.xi(207), .yi(246), .xf(235), .yf(276), .x_atual(col), .y_atual(row), .esta_dentro(garrafa_amarela_superior4));
	square_check (.xi(203), .yi(276), .xf(239), .yf(319), .x_atual(col), .y_atual(row), .esta_dentro(garrafa_amarela_inferior4));
	
	// Desenho Garrafa vazia movendo - Sprite 5
	square_check (.xi(184), .yi(246), .xf(212), .yf(276), .x_atual(col), .y_atual(row), .esta_dentro(garrafa_amarela_superior5));
	square_check (.xi(180), .yi(276), .xf(216), .yf(319), .x_atual(col), .y_atual(row), .esta_dentro(garrafa_amarela_inferior5));
	
	// Desenho Garrafa vazia movendo - Sprite 6
	square_check (.xi(304), .yi(246), .xf(332), .yf(276), .x_atual(col), .y_atual(row), .esta_dentro(garrafa_amarela_superior6));
	square_check (.xi(300), .yi(276), .xf(335), .yf(319), .x_atual(col), .y_atual(row), .esta_dentro(garrafa_amarela_inferior6));
	
	// Desenho Garrafa vazia movendo - Sprite 7
	square_check (.xi(398), .yi(246), .xf(426), .yf(276), .x_atual(col), .y_atual(row), .esta_dentro(garrafa_amarela_superior7));
	square_check (.xi(394), .yi(276), .xf(430), .yf(319), .x_atual(col), .y_atual(row), .esta_dentro(garrafa_amarela_inferior7));
	
	// Desenho Garrafa vazia movendo - Sprite 8
	square_check (.xi(418), .yi(246), .xf(446), .yf(276), .x_atual(col), .y_atual(row), .esta_dentro(garrafa_amarela_superior8));
	square_check (.xi(414), .yi(276), .xf(450), .yf(319), .x_atual(col), .y_atual(row), .esta_dentro(garrafa_amarela_inferior8));
	
	// Desenho Garrafa vazia movendo - Sprite 9
	square_check (.xi(501), .yi(246), .xf(529), .yf(276), .x_atual(col), .y_atual(row), .esta_dentro(garrafa_amarela_superior9));
	square_check (.xi(497), .yi(276), .xf(533), .yf(319), .x_atual(col), .y_atual(row), .esta_dentro(garrafa_amarela_inferior9));
	
	// Desenho liquido superior - sprite 1
	square_check (.xi(108), .yi(249), .xf(130), .yf(276), .x_atual(col), .y_atual(row), .esta_dentro(liquido_superior1));
	square_check (.xi(106), .yi(277), .xf(132), .yf(315), .x_atual(col), .y_atual(row), .esta_dentro(liquido_inferior1));
	
	// Desenho liquido superior - sprite 2
	square_check (.xi(108), .yi(249), .xf(130), .yf(276), .x_atual(col), .y_atual(row), .esta_dentro(liquido_superior2));
	square_check (.xi(106), .yi(277), .xf(132), .yf(315), .x_atual(col), .y_atual(row), .esta_dentro(liquido_inferior2));
	
	// Desenho liquido superior - sprite 3
	square_check (.xi(210), .yi(249), .xf(232), .yf(276), .x_atual(col), .y_atual(row), .esta_dentro(liquido_superior3));
	square_check (.xi(208), .yi(277), .xf(234), .yf(315), .x_atual(col), .y_atual(row), .esta_dentro(liquido_inferior3));
	
	// Desenho liquido superior - sprite 4
	square_check (.xi(187), .yi(249), .xf(209), .yf(276), .x_atual(col), .y_atual(row), .esta_dentro(liquido_superior4));
	square_check (.xi(185), .yi(277), .xf(211), .yf(315), .x_atual(col), .y_atual(row), .esta_dentro(liquido_inferior4));
	
	// Desenho liquido superior - sprite 5
	square_check (.xi(307), .yi(249), .xf(329), .yf(276), .x_atual(col), .y_atual(row), .esta_dentro(liquido_superior5));
	square_check (.xi(305), .yi(277), .xf(331), .yf(315), .x_atual(col), .y_atual(row), .esta_dentro(liquido_inferior5));
	
	// Desenho liquido superior - sprite 6
	square_check (.xi(401), .yi(249), .xf(423), .yf(276), .x_atual(col), .y_atual(row), .esta_dentro(liquido_superior6));
	square_check (.xi(399), .yi(277), .xf(425), .yf(315), .x_atual(col), .y_atual(row), .esta_dentro(liquido_inferior6));
	
	// Desenho liquido superior - sprite 7
	square_check (.xi(421), .yi(249), .xf(443), .yf(276), .x_atual(col), .y_atual(row), .esta_dentro(liquido_superior7));
	square_check (.xi(419), .yi(277), .xf(445), .yf(315), .x_atual(col), .y_atual(row), .esta_dentro(liquido_inferior7));
	
	// Desenho liquido superior - sprite 8
	square_check (.xi(504), .yi(249), .xf(526), .yf(276), .x_atual(col), .y_atual(row), .esta_dentro(liquido_superior8));
	square_check (.xi(502), .yi(277), .xf(528), .yf(315), .x_atual(col), .y_atual(row), .esta_dentro(liquido_inferior8));
	
	always @(posedge vga_clk) begin
		if (disp_ena == 1'b1) begin

			// "Torneiras" de estado
			if (cabeca_enchimento || cabeca_cq || cabeca_lacre) begin
				
				VGA_R <= 16'd12;
				VGA_G <= 16'd12;
				VGA_B <= 16'd12;
			
			end else if (parte_baixo_enchimento || parte_baixo_cq || parte_baixo_lacre) begin
				
				VGA_R <= 16'd9;
				VGA_G <= 16'd9;
				VGA_B <= 16'd9;
					
			end else begin

				VGA_R <= 16'd0;
				VGA_G <= 16'd0;
				VGA_B <= 16'd0;
				
			end

			// Movimento da esteira
			if (!w_led_motor) begin
				if (row >= 320 && row <= 408) begin
					if ((col >= 0 && col <= 136) 
						|| (col >= 163 && col <= 299)
						|| (col >= 326 && col <= 462)
						|| (col >= 489 && col <= 625)) begin

							VGA_R <= 16'd12;
							VGA_G <= 16'd12;
							VGA_B <= 16'd12;

						end

					else if ((col > 136 && col < 163)
							|| (col > 299 && col < 326)
							|| (col > 462 && col < 489)
							|| (col > 489 && col < 640)) begin

							VGA_R <= 16'd9;
							VGA_G <= 16'd9;
							VGA_B <= 16'd9;

					end
				end

			end else begin
				if (clk_lento) begin
					if (row >= 320 && row <= 408) begin
						if ((col >= 0 && col <= 136) 
							|| (col >= 163 && col <= 299)
							|| (col >= 326 && col <= 462)
							|| (col >= 489 && col <= 625)) begin

								VGA_R <= 16'd12;
								VGA_G <= 16'd12;
								VGA_B <= 16'd12;

							end

						else if ((col > 136 && col < 163)
								|| (col > 299 && col < 326)
								|| (col > 462 && col < 489)
								|| (col > 489 && col < 640)) begin

								VGA_R <= 16'd9;
								VGA_G <= 16'd9;
								VGA_B <= 16'd9;

						end
					end
				end else begin
					if (row >= 320 && row <= 408) begin
						if ((col >= 0 && col <= 69) 
							|| (col >= 96 && col <= 232)
							|| (col >= 259 && col <= 395)
							|| (col >= 422 && col <= 558)
							|| (col >= 585 && col <= 640)) begin

								VGA_R <= 16'd12;
								VGA_G <= 16'd12;
								VGA_B <= 16'd12;

							end

						else if ((col > 69 && col < 96)
								|| (col > 232 && col < 259)
								|| (col > 395 && col < 422)
								|| (col > 558 && col < 585)) begin

								VGA_R <= 16'd9;
								VGA_G <= 16'd9;
								VGA_B <= 16'd9;

						end
					end
				end
			end
			
			case (Estado_Atual)
				AGUARDANDO_ENCHIMENTO:
					if (Motor_Parado_Pos_Enchimento) begin
					
						// enchendo garrafa
						if ((row >= 174 && row <= 245) && (col >= 108 && col <= 130)) begin
							if (w_val_enchimento) begin

								VGA_R <= 16'd15;
								VGA_G <= 16'd0;
								VGA_B <= 16'd0;

							end else begin

								VGA_R <= 16'd0;
								VGA_G <= 16'd0;
								VGA_B <= 16'd0;
							end
							
						// garrafa parada no enchimento
						end else if (garrafa_amarela_superior3 || garrafa_amarela_inferior3) begin

							VGA_R <= 16'd12;
							VGA_G <= 16'd12;
							VGA_B <= 16'd4;

						end 
					
					end else if (clk_lento) begin // garrafa movimentado

						if ((row >= 246 && row <= 319) && (col >= 35 && col <= 63) 
							|| (row >= 276 && row <= 319) && (col >= 31 && col <= 67)) begin

								VGA_R <= 16'd12;
								VGA_G <= 16'd12;
								VGA_B <= 16'd4;

						end 

					end else begin

						if ((row >= 246 && row <= 319) && (col >= 12 && col <= 40) 
							|| (row >= 276 && row <= 319) && (col >= 8 && col <= 44)) begin

								VGA_R <= 16'd12;
								VGA_G <= 16'd12;
								VGA_B <= 16'd4;

						end 

					end


				AGUARDANDO_VEDACAO: begin

					// parte vermelha
					if (liquido_superior1 || liquido_inferior1) begin

							VGA_R <= 16'd15;
							VGA_G <= 16'd0;
							VGA_B <= 16'd0;
						
					// Garrafa Amarela
					end else if (garrafa_amarela_superior3 || garrafa_amarela_inferior3) begin

							VGA_R <= 16'd12;
							VGA_G <= 16'd12;
							VGA_B <= 16'd4;

						end 
				
				end

				AGUARDANDO_CQ:

					if (Motor_Parado_Pos_CQ) begin

						// Desenho tampa
						if ((row >= 238 && row <= 245) && (col >= 306 && col <= 330)) begin

							VGA_R <= 16'd10;
							VGA_G <= 16'd9;
							VGA_B <= 16'd6;

						end
	
					// parte vermelha
					if (liquido_superior5 || liquido_inferior5) begin

							VGA_R <= 16'd15;
							VGA_G <= 16'd0;
							VGA_B <= 16'd0;
						
					// Garrafa Amarela
					end else if (garrafa_amarela_superior6 || garrafa_amarela_inferior6) begin

							VGA_R <= 16'd12;
							VGA_G <= 16'd12;
							VGA_B <= 16'd4;

						end 
					
					end else if (clk_lento) begin

						// Desenho tampa
						if ((row >= 238 && row <= 245) && (col >= 209 && col <= 233)) begin

							VGA_R <= 16'd10;
							VGA_G <= 16'd9;
							VGA_B <= 16'd6;

						end
						
						// parte vermelha
						if (liquido_superior3 || liquido_inferior3) begin

								VGA_R <= 16'd15;
								VGA_G <= 16'd0;
								VGA_B <= 16'd0;
							
						// Garrafa Amarela
						end else if (garrafa_amarela_superior4 || garrafa_amarela_inferior4) begin

								VGA_R <= 16'd12;
								VGA_G <= 16'd12;
								VGA_B <= 16'd4;

							end 

					end else begin

						// Desenho tampa
						if ((row >= 238 && row <= 245) && (col >= 186 && col <= 210)) begin

							VGA_R <= 16'd10;
							VGA_G <= 16'd9;
							VGA_B <= 16'd6;

						end
						
						// parte vermelha
						if (liquido_superior4 || liquido_inferior4) begin

								VGA_R <= 16'd15;
								VGA_G <= 16'd0;
								VGA_B <= 16'd0;
							
						// Garrafa Amarela
						end else if (garrafa_amarela_superior5 || garrafa_amarela_inferior5) begin

								VGA_R <= 16'd12;
								VGA_G <= 16'd12;
								VGA_B <= 16'd4;

							end

					end
					
				AGUARDANDO_LACRE: 
					if (Motor_Parado_Pos_Lacre) begin

						// Desenho tampa
						if ((row >= 238 && row <= 245) && (col >= 503 && col <= 527)) begin

							VGA_R <= 16'd10;
							VGA_G <= 16'd9;
							VGA_B <= 16'd6;

						end

						// parte vermelha
						if (liquido_superior8 || liquido_inferior8) begin

								VGA_R <= 16'd15;
								VGA_G <= 16'd0;
								VGA_B <= 16'd0;
							
						// Garrafa Amarela
						end else if (garrafa_amarela_superior9 || garrafa_amarela_inferior9) begin

								VGA_R <= 16'd12;
								VGA_G <= 16'd12;
								VGA_B <= 16'd4;

						end
						
					end else if (clk_lento) begin

							// Desenho tampa
							if ((row >= 238 && row <= 245) && (col >= 400 && col <= 424)) begin

								VGA_R <= 16'd10;
								VGA_G <= 16'd9;
								VGA_B <= 16'd6;

							end

							// parte vermelha
						if (liquido_superior6 || liquido_inferior6) begin

								VGA_R <= 16'd15;
								VGA_G <= 16'd0;
								VGA_B <= 16'd0;
							
						// Garrafa Amarela
						end else if (garrafa_amarela_superior7 || garrafa_amarela_inferior7) begin
								VGA_R <= 16'd12;
								VGA_G <= 16'd12;
								VGA_B <= 16'd4;

						end
					end else begin
					
						// Desenho tampa
							if ((row >= 238 && row <= 245) && (col >= 420 && col <= 444)) begin

								VGA_R <= 16'd10;
								VGA_G <= 16'd9;
								VGA_B <= 16'd6;

							end

							// parte vermelha
						if (liquido_superior7 || liquido_inferior7) begin

								VGA_R <= 16'd15;
								VGA_G <= 16'd0;
								VGA_B <= 16'd0;
							
						// Garrafa Amarela
						end else if (garrafa_amarela_superior8 || garrafa_amarela_inferior8) begin
								VGA_R <= 16'd12;
								VGA_G <= 16'd12;
								VGA_B <= 16'd4;

						end
				end
		  endcase

		end else begin

			VGA_R <= 4'd0;
			VGA_B <= 4'd0;
			VGA_G <= 4'd0;

		end
		
		VGA_HS <= h_sync;
		VGA_VS <= v_sync;
		
	end

// Instantiate PLL to convert the 50 MHz clock to a 25 MHz clock for timing.
	pll vgapll_inst (
		 .inclk0    (CLK),
		 .c0        (vga_clk)
	);
	
	// Instantite VGA controller
	vga_controller control (
		.pixel_clk  (vga_clk),
		.reset_n    (RESET),
		.h_sync     (h_sync),
		.v_sync     (v_sync),
		.disp_ena   (disp_ena),
		.column     (col),
		.row        (row)
   );

endmodule
