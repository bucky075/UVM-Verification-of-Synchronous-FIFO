#!/usr/bin/env bash
set -euo pipefail

: "${UVM_HOME:?Set UVM_HOME to your UVM source tree first}"

verilator --sv --timing --binary --build -Wall --coverage \
  --top-module tb_top \
  -Irtl -Itb -I"${UVM_HOME}/src" \
  "${UVM_HOME}/src/uvm_pkg.sv" \
  rtl/fifo.sv \
  tb/fifo_if.sv \
  tb/fifo_pkg.sv \
  tb/tb_top.sv

./obj_dir/Vtb_top