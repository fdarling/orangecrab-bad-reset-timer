# OrangeCrab bad reset timer behavior

## Problem

the `reset_timer` module is supposed to assert the `usb_uart_reset` output high for a certain amount of clock cycles determined by a saturating down-counter. Once the counter reaches zero, it's supposed to deassert `usb_uart_reset`. For some reason under synthesis it's behaving as an auto-restarting timer rather than a single-shot one. I have similar logic to what is inside `reset_timer` in the `top` module, and it works as expected...

## Simulation

The top module under simulation with a 100MHz clock (clock speed is irrelevant for simulation):

![Simulation](https://user-images.githubusercontent.com/1173876/123530929-8698e300-d6c5-11eb-967f-84bb28f1bb12.png)

Commands to run simulation:

```sh
make
gtkwave tb_top.vcd
```

## Reality

The top module synthesized and running on an OrangeCrab:

![Reality](https://user-images.githubusercontent.com/1173876/123530925-7f71d500-d6c5-11eb-9cd8-0f99730ca802.png)

Commands for compiling/flashing:

```sh
source env.sh
make dfu
```
