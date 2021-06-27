`default_nettype none

module top
(
    input wire clk48,

    output wire rgb_led0_r,
    output wire rgb_led0_g,
    output wire rgb_led0_b,

    output wire DEBUG0,
    output wire DEBUG1,
    output wire DEBUG2,
    output wire DEBUG3,
    output wire DEBUG4,
    output wire DEBUG5,
    output wire DEBUG6,
    output wire DEBUG7,

    output reg rst_n,
    input wire usr_btn,
    output wire usb_pullup
);
    localparam CLOCK_HZ = 48000000;

    // inter-modular wires
    wire       usb_uart_reset;
    wire [7:0] reset_counter;
    wire       counter_non_zero;

    // state
    reg reset2 = 1'b1;
    reg [3:0] counter2 = 11;

    // sub-modules
    reset_timer
    #(
        .CLOCK_HZ(CLOCK_HZ),
        .TIME_NS(255)
    )
    usb_uart_reset_inst
    (
        .clk(clk48),
        .reset_out(usb_uart_reset),
        .counter_out(reset_counter),
        .counter_non_zero(counter_non_zero)
    );

    // initial state
    initial begin
        rst_n = 1'b1;
    end

    // state change
    always @(posedge clk48) begin
        rst_n <= usr_btn;
        if (counter2 != 0) begin
            counter2 <= counter2 - 1;
        end
        else begin
            reset2 <= 1'b0;
        end
    end

    // output logic
    assign rgb_led0_r = 1;
    assign rgb_led0_g = 1;
    assign rgb_led0_b = 1;
    assign usb_pullup = 1'b1;
    assign DEBUG0 = clk48;
    assign DEBUG1 = usb_uart_reset;
    assign DEBUG2 = counter_non_zero;
    assign DEBUG3 = reset_counter[0];
    assign DEBUG4 = reset_counter[1];
    assign DEBUG5 = reset2;
    assign DEBUG6 = counter2[0];
    assign DEBUG7 = counter2[1];
endmodule
