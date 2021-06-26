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
    output wire DEBUG8,
    output wire DEBUG9,

    output wire ETH_CLK,
    output wire ETH_MDC,
    inout  wire ETH_MDIO,
    input wire ETH_CRS_DV,
    input wire [1:0] ETH_RX,
    output wire ETH_TX_EN,
    output wire [1:0] ETH_TX,

    output reg rst_n,
    input wire usr_btn,
    inout wire usb_d_p,
    inout wire usb_d_n,
    output wire usb_pullup
);
    localparam CLOCK_HZ = 48000000;

    // inter-modular wires
    wire       usb_uart_reset;
    wire       usb_uart_tx_ready;
    wire [7:0] tx_byte;
    wire       tx_byte_valid;
    wire       tx_finishing;

    // sub-modules
    wire [7:0] reset_counter;
    wire       counter_non_zero;
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

    // state

    // initial state
    initial begin
        rst_n = 1'b1;
    end

    // state change
    always @(posedge clk48) begin
        rst_n <= usr_btn;
    end

    // output logic
    assign rgb_led0_r = 1;
    assign rgb_led0_g = 1;
    assign rgb_led0_b = 1;
    assign usb_pullup = 1'b1;
    assign ETH_CLK = 1'b0;
    assign ETH_MDC = 1'b0;
    assign ETH_MDIO = 1'bz;
    assign ETH_TX_EN = 1'b0;
    assign ETH_TX = 2'b00;
    // assign {DEBUG9, DEBUG8, DEBUG7, DEBUG6, DEBUG5, DEBUG4, DEBUG3, DEBUG2, DEBUG1, DEBUG0} = 10'd0;
    // assign {DEBUG9, DEBUG8, DEBUG7, DEBUG6, DEBUG5, DEBUG4, DEBUG3, DEBUG2, DEBUG1, DEBUG0} = {reset_counter, usb_uart_reset, clk48};
    assign {DEBUG9, DEBUG8, DEBUG7, DEBUG6, DEBUG5, DEBUG4, DEBUG3, DEBUG2, DEBUG1, DEBUG0} = {reset_counter[6:0], counter_non_zero, usb_uart_reset, clk48};
endmodule
