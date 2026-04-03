class fifo_cov extends uvm_component;
  `uvm_component_utils(fifo_cov)

  uvm_analysis_imp #(fifo_seq_item, fifo_cov) analysis_export;
  fifo_seq_item sample;

  covergroup cg;
    option.per_instance = 1;

    cp_rst : coverpoint sample.rst_n {
      bins in_reset  = {0};
      bins out_reset = {1};
    }

    cp_op : coverpoint {sample.wr_en, sample.rd_en} iff (sample.rst_n) {
      bins write = {2'b10};
      bins read  = {2'b01};
      bins both  = {2'b11};
      bins idle  = {2'b00};
    }

    cp_full : coverpoint sample.full iff (sample.rst_n) {
      bins not_full = {0};
      bins full     = {1};
    }

    cp_empty : coverpoint sample.empty iff (sample.rst_n) {
      bins not_empty = {0};
      bins empty     = {1};
    }

    cp_count : coverpoint sample.count iff (sample.rst_n) {
      bins zero = {0};
      bins low  = {[1:FIFO_DEPTH-2]};
      bins near_full = {FIFO_DEPTH-1};
      bins full = {FIFO_DEPTH};
    }

    x_op_flags : cross cp_op, cp_full, cp_empty;
  endgroup

  function new(string name = "fifo_cov", uvm_component parent = null);
    super.new(name, parent);
    analysis_export = new("analysis_export", this);
    cg = new;
  endfunction

  function void write(fifo_seq_item t);
    sample = t;
    cg.sample();
  endfunction

endclass