
module bipolar_convert (
    input clk,
    input data_in,          // 输入数据（0/1）
    output reg signed [15:0] bipolar_out // 输出±32767（16位有符号）
);
    always @(posedge clk) begin
        bipolar_out <= (data_in) ? 16'sd32767 : -16'sd32767;
    end
endmodule