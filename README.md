# OrangeCrab bad reset timer behavior

## Problem

the `reset_timer` module is supposed to assert the `reset_out` output high for a certain amount of clock cycles determined by a saturating down-counter. Once the counter reaches zero, it's supposed to deassert `reset_out`. For some reason under synthesis it's behaving as an auto-restarting timer rather than a single-shot one.

## Simulation

The top module under simulation with a 100MHz clock (clock speed is irrelevant for simulation):

![Screenshot_2021-06-26_17-27-37](https://user-images.githubusercontent.com/1173876/123527291-db2b6680-d6a3-11eb-8c71-80e188c48115.png)

Commands to run simulation:

```sh
make
gtkwave tb_top.vcd
```

## Reality

The top module synthesized and running on an OrangeCrab:

![Screenshot_2021-06-26_17-25-39](https://user-images.githubusercontent.com/1173876/123527289-d8307600-d6a3-11eb-9368-3d6d7ce56350.png)

Commands for compiling/flashing:

```sh
source env.sh
make dfu
```
