module register_file(
    input [4:0] ReadReg1, //src reg
    input [4:0] ReadReg2, //src reg
    input [4:0] WriteReg, //destination reg
    input [63:0] WriteData, //data to write
    input rst,
    input RegWrite, //control signal

    output [63:0] ReadData1,
    output [63:0] ReadData2
);

reg [63:0] registers [31:0];

assign ReadData1 = (rst == 1'b1 || ReadReg1 == 5'b0) ? 64'b0 : registers[ReadReg1];
assign ReadData2 = (rst == 1'b1 || ReadReg2 == 5'b0) ? 64'b0 : registers[ReadReg2];

integer fd;
integer i;

// Write to register file - combinational for immediate effect
always @(*) begin
    if (RegWrite && WriteReg != 5'b0) begin
        registers[WriteReg] = WriteData;
    end
    // $display("Write: %0d | Data: %h", WriteReg, WriteData);
end

// File dump on any register change 
always @(*) begin
    if (RegWrite && WriteReg != 5'b0) begin
        fd = $fopen("registers_dump.txt", "w");
        if (fd) begin
            $fdisplay(fd, "Register file dump at time %0t:", $time);
            for (i = 0; i < 32; i = i + 1) begin
                $fdisplay(fd, "x%0d: %d", i, $signed(registers[i]));
            end
            $fclose(fd);
        end
    end
end

// always@(*) begin
//     $display("ReadReg1: %h | ReadReg2: %h", ReadReg1, ReadReg2);
// end

initial begin
    for (i = 0; i < 32; i = i + 1) begin
        registers[i] = 64'b0;
    end
end
initial begin
    //registers[0] = 64'd0;
    //registers[1] = 64'd0;
    //registers[2] = 64'd0;
    //registers[3] = 64'd0;
    //registers[4] = 64'd0;
    //registers[5] = 64'd0;
    //registers[6] = 64'd0;
    //registers[7] = 64'd0;
    //registers[8] = 64'd0;
    //registers[9] = 64'd0;
    //registers[10] = 64'd0;
    //registers[11] = 64'd0;
    //registers[12] = 64'd0;
    //registers[13] = 64'd0;
    //registers[14] = 64'd0;
    //registers[15] = 64'd0;
    //registers[16] = 64'd0;
    //registers[17] = 64'd0;
    //registers[18] = 64'd0;
    //registers[19] = 64'd0;
    //registers[20] = 64'd0;
    //registers[21] = 64'd0;
    //registers[22] = 64'd0;
    //registers[23] = 64'd0;
    //registers[24] = 64'd0;
    //registers[25] = 64'd0;
    //registers[26] = 64'd0;
    //registers[27] = 64'd0;
    //registers[28] = 64'd0;
    //registers[29] = 64'd0;
    //registers[30] = 64'd0;
    //registers[31] = 64'd0;
end
endmodule