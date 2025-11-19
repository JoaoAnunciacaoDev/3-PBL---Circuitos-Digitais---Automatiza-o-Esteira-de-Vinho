module my_dff ( input DFF_CLOCK , D , output reg Q, output wire Qn ) ;
    always @ ( posedge DFF_CLOCK ) begin
        Q <= D;
    end
     
     assign Qn = ~Q;
     
endmodule