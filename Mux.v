module Mux (
    input [63:0]a,b,
    input s,
    output [63:0]c
);
    assign c = (~s) ? a : b ;
    
endmodule