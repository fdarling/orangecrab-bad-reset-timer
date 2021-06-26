`timescale 1ns/1ps

module tb_top();
    reg clk;

    localparam CLOCK_HZ = 100000000;

    top top_inst
    (
        .clk48(clk)
    );

    initial begin
        clk = 0;
        $printtimescale(tb_top);
        $dumpfile("tb_top.vcd");
        $dumpvars(0, tb_top);
        #500 $finish;
    end

    always begin
        #10 clk = ~clk;
    end
endmodule
