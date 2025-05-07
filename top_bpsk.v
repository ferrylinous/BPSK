module top_bpsk (
     input clk,          // 100MHzʱ��
    input rst,          // �ߵ�ƽ��λ
    input data_in,      // �������ݣ�0/1��
    output [15:0] bpsk_out, // �����ź����
    output data_out          // �������������
);
    //�м��ź�
   wire signed [15:0] bipolar_data;//����data��out���޸���
    wire [15:0] dds_cos;           // DDS ���ɵ� I ·�ز�
    wire [15:0] dds_sin;           // DDS ���ɵ� Q ·�ز���BPSK δʹ�ã�
    wire [7:0] costas_cos;
    wire [7:0] costas_sin;
    wire locked;
    reg symbol_clk;
    
    
    // ����ʱ�����ɣ������������Ϊ1000ns��
    reg [9:0] symbol_counter;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            symbol_counter <= 0;
            symbol_clk <= 0;
        end else if (symbol_counter == 999) begin
            symbol_counter <= 0;
            symbol_clk <= ~symbol_clk;
        end else begin
            symbol_counter <= symbol_counter + 1;
        end
    end
// --- ʵ��������ת��ģ�� ---
    bipolar_convert u_convert (
        .clk(clk),
        .data_in(data_in),
        .bipolar_out(bipolar_data)
    );


    //--- DDS���������ز� ---
    
    dds_manual u_dds (
        .clk(clk),
        .rst(rst),
        .cos_out(dds_cos),  // ����cos���
        .sin_out(dds_sin)   // ����sin���
    );

    //--- IQ��������Q·�̶�Ϊ0�� ---
    iq_modulator u_mod (
        .clk(clk),
        .i_data(bipolar_data), // 
        .q_data(16'sd0),              // Q·�̶�Ϊ0��BPSK��
        .cos_in(dds_cos),             // I·�ز�
        .sin_in(dds_sin),             // Q·�ز���BPSKδʹ�ã�
        .mod_out(bpsk_out)  //
    );
     // --- Costas�� ---
    costas_loop u_costas (
        .clk(clk),
        .rst(rst),
        .bpsk_in(bpsk_out),
        .cos_out(costas_cos),
        .sin_out(costas_sin),
         .locked(locked)
    );
    // --- BPSK����� ---
    bpsk_demodulator u_demod (
       .clk(clk),
        .rst(rst),
        .bpsk_in(bpsk_out),
        .cos_in(costas_cos),
        .symbol_clk(symbol_clk), // ����ʱ������
        .locked(locked),         // ����״̬����
        .data_out(data_out)
    );
endmodule