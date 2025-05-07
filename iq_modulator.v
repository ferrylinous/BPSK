//=============================================
// ģ�飺iq_modulator
// ���ܣ�����������������֧��BPSK/QPSK��չ��
// ���룺
//   - I·�������˲���Ļ����źţ��з��ţ�
//   - Q·������Ϊ0��BPSK��
//   - �ز���DDS���ɵ������ز���cos/sin��
// ��������ƺ���źţ�I*cos + Q*sin��
//=============================================
module iq_modulator
 (
    input clk,                      // ϵͳʱ��
    input signed [15:0] i_data,     // I·��������32767��
    input signed [15:0] q_data,     // Q·������BPSK�й̶�Ϊ0��
    input [7:0] cos_in,            // I·�ز���8λ�޷��ţ�
    input [7:0] sin_in,            // Q·�ز���8λ�޷��ţ�
    output reg signed [15:0] mod_out // �������
);
    //--- �ز���ʽת�����޷���ת�з��ţ� ---
    wire signed [7:0] cos_signed = cos_in - 8'd128; // -128 ~ +127
    wire signed [7:0] sin_signed = sin_in - 8'd128;

    //--- I·���ƣ�i_data * cos(��t) ---
    reg signed [23:0] i_mult;
    always @(posedge clk) begin
        i_mult <= i_data * cos_signed;
    end

    //--- Q·���ƣ�q_data * sin(��t) ---
    reg signed [23:0] q_mult;
    always @(posedge clk) begin
        q_mult <= q_data * sin_signed;
    end

    //--- �ϲ�I/Q·�ź� ---
    reg signed [24:0] mod_sum; // ��ֹ���
    always @(posedge clk) begin
        mod_sum <= i_mult + q_mult; // I+Q��BPSK��Q��Ϊ0��
    end

    //--- ����ضϣ�����16λ�� ---
    always @(posedge clk) begin
        mod_out <= mod_sum[23:8]; // ��Ч������8λ
    end

endmodule