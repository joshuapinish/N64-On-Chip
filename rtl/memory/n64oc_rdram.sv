module n64oc_rdram #(
  parameter int BYTES = 8 * 1024 * 1024
)(
  input  logic        clk,
  input  logic        reset_n,
  input  logic        valid,
  input  logic        write,
  input  logic [31:0] addr,
  input  logic [63:0] wdata,
  input  logic [7:0]  wstrb,
  output logic        ready,
  output logic [63:0] rdata
);

  localparam int WORDS = BYTES / 8;
  logic [63:0] mem [0:WORDS-1];

  always_ff @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
      ready <= 1'b0;
      rdata <= 64'd0;
    end else begin
      ready <= valid;
      if (valid && (addr[31:3] < WORDS)) begin
        if (write) begin
          if (wstrb[0]) mem[addr[31:3]][7:0]   <= wdata[7:0];
          if (wstrb[1]) mem[addr[31:3]][15:8]  <= wdata[15:8];
          if (wstrb[2]) mem[addr[31:3]][23:16] <= wdata[23:16];
          if (wstrb[3]) mem[addr[31:3]][31:24] <= wdata[31:24];
          if (wstrb[4]) mem[addr[31:3]][39:32] <= wdata[39:32];
          if (wstrb[5]) mem[addr[31:3]][47:40] <= wdata[47:40];
          if (wstrb[6]) mem[addr[31:3]][55:48] <= wdata[55:48];
          if (wstrb[7]) mem[addr[31:3]][63:56] <= wdata[63:56];
        end
        rdata <= mem[addr[31:3]];
      end else begin
        rdata <= 64'd0;
      end
    end
  end

endmodule
