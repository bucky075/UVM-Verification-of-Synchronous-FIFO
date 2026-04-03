class fifo_agent extends uvm_component;
  `uvm_component_utils(fifo_agent)

  uvm_active_passive_enum is_active = UVM_ACTIVE;

  fifo_sequencer seqr;
  fifo_driver    drv;
  fifo_monitor   mon;

  uvm_analysis_port #(fifo_seq_item) ap;

  function new(string name = "fifo_agent", uvm_component parent = null);
    super.new(name, parent);
    ap = new("ap", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    void'(uvm_config_db#(uvm_active_passive_enum)::get(this, "", "is_active", is_active));

    mon = fifo_monitor::type_id::create("mon", this);
    if (is_active == UVM_ACTIVE) begin
      seqr = fifo_sequencer::type_id::create("seqr", this);
      drv  = fifo_driver::type_id::create("drv", this);
    end
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    if (is_active == UVM_ACTIVE) begin
      drv.seq_item_port.connect(seqr.seq_item_export);
    end

    mon.ap.connect(ap);
  endfunction

endclass