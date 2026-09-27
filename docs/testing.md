# Testing and bring-up

The project has two immediate, reproducible tests plus a path toward real ROM boot.

## 1. CPU smoke test

This self-contained MIPS execution test requires no Nintendo ROM.

On Void Linux:

```bash
sudo xbps-install -S iverilog
make test-cpu
```

Expected result:

```text
MIPS smoke test passed: r1=0000000000001234 r2=0000000000001234 r3=0000000000002468
```

It proves that the experimental CPU can fetch instructions, execute integer operations, perform a 64-bit store/load, and halt.

## 2. Video bring-up

The top-level currently drives a deterministic 640x480 diagnostic pattern:

- red/green/blue vertical regions
- white center rectangle
- generated HSYNC/VSYNC

A real FPGA target will need a PLL/MMCM or equivalent clock wrapper for the board oscillator.

Run:

```bash
make test-top
```

## 3. Cartridge ROM interface

The next test boundary is an external ROM image supplied to simulation or FPGA storage.

The repository must never contain commercial game ROMs or proprietary boot images. The intended architecture is:

```text
legal ROM image
      |
      v
SD / flash / simulation loader
      |
      v
N64 cartridge address space
      |
      +--> CPU / RSP / RDP / peripherals
```

## 4. Mario 64 title-screen milestone

Reaching the actual Super Mario 64 title screen is a substantially larger milestone. The N64 boot chain initializes hardware, moves IPL2 into RSP memory, validates IPL3, initializes RDRAM/caches and then enters the cartridge program. The open N64-IPL project documents those stages and expects matching binary inputs for testing.

Therefore the project will not fake a claim of Mario 64 compatibility. The first real Mario milestone is:

1. CPU reset path.
2. PIF/boot interface.
3. RDRAM model.
4. Cartridge ROM mapping.
5. IPL3 execution.
6. RSP scalar/vector support.
7. VI scanout.
8. RDP support sufficient for the title screen.

Only after these stages work with an external, legally obtained ROM should the repository claim that Mario 64 reaches its title screen.
