# OrangeCrab bad reset timer behavior

## Problem

The `reset_timer` module is supposed to assert the `usb_uart_reset` output high for a certain amount of clock cycles determined by a saturating down-counter. Once the counter reaches zero, it's supposed to deassert `usb_uart_reset`. For some reason under synthesis it's behaving as an auto-restarting timer rather than a single-shot one.

There is a nearly identical module `reset_timer_hardcoded` that avoids the use of parameters in favor of hard-coding values, and it works as expected. This means the `initial` block and `parameter`s aren't working together correctly...

## Solution

The issue was a `localparam` declaration not evaluating to the correct value of `11`, but instead was becoming `-1` (`0xFFFFFFFF` in 32-bit 2's complement). A side effect was that the counter was 32-bit instead of 2-bit due to taking the base 2 logarithm of that `localparam`.

This was because a multiply/division portion of the expression was evaluating to `0`, and after subtracting `1` it became `-1`. The underlying issue was the operands to the multiplication / division were all 32-bit (implicitly apparently, not explicitly), and it wasn't promoting it to 64-bit during the multiplicatin, but rather was truncating it to 32-bit (too early) and since the intermediate value was in the upper 32-bits of the 64-bit result, this truncation resulted in `0`.

The workaround was to multiply by `64'd1` first thing in the expression, which tricked `yosys` into promoting everything following to 64-bit.

## Simulation

The top module under simulation with a 100MHz clock (clock speed is irrelevant for simulation):

![Simulation](https://user-images.githubusercontent.com/1173876/123531576-50f6f880-d6cb-11eb-89a6-480cd1aae4d0.png)

Commands to run simulation:

```sh
make
gtkwave tb_top.vcd
```

## Reality

The top module synthesized and running on an OrangeCrab:

![Reality](https://user-images.githubusercontent.com/1173876/123531579-548a7f80-d6cb-11eb-9837-a26799487f5c.png)

Commands for compiling/flashing:

```sh
source env.sh
make dfu
```
