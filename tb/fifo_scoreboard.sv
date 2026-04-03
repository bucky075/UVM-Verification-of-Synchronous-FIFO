class fifo_scoreboard extends uvm_component;
  `uvm_component_utils(fifo_scoreboard)

  uvm_analysis_imp #(fifo_seq_item, fifo_scoreboard) analysis_export;
  bit [FIFO_WIDTH-1:0] exp_q[$];

  int unsigned pass_cnt;
  int unsigned fail_cnt;

  function new(string name = "fifo_scoreboard", uvm_component parent = null);
    super.new(name, parent);
    analysis_export = new("analysis_export", this);
  endfunction

  function void write(fifo_seq_item t);
    bit [FIFO_WIDTH-1:0] exp_dout;

    if (!t.rst_n) begin
      exp_q.delete();
      return;
    end

    if (t.rd_en && !t.empty) begin
      if (exp_q.size() == 0) begin
        fail_cnt++;
        `uvm_error("SB", "DUT reported a valid read but expected queue is empty")
      end else begin
        exp_dout = exp_q.pop_front();
        if (t.dout !== exp_dout) begin
          fail_cnt++;
          `uvm_error("SB", $sformatf("Read mismatch exp=0x%0h got=0x%0h | %s",
                                     exp_dout, t.dout, t.convert2string()))
        end else begin
          pass_cnt++;
        end
      end
    end

    if (t.wr_en && !t.full) begin
      exp_q.push_back(t.din);
    end

    if (t.count !== exp_q.size()) begin
      fail_cnt++;
      `uvm_error("SB", $sformatf("Count mismatch exp=%0d got=%0d | %s",
                                 exp_q.size(), t.count, t.convert2string()))
    end
  endfunction

  function void report_phase(uvm_phase phase);
    `uvm_info("SB", $sformatf("PASS=%0d FAIL=%0d FINAL_EXP_Q_SIZE=%0d",
                              pass_cnt, fail_cnt, exp_q.size()), UVM_LOW)
    if (fail_cnt == 0) begin
      `uvm_info("SB", "FIFO scoreboard completed with no mismatches", UVM_NONE)
    end
  endfunction

endclass