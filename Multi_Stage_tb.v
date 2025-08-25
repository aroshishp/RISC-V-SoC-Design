module Single_Stage_tb();

    reg clk = 1'b0;
    reg rst;

    Single_Stage_Top Single_Stage_Top(
        .clk(clk),
        .rst(rst)
    );

    initial begin
        $dumpfile("SS.vcd");
        $dumpvars(0, Single_Stage_Top);
    end

    always begin
        clk = ~clk;
        #50;
    end

    initial begin
        rst = 1'b1;
        #500;

        rst = 1'b0;
        #100000;
        $finish;
    end
endmodule