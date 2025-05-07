module costas_loop (
    input clk,
    input rst,
    input signed [15:0] bpsk_in,
    output reg [7:0] cos_out,
    output reg [7:0] sin_out,
    output reg locked // ����״̬���
);
    // ��λ�ۼ���
    reg [31:0] phase_accum;
    parameter FTW = 32'h1999_999A; // ��ʼƵ����

    // ������
    wire signed [23:0] i_mult;
    wire signed [23:0] q_mult;
    wire signed [23:0] phase_error;

    assign i_mult = bpsk_in * (cos_out - 8'd128);
    assign q_mult = bpsk_in * (sin_out - 8'd128);
    assign phase_error = i_mult * q_mult;

    // ��·�˲���
    reg signed [31:0] filter_out;
    always @(posedge clk) begin
        if (rst) begin
            filter_out <= 0;
        end else begin
            filter_out <= filter_out + phase_error;
        end
    end

    // ѹ������
    always @(posedge clk) begin
        if (rst) begin
            phase_accum <= 0;
        end else begin
            phase_accum <= phase_accum + FTW + filter_out[31:16];
        end
    end

    // ��/���Ҳ��ұ�
    reg [7:0] cos_lut[0:255];
    reg [7:0] sin_lut[0:255];

    initial begin
        cos_lut[0] = 8'd254; sin_lut[0] = 8'd127;
cos_lut[1] = 8'd254; sin_lut[1] = 8'd130;
cos_lut[2] = 8'd254; sin_lut[2] = 8'd133;
cos_lut[3] = 8'd254; sin_lut[3] = 8'd136;
cos_lut[4] = 8'd253; sin_lut[4] = 8'd139;
cos_lut[5] = 8'd253; sin_lut[5] = 8'd143;
cos_lut[6] = 8'd253; sin_lut[6] = 8'd146;
cos_lut[7] = 8'd252; sin_lut[7] = 8'd149;
cos_lut[8] = 8'd252; sin_lut[8] = 8'd152;
cos_lut[9] = 8'd251; sin_lut[9] = 8'd155;
cos_lut[10] = 8'd250; sin_lut[10] = 8'd158;
cos_lut[11] = 8'd249; sin_lut[11] = 8'd161;
cos_lut[12] = 8'd249; sin_lut[12] = 8'd164;
cos_lut[13] = 8'd248; sin_lut[13] = 8'd167;
cos_lut[14] = 8'd247; sin_lut[14] = 8'd170;
cos_lut[15] = 8'd245; sin_lut[15] = 8'd173;
cos_lut[16] = 8'd244; sin_lut[16] = 8'd176;
cos_lut[17] = 8'd243; sin_lut[17] = 8'd178;
cos_lut[18] = 8'd242; sin_lut[18] = 8'd181;
cos_lut[19] = 8'd240; sin_lut[19] = 8'd184;
cos_lut[20] = 8'd239; sin_lut[20] = 8'd187;
cos_lut[21] = 8'd238; sin_lut[21] = 8'd190;
cos_lut[22] = 8'd236; sin_lut[22] = 8'd192;
cos_lut[23] = 8'd234; sin_lut[23] = 8'd195;
cos_lut[24] = 8'd233; sin_lut[24] = 8'd198;
cos_lut[25] = 8'd231; sin_lut[25] = 8'd200;
cos_lut[26] = 8'd229; sin_lut[26] = 8'd203;
cos_lut[27] = 8'd227; sin_lut[27] = 8'd205;
cos_lut[28] = 8'd225; sin_lut[28] = 8'd208;
cos_lut[29] = 8'd223; sin_lut[29] = 8'd210;
cos_lut[30] = 8'd221; sin_lut[30] = 8'd212;
cos_lut[31] = 8'd219; sin_lut[31] = 8'd215;
cos_lut[32] = 8'd217; sin_lut[32] = 8'd217;
cos_lut[33] = 8'd215; sin_lut[33] = 8'd219;
cos_lut[34] = 8'd212; sin_lut[34] = 8'd221;
cos_lut[35] = 8'd210; sin_lut[35] = 8'd223;
cos_lut[36] = 8'd208; sin_lut[36] = 8'd225;
cos_lut[37] = 8'd205; sin_lut[37] = 8'd227;
cos_lut[38] = 8'd203; sin_lut[38] = 8'd229;
cos_lut[39] = 8'd200; sin_lut[39] = 8'd231;
cos_lut[40] = 8'd198; sin_lut[40] = 8'd233;
cos_lut[41] = 8'd195; sin_lut[41] = 8'd234;
cos_lut[42] = 8'd192; sin_lut[42] = 8'd236;
cos_lut[43] = 8'd190; sin_lut[43] = 8'd238;
cos_lut[44] = 8'd187; sin_lut[44] = 8'd239;
cos_lut[45] = 8'd184; sin_lut[45] = 8'd240;
cos_lut[46] = 8'd181; sin_lut[46] = 8'd242;
cos_lut[47] = 8'd178; sin_lut[47] = 8'd243;
cos_lut[48] = 8'd176; sin_lut[48] = 8'd244;
cos_lut[49] = 8'd173; sin_lut[49] = 8'd245;
cos_lut[50] = 8'd170; sin_lut[50] = 8'd247;
cos_lut[51] = 8'd167; sin_lut[51] = 8'd248;
cos_lut[52] = 8'd164; sin_lut[52] = 8'd249;
cos_lut[53] = 8'd161; sin_lut[53] = 8'd249;
cos_lut[54] = 8'd158; sin_lut[54] = 8'd250;
cos_lut[55] = 8'd155; sin_lut[55] = 8'd251;
cos_lut[56] = 8'd152; sin_lut[56] = 8'd252;
cos_lut[57] = 8'd149; sin_lut[57] = 8'd252;
cos_lut[58] = 8'd146; sin_lut[58] = 8'd253;
cos_lut[59] = 8'd143; sin_lut[59] = 8'd253;
cos_lut[60] = 8'd139; sin_lut[60] = 8'd253;
cos_lut[61] = 8'd136; sin_lut[61] = 8'd254;
cos_lut[62] = 8'd133; sin_lut[62] = 8'd254;
cos_lut[63] = 8'd130; sin_lut[63] = 8'd254;
cos_lut[64] = 8'd127; sin_lut[64] = 8'd254;
cos_lut[65] = 8'd124; sin_lut[65] = 8'd254;
cos_lut[66] = 8'd121; sin_lut[66] = 8'd254;
cos_lut[67] = 8'd118; sin_lut[67] = 8'd254;
cos_lut[68] = 8'd115; sin_lut[68] = 8'd253;
cos_lut[69] = 8'd111; sin_lut[69] = 8'd253;
cos_lut[70] = 8'd108; sin_lut[70] = 8'd253;
cos_lut[71] = 8'd105; sin_lut[71] = 8'd252;
cos_lut[72] = 8'd102; sin_lut[72] = 8'd252;
cos_lut[73] = 8'd99; sin_lut[73] = 8'd251;
cos_lut[74] = 8'd96; sin_lut[74] = 8'd250;
cos_lut[75] = 8'd93; sin_lut[75] = 8'd249;
cos_lut[76] = 8'd90; sin_lut[76] = 8'd249;
cos_lut[77] = 8'd87; sin_lut[77] = 8'd248;
cos_lut[78] = 8'd84; sin_lut[78] = 8'd247;
cos_lut[79] = 8'd81; sin_lut[79] = 8'd245;
cos_lut[80] = 8'd78; sin_lut[80] = 8'd244;
cos_lut[81] = 8'd76; sin_lut[81] = 8'd243;
cos_lut[82] = 8'd73; sin_lut[82] = 8'd242;
cos_lut[83] = 8'd70; sin_lut[83] = 8'd240;
cos_lut[84] = 8'd67; sin_lut[84] = 8'd239;
cos_lut[85] = 8'd64; sin_lut[85] = 8'd238;
cos_lut[86] = 8'd62; sin_lut[86] = 8'd236;
cos_lut[87] = 8'd59; sin_lut[87] = 8'd234;
cos_lut[88] = 8'd56; sin_lut[88] = 8'd233;
cos_lut[89] = 8'd54; sin_lut[89] = 8'd231;
cos_lut[90] = 8'd51; sin_lut[90] = 8'd229;
cos_lut[91] = 8'd49; sin_lut[91] = 8'd227;
cos_lut[92] = 8'd46; sin_lut[92] = 8'd225;
cos_lut[93] = 8'd44; sin_lut[93] = 8'd223;
cos_lut[94] = 8'd42; sin_lut[94] = 8'd221;
cos_lut[95] = 8'd39; sin_lut[95] = 8'd219;
cos_lut[96] = 8'd37; sin_lut[96] = 8'd217;
cos_lut[97] = 8'd35; sin_lut[97] = 8'd215;
cos_lut[98] = 8'd33; sin_lut[98] = 8'd212;
cos_lut[99] = 8'd31; sin_lut[99] = 8'd210;
cos_lut[100] = 8'd29; sin_lut[100] = 8'd208;
cos_lut[101] = 8'd27; sin_lut[101] = 8'd205;
cos_lut[102] = 8'd25; sin_lut[102] = 8'd203;
cos_lut[103] = 8'd23; sin_lut[103] = 8'd200;
cos_lut[104] = 8'd21; sin_lut[104] = 8'd198;
cos_lut[105] = 8'd20; sin_lut[105] = 8'd195;
cos_lut[106] = 8'd18; sin_lut[106] = 8'd192;
cos_lut[107] = 8'd16; sin_lut[107] = 8'd190;
cos_lut[108] = 8'd15; sin_lut[108] = 8'd187;
cos_lut[109] = 8'd14; sin_lut[109] = 8'd184;
cos_lut[110] = 8'd12; sin_lut[110] = 8'd181;
cos_lut[111] = 8'd11; sin_lut[111] = 8'd178;
cos_lut[112] = 8'd10; sin_lut[112] = 8'd176;
cos_lut[113] = 8'd9; sin_lut[113] = 8'd173;
cos_lut[114] = 8'd7; sin_lut[114] = 8'd170;
cos_lut[115] = 8'd6; sin_lut[115] = 8'd167;
cos_lut[116] = 8'd5; sin_lut[116] = 8'd164;
cos_lut[117] = 8'd5; sin_lut[117] = 8'd161;
cos_lut[118] = 8'd4; sin_lut[118] = 8'd158;
cos_lut[119] = 8'd3; sin_lut[119] = 8'd155;
cos_lut[120] = 8'd2; sin_lut[120] = 8'd152;
cos_lut[121] = 8'd2; sin_lut[121] = 8'd149;
cos_lut[122] = 8'd1; sin_lut[122] = 8'd146;
cos_lut[123] = 8'd1; sin_lut[123] = 8'd143;
cos_lut[124] = 8'd1; sin_lut[124] = 8'd139;
cos_lut[125] = 8'd0; sin_lut[125] = 8'd136;
cos_lut[126] = 8'd0; sin_lut[126] = 8'd133;
cos_lut[127] = 8'd0; sin_lut[127] = 8'd130;
cos_lut[128] = 8'd0; sin_lut[128] = 8'd127;
cos_lut[129] = 8'd0; sin_lut[129] = 8'd124;
cos_lut[130] = 8'd0; sin_lut[130] = 8'd121;
cos_lut[131] = 8'd0; sin_lut[131] = 8'd118;
cos_lut[132] = 8'd1; sin_lut[132] = 8'd115;
cos_lut[133] = 8'd1; sin_lut[133] = 8'd111;
cos_lut[134] = 8'd1; sin_lut[134] = 8'd108;
cos_lut[135] = 8'd2; sin_lut[135] = 8'd105;
cos_lut[136] = 8'd2; sin_lut[136] = 8'd102;
cos_lut[137] = 8'd3; sin_lut[137] = 8'd99;
cos_lut[138] = 8'd4; sin_lut[138] = 8'd96;
cos_lut[139] = 8'd5; sin_lut[139] = 8'd93;
cos_lut[140] = 8'd5; sin_lut[140] = 8'd90;
cos_lut[141] = 8'd6; sin_lut[141] = 8'd87;
cos_lut[142] = 8'd7; sin_lut[142] = 8'd84;
cos_lut[143] = 8'd9; sin_lut[143] = 8'd81;
cos_lut[144] = 8'd10; sin_lut[144] = 8'd78;
cos_lut[145] = 8'd11; sin_lut[145] = 8'd76;
cos_lut[146] = 8'd12; sin_lut[146] = 8'd73;
cos_lut[147] = 8'd14; sin_lut[147] = 8'd70;
cos_lut[148] = 8'd15; sin_lut[148] = 8'd67;
cos_lut[149] = 8'd16; sin_lut[149] = 8'd64;
cos_lut[150] = 8'd18; sin_lut[150] = 8'd62;
cos_lut[151] = 8'd20; sin_lut[151] = 8'd59;
cos_lut[152] = 8'd21; sin_lut[152] = 8'd56;
cos_lut[153] = 8'd23; sin_lut[153] = 8'd54;
cos_lut[154] = 8'd25; sin_lut[154] = 8'd51;
cos_lut[155] = 8'd27; sin_lut[155] = 8'd49;
cos_lut[156] = 8'd29; sin_lut[156] = 8'd46;
cos_lut[157] = 8'd31; sin_lut[157] = 8'd44;
cos_lut[158] = 8'd33; sin_lut[158] = 8'd42;
cos_lut[159] = 8'd35; sin_lut[159] = 8'd39;
cos_lut[160] = 8'd37; sin_lut[160] = 8'd37;
cos_lut[161] = 8'd39; sin_lut[161] = 8'd35;
cos_lut[162] = 8'd42; sin_lut[162] = 8'd33;
cos_lut[163] = 8'd44; sin_lut[163] = 8'd31;
cos_lut[164] = 8'd46; sin_lut[164] = 8'd29;
cos_lut[165] = 8'd49; sin_lut[165] = 8'd27;
cos_lut[166] = 8'd51; sin_lut[166] = 8'd25;
cos_lut[167] = 8'd54; sin_lut[167] = 8'd23;
cos_lut[168] = 8'd56; sin_lut[168] = 8'd21;
cos_lut[169] = 8'd59; sin_lut[169] = 8'd20;
cos_lut[170] = 8'd62; sin_lut[170] = 8'd18;
cos_lut[171] = 8'd64; sin_lut[171] = 8'd16;
cos_lut[172] = 8'd67; sin_lut[172] = 8'd15;
cos_lut[173] = 8'd70; sin_lut[173] = 8'd14;
cos_lut[174] = 8'd73; sin_lut[174] = 8'd12;
cos_lut[175] = 8'd76; sin_lut[175] = 8'd11;
cos_lut[176] = 8'd78; sin_lut[176] = 8'd10;
cos_lut[177] = 8'd81; sin_lut[177] = 8'd9;
cos_lut[178] = 8'd84; sin_lut[178] = 8'd7;
cos_lut[179] = 8'd87; sin_lut[179] = 8'd6;
cos_lut[180] = 8'd90; sin_lut[180] = 8'd5;
cos_lut[181] = 8'd93; sin_lut[181] = 8'd5;
cos_lut[182] = 8'd96; sin_lut[182] = 8'd4;
cos_lut[183] = 8'd99; sin_lut[183] = 8'd3;
cos_lut[184] = 8'd102; sin_lut[184] = 8'd2;
cos_lut[185] = 8'd105; sin_lut[185] = 8'd2;
cos_lut[186] = 8'd108; sin_lut[186] = 8'd1;
cos_lut[187] = 8'd111; sin_lut[187] = 8'd1;
cos_lut[188] = 8'd115; sin_lut[188] = 8'd1;
cos_lut[189] = 8'd118; sin_lut[189] = 8'd0;
cos_lut[190] = 8'd121; sin_lut[190] = 8'd0;
cos_lut[191] = 8'd124; sin_lut[191] = 8'd0;
cos_lut[192] = 8'd127; sin_lut[192] = 8'd0;
cos_lut[193] = 8'd130; sin_lut[193] = 8'd0;
cos_lut[194] = 8'd133; sin_lut[194] = 8'd0;
cos_lut[195] = 8'd136; sin_lut[195] = 8'd0;
cos_lut[196] = 8'd139; sin_lut[196] = 8'd1;
cos_lut[197] = 8'd143; sin_lut[197] = 8'd1;
cos_lut[198] = 8'd146; sin_lut[198] = 8'd1;
cos_lut[199] = 8'd149; sin_lut[199] = 8'd2;
cos_lut[200] = 8'd152; sin_lut[200] = 8'd2;
cos_lut[201] = 8'd155; sin_lut[201] = 8'd3;
cos_lut[202] = 8'd158; sin_lut[202] = 8'd4;
cos_lut[203] = 8'd161; sin_lut[203] = 8'd5;
cos_lut[204] = 8'd164; sin_lut[204] = 8'd5;
cos_lut[205] = 8'd167; sin_lut[205] = 8'd6;
cos_lut[206] = 8'd170; sin_lut[206] = 8'd7;
cos_lut[207] = 8'd173; sin_lut[207] = 8'd9;
cos_lut[208] = 8'd176; sin_lut[208] = 8'd10;
cos_lut[209] = 8'd178; sin_lut[209] = 8'd11;
cos_lut[210] = 8'd181; sin_lut[210] = 8'd12;
cos_lut[211] = 8'd184; sin_lut[211] = 8'd14;
cos_lut[212] = 8'd187; sin_lut[212] = 8'd15;
cos_lut[213] = 8'd190; sin_lut[213] = 8'd16;
cos_lut[214] = 8'd192; sin_lut[214] = 8'd18;
cos_lut[215] = 8'd195; sin_lut[215] = 8'd20;
cos_lut[216] = 8'd198; sin_lut[216] = 8'd21;
cos_lut[217] = 8'd200; sin_lut[217] = 8'd23;
cos_lut[218] = 8'd203; sin_lut[218] = 8'd25;
cos_lut[219] = 8'd205; sin_lut[219] = 8'd27;
cos_lut[220] = 8'd208; sin_lut[220] = 8'd29;
cos_lut[221] = 8'd210; sin_lut[221] = 8'd31;
cos_lut[222] = 8'd212; sin_lut[222] = 8'd33;
cos_lut[223] = 8'd215; sin_lut[223] = 8'd35;
cos_lut[224] = 8'd217; sin_lut[224] = 8'd37;
cos_lut[225] = 8'd219; sin_lut[225] = 8'd39;
cos_lut[226] = 8'd221; sin_lut[226] = 8'd42;
cos_lut[227] = 8'd223; sin_lut[227] = 8'd44;
cos_lut[228] = 8'd225; sin_lut[228] = 8'd46;
cos_lut[229] = 8'd227; sin_lut[229] = 8'd49;
cos_lut[230] = 8'd229; sin_lut[230] = 8'd51;
cos_lut[231] = 8'd231; sin_lut[231] = 8'd54;
cos_lut[232] = 8'd233; sin_lut[232] = 8'd56;
cos_lut[233] = 8'd234; sin_lut[233] = 8'd59;
cos_lut[234] = 8'd236; sin_lut[234] = 8'd62;
cos_lut[235] = 8'd238; sin_lut[235] = 8'd64;
cos_lut[236] = 8'd239; sin_lut[236] = 8'd67;
cos_lut[237] = 8'd240; sin_lut[237] = 8'd70;
cos_lut[238] = 8'd242; sin_lut[238] = 8'd73;
cos_lut[239] = 8'd243; sin_lut[239] = 8'd76;
cos_lut[240] = 8'd244; sin_lut[240] = 8'd78;
cos_lut[241] = 8'd245; sin_lut[241] = 8'd81;
cos_lut[242] = 8'd247; sin_lut[242] = 8'd84;
cos_lut[243] = 8'd248; sin_lut[243] = 8'd87;
cos_lut[244] = 8'd249; sin_lut[244] = 8'd90;
cos_lut[245] = 8'd249; sin_lut[245] = 8'd93;
cos_lut[246] = 8'd250; sin_lut[246] = 8'd96;
cos_lut[247] = 8'd251; sin_lut[247] = 8'd99;
cos_lut[248] = 8'd252; sin_lut[248] = 8'd102;
cos_lut[249] = 8'd252; sin_lut[249] = 8'd105;
cos_lut[250] = 8'd253; sin_lut[250] = 8'd108;
cos_lut[251] = 8'd253; sin_lut[251] = 8'd111;
cos_lut[252] = 8'd253; sin_lut[252] = 8'd115;
cos_lut[253] = 8'd254; sin_lut[253] = 8'd118;
cos_lut[254] = 8'd254; sin_lut[254] = 8'd121;
cos_lut[255] = 8'd254; sin_lut[255] = 8'd124;

    end


    // ��������ز�
    always @(posedge clk) begin
        cos_out <= cos_lut[phase_accum[31:24]];
        sin_out <= sin_lut[phase_accum[31:24]];
    end

    // ��������߼�
    reg [23:0] phase_error_abs; // ����ֵ����λ���
    reg [15:0] lock_counter;    // �����������ļ�����
    parameter LOCK_THRESHOLD = 24'd5000; // ������ֵ
    parameter LOCK_COUNT_MAX = 16'd1000; // �����������ֵ

    always @(posedge clk) begin
        if (rst) begin
            phase_error_abs <= 0;
            lock_counter <= 0;
            locked <= 0;
        end else begin
            // ������λ���ľ���ֵ
            phase_error_abs <= (phase_error < 0) ? -phase_error : phase_error;

            // �����λ����Ƿ����������ֵ
            if (phase_error_abs < LOCK_THRESHOLD) begin
                if (lock_counter < LOCK_COUNT_MAX) begin
                    lock_counter <= lock_counter + 1;
                end else begin
                    locked <= 1; // �����ɹ�
                end
            end else begin
                lock_counter <= 0;
                locked <= 0; // δ����
            end
        end
    end
endmodule