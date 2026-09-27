module n64oc_test_video #(
  parameter int H_ACTIVE = 640,
  parameter int H_FP = 16,
  parameter int H_SYNC = 96,
  parameter int H_BP = 48,
  parameter int V_ACTIVE = 480,
  parameter int V_FP = 10,
  parameter int V_SYNC = 2,
  parameter int V_BP = 33
)(
  input logic clk,
  input logic reset_n,
  output logic valid,
  output logic [23:0] rgb,
  output logic hsync,
  output logic vsync
);
  localparam int H_TOTAL = H_ACTIVE + H_FP + H_SYNC + H_BP;
  localparam int V_TOTAL = V_ACTIVE + V_FP + V_SYNC + V_BP;
  logic [$clog2(H_TOTAL)-1:0] x;
  logic [$clog2(V_TOTAL)-1:0] y;

  always_ff @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
      x <= '0; y <= '0;
    end else if (x == H_TOTAL-1) begin
      x <= '0;
      if (y == V_TOTAL-1) y <= '0;
      else y <= y + 1'b1;
    end else x <= x + 1'b1;
  end

  always_comb begin
    valid = (x < H_ACTIVE && y < V_ACTIVE);
    hsync = !(x >= H_ACTIVE + H_FP && x < H_ACTIVE + H_FP + H_SYNC);
    vsync = !(y >= V_ACTIVE + V_FP && y < V_ACTIVE + V_FP + V_SYNC);

    if (!valid) rgb = 24'h000000;
    else if (x < H_ACTIVE/3) rgb = 24'hCC2020;
    else if (x < (H_ACTIVE*2)/3) rgb = 24'h20CC40;
    else rgb = 24'h2050CC;

    // White diagnostic rectangle in the center.
    if (valid && x >= 220 && x < 420 && y >= 170 && y < 310)
      rgb = 24'hFFFFFF;
  end
endmodule
