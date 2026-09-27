module n64oc_top (
  input logic clk,
  input logic reset_n,
  output logic video_valid,
  output logic [23:0] video_rgb,
  output logic video_hsync,
  output logic video_vsync,
  output logic audio_valid,
  output logic [15:0] audio_l,
  output logic [15:0] audio_r
);
  always_ff @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
      video_valid <= 1'b0;
      video_rgb <= '0;
      video_hsync <= 1'b0;
      video_vsync <= 1'b0;
      audio_valid <= 1'b0;
      audio_l <= '0;
      audio_r <= '0;
    end else begin
      video_valid <= 1'b0;
      audio_valid <= 1'b0;
    end
  end
endmodule
