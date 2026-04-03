class fifo_monitor extends uvm_component;
  `uvm_component_utils(fifo_monitor)

  virtual fifo_if #(FIFO_WIDTH, FIFO_DEPTH) vif;
  uvm_analysis_port #(fifo_seq_item) ap;

  function new(string name = "fifo_monitor", uvm_component parent = null);
    super.new(name, parent);
    ap = new("ap", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual fifo_if #(FIFO_WIDTH, FIFO_DEPTH))::get(this, "", "vif", vif)) begin
      `uvm_fatal("MON", "Virtual interface not found")
    end
  endfunction

  task run_phase(uvm_phase phase);
    fifo_seq_item tr;

    forever begin
      @(posedge vif.clk);
      #1;

      tr = fifo_seq_item::type_id::create("tr", this);
      tr.rst_n = vif.rst_n;
      tr.wr_en = vif.wr_en;
      tr.rd_en = vif.rd_en;
      tr.din   = vif.din;
      tr.dout  = vif.dout;
      tr.full  = vif.full;
      tr.empty = vif.empty;
      tr.count = vif.count;

      ap.write(tr);
    end
  endtask

endclass