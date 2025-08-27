module Mux (
    input [63:0]a,b,
    input s,
    output [63:0]c
);
    assign c = (~s) ? a : b ;
    
    // always@(*) begin
    //     $display("Time = %0t, s: %b, b: %h", $time, s, b);
    // end
endmodule