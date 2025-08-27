module PC_block(
    input [63:0] PC_NEXT,
    input clk,
    input rst,
    input stall,
    output reg [63:0] PC
);

always @(posedge clk) begin
    if (rst) begin
        PC <= 64'd0;
    end else if(stall) begin
        PC <= PC;
    end else begin
        PC <= PC_NEXT;
    end

    // $display("PC: %d, PC_NEXT: %d", PC, PC_NEXT);
end

always@(*) begin
    $display("time: %0t, PC: %d, PC_NEXT: %d",$time, PC, PC_NEXT);
end



// assign PC = (rst) ? 64'd0 : PC_NEXT;

endmodule