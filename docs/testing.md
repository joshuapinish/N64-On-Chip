# Testing and bring-up

The project intentionally has two different kinds of tests.

## 1. CPU smoke test

This is a self-contained MIPS execution test. It does not require a Nintendo ROM.

On a Linux machine with Icarus Verilog:

```bash
sudo xbps-install -S iverilog   # Void Linux
make test-cpu
```

Expected result:

```text
MIPS smoke test passed: r1=0000000000001234 r2=0000000000001234 r3=0000000000002468
```

This proves that the current experimental CPU can fetch instructions, execute integer operations, perform a 64-bit store/load, and halt.

## 2. Video bring-up

The top-level currently drives a deterministic 640x480 diagnostic pattern:

- red/green/blue vertical regions
- white center rectangle
- generated HSYNC/VSYNC

The top-level clock is intended to be supplied by a suitable pixel-clock source. A real FPGA target will need a PLL/MMCM or equivalent clock wrapper for the board's oscillator.

Run the simulation with:

```bash
make test-top
```

## 3. Mario 64 target

The repository does **not** include Super Mario 64, the N64 PIF boot ROM, or other Nintendo copyrighted firmware.

A real Mario 64 title-screen boot requires much more than the current CPU smoke test. The boot chain initializes hardware, copies IPL2 into RSP memory, validates IPL3 and then enters the cartridge program. The N64 IPL stages are documented by the open N64-IPL project. citeturn0search11

The intended test interface is therefore:

```text
legal ROM dump
     |
     v
SD/ROM loader
     |
     v
cartridge address space
     |
     +--> CPU / RSP / RDP / VI / AI / SI / PIF
```

Do not commit a ROM or proprietary boot image to this repository. The loader should accept an external image supplied by the user.

## Compatibility milestone

The first meaningful console milestone is:

1. CPU reset and PIF/boot path.
2. RDRAM initialization.
3. Cartridge ROM mapping.
4. IPL3 entry.
5. ROM entrypoint execution.
6. VI scanout.
7. RSP/RDP support sufficient for the Mario 64 title screen.

Only after that should the project claim that Mario 64 boots.
