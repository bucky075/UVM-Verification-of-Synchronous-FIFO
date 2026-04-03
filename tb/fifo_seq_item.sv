class fifo_seq_item extends uvm_sequence_item;

  rand bit                 wr_en;
  rand bit                 rd_en;
  rand bit [FIFO_WIDTH-1:0] din;

  bit                      rst_n;
  bit [FIFO_WIDTH-1:0]     dout;
  bit                      full;
  bit                      empty;
  bit [FIFO_CNT_W-1:0]     count;

  `uvm_object_utils_begin(fifo_seq_item)
    `uvm_field_int(wr_en, UVM_ALL_ON)
    `uvm_field_int(rd_en, UVM_ALL_ON)
    `uvm_field_int(din,   UVM_ALL_ON)
    `uvm_field_int(rst_n, UVM_ALL_ON)
    `uvm_field_int(dout,  UVM_ALL_ON)
    `uvm_field_int(full,   UVM_ALL_ON)
    `uvm_field_int(empty,  UVM_ALL_ON)
    `uvm_field_int(count,  UVM_ALL_ON)
  `uvm_object_utils_end

  constraint c_not_idle { wr_en || rd_en; }

  function new(string name = "fifo_seq_item");
    super.new(name);
  endfunction

  function string convert2string();
    return $sformatf("wr_en=%0b rd_en=%0b din=0x%0h rst_n=%0b dout=0x%0h full=%0b empty=%0b count=%0d",
                     wr_en, rd_en, din, rst_n, dout, full, empty, count);
  endfunction

endclass