`timescale 1ps / 1ps

module tb_bpsk();
    reg clk = 0;
    reg rst = 1;
    reg data_in = 0; // 输入信号
    wire [15:0] bpsk_out;
    wire signed [15:0] bipolar_data;//data应该是out，我先修改一下
    wire [15:0] dds_cos, dds_sin;
    wire data_out; // 解调后的输出信号
    wire [7:0] costas_cos;
    wire [7:0] costas_sin;
    // Clock generation (100 MHz)
    always #5 clk = ~clk;

    // Instantiate bipolar conversion module
    bipolar_convert u_bipolar_convert (
        .clk(clk),
        .data_in(data_in),
        .bipolar_out(bipolar_data)
    );

    // Instantiate DDS module
    dds_manual u_dds (
        .clk(clk),
        .rst(rst),
        .cos_out(dds_cos),
        .sin_out(dds_sin)
    );

    // Instantiate IQ modulator
    iq_modulator u_mod (
        .clk(clk),
        .i_data(bipolar_data),  // I input
        .q_data(16'sd0),       // Q input fixed to 0 for BPSK
        .cos_in(dds_cos),      // I carrier
        .sin_in(dds_sin),      // Q carrier (not used in BPSK)
        .mod_out(bpsk_out)     // Modulated output
    );
// Instantiate Costas loop module
    costas_loop u_costas (
        .clk(clk),
        .rst(rst),
        .bpsk_in(bpsk_out),
        .cos_out(costas_cos),
        .sin_out(costas_sin)
    );
    // Instantiate BPSK demodulator
    bpsk_demodulator u_demod (
        .clk(clk),
        .rst(rst),
        .bpsk_in(bpsk_out),    // Modulated signal as input
        .cos_in(costas_cos), // Use the high 8 bits of DDS cos as carrier
        .data_out(data_out)    // Demodulated output
    );

    // 仿真初始化
    initial begin
        // 复位信号
        #100 rst = 0;

        // 硬编码数据序列
        data_in = 0; #10000; // 符号周期（1ns）
        data_in = 1; #10000; // 符号周期（1ns）
        data_in = 0; #10000; // 符号周期（1ns）
        data_in = 1; #10000; // 符号周期（1ns）
        data_in = 1; #10000; // 符号周期（1ns）
        data_in = 0; #10000; // 符号周期（1ns）
        data_in = 1; #10000; // 符号周期（1ns）
        data_in = 0; #10000; // 符号周期（1ns）
        data_in = 1; #10000; // 符号周期（1ns）
        data_in = 0; #10000; // 符号周期（1ns）

        #20000 $finish; // End simulation
    end
endmodule