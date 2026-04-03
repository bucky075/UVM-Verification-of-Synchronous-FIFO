`timescale 1ns/1ps

module tb_top;

  import uvm_pkg::*;
  import fifo_pkg::*;

  logic clk;

  initial clk = 1'b0;
  always #5 clk = ~clk;

  fifo_if #(.WIDTH(FIFO_WIDTH), .DEPTH(FIFO_DEPTH)) fifo_vif (.clk(clk));

  fifo #(
    .WIDTH(FIFO_WIDTH),
    .DEPTH(FIFO_DEPTH)
  ) dut (
    .clk   (clk),
    .rst_n (fifo_vif.rst_n),
    .wr_en (fifo_vif.wr_en),
    .rd_en (fifo_vif.rd_en),
    .din   (fifo_vif.din),
    .dout  (fifo_vif.dout),
    .full  (fifo_vif.full),
    .empty (fifo_vif.empty),
    .count (fifo_vif.count)
  );

  initial begin
    fifo_vif.rst_n = 1'b0;
    fifo_vif.wr_en  = 1'b0;
    fifo_vif.rd_en  = 1'b0;
    fifo_vif.din    = '0;

    repeat (5) @(posedge clk);
    fifo_vif.rst_n = 1'b1;
  end

  initial begin
    uvm_config_db#(virtual fifo_if #(FIFO_WIDTH, FIFO_DEPTH))::set(null, "*", "vif", fifo_vif);
    run_test("fifo_test");
  end

endmodule