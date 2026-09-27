IVERILOG ?= iverilog
VVP ?= vvp
RTL := rtl/core/n64oc_top.sv rtl/core/n64oc_pkg.sv rtl/bus/n64oc_bus.sv
TB := sim/tb_n64oc_top.sv

.PHONY: all lint sim clean
all: lint sim

lint:
	$(IVERILOG) -g2012 -t null $(RTL)

sim:
	mkdir -p build
	$(IVERILOG) -g2012 -o build/n64oc_tb $(RTL) $(TB)
	$(VVP) build/n64oc_tb

clean:
	rm -rf build
