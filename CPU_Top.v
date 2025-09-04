`include "register_file.v"
`include "ALU.v"
`include "control_unit_alu.v"
`include "control_unit_main.v"
`include "PC_block.v"
`include "Mux.v"
`include "PC_Adder.v"
`include "Imm_Gen.v"
`include "Mux_4_1.v"
`include "forwarding_unit.v"
`include "Hazard_det_unit.v"

module CPU_Top(
    input clk,
    input rst,

    output [63:0] IMEM_address,
    input [31:0] IMEM_instruction,

    output [63:0] DMEM_address,
    output [63:0] DMEM_WriteData,
    output DMEM_MemWrite,
    output DMEM_MemRead,
    input [63:0] DMEM_ReadData
);

//LEFT TO RIGHT

// -------- First Stage --------

wire [63:0] PC_NEXT;
wire [63:0] PC_CURR;

Mux PC_Update_Mux(
    .a(PC_NEXT_REG),
    .b(EX_MEM_PC_NEXT_IMM),
    .s(Flush),
    .c(PC_NEXT)
);

PC_block PC_block (
    .clk(clk),
    .rst(rst),
    .stall(stall),
    .PC_NEXT(PC_NEXT),
    .PC(PC_CURR)
);

wire [63:0] PC_NEXT_REG;

PC_Adder PC_Adder_Regular(
    .a(PC_CURR),
    .b(64'd4),
    .c(PC_NEXT_REG)
);

wire [31:0] INSTRUCTION_BUS;

// instruction_memory instruction_memory(
//     .PC(PC_CURR),
//     .rst(rst),
//     .instruction(INSTRUCTION_BUS)
// );

assign IMEM_address = PC_CURR;
assign INSTRUCTION_BUS = IMEM_instruction;

// IF/ID
reg [31:0] IF_ID_INSTRUCTION_BUS;
reg [63:0] IF_ID_PC_CURR; 

always@(posedge clk) begin
    if (rst || Flush) begin
        IF_ID_INSTRUCTION_BUS <= 32'b0;
        IF_ID_PC_CURR <= 64'b0;
    end else begin
        IF_ID_INSTRUCTION_BUS <= INSTRUCTION_BUS;
        IF_ID_PC_CURR <= PC_CURR;
    end
end



// -------- Second Stage --------

wire Branch;
wire MemRead;
wire MemtoReg;
wire [2:0] ALUOp;
wire MemWrite;
wire ALUSrc;
wire RegWrite;
wire [1:0] Imm_Src;

control_unit_main control_unit_main(
    .opcode(IF_ID_INSTRUCTION_BUS[6:0]),
    .Branch(Branch),
    .MemRead(MemRead),
    .MemtoReg(MemtoReg),
    .ALUOp(ALUOp),
    .MemWrite(MemWrite),
    .ALUSrc(ALUSrc),
    .RegWrite(RegWrite),
    .Imm_Src(Imm_Src)
);

wire [63:0] WRITE_DATA;
wire [63:0] READ_DATA1;
wire [63:0] READ_DATA2;

register_file register_file(
    .ReadReg1(IF_ID_INSTRUCTION_BUS[19:15]),
    .ReadReg2(IF_ID_INSTRUCTION_BUS[24:20]),
    .WriteReg(MEM_WB_INSTRUCTION_11_7),
    .WriteData(WRITE_DATA),
    // .clk(clk),
    .rst(rst),
    .RegWrite(MEM_WB_RegWrite),
    .ReadData1(READ_DATA1),
    .ReadData2(READ_DATA2)
);

wire [63:0] IMM_OUT;

Imm_Gen Imm_Gen(
    .imm_in(IF_ID_INSTRUCTION_BUS),
    .imm_src(Imm_Src),
    .imm_out(IMM_OUT)
);

wire stall;

hazard_detection_unit hazard_detection_unit(
    .rs1(IF_ID_INSTRUCTION_BUS[19:15]),
    .rs2(IF_ID_INSTRUCTION_BUS[24:20]),
    .rd(ID_EX_INSTRUCTION_11_7),
    .mem_read_1(ID_EX_MemRead),
    .mem_read_2(EX_MEM_MemRead),
    .branch(Branch),
    .opcode(ID_EX_INSTRUCTION_OPCODE),
    .stall(stall)
);

// ID/EX REGISTER
reg [6:0] ID_EX_INSTRUCTION_OPCODE;
reg [4:0] ID_EX_INSTRUCTION_11_7;
reg [3:0] ID_EX_INSTRUCTION_30_14_12;
reg [4:0] ID_EX_INSTRUCTION_19_15; // RS1
reg [4:0] ID_EX_INSTRUCTION_24_20; // RS2
reg [63:0] ID_EX_IMM_OUT;
reg [63:0] ID_EX_READ_DATA2;
reg [63:0] ID_EX_READ_DATA1;
reg [63:0] ID_EX_PC_CURR;
reg ID_EX_RegWrite;
reg ID_EX_ALUSrc;
reg ID_EX_MemWrite;
reg [2:0] ID_EX_ALUOp;
reg ID_EX_MemtoReg;
reg ID_EX_MemRead;
reg ID_EX_Branch;


always@(posedge clk) begin
    if (rst || Flush) begin
        ID_EX_INSTRUCTION_OPCODE <= 7'b0;
        ID_EX_INSTRUCTION_11_7 <= 5'b0;
        ID_EX_INSTRUCTION_30_14_12 <= 4'b0;
        ID_EX_INSTRUCTION_19_15 <= 5'b0;
        ID_EX_INSTRUCTION_24_20 <= 5'b0;
        ID_EX_IMM_OUT <= 64'b0;
        ID_EX_READ_DATA2 <= 64'b0;
        ID_EX_READ_DATA1 <= 64'b0;
        ID_EX_PC_CURR <= 64'b0;
        ID_EX_RegWrite <= 1'b0;
        ID_EX_ALUSrc <= 1'b0;
        ID_EX_MemWrite <= 1'b0;
        ID_EX_ALUOp <= 3'b0;
        ID_EX_MemtoReg <= 1'b0;
        ID_EX_MemRead <= 1'b0;
        ID_EX_Branch <= 1'b0;
    end else if(stall) begin
        ID_EX_RegWrite <= 0;
        ID_EX_ALUSrc <= 0;
        ID_EX_MemWrite <= 0;
        ID_EX_ALUOp <= 0;
        ID_EX_MemtoReg <= 0;
        ID_EX_MemRead <= 0;
        ID_EX_Branch <= 0;
    end else begin
        ID_EX_INSTRUCTION_OPCODE <= IF_ID_INSTRUCTION_BUS[6:0];
        ID_EX_INSTRUCTION_11_7 <= IF_ID_INSTRUCTION_BUS[11:7];
        ID_EX_INSTRUCTION_30_14_12 <= {IF_ID_INSTRUCTION_BUS[30], IF_ID_INSTRUCTION_BUS[14:12]};
        ID_EX_INSTRUCTION_19_15 <= IF_ID_INSTRUCTION_BUS[19:15];
        ID_EX_INSTRUCTION_24_20 <= IF_ID_INSTRUCTION_BUS[24:20];
        ID_EX_IMM_OUT <= IMM_OUT;
        ID_EX_READ_DATA2 <= READ_DATA2;
        ID_EX_READ_DATA1 <= READ_DATA1;
        ID_EX_PC_CURR <= IF_ID_PC_CURR;
        ID_EX_RegWrite <= RegWrite;
        ID_EX_ALUSrc <= ALUSrc;
        ID_EX_MemWrite <= MemWrite;
        ID_EX_ALUOp <= ALUOp;
        ID_EX_MemtoReg <= MemtoReg;
        ID_EX_MemRead <= MemRead;
        ID_EX_Branch <= Branch;
    end
end


// -------- Third Stage --------

wire [2:0] ALUCONTROL;
wire SUB;

control_unit_alu control_unit_alu(
    .ALUOp(ID_EX_ALUOp),
    .funct(ID_EX_INSTRUCTION_30_14_12),
    .ALUControl(ALUCONTROL),
    .sub(SUB)
);

wire [63:0] ID_EX_READ_DATA2_IMM;

Mux Imm_Sel (
    .a(ID_EX_READ_DATA2),
    .b(ID_EX_IMM_OUT),
    .c(ID_EX_READ_DATA2_IMM),
    .s(ID_EX_ALUSrc)
);

wire [63:0] ALU_B;
wire [63:0] ALU_A;

wire [1:0] Forward_A;
wire [1:0] Forward_B;

forwarding_unit forwarding_unit(
    .ID_EX_RS1(ID_EX_INSTRUCTION_19_15),
    .ID_EX_RS2(ID_EX_INSTRUCTION_24_20),
    .EX_MEM_RD(EX_MEM_INSTRUCTION_11_7),
    .MEM_WB_RD(MEM_WB_INSTRUCTION_11_7),
    .EX_MEM_RegWrite(EX_MEM_RegWrite),
    .MEM_WB_RegWrite(MEM_WB_RegWrite),
    .Forward_A(Forward_A),
    .Forward_B(Forward_B)
);

Mux_4_1 ALU_Mux_A(
    .a(ID_EX_READ_DATA1),
    .b(WRITE_DATA),
    .c(EX_MEM_ALU_OUT),
    .d(64'b0),
    .s(Forward_A),
    .y(ALU_A)
);

Mux_4_1 ALU_Mux_B(
    .a(ID_EX_READ_DATA2_IMM),
    .b(WRITE_DATA),
    .c(EX_MEM_ALU_OUT),
    .d(ID_EX_READ_DATA2),
    .s(Forward_B),
    .y(ALU_B)
);

wire [63:0] ALU_OUT;
wire ALU_ZERO;
wire ALU_CARRY;

ALU ALU(
    .A(ALU_A),
    .B(ALU_B),
    .ALU_Sel(ALUCONTROL),
    .sub(SUB),
    .ALU_Out(ALU_OUT),
    .Carry_out(ALU_CARRY),
    .zero(ALU_ZERO)
);

wire [63:0] PC_NEXT_IMM;

PC_Adder PC_Adder_Imm(
    .a(ID_EX_PC_CURR),
    .b(ID_EX_IMM_OUT),
    .c(PC_NEXT_IMM)
);

reg [3:0] EX_MEM_INSTRUCTION_30_14_12;
reg [6:0] EX_MEM_OPCODE;
reg [4:0] EX_MEM_INSTRUCTION_11_7;
reg [63:0] EX_MEM_READ_DATA_2;
reg [63:0] EX_MEM_ALU_OUT;
reg EX_MEM_zero;
reg [63:0] EX_MEM_PC_NEXT_IMM;
reg EX_MEM_RegWrite;
reg EX_MEM_MemWrite;
reg EX_MEM_MemtoReg;
reg EX_MEM_MemRead;
reg EX_MEM_Branch;

always@(posedge clk) begin
    if (rst || Flush) begin
        EX_MEM_INSTRUCTION_30_14_12 <= 4'b0;
        EX_MEM_OPCODE <= 7'b0;
        EX_MEM_INSTRUCTION_11_7 <= 5'b0;
        EX_MEM_READ_DATA_2 <= 64'b0;
        EX_MEM_ALU_OUT <= 64'b0;
        EX_MEM_zero <= 1'b0;
        EX_MEM_PC_NEXT_IMM <= 64'b0;
        EX_MEM_RegWrite <= 1'b0;
        EX_MEM_MemWrite <= 1'b0;
        EX_MEM_MemtoReg <= 1'b0;
        EX_MEM_MemRead <= 1'b0;
        EX_MEM_Branch <= 1'b0;
    end else begin
        EX_MEM_INSTRUCTION_30_14_12 <= ID_EX_INSTRUCTION_30_14_12;
        EX_MEM_OPCODE <= ID_EX_INSTRUCTION_OPCODE;
        EX_MEM_INSTRUCTION_11_7 <= ID_EX_INSTRUCTION_11_7;
        EX_MEM_READ_DATA_2 <= ID_EX_READ_DATA2;
        EX_MEM_ALU_OUT <= ALU_OUT;
        EX_MEM_zero <= ALU_ZERO;
        EX_MEM_PC_NEXT_IMM <= PC_NEXT_IMM;
        EX_MEM_RegWrite <= ID_EX_RegWrite;
        EX_MEM_MemWrite <= ID_EX_MemWrite;
        EX_MEM_MemtoReg <= ID_EX_MemtoReg;
        EX_MEM_MemRead <= ID_EX_MemRead;
        EX_MEM_Branch <= ID_EX_Branch;

    end
end



// -------- Fourth Stage --------

wire [63:0] DMEM_READ_DATA;

// data_memory data_memory(
//     .address(EX_MEM_ALU_OUT),
//     .WriteData(EX_MEM_READ_DATA_2),
//     .zero(EX_MEM_zero),
//     .MemWrite(EX_MEM_MemWrite),
//     .MemRead(EX_MEM_MemRead),
//     // .clk(clk),
//     .rst(rst),
//     .ReadData(DMEM_READ_DATA)
// );

assign DMEM_address = EX_MEM_ALU_OUT;
assign DMEM_WriteData = EX_MEM_READ_DATA_2;
assign DMEM_MemWrite = EX_MEM_MemWrite;
assign DMEM_MemRead = EX_MEM_MemRead;

assign DMEM_READ_DATA = DMEM_ReadData;

wire Flush;

assign Flush = (EX_MEM_Branch & ((EX_MEM_zero & (EX_MEM_INSTRUCTION_30_14_12[2:0] == 3'b000)) || //beq
                                  (EX_MEM_ALU_OUT[63] & (EX_MEM_INSTRUCTION_30_14_12[2:0] == 3'b100)) || //blt
                                  (!EX_MEM_ALU_OUT[63] & (EX_MEM_INSTRUCTION_30_14_12[2:0] == 3'b101)) || //bge
                                  ((!EX_MEM_zero) & (EX_MEM_INSTRUCTION_30_14_12[2:0] == 3'b001)) //bne
                                )) || EX_MEM_OPCODE == 7'b1101111; //jump

// always@(*) begin
//     $display("Time: %0t, EX_MEM_ALU_OUT[63]: %b, EX_MEM_Branch: %b, Flush: %b", $time, EX_MEM_ALU_OUT[63], EX_MEM_Branch, Flush);
// end

// MEM/WB Register
reg [4:0] MEM_WB_INSTRUCTION_11_7;
reg [63:0] MEM_WB_ALU_OUT;
reg [63:0] MEM_WB_DMEM_READ_DATA;
reg MEM_WB_RegWrite;
reg MEM_WB_MemtoReg;

// initial begin
//     // $monitor("ALU_OUT: %h", MEM_WB_ALU_OUT);
//     // $monitor("DMEM_READ_DATA: %h", MEM_WB_DMEM_READ_DATA);
// end

always@(posedge clk) begin
    if (rst) begin
        MEM_WB_INSTRUCTION_11_7 <= 5'b0;
        MEM_WB_ALU_OUT <= 64'b0;
        MEM_WB_DMEM_READ_DATA <= 64'b0;
        MEM_WB_RegWrite <= 1'b0;
        MEM_WB_MemtoReg <= 1'b0;
    end else begin
        MEM_WB_INSTRUCTION_11_7 <= EX_MEM_INSTRUCTION_11_7;
        MEM_WB_ALU_OUT <= EX_MEM_ALU_OUT;
        MEM_WB_DMEM_READ_DATA <= DMEM_READ_DATA;
        MEM_WB_RegWrite <= EX_MEM_RegWrite;
        MEM_WB_MemtoReg <= EX_MEM_MemtoReg;
    end
end

Mux Write_Back_Mux(
    .a(MEM_WB_ALU_OUT),
    .b(MEM_WB_DMEM_READ_DATA),
    .s(MEM_WB_MemtoReg),
    .c(WRITE_DATA)
);

endmodule