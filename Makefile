IVERILOG ?= iverilog
VVP ?= vvp

RTL_COMMON := rtl/core/n64oc_top.sv rtl/core/n64oc_pkg.sv rtl/bus/n64oc_bus.sv rtl/video/n64oc_test_video.sv
CPU_RTL := rtl/cpu/n64oc_mips_core.sv
SOC_RTL := $(CPU_RTL) rtl/core/n64oc_soc.sv rtl/memory/n64oc_bootrom.sv rtl/memory/n64oc_rdram.sv
TOP_TB := sim/tb_n64oc_top.sv
CPU_TB := sim/tb_n64oc_mips_core.sv
SOC_TB := sim/tb_n64oc_soc.sv

.PHONY: all lint sim test-cpu test-cart test-top test-soc clean

all: lint sim

lint:
	$(IVERILOG) -g2012 -t null $(RTL_COMMON) $(SOC_RTL)

sim: test-cpu test-cart test-top test-soc

test-cpu:
	mkdir -p build
	$(IVERILOG) -g2012 -o build/n64oc_cpu_tb $(CPU_RTL) $(CPU_TB)
	$(VVP) build/n64oc_cpu_tb

test-cart:
	mkdir -p build
	$(IVERILOG) -g2012 -o build/n64oc_cart_tb rtl/memory/n64oc_cart_rom.sv sim/tb_n64oc_cart_rom.sv
	$(VVP) build/n64oc_cart_tb

test-top:
	mkdir -p build
	$(IVERILOG) -g2012 -o build/n64oc_top_tb $(RTL_COMMON) $(TOP_TB)
	$(VVP) build/n64oc_top_tb

test-soc:
	mkdir -p build
	$(IVERILOG) -g2012 -o build/n64oc_soc_tb $(SOC_RTL) $(SOC_TB)
	$(VVP) build/n64oc_soc_tb

clean:
	rm -rf build
