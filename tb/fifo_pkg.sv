package fifo_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  parameter int FIFO_WIDTH = 8;
  parameter int FIFO_DEPTH  = 16;
  parameter int FIFO_CNT_W  = $clog2(FIFO_DEPTH + 1);

  `include "fifo_seq_item.sv"
  `include "fifo_sequencer.sv"
  `include "fifo_sequence.sv"
  `include "fifo_driver.sv"
  `include "fifo_monitor.sv"
  `include "fifo_scoreboard.sv"
  `include "fifo_cov.sv"
  `include "fifo_agent.sv"
  `include "fifo_env.sv"
  `include "fifo_test.sv"

endpackage