module PC_Adder (
    input [63:0]a,b,
    output [63:0]c
);

    assign c = a + b;

    // always@(*) begin
    //     $display("Time: %0t, PC: %d, Imm: %d, Out: %d", $time, $signed(a), $signed(b), $signed(c));
    // end
endmodule