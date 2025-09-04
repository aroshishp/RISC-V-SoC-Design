module Multi_Stage_tb();

    reg clk = 1'b0;
    reg rst;

    Memory_Top Memory_Top(
        .clk(clk),
        .rst(rst)
    );

    initial begin
        $dumpfile("SS.vcd");
        $dumpvars(0, Memory_Top);
    end

    always begin
        clk = ~clk;
        #50;
    end

    initial begin
        rst = 1'b1;
        #500;

        rst = 1'b0;
        #110000;
        $finish;
    end
endmodule