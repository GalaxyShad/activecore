module NEXYS4_DDR
(
	input 	CLK100MHZ
    , input   CPU_RESETN
    
    , input   [15:0] SW
    , output  [15:0] LED

    , input   UART_TXD_IN
    , output  UART_RXD_OUT
);

wire clk_gen;
wire pll_locked;

sys_clk sys_clk
(
    .clk_in1(CLK100MHZ)
    , .reset(!CPU_RESETN)
    , .clk_out1(clk_gen)
    , .locked(pll_locked)
);

wire pss_arst;
assign pss_arst = !(CPU_RESETN & pll_locked);

pss_memsplit
#(
	.CPU("riscv_1stage")
	, .delay_test_flag(0)
	, .mem_data("../pss_memsplit/sw/benchmarks/heartbeat_variable.riscv.hex")
	, .mem_size(8192)
) riscv_udm
(
	.clk_i(clk_gen)
	, .arst_i(pss_arst)
	, .rx_i(UART_TXD_IN)
	, .tx_o(UART_RXD_OUT)
	, .gpio_bi({8'h0, SW, 8'h0})
	, .gpio_bo(LED)
);

endmodule
