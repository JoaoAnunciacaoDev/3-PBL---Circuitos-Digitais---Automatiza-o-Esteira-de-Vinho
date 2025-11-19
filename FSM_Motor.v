module FSM_Motor (
    input clk, Reset, Comando_Mover_Esteira, Sensor_Ativado,
    output Motor
);

    reg estado_atual, proximo_estado;
    
    parameter PARADO = 1'b0, 
              ANDANDO = 1'b1;

    always @(posedge clk or posedge Reset) begin
        if (Reset)
            estado_atual <= PARADO;
        else
            estado_atual <= proximo_estado;
    end

    always @(*) begin
        case (estado_atual)
            PARADO: begin
               if (Comando_Mover_Esteira)
                   proximo_estado = ANDANDO;
					else proximo_estado = PARADO;
				end
            
            ANDANDO: begin
               if (Sensor_Ativado || !Comando_Mover_Esteira)
                   proximo_estado = PARADO;
					else proximo_estado = ANDANDO;
            end
				
				default: proximo_estado = PARADO;
        endcase
    end
	 
   assign Motor = estado_atual;
	
endmodule