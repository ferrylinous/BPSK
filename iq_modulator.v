//=============================================
// 模块：iq_modulator
// 功能：数字正交调制器（支持BPSK/QPSK扩展）
// 输入：
//   - I路：成形滤波后的基带信号（有符号）
//   - Q路：保留为0（BPSK）
//   - 载波：DDS生成的正交载波（cos/sin）
// 输出：调制后的信号（I*cos + Q*sin）
//=============================================
module iq_modulator
 (
    input clk,                      // 系统时钟
    input signed [15:0] i_data,     // I路基带（±32767）
    input signed [15:0] q_data,     // Q路基带（BPSK中固定为0）
    input [7:0] cos_in,            // I路载波（8位无符号）
    input [7:0] sin_in,            // Q路载波（8位无符号）
    output reg signed [15:0] mod_out // 调制输出
);
    //--- 载波格式转换（无符号转有符号） ---
    wire signed [7:0] cos_signed = cos_in - 8'd128; // -128 ~ +127
    wire signed [7:0] sin_signed = sin_in - 8'd128;

    //--- I路调制：i_data * cos(ωt) ---
    reg signed [23:0] i_mult;
    always @(posedge clk) begin
        i_mult <= i_data * cos_signed;
    end

    //--- Q路调制：q_data * sin(ωt) ---
    reg signed [23:0] q_mult;
    always @(posedge clk) begin
        q_mult <= q_data * sin_signed;
    end

    //--- 合并I/Q路信号 ---
    reg signed [24:0] mod_sum; // 防止溢出
    always @(posedge clk) begin
        mod_sum <= i_mult + q_mult; // I+Q（BPSK中Q项为0）
    end

    //--- 输出截断（保留16位） ---
    always @(posedge clk) begin
        mod_out <= mod_sum[23:8]; // 等效于右移8位
    end

endmodule