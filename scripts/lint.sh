#!/usr/bin/env bash
set -euo pipefail

if command -v verilator >/dev/null 2>&1; then
  verilator --lint-only -Wall -Wno-DECLFILENAME     rtl/core/n64oc_top.sv     rtl/core/n64oc_pkg.sv     rtl/bus/n64oc_bus.sv
else
  echo "Verilator not installed; skipping lint."
fi
