module n64oc_cart_rom #(
  parameter int ROM_WORDS = 1024,
  parameter string ROM_HEX = ""
)(
  input logic clk,
  input logic reset_n,
  input logic        valid,
  input logic [31:0] addr,
  output logic       ready,
  output logic [63:0] rdata
);

  logic [63:0] rom [0:ROM_WORDS-1];
  integer i;

  initial begin
    for (i = 0; i < ROM_WORDS; i = i + 1)
      rom[i] = 64'd0;
    if (ROM_HEX != "")
      $readmemh(ROM_HEX, rom);
  end

  always_ff @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
      ready <= 1'b0;
      rdata <= 64'd0;
    end else begin
      ready <= valid;
      if (valid && (addr[31:3] < ROM_WORDS))
        rdata <= rom[addr[31:3]];
      else
        rdata <= 64'd0;
    end
  end

endmodule
