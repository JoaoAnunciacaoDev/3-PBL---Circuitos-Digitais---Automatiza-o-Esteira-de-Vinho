module Automatizacao_Esteira_Vinho (
    input CLK, RESET, KEY_START, KEY_VEDAR, KEY_ENTER_CQ, KEY_LACRE_CONTA, SW_ADD_ROLHA, SW_QUALIDADE_OK,
    SENSOR_POS_ENCHIMENTO, SENSOR_POS_CQ, SENSOR_POS_LACRE, SENSOR_GARRAFA_CHEIA,

    output LED_MOTOR, LED_ALARME_ROLHA, LED_DESCARTE, VALVULA_ENCHIMENTO, ATUADOR_VEDACAO, DISPENSADOR_ROLHAS,
    output [6:0] HEX0, HEX1, HEX4, HEX5,
	 output [2:0] Estado_Atual
);

    wire w_comando_mover_esteira, w_rolha_disponivel, w_dec_rolha, w_inc_duzia, w_start_pressionado, clk_lento,
	 w_motor_parado_pos_enchimento, w_motor_parado_pos_cq, w_motor_parado_pos_lacre, w_sensor_esteira_ativado;
    
    wire [4:0] w_contagem_rolhas;
    wire [3:0] w_contagem_duzias;
	 wire [2:0] w_fsm_estado_atual;
	
	 assign Estado_Atual = w_fsm_estado_atual;
	
	 wire not_q2, not_q1, not_q0, not_led_motor;
	 wire w_estado_001;
	 wire w_estado_100;
	 wire w_estado_101;

	 not (w_start_pressionado, w_start);
	 
	 not (not_q2, w_fsm_estado_atual[2]);
	 not (not_q1, w_fsm_estado_atual[1]);
	 not (not_q0, w_fsm_estado_atual[0]);
	 not (not_led_motor, LED_MOTOR);

	 and (w_estado_001, not_q2, not_q1, w_fsm_estado_atual[0]);
	 and (w_estado_100, w_fsm_estado_atual[2], not_q1, not_q0);
	 and (w_estado_101, w_fsm_estado_atual[2], not_q1, w_fsm_estado_atual[0]);

	 and (w_motor_parado_pos_enchimento, not_led_motor, w_estado_001, SENSOR_POS_ENCHIMENTO);
	 and (w_motor_parado_pos_cq, not_led_motor, w_estado_100, SENSOR_POS_CQ);
	 and (w_motor_parado_pos_lacre, not_led_motor, w_estado_101, SENSOR_POS_LACRE);

	 or g7 (w_sensor_esteira_ativado, SENSOR_POS_ENCHIMENTO, SENSOR_POS_CQ, SENSOR_POS_LACRE);
	 
	 wire w_reset, w_start, w_key_vedar, w_key_enter_cq, w_key_lacre, w_add_rolha, w_qualidade_ok;
	 
	 clock_enable (.Clk_100M(CLK), .slow_clk_en(clk_lento));
	 
	 debounce_better_version reset_debounce(.pb_1(RESET), .clk(CLK), .slow_clk_en(clk_lento), .pb_out(w_reset));
	 debounce_better_version start_debounce(.pb_1(KEY_START), .clk(CLK), .slow_clk_en(clk_lento), .pb_out(w_start));
	 debounce_better_version vedar_debounce(.pb_1(KEY_VEDAR), .clk(CLK), .slow_clk_en(clk_lento), .pb_out(w_key_vedar));
	 debounce_better_version enter_debounce(.pb_1(KEY_ENTER_CQ), .clk(CLK), .slow_clk_en(clk_lento), .pb_out(w_key_enter_cq));
	 debounce_better_version lacre_debounce(.pb_1(KEY_LACRE_CONTA), .clk(CLK), .slow_clk_en(clk_lento), .pb_out(w_key_lacre));
	 debounce_better_version add_rolha_debounce(.pb_1(SW_ADD_ROLHA), .clk(CLK), .slow_clk_en(clk_lento), .pb_out(w_add_rolha));
	 //debounce_better_version qualidade_ok_debounce(.pb_1(SW_QUALIDADE_OK), .clk(CLK), .slow_clk_en(clk_lento), .pb_out(w_qualidade_ok));
    
    FSM_Processo fsm_p (
        .clk(clk_lento), 
		  .Reset(w_reset), 
		  .Start_Pressionado(w_start),
        .Motor_Parado_Pos_Enchimento(w_motor_parado_pos_enchimento),
        .Motor_Parado_Pos_CQ(w_motor_parado_pos_cq),
        .Motor_Parado_Pos_Lacre(w_motor_parado_pos_lacre),
        .Sensor_Garrafa_Cheia(SENSOR_GARRAFA_CHEIA),
        .Rolha_Disponivel(w_rolha_disponivel),
        .Botao_Vedar(w_key_vedar), 
		  .Botao_Enter_CQ(w_key_enter_cq), 
        .Input_Qualidade_OK(SW_QUALIDADE_OK),
        .Botao_Lacre_e_Conta(w_key_lacre),
        .Comando_Mover_Esteira(w_comando_mover_esteira), 
        .Valv_Enchimento(VALVULA_ENCHIMENTO), 
        .Atuador_Vedacao(ATUADOR_VEDACAO), 
        .Dec_Rolha(w_dec_rolha), 
        .LED_Descarte(LED_DESCARTE), 
		  .Inc_Duzia(w_inc_duzia),
		  .saida_estado_atual(w_fsm_estado_atual)
    );

    FSM_Motor fsm_m (
        .clk(clk_lento), 
		  .Reset(w_reset),
        .Comando_Mover_Esteira(w_comando_mover_esteira),
        .Sensor_Ativado(w_sensor_esteira_ativado),
        .Motor(LED_MOTOR)
    );

    contador_rolhas contador_r (
		 .clk(clk_lento), 
		 .reset(w_reset),
		 .dec(w_dec_rolha),
		 .add_manual(w_add_rolha),
		 .start_proc(w_start),
		 .contagem(w_contagem_rolhas),
		 .disp_acionado(DISPENSADOR_ROLHAS),
		 .LED_Alarme(LED_ALARME_ROLHA),
		 .rolha_disponivel(w_rolha_disponivel)
	 );

    contador_duzias contador_d (
        .clk(clk_lento), 
		  .reset(w_reset),
        .inc(w_inc_duzia),
        .start_proc(w_start_pressionado),
        .contagem(w_contagem_duzias)
    );

    wire [3:0] w_rolhas_dezena_bcd;
	 wire [3:0] w_rolhas_unidade_bcd;
	 
	 //buf (w_contagem_rolhas[3], 1'b0);

	 bin_to_bcd conversor_rolhas (
		 .bin_in(w_contagem_rolhas),
		 .bcd_dezena(w_rolhas_dezena_bcd),
		 .bcd_unidade(w_rolhas_unidade_bcd)
	 );

	 bcd_to_7seg dec0 (
		 .bcd(w_rolhas_unidade_bcd),
		 .sa(HEX0[0]), 
		 .sb(HEX0[1]), 
		 .sc(HEX0[2]), 
		 .sd(HEX0[3]), 
		 .se(HEX0[4]), 
		 .sf(HEX0[5]), 
		 .sg(HEX0[6])
	 );

	 bcd_to_7seg dec1 (
		 .bcd(w_rolhas_dezena_bcd),
		 .sa(HEX1[0]), 
		 .sb(HEX1[1]), 
		 .sc(HEX1[2]), 
		 .sd(HEX1[3]), 
		 .se(HEX1[4]), 
		 .sf(HEX1[5]), 
		 .sg(HEX1[6])
	 );

	 wire [3:0] w_duzias_dezena_bcd;
	 wire [3:0] w_duzias_unidade_bcd;

	 bin_to_bcd conversor_duzias (
		 .bin_in(w_contagem_duzias),
		 .bcd_dezena(w_duzias_dezena_bcd),
		 .bcd_unidade(w_duzias_unidade_bcd)
	 );

	 bcd_to_7seg dec4 (
		 .bcd(w_duzias_unidade_bcd),
		 .sa(HEX4[0]), 
		 .sb(HEX4[1]), 
		 .sc(HEX4[2]), 
		 .sd(HEX4[3]), 
		 .se(HEX4[4]), 
		 .sf(HEX4[5]), 
		 .sg(HEX4[6])
	 );

	 bcd_to_7seg dec5 (
			 .bcd(w_duzias_dezena_bcd),
			 .sa(HEX5[0]), 
			 .sb(HEX5[1]), 
			 .sc(HEX5[2]), 
			 .sd(HEX5[3]), 
			 .se(HEX5[4]), 
			 .sf(HEX5[5]), 
			 .sg(HEX5[6])
	 );

endmodule