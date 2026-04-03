class fifo_stress_sequence extends uvm_sequence #(fifo_seq_item);
  `uvm_object_utils(fifo_stress_sequence)

  function new(string name = "fifo_stress_sequence");
    super.new(name);
  endfunction

  task automatic send_item(bit wr, bit rd, bit [FIFO_WIDTH-1:0] data);
    fifo_seq_item req;
    req = fifo_seq_item::type_id::create("req");
    start_item(req);
    if (!req.randomize() with { wr_en == wr; rd_en == rd; din == data; }) begin
      `uvm_fatal("SEQ", "Randomization failed in fifo_stress_sequence")
    end
    finish_item(req);
  endtask

  task body();
    int i;
    bit wr;
    bit rd;
    bit [FIFO_WIDTH-1:0] data;

    for (i = 0; i < FIFO_DEPTH + 3; i++) begin
      send_item(1'b1, 1'b0, $urandom());
    end

    for (i = 0; i < (FIFO_DEPTH / 2) + 1; i++) begin
      send_item(1'b0, 1'b1, '0);
    end

    for (i = 0; i < 20; i++) begin
      send_item(1'b1, 1'b1, $urandom());
    end

    for (i = 0; i < 50; i++) begin
      wr   = $urandom_range(0, 1);
      rd   = $urandom_range(0, 1);
      data = $urandom();

      if (!wr && !rd) wr = 1'b1;

      send_item(wr, rd, data);
    end
  endtask

endclass