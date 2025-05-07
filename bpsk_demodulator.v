module bpsk_demodulator (
    input clk,                       // ϵͳʱ��
    input rst,                       // ��λ�ź�
    input signed [15:0] bpsk_in,     // ���յ���BPSK�źţ�bpsk_out��
    input [7:0] cos_in,              // I·�ز���8λ�޷��ţ�
    output reg data_out              // ����������
);
    //--- �ز���ʽת�����޷���ת�з��ţ� ---
    wire signed [7:0] cos_signed = cos_in - 8'd128; // -128 ~ +127

    //--- �������ز���ˣ�ͬ������ ---��ɽ��
    reg signed [23:0] i_mult;
    always @(posedge clk) begin
        if (rst) begin
            i_mult <= 0;
        end else begin
            i_mult <= bpsk_in * cos_signed;
        end
    end

    //--- ��ͨ�˲������򵥻���ʵ�֣� ---
    reg signed [31:0] integrator;
    always @(posedge clk) begin
        if (rst) begin
            integrator <= 0;
        end else begin
            integrator <= integrator + i_mult;
        end
    end

    //--- �о��߼� ---
    always @(posedge clk) begin
        if (rst) begin
            data_out <= 0;
        end else begin
            // �о����򣺻���ֵ����0Ϊ1��С��0Ϊ0
            data_out <= (integrator > 0) ? 1'b1 : 1'b0;
        end
    end
endmodule