# Architecture

N64-On-Chip targets practical software compatibility rather than cycle-perfect reproduction.

The physical implementation may differ from the original console while preserving the observable behavior required by software.

## Major blocks

### CPU
MIPS-compatible 64-bit execution, CP0, exceptions, memory management, caches and floating-point behavior.

### RSP
Scalar/control execution plus a 128-bit vector unit and SP DMA.

### RDP
Command-driven raster pipeline with triangle setup, textures, combiner/blender logic and depth processing.

### Peripherals
MI, VI, AI, PI, SI and PIF/JoyBus-compatible interfaces.

### Platform
FPGA-specific DDR, clocks, HDMI, I2S, USB and SD logic should remain outside the portable core where practical.

## Compatibility rule
Keep the N64-visible programming model stable even when the physical implementation changes.
