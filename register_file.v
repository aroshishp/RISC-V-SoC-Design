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

// assign registers[0] = 64'b0;

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

// File dump on any register change - moved to separate always block
always @(*) begin
    if (RegWrite && WriteReg != 5'b0) begin
        // Dump all register values to a file for debugging
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
    // registers[3] = 64'd3; // x3 is initialized to 3
    // registers[4] = 64'd4; // x4 is initialized to 4
    // registers[6] = 64'd6;
    // registers[7] = 64'd2;
    // registers[7] = 64'd8;
    // registers[13] = 64'd6;
    // registers[12] = 64'd5;


    // registers[10] = 64'd1;  
    // registers[11] = 64'd5;
    // registers[20] = 64'd3;
    // registers[17] = 64'd2;

    // registers[28] = 64'd0;
    // registers[29] = 64'd0;
    // registers[30] = 64'd0;
    // registers[31] = 64'd0;  

    // registers[6] = 64'd12;
    // registers[5] = 64'd3;

    // registers[20] = 64'd3;
    // registers[21] = 64'd3;
    // $monitor("Time: %0t | ReadData1: %h | ReadData2: %h | WriteData: %h", $time, ReadData1, ReadData2, WriteData);
end
endmodule