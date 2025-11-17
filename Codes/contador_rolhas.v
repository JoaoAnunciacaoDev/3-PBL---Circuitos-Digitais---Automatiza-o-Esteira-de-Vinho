module contador_rolhas (
    input clk, reset, dec, add_manual, start_proc,  
    output reg [4:0] contagem, 
	 output reg disp_acionado,
    output rolha_disponivel
);

    parameter MAX_ROLHAS      = 5'd31;
    parameter VALOR_INICIAL   = 5'd16;
    parameter CONTAGEM_MINIMA = 5'd5;
    parameter RECARGA_AUTO    = 5'd15;

    assign rolha_disponivel = (contagem > 0);

    always @(posedge clk or posedge reset or posedge start_proc) begin

        if (reset || start_proc) begin
            contagem <= VALOR_INICIAL;
            disp_acionado <= 1'b0;
        end else begin
            disp_acionado <= 1'b0;

            if (contagem <= CONTAGEM_MINIMA) begin
                if (contagem + RECARGA_AUTO > MAX_ROLHAS) begin
                    contagem <= MAX_ROLHAS;
                end else begin
                    contagem <= contagem + RECARGA_AUTO;
                end
                disp_acionado <= 1'b1;
           
            end else if (dec && rolha_disponivel) begin
                contagem <= contagem - 1;
            
            end else if (add_manual && contagem < MAX_ROLHAS) begin
                contagem <= contagem + 1;
            end
        end
    end

endmodule