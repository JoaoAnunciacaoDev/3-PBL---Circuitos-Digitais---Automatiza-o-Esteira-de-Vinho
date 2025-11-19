module contador_duzias (
    input clk, reset, inc,
    output reg [3:0] contagem
);

    parameter MAX_DUZIAS = 9;
	 
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            contagem <= 4'd0;
        end else if (inc) begin
            if (contagem == MAX_DUZIAS) begin
                contagem <= 4'd0;
            end else begin
                contagem <= contagem + 1;
            end
        end
    end
	 
endmodule