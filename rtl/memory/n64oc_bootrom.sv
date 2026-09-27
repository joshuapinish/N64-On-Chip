module n64oc_bootrom #(
  parameter int WORDS = 1024
)(
  input logic clk,
  input logic reset_n,
  input logic        valid,
  input logic [63:0] addr,
  output logic       ready,
  output logic [63:0] rdata,
  output logic        halted
);
  logic [63:0] rom [0:WORDS-1];
  integer i;

  always_ff @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
      ready <= 1'b0;
      rdata <= '0;
      halted <= 1'b0;
      for (i=0; i<WORDS; i=i+1) rom[i] <= '0;
    end else begin
      ready <= valid;
      if (valid && addr[63:3] < WORDS)
        rdata <= rom[addr[63:3]];
    end
  end
endmodule
