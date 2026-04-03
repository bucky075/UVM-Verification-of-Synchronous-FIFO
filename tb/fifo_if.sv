interface fifo_if #(
  parameter int WIDTH = 8,
  parameter int DEPTH = 16
) (
  input logic clk
);

  localparam int CNT_W = $clog2(DEPTH + 1);

  logic rst_n;
  logic wr_en;
  logic rd_en;
  logic [WIDTH-1:0] din;
  logic [WIDTH-1:0] dout;
  logic full;
  logic empty;
  logic [CNT_W-1:0] count;

endinterface