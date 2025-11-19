module FSM_Processo (
	input clk, Reset, Start_Pressionado, 
	Motor_Parado_Pos_Enchimento, Motor_Parado_Pos_CQ, Motor_Parado_Pos_Lacre,
   Sensor_Garrafa_Cheia, Rolha_Disponivel, Botao_Vedar, 
	Botao_Enter_CQ, Input_Qualidade_OK, Botao_Lacre_e_Conta, alarme_rolha,
	
   output Comando_Mover_Esteira, Valv_Enchimento, Atuador_Vedacao, 
   Dec_Rolha, LED_Descarte, Inc_Duzia, LED_Alarme,
	output [2:0] saida_estado_atual
);
    reg [2:0] estado_atual, proximo_estado;
    
    parameter PARADO                  = 3'b000, 
              AGUARDANDO_ENCHIMENTO   = 3'b001, 
              AGUARDANDO_VEDACAO      = 3'b010,
              FALTA_ROLHA             = 3'b011,
              AGUARDANDO_CQ           = 3'b100, 
              AGUARDANDO_LACRE        = 3'b101;

    always @(posedge clk or posedge Reset)
        if (Reset)
            estado_atual <= PARADO;
        else if (!alarme_rolha)
            estado_atual <= proximo_estado;

    always @(*)
        case (estado_atual)
            PARADO:
               if (Start_Pressionado) proximo_estado = AGUARDANDO_ENCHIMENTO;
					else proximo_estado = PARADO;

            AGUARDANDO_ENCHIMENTO:
               if (Motor_Parado_Pos_Enchimento && Sensor_Garrafa_Cheia)
                   proximo_estado = AGUARDANDO_VEDACAO;
					else proximo_estado = AGUARDANDO_ENCHIMENTO;

            AGUARDANDO_VEDACAO:
               if (!Rolha_Disponivel)
                   proximo_estado = FALTA_ROLHA;
               else if (Botao_Vedar)
                   proximo_estado = AGUARDANDO_CQ;
					else proximo_estado = AGUARDANDO_VEDACAO;

            FALTA_ROLHA:
               if (Rolha_Disponivel)
                   proximo_estado = AGUARDANDO_VEDACAO;
					else proximo_estado = FALTA_ROLHA;

            AGUARDANDO_CQ:
               if (Motor_Parado_Pos_CQ && Botao_Enter_CQ) begin
                  if (Input_Qualidade_OK)
                      proximo_estado = AGUARDANDO_LACRE;
                  else
                      proximo_estado = AGUARDANDO_ENCHIMENTO;
						end
					else proximo_estado = AGUARDANDO_CQ;
					
            AGUARDANDO_LACRE:
               if (Motor_Parado_Pos_Lacre && Botao_Lacre_e_Conta)
                   proximo_estado = AGUARDANDO_ENCHIMENTO;
					else proximo_estado = AGUARDANDO_LACRE;
				
				default: proximo_estado = PARADO;
        endcase

	 assign saida_estado_atual = estado_atual;
	 
	 assign Comando_Mover_Esteira =
		(estado_atual == AGUARDANDO_ENCHIMENTO && !Motor_Parado_Pos_Enchimento)
		|| (estado_atual == AGUARDANDO_VEDACAO && Botao_Vedar && Rolha_Disponivel)
		|| (estado_atual == AGUARDANDO_CQ && (!Motor_Parado_Pos_CQ || Botao_Enter_CQ))
		|| (estado_atual == AGUARDANDO_LACRE && (!Motor_Parado_Pos_Lacre || Botao_Lacre_e_Conta));
		
	 assign Valv_Enchimento = (estado_atual == AGUARDANDO_ENCHIMENTO && Motor_Parado_Pos_Enchimento);
	 assign Atuador_Vedacao = (estado_atual == AGUARDANDO_VEDACAO && Botao_Vedar && Rolha_Disponivel);
	 assign Dec_Rolha = Atuador_Vedacao;
	 assign LED_Alarme = (estado_atual == FALTA_ROLHA);
	 assign LED_Descarte = (estado_atual == AGUARDANDO_CQ && !alarme_rolha && Motor_Parado_Pos_CQ && Botao_Enter_CQ && !Input_Qualidade_OK);
	 assign Inc_Duzia = (estado_atual == AGUARDANDO_LACRE && Motor_Parado_Pos_Lacre && Botao_Lacre_e_Conta);
	 
endmodule