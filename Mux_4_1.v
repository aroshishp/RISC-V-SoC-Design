module Mux_4_1 (
    input [63:0]a,b,c,d,
    input [1:0] s,
    output [63:0] y
);
    assign y = (s == 2'b00) ? a :
               (s == 2'b01) ? b :
               (s == 2'b10) ? c :
               (s == 2'b11) ? d : 64'b0;

endmodule