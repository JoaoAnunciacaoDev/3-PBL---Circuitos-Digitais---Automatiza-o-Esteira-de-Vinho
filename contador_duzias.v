module contador_duzias (
    input clk, reset, inc,
    output reg [3:0] contagem
);

    parameter MAX_DUZIAS = 9;
    parameter PULSOS_POR_INCREMENTO = 6;
     
    reg [2:0] sub_contador;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            contagem <= 4'd0;
            sub_contador <= 3'd0;
        end else if (inc) begin
            if (sub_contador == PULSOS_POR_INCREMENTO - 1) begin
                
                sub_contador <= 3'd0;
                
                if (contagem == MAX_DUZIAS) begin
                    contagem <= 4'd0;
                end else begin
                    contagem <= contagem + 1;
                end
                
            end else begin
                sub_contador <= sub_contador + 1'b1;
            end
        end
    end
     
endmodule