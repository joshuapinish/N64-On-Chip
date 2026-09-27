# Roadmap

## M0 Infrastructure
- [x] Repository scaffold
- [x] SystemVerilog package
- [x] Initial bus interface
- [x] Top-level smoke test
- [ ] CI with Icarus/Verilator

## M1 CPU
- [ ] Integer register file
- [ ] Fetch/decode
- [ ] ALU
- [ ] HI/LO
- [ ] Branches/jumps
- [ ] Load/store
- [ ] CP0
- [ ] Exceptions/interrupts
- [ ] TLB
- [ ] Instruction/data caches
- [ ] Floating point

## M2 RCP
- [ ] SP DMEM/IMEM
- [ ] RSP scalar ISA
- [ ] RSP vector ISA
- [ ] SP DMA
- [ ] DP command FIFO
- [ ] RDP pipeline

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

## M5 Validation
- [ ] CPU instruction tests
- [ ] RSP instruction tests
- [ ] RDP tests
- [ ] Peripheral tests
- [ ] ROM boot tests
- [ ] Compatibility matrix
- [ ] FPGA timing/resource reports

## M6 Hardware
- [ ] FPGA target selection
- [ ] Schematic
- [ ] PCB Rev A
- [ ] Bring-up
- [ ] BOM
- [ ] Thermal/power validation
- [ ] ASIC feasibility study
