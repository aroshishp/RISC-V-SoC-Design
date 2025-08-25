module ALU (
    input [63:0] A,
    input [63:0] B,
    input [2:0] ALU_Sel,
    input sub,
    output reg [63:0] ALU_Out,
    output Carry_out, 
    output zero
);

    wire [63:0] sum;
    wire [63:0] B_comp;
    wire [63:0] A_xor_B;
    wire [63:0] A_and_B;
    wire [63:0] A_xor_B_and_cin;

    wire [63:0] Carry_intermediate;

    assign B_comp = {64{sub}} ^ B;
    assign A_xor_B = A ^ B_comp;
    assign A_and_B = A & B_comp;

    assign A_xor_B_and_cin[0] = A_xor_B[0] & sub;
    assign Carry_intermediate[0] = A_and_B[0] | A_xor_B_and_cin[0];
    assign A_xor_B_and_cin[63:1] = A_xor_B[63:1] & Carry_intermediate[62:0];
    assign Carry_intermediate[63:1] = A_and_B[63:1] | A_xor_B_and_cin[63:1];

    assign sum = A_xor_B ^ {Carry_intermediate[62:0], sub};
    assign Carry_out = Carry_intermediate[63];
    assign zero = (sum == 64'b0) ? 1'b1 : 1'b0;

    always@(*) begin
        case (ALU_Sel)
            3'b000: ALU_Out = sum; // Addition and  Subtraction
            3'b001: ALU_Out = ~A & B_comp; // A'B for slt
            3'b010: ALU_Out = A_and_B; // AND
            3'b011: ALU_Out = A | B; // OR
            3'b100: ALU_Out = A_xor_B; // XOR
            3'b101: ALU_Out = A >>> B[5:0]; // SRA
            3'b110: ALU_Out = A << B[5:0]; // SLL
            3'b111: ALU_Out = A >> B[5:0]; // SRL
            default: ALU_Out = 64'h0000000000000000; // Default case
        endcase
        // $display("ALU Operation: %b | A: %h | B: %h | ALU_Out: %h | Carry_out: %b | zero: %b",
        //          ALU_Sel, A, B, ALU_Out, Carry_out, zero);
    end

    // always@(*) begin
    //     $display("Time = %0t | ALU Operation: %b | A: %h | B: %h | ALU_Out: %h",
    //              $time, ALU_Sel, A, B, ALU_Out);
    // end

    // initial begin
    //     $monitor("Time: %0t | A: %h | B: %h | ALU_Sel: %b | ALU_Out: %h | Carry_out: %b | zero: %b", 
    //              $time, A, B, ALU_Sel, ALU_Out, Carry_out, zero);
    // end

endmodule

// module ALU_testbench;
//     reg [63:0] A, B;
//     reg [2:0] ALU_Sel;
//     reg sub;
//     wire [63:0] ALU_Out;
//     wire Carry_out;
//     wire zero;

//     ALU uut (
//         .A(A),
//         .B(B),
//         .ALU_Sel(ALU_Sel),
//         .sub(sub),
//         .ALU_Out(ALU_Out),
//         .Carry_out(Carry_out),
//         .zero(zero)
//     );

//     initial begin
//         $display("ALU Testbench Started");
//         A = 64'h000000000000000F; B = 64'h0000000000000003; sub = 0;

//         // Test all 8 functions and display zero output
//         ALU_Sel = 3'b000; sub = 0; #10; $display("ADD: %h, zero: %b", ALU_Out, zero);
//         ALU_Sel = 3'b000; sub = 1; #10; $display("SUB: %h, zero: %b", ALU_Out, zero);
//         ALU_Sel = 3'b001; sub = 0; #10; $display("SLT: %h, zero: %b", ALU_Out, zero);
//         ALU_Sel = 3'b010; #10; $display("AND: %h, zero: %b", ALU_Out, zero);
//         ALU_Sel = 3'b011; #10; $display("OR: %h, zero: %b", ALU_Out, zero);
//         ALU_Sel = 3'b100; #10; $display("XOR: %h, zero: %b", ALU_Out, zero);
//         ALU_Sel = 3'b101; #10; $display("SRA: %h, zero: %b", ALU_Out, zero);
//         ALU_Sel = 3'b110; #10; $display("SLL: %h, zero: %b", ALU_Out, zero);
//         ALU_Sel = 3'b111; #10; $display("SRL: %h, zero: %b", ALU_Out, zero);

//         $display("ALU Testbench Finished");
//         $finish;
//     end
// endmodule