module fifo #(
  parameter int WIDTH = 8,
  parameter int DEPTH = 16
) (
  input  logic                   clk,
  input  logic                   rst_n,
  input  logic                   wr_en,
  input  logic                   rd_en,
  input  logic [WIDTH-1:0]       din,
  output logic [WIDTH-1:0]       dout,
  output logic                   full,
  output logic                   empty,
  output logic [$clog2(DEPTH+1)-1:0] count
);

  localparam int CNT_W = $clog2(DEPTH + 1);

  logic [WIDTH-1:0] mem [0:DEPTH-1];
  int unsigned wr_ptr;
  int unsigned rd_ptr;
  logic [CNT_W-1:0] count_r;

  assign full  = (count_r == DEPTH);
  assign empty = (count_r == 0);
  assign count  = count_r;

  wire do_wr = wr_en && !full;
  wire do_rd = rd_en && !empty;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      wr_ptr  <= 0;
      rd_ptr  <= 0;
      count_r <= '0;
      dout    <= '0;
    end else begin
      if (do_wr) begin
        mem[wr_ptr] <= din;
        if (wr_ptr == DEPTH-1) wr_ptr <= 0;
        else                   wr_ptr <= wr_ptr + 1;
      end

      if (do_rd) begin
        dout <= mem[rd_ptr];
        if (rd_ptr == DEPTH-1) rd_ptr <= 0;
        else                   rd_ptr <= rd_ptr + 1;
      end

      unique case ({do_wr, do_rd})
        2'b10: count_r <= count_r + 1;
        2'b01: count_r <= count_r - 1;
        default: count_r <= count_r;
      endcase
    end
  end

endmodule