PROJ=bad_reset_timer

TOP_MODULE = top
VERILOG_SOURCES = \
	src/top.v \
	src/reset_timer.v \
	src/reset_timer_hardcoded.v

all: $(PROJ).dfu

dfu: $(PROJ).dfu
	dfu-util -D $<

%.json: $(VERILOG_SOURCES)
	yosys -p "synth_ecp5 -json $@ -top $(TOP_MODULE)" $(VERILOG_SOURCES)

%_out.config: %.json orangecrab_r0.2.pcf
	nextpnr-ecp5 --json $< --textcfg $@ --25k --package CSFBGA285 --lpf orangecrab_r0.2.pcf

%.bit: %_out.config
	ecppack --compress --freq 38.8 --input $< --bit $@

%.dfu : %.bit
	cp $< $@
	dfu-suffix -v 1209 -p 5af0 -a $@

clean:
	rm -f $(PROJ).svf $(PROJ).bit $(PROJ).config $(PROJ).json $(PROJ).dfu

.PHONY: all dfu clean
