module n64oc_bootrom #(
  parameter int WORDS = 1024,
  parameter string ROM_HEX = ""
)(
  input  logic        clk,
  input  logic        reset_n,
  input  logic        valid,
  input  logic [63:0] addr,
  output logic        ready,
  output logic [63:0] rdata
);

  logic [31:0] rom [0:WORDS-1];
  integer i;
  integer word_index;

  initial begin
    for (i = 0; i < WORDS; i = i + 1)
      rom[i] = 32'h0000_000D;
    if (ROM_HEX != "")
      $readmemh(ROM_HEX, rom);
  end

  always_ff @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
      ready <= 1'b0;
      rdata <= 64'd0;
    end else begin
      ready <= valid;
      if (valid && addr >= 64'h0000_0000_BFC0_0000 &&
          addr < (64'h0000_0000_BFC0_0000 + (WORDS * 4))) begin
        word_index = (addr - 64'h0000_0000_BFC0_0000) >> 2;
        rdata <= {32'd0, rom[word_index]};
      end else begin
        rdata <= 64'd0;
      end
    end
  end

endmodule
