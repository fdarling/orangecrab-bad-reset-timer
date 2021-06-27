`default_nettype none

module reset_timer_hardcoded
(
    input wire clk,
    output reg reset_out,
    output wire [3:0] counter_out,
    output wire       counter_non_zero
);
    // parameters
    localparam COUNTER_MAX = 11;

    // state
    reg [3:0] counter;

    // initial state
    initial begin
        counter = COUNTER_MAX;
        reset_out = 1'b1;
    end

    // state change
    always @(posedge clk) begin
        if (counter != 0) begin
            counter <= counter - 1;
        end
        else begin
            reset_out <= 1'b0;
        end
    end

    // output logic
    assign counter_out = counter;
    assign counter_non_zero = counter != 0;
endmodule
