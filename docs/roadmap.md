# Roadmap

The target milestone is **software compatibility sufficient to boot Super Mario 64**, initially stopping at the title screen. The project deliberately uses modern external memory/storage and does not aim for transistor-level or cycle-perfect N64 reproduction.

## M0 Infrastructure
- [x] Repository scaffold
- [x] SystemVerilog package
- [x] Initial bus interface
- [x] Top-level smoke test
- [x] CI with Icarus/Verilator
- [x] CPU instruction smoke test
- [x] Cartridge ROM smoke test
- [x] Video bring-up pattern
- [x] Integrated CPU reset-vector + RDRAM smoke test

## M1 CPU and boot path

Status: **in progress**

### M1.1 Bring-up foundation
- [x] Integer register file
- [x] Fetch/decode
- [x] ALU
- [x] Branches/jumps
- [x] Basic load/store
- [x] Reset vector at 0xBFC00000
- [x] Boot ROM mapped into reset vector
- [x] 8 MiB RDRAM model
- [x] CPU → memory decoder
- [x] Automated integrated boot test

### M1.2 VR4300-compatible integer core
- [ ] HI/LO registers
- [ ] Multiply/divide instructions
- [ ] Full MIPS III 64-bit integer instruction set
- [ ] CP0 registers
- [ ] Exceptions and interrupts
- [ ] TLB
- [ ] Instruction/data caches
- [ ] Unaligned load/store instructions
- [ ] Correct MIPS/N64 big-endian memory semantics
- [ ] FPU / COP1

### M1.3 Cartridge and boot compatibility
- [ ] N64 cartridge address mapping
- [ ] PI-compatible ROM reads
- [ ] PIF boot model
- [ ] IPL1/IPL2-compatible boot flow
- [ ] IPL3-compatible environment
- [ ] RDRAM initialization behavior
- [ ] ROM header/checksum handling

## M2 RCP

- [ ] SP DMEM/IMEM
- [ ] RSP scalar ISA
- [ ] RSP vector ISA
- [ ] SP DMA
- [ ] DP command FIFO
- [ ] RDP command parser
- [ ] Triangle setup/rasterization
- [ ] Texture pipeline
- [ ] Combiner/blender
- [ ] Depth buffer

## M3 Peripherals

- [ ] MI
- [ ] VI
- [ ] AI
- [ ] PI
- [ ] RI
- [ ] SI
- [ ] PIF/JoyBus

## M4 Platform

- [ ] DDR3/DDR4 wrapper
- [ ] SPI boot flash
- [ ] microSD ROM loader
- [ ] Save backend
- [ ] HDMI output
- [ ] I2S audio
- [ ] USB controllers

## M5 Mario 64 compatibility milestone

- [ ] CPU passes focused MIPS III instruction tests
- [ ] Boot ROM/PIF path reaches cartridge entrypoint
- [ ] Super Mario 64 ROM can be loaded externally
- [ ] RSP executes the game's required microcode
- [ ] VI produces a software-driven framebuffer
- [ ] RDP renders the first title-screen frame
- [ ] Title screen remains stable for at least 30 seconds
- [ ] USB controller input reaches the game
- [ ] Save/EEPROM path is functional

## M6 Hardware

- [ ] FPGA target selection
- [ ] Schematic
- [ ] PCB Rev A
- [ ] Bring-up
- [ ] BOM
- [ ] Thermal/power validation
- [ ] ASIC feasibility study
