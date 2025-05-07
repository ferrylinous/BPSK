module top_bpsk (
     input clk,          // 100MHz时钟
    input rst,          // 高电平复位
    input data_in,      // 输入数据（0/1）
    output [15:0] bpsk_out, // 调制信号输出
    output data_out          // 解调后的数据输出
);
    //中间信号
   wire signed [15:0] bipolar_data;//这里data是out我修改了
    wire [15:0] dds_cos;           // DDS 生成的 I 路载波
    wire [15:0] dds_sin;           // DDS 生成的 Q 路载波（BPSK 未使用）
    wire [7:0] costas_cos;
    wire [7:0] costas_sin;
    wire locked;
    reg symbol_clk;
    
    
    // 符号时钟生成（假设符号周期为1000ns）
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
// --- 实例化极性转换模块 ---
    bipolar_convert u_convert (
        .clk(clk),
        .data_in(data_in),
        .bipolar_out(bipolar_data)
    );


    //--- DDS生成正交载波 ---
    
    dds_manual u_dds (
        .clk(clk),
        .rst(rst),
        .cos_out(dds_cos),  // 新增cos输出
        .sin_out(dds_sin)   // 新增sin输出
    );

    //--- IQ调制器（Q路固定为0） ---
    iq_modulator u_mod (
        .clk(clk),
        .i_data(bipolar_data), // 
        .q_data(16'sd0),              // Q路固定为0（BPSK）
        .cos_in(dds_cos),             // I路载波
        .sin_in(dds_sin),             // Q路载波（BPSK未使用）
        .mod_out(bpsk_out)  //
    );
     // --- Costas环 ---
    costas_loop u_costas (
        .clk(clk),
        .rst(rst),
        .bpsk_in(bpsk_out),
        .cos_out(costas_cos),
        .sin_out(costas_sin),
         .locked(locked)
    );
    // --- BPSK解调器 ---
    bpsk_demodulator u_demod (
       .clk(clk),
        .rst(rst),
        .bpsk_in(bpsk_out),
        .cos_in(costas_cos),
        .symbol_clk(symbol_clk), // 符号时钟输入
        .locked(locked),         // 锁定状态输入
        .data_out(data_out)
    );
endmodule