class fifo_driver extends uvm_driver #(fifo_seq_item);
  `uvm_component_utils(fifo_driver)

  virtual fifo_if #(FIFO_WIDTH, FIFO_DEPTH) vif;

  function new(string name = "fifo_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual fifo_if #(FIFO_WIDTH, FIFO_DEPTH))::get(this, "", "vif", vif)) begin
      `uvm_fatal("DRV", "Virtual interface not found")
    end
  endfunction

  task run_phase(uvm_phase phase);
    fifo_seq_item req;

    vif.wr_en <= 1'b0;
    vif.rd_en <= 1'b0;
    vif.din   <= '0;

    forever begin
      seq_item_port.get_next_item(req);

      wait (vif.rst_n === 1'b1);
      @(negedge vif.clk);
      vif.wr_en <= req.wr_en;
      vif.rd_en <= req.rd_en;
      vif.din   <= req.din;

      seq_item_port.item_done();
    end
  endtask

endclass