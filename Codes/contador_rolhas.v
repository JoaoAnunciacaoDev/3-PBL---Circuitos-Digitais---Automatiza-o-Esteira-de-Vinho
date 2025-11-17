module contador_rolhas (
    input clk, reset, dec, add_manual, start_proc,  
    output reg [4:0] contagem,
	 output reg [3:0] estoque,
	 output disp_acionado,
	 output LED_Alarme,
    output rolha_disponivel
);

    parameter MAX_ROLHAS      = 5'd31;
    parameter VALOR_INICIAL   = 5'd16;
    parameter CONTAGEM_MINIMA = 5'd5;
    parameter RECARGA_AUTO    = 5'd15;
	 parameter ESTOQUE_INICIAL = 6'd15;

    assign rolha_disponivel = (contagem > 0);
	 assign LED_Alarme = (contagem == 0 && estoque == 0);
	 assign disp_acionado = (contagem <= CONTAGEM_MINIMA && estoque > 0);

    always @(posedge clk or posedge reset or posedge start_proc) begin

        if (reset || start_proc) begin
		  
            contagem <= VALOR_INICIAL;
				estoque <= ESTOQUE_INICIAL;
				
        end else begin
		  
				if (contagem <= CONTAGEM_MINIMA && estoque > 0) begin
                if (estoque >= RECARGA_AUTO) begin
                    if (contagem + RECARGA_AUTO > MAX_ROLHAS) begin
						  
                        estoque <= estoque - (MAX_ROLHAS - contagem);
                        contagem <= MAX_ROLHAS;
								
                    end else begin
                        
                        estoque <= estoque - RECARGA_AUTO;
                        contagem <= contagem + RECARGA_AUTO;
								
                    end

            end else begin 
                    
                    if (contagem + estoque > MAX_ROLHAS) begin
                    
                        estoque <= estoque - (MAX_ROLHAS - contagem);
                        contagem <= MAX_ROLHAS;
								
                    end else begin
                        
                        contagem <= contagem + estoque;
                        estoque <= 0;
								
                    end
                end

            end else if (dec && rolha_disponivel) begin
                contagem <= contagem - 1;
            
            end else if (add_manual && contagem < MAX_ROLHAS && estoque > 0) begin
                contagem <= contagem + 1;
                estoque <= estoque - 1;
            end
        end
    end

endmodule