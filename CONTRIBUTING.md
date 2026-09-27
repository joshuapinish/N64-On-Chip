# Contributing

## RTL rules
- Prefer synthesizable SystemVerilog.
- Keep vendor-specific primitives behind platform wrappers.
- Keep reset behavior deterministic.
- Document N64-visible behavior before implementing peripherals.
- Add focused testbenches for non-trivial RTL.
- Do not make unit tests depend on commercial game ROMs.
- Record synthesis/resource implications for major architectural changes.

## Compatibility
When behavior differs from original hardware, document the externally observable behavior software depends on and why the implementation remains compatible.
