
module bipolar_convert (
    input clk,
    input data_in,          // �������ݣ�0/1��
    output reg signed [15:0] bipolar_out // �����32767��16λ�з��ţ�
);
    always @(posedge clk) begin
        bipolar_out <= (data_in) ? 16'sd32767 : -16'sd32767;
    end
endmodule