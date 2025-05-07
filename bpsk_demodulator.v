module bpsk_demodulator (
    input clk,                       // 系统时钟
    input rst,                       // 复位信号
    input signed [15:0] bpsk_in,     // 接收到的BPSK信号（bpsk_out）
    input [7:0] cos_in,              // I路载波（8位无符号）
    output reg data_out              // 解调后的数据
);
    //--- 载波格式转换（无符号转有符号） ---
    wire signed [7:0] cos_signed = cos_in - 8'd128; // -128 ~ +127

    //--- 与正交载波相乘（同相解调） ---相干解调
    reg signed [23:0] i_mult;
    always @(posedge clk) begin
        if (rst) begin
            i_mult <= 0;
        end else begin
            i_mult <= bpsk_in * cos_signed;
        end
    end

    //--- 低通滤波器（简单积分实现） ---
    reg signed [31:0] integrator;
    always @(posedge clk) begin
        if (rst) begin
            integrator <= 0;
        end else begin
            integrator <= integrator + i_mult;
        end
    end

    //--- 判决逻辑 ---
    always @(posedge clk) begin
        if (rst) begin
            data_out <= 0;
        end else begin
            // 判决规则：积分值大于0为1，小于0为0
            data_out <= (integrator > 0) ? 1'b1 : 1'b0;
        end
    end
endmodule