module PC_Adder (
    input [63:0]a,b,
    output [63:0]c
);

    assign c = a + b;
    
    // always@(*) begin
    //     $display("time = %t, PC_CURR = %d, IMM = %d, Sum = %d", $time, a, b, c);
    // end
endmodule