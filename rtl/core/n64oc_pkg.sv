package n64oc_pkg;

  typedef logic [31:0] addr_t;
  typedef logic [63:0] data_t;

  localparam addr_t N64_RDRAM_BASE = 32'h0000_0000;
  localparam addr_t N64_RDRAM_END  = 32'h007F_FFFF;
  localparam addr_t N64_SP_BASE = 32'h0400_0000;
  localparam addr_t N64_SP_END  = 32'h0400_1FFF;
  localparam addr_t N64_DP_BASE = 32'h0410_0000;
  localparam addr_t N64_DP_END  = 32'h0410_001F;
  localparam addr_t N64_MI_BASE = 32'h0430_0000;
  localparam addr_t N64_MI_END  = 32'h0430_000F;
  localparam addr_t N64_VI_BASE = 32'h0440_0000;
  localparam addr_t N64_VI_END  = 32'h0440_0037;
  localparam addr_t N64_AI_BASE = 32'h0450_0000;
  localparam addr_t N64_AI_END  = 32'h0450_001F;
  localparam addr_t N64_PI_BASE = 32'h0460_0000;
  localparam addr_t N64_PI_END  = 32'h0460_0033;
  localparam addr_t N64_RI_BASE = 32'h0470_0000;
  localparam addr_t N64_RI_END  = 32'h0470_001F;
  localparam addr_t N64_SI_BASE = 32'h0480_0000;
  localparam addr_t N64_SI_END  = 32'h0480_001F;

endpackage
