# Production Plan

The first hardware revision should be designed around measured RTL resource and timing requirements.

## Rev A target
- FPGA with sufficient LUTs, BRAM and DSP.
- External DDR3/DDR3L or DDR4.
- SPI configuration flash.
- microSD.
- HDMI physical interface.
- USB controller interface.
- Optional I2S audio.
- Minimal regulators and clock source.
- Test pads.

## Gate before PCB
Do not freeze the FPGA choice before synthesis and timing reports exist for CPU, RSP, RDP and memory.

## Stages
1. RTL simulation.
2. FPGA synthesis.
3. Timing closure.
4. Video/audio/controller validation.
5. Save/ROM validation.
6. Power and thermal measurements.
7. PCB revision.
8. Small hardware run.
9. ASIC feasibility after architecture stabilization.
