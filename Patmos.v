module MCacheCtrl(input clk, input reset,
    input  io_ena_in,
    output io_fetch_ena,
    output io_mcache_ctrlrepl_w_enable,
    output[31:0] io_mcache_ctrlrepl_w_data,
    output[31:0] io_mcache_ctrlrepl_w_addr,
    output io_mcache_ctrlrepl_w_tag,
    output[9:0] io_mcache_ctrlrepl_address,
    output io_mcache_ctrlrepl_instr_stall,
    input  io_mcache_replctrl_hit,
    input [10:0] io_mcache_replctrl_pos_offset,
    input [31:0] io_femcache_address,
    input  io_femcache_request,
    input  io_femcache_doCallRet,
    input [31:0] io_femcache_callRetBase,
    input  io_exmcache_doCallRet,
    input [31:0] io_exmcache_callRetBase,
    input [31:0] io_exmcache_callRetAddr,
    output[2:0] io_ocp_port_M_Cmd,
    output[31:0] io_ocp_port_M_Addr,
    output[31:0] io_ocp_port_M_Data,
    output io_ocp_port_M_DataValid,
    output[3:0] io_ocp_port_M_DataByteEn,
    input [1:0] io_ocp_port_S_Resp,
    input [31:0] io_ocp_port_S_Data,
    input  io_ocp_port_S_CmdAccept,
    input  io_ocp_port_S_DataAccept
);

  wire[31:0] T0;
  wire[31:0] T1;
  wire[33:0] T2;
  wire[31:0] ext_mem_addr;
  wire[31:0] T3;
  wire[31:0] T4;
  wire[31:0] T5;
  wire[31:0] T6;
  wire[31:0] T7;
  wire[29:0] T8;
  wire[31:0] msize_addr;
  wire[31:0] T9;
  reg[31:0] callRetBaseReg;
  wire T10;
  wire T11;
  wire T12;
  wire T13;
  reg[2:0] mcache_state;
  wire T14;
  wire T15;
  wire T16;
  wire T17;
  wire T18;
  wire T19;
  reg[9:0] ext_mem_tsize;
  wire T20;
  wire T21;
  wire[1:0] T22;
  reg[1:0] ext_mem_burst_cnt;
  wire T23;
  wire T24;
  wire T25;
  wire T26;
  wire T27;
  wire[9:0] T28;
  wire[9:0] T29;
  reg[9:0] ext_mem_fcounter;
  wire T30;
  wire T31;
  wire T32;
  reg[1:0] ocpSlaveReg_Resp;
  wire T33;
  wire T34;
  wire[9:0] T35;
  wire[9:0] T36;
  wire[9:0] T37;
  wire[9:0] T38;
  wire T39;
  wire T40;
  wire T41;
  wire T42;
  wire T43;
  wire T44;
  wire T45;
  wire T46;
  wire[1:0] T47;
  wire[1:0] T48;
  wire[1:0] T49;
  wire[1:0] T50;
  wire[1:0] T51;
  wire[1:0] T52;
  wire[1:0] T53;
  wire[1:0] T54;
  wire[1:0] T55;
  wire[1:0] T56;
  wire[1:0] T57;
  wire[9:0] T58;
  wire[10:0] T59;
  reg[31:0] ocpSlaveReg_Data;
  wire T60;
  wire T61;
  wire T62;
  wire T63;
  wire[2:0] T64;
  wire[2:0] T65;
  wire[2:0] T66;
  wire[2:0] T67;
  wire[31:0] T68;
  wire[31:0] T69;
  wire[31:0] T70;
  wire[31:0] T71;
  wire[2:0] ext_mem_cmd;
  wire[2:0] T72;
  wire[2:0] T73;
  wire[2:0] T74;
  wire T75;
  wire[9:0] T76;
  wire[31:0] mcachemem_address;
  wire[31:0] T77;
  wire[31:0] T78;
  reg[31:0] addrReg;
  wire T79;
  wire mcachemem_w_tag;
  wire[31:0] mcachemem_w_addr;
  wire[31:0] T80;
  wire[31:0] T81;
  wire[31:0] T82;
  wire[31:0] T83;
  wire[31:0] mcachemem_w_data;
  wire[31:0] T84;
  wire[31:0] T85;
  wire[10:0] T86;
  wire[10:0] T87;
  wire[10:0] T88;
  wire[10:0] T89;
  wire T90;
  wire mcachemem_w_enable;
  wire T91;
  reg[0:0] wenaReg;
  wire T92;
  wire T93;

  assign io_ocp_port_M_DataByteEn = 4'b1111/* 0*/;
  assign io_ocp_port_M_DataValid = 1'h0/* 0*/;
  assign io_ocp_port_M_Data = T0;
  assign T0 = {31'h0/* 0*/, 1'h0/* 0*/};
  assign io_ocp_port_M_Addr = T1;
  assign T1 = T2[5'h1f/* 31*/:1'h0/* 0*/];
  assign T2 = {ext_mem_addr, 2'b00/* 0*/};
  assign ext_mem_addr = T3;
  assign T3 = T24 ? T68 : T4;
  assign T4 = T41 ? callRetBaseReg : T5;
  assign T5 = T10 ? T7 : T6;
  assign T6 = {31'h0/* 0*/, 1'h0/* 0*/};
  assign T7 = {T8, 2'b00/* 0*/};
  assign T8 = msize_addr[5'h1f/* 31*/:2'h2/* 2*/];
  assign msize_addr = callRetBaseReg - T9;
  assign T9 = {31'h0/* 0*/, 1'h1/* 1*/};
  assign T10 = T13 && T11;
  assign T11 = ! T12;
  assign T12 = io_mcache_replctrl_hit == 1'h1/* 1*/;
  assign T13 = mcache_state == 3'h1/* 1*/;
  assign T14 = T16 || T15;
  assign T15 = mcache_state == 3'h4/* 4*/;
  assign T16 = T60 || T17;
  assign T17 = T34 && T18;
  assign T18 = ! T19;
  assign T19 = ext_mem_fcounter < ext_mem_tsize;
  assign T20 = T44 && T21;
  assign T21 = ext_mem_burst_cnt == T22;
  assign T22 = msize_addr[1'h1/* 1*/:1'h0/* 0*/];
  assign T23 = T39 || T24;
  assign T24 = T26 && T25;
  assign T25 = ext_mem_burst_cnt >= 2'h3/* 3*/;
  assign T26 = T31 && T27;
  assign T27 = ext_mem_fcounter < T28;
  assign T28 = ext_mem_tsize - T29;
  assign T29 = {9'h0/* 0*/, 1'h1/* 1*/};
  assign T30 = T20 || T31;
  assign T31 = T33 && T32;
  assign T32 = ocpSlaveReg_Resp == 2'b01/* 0*/;
  assign T33 = T34 && T19;
  assign T34 = mcache_state == 3'h3/* 3*/;
  assign T35 = T31 ? T37 : T36;
  assign T36 = {9'h0/* 0*/, 1'h0/* 0*/};
  assign T37 = ext_mem_fcounter + T38;
  assign T38 = {9'h0/* 0*/, 1'h1/* 1*/};
  assign T39 = T40 || T31;
  assign T40 = T43 || T41;
  assign T41 = T20 && T42;
  assign T42 = ext_mem_burst_cnt >= 2'h3/* 3*/;
  assign T43 = T10 || T44;
  assign T44 = T46 && T45;
  assign T45 = ocpSlaveReg_Resp == 2'b01/* 0*/;
  assign T46 = mcache_state == 3'h2/* 2*/;
  assign T47 = T24 ? T57 : T48;
  assign T48 = T31 ? T55 : T49;
  assign T49 = T41 ? T54 : T50;
  assign T50 = T44 ? T52 : T51;
  assign T51 = {1'h0/* 0*/, 1'h0/* 0*/};
  assign T52 = ext_mem_burst_cnt + T53;
  assign T53 = {1'h0/* 0*/, 1'h1/* 1*/};
  assign T54 = {1'h0/* 0*/, 1'h0/* 0*/};
  assign T55 = ext_mem_burst_cnt + T56;
  assign T56 = {1'h0/* 0*/, 1'h1/* 1*/};
  assign T57 = {1'h0/* 0*/, 1'h0/* 0*/};
  assign T58 = T59[4'h9/* 9*/:1'h0/* 0*/];
  assign T59 = ocpSlaveReg_Data[4'hc/* 12*/:2'h2/* 2*/];
  assign T60 = T61 || T20;
  assign T61 = T62 || T10;
  assign T62 = T63 && io_femcache_request;
  assign T63 = mcache_state == 3'h0/* 0*/;
  assign T64 = T15 ? 3'h1/* 1*/ : T65;
  assign T65 = T17 ? 3'h4/* 4*/ : T66;
  assign T66 = T20 ? 3'h3/* 3*/ : T67;
  assign T67 = T10 ? 3'h2/* 2*/ : 3'h1/* 1*/;
  assign T68 = T70 + T69;
  assign T69 = {31'h0/* 0*/, 1'h1/* 1*/};
  assign T70 = callRetBaseReg + T71;
  assign T71 = {22'h0/* 0*/, ext_mem_fcounter};
  assign io_ocp_port_M_Cmd = ext_mem_cmd;
  assign ext_mem_cmd = T72;
  assign T72 = T24 ? 3'b010/* 0*/ : T73;
  assign T73 = T41 ? 3'b010/* 0*/ : T74;
  assign T74 = T10 ? 3'b010/* 0*/ : 3'b000/* 0*/;
  assign io_mcache_ctrlrepl_instr_stall = T75;
  assign T75 = mcache_state != 3'h1/* 1*/;
  assign io_mcache_ctrlrepl_address = T76;
  assign T76 = mcachemem_address[4'h9/* 9*/:1'h0/* 0*/];
  assign mcachemem_address = T77;
  assign T77 = T15 ? io_femcache_address : T78;
  assign T78 = T79 ? io_femcache_address : addrReg;
  assign T79 = T13 && T12;
  assign io_mcache_ctrlrepl_w_tag = mcachemem_w_tag;
  assign mcachemem_w_tag = T20;
  assign io_mcache_ctrlrepl_w_addr = mcachemem_w_addr;
  assign mcachemem_w_addr = T80;
  assign T80 = T33 ? T83 : T81;
  assign T81 = T20 ? callRetBaseReg : T82;
  assign T82 = {31'h0/* 0*/, 1'h0/* 0*/};
  assign T83 = {22'h0/* 0*/, ext_mem_fcounter};
  assign io_mcache_ctrlrepl_w_data = mcachemem_w_data;
  assign mcachemem_w_data = T84;
  assign T84 = T31 ? ocpSlaveReg_Data : T85;
  assign T85 = {21'h0/* 0*/, T86};
  assign T86 = T20 ? T88 : T87;
  assign T87 = {10'h0/* 0*/, 1'h0/* 0*/};
  assign T88 = T59 + T89;
  assign T89 = {10'h0/* 0*/, T90};
  assign T90 = T59[1'h0/* 0*/:1'h0/* 0*/];
  assign io_mcache_ctrlrepl_w_enable = mcachemem_w_enable;
  assign mcachemem_w_enable = T31;
  assign io_fetch_ena = T91;
  assign T91 = ! wenaReg;
  assign T92 = T10 || T17;
  assign T93 = T17 ? 1'h0/* 0*/ : 1'h1/* 1*/;

  always @(posedge clk) begin
    if(reset) begin
      callRetBaseReg <= 32'h0/* 0*/;
    end else if(io_exmcache_doCallRet) begin
      callRetBaseReg <= io_exmcache_callRetBase;
    end
    if(reset) begin
      mcache_state <= 3'h0/* 0*/;
    end else if(T14) begin
      mcache_state <= T64;
    end
    if(reset) begin
      ext_mem_tsize <= 10'h0/* 0*/;
    end else if(T20) begin
      ext_mem_tsize <= T58;
    end
    if(reset) begin
      ext_mem_burst_cnt <= 2'h0/* 0*/;
    end else if(T23) begin
      ext_mem_burst_cnt <= T47;
    end
    if(reset) begin
      ext_mem_fcounter <= 10'h0/* 0*/;
    end else if(T30) begin
      ext_mem_fcounter <= T35;
    end
    ocpSlaveReg_Resp <= io_ocp_port_S_Resp;
    ocpSlaveReg_Data <= io_ocp_port_S_Data;
    if(reset) begin
      addrReg <= 1'h0/* 0*/;
    end else if(io_exmcache_doCallRet) begin
      addrReg <= io_femcache_address;
    end
    if(reset) begin
      wenaReg <= 1'h0/* 0*/;
    end else if(T92) begin
      wenaReg <= T93;
    end
  end
endmodule

module MCacheReplFifo(input clk, input reset,
    input  io_ena_in,
    output io_hit_ena,
    input  io_exmcache_doCallRet,
    input [31:0] io_exmcache_callRetBase,
    input [31:0] io_exmcache_callRetAddr,
    output[31:0] io_mcachefe_instr_a,
    output[31:0] io_mcachefe_instr_b,
    output[10:0] io_mcachefe_relBase,
    output[11:0] io_mcachefe_relPc,
    output[31:0] io_mcachefe_reloc,
    output[1:0] io_mcachefe_mem_sel,
    input  io_mcache_ctrlrepl_w_enable,
    input [31:0] io_mcache_ctrlrepl_w_data,
    input [31:0] io_mcache_ctrlrepl_w_addr,
    input  io_mcache_ctrlrepl_w_tag,
    input [9:0] io_mcache_ctrlrepl_address,
    input  io_mcache_ctrlrepl_instr_stall,
    output io_mcache_replctrl_hit,
    output[10:0] io_mcache_replctrl_pos_offset,
    output io_mcachemem_in_w_even,
    output io_mcachemem_in_w_odd,
    output[31:0] io_mcachemem_in_w_data,
    output[8:0] io_mcachemem_in_w_addr,
    output[8:0] io_mcachemem_in_addr_even,
    output[8:0] io_mcachemem_in_addr_odd,
    input [31:0] io_mcachemem_out_instr_even,
    input [31:0] io_mcachemem_out_instr_odd
);

  wire[8:0] mcachemem_in_address;
  wire[8:0] T0;
  wire[8:0] T1;
  wire[8:0] T2;
  wire rd_parity;
  wire[8:0] mcachemem_w_address;
  wire[31:0] T3;
  wire[31:0] T4;
  reg[9:0] wrPosReg;
  reg[9:0] posReg;
  wire T5;
  wire T6;
  wire hit;
  wire T7;
  wire T8;
  wire T9;
  wire T10;
  wire T11;
  wire T12;
  wire T13;
  wire T14;
  wire T15;
  wire T16;
  wire T17;
  wire T18;
  wire T19;
  wire T20;
  wire T21;
  wire T22;
  wire T23;
  reg[0:0] mcache_valid_vec_0;
  wire T24;
  wire T25;
  wire T26;
  wire[15:0] T27;
  wire[30:0] T28;
  wire[3:0] T29;
  reg[3:0] next_replace_tag;
  wire T30;
  wire signed  T31;
  wire[11:0] T32;
  reg signed [11:0] free_space;
  wire T33;
  wire[11:0] T34;
  wire signed [11:0] T35;
  wire signed [11:0] T36;
  wire[11:0] T37;
  wire[10:0] T38;
  wire[10:0] T39;
  wire[10:0] T40;
  wire[10:0] T41;
  reg[10:0] mcache_size_vec_0;
  wire T42;
  wire T43;
  wire T44;
  wire[15:0] T45;
  wire[30:0] T46;
  wire[3:0] T47;
  wire T48;
  wire T49;
  wire[15:0] T50;
  wire[30:0] T51;
  wire[3:0] T52;
  reg[3:0] next_index_tag;
  wire[3:0] T53;
  wire[3:0] T54;
  wire[3:0] T55;
  wire[3:0] T56;
  wire T57;
  wire[10:0] T58;
  wire[10:0] T59;
  wire[10:0] T60;
  reg[10:0] mcache_size_vec_1;
  wire T61;
  wire T62;
  wire T63;
  wire T64;
  wire T65;
  wire[10:0] T66;
  wire[10:0] T67;
  wire T68;
  wire[10:0] T69;
  reg[10:0] mcache_size_vec_2;
  wire T70;
  wire T71;
  wire T72;
  wire T73;
  wire T74;
  wire[10:0] T75;
  wire[10:0] T76;
  reg[10:0] mcache_size_vec_3;
  wire T77;
  wire T78;
  wire T79;
  wire T80;
  wire T81;
  wire[10:0] T82;
  wire[10:0] T83;
  wire T84;
  wire T85;
  wire[10:0] T86;
  wire[10:0] T87;
  reg[10:0] mcache_size_vec_4;
  wire T88;
  wire T89;
  wire T90;
  wire T91;
  wire T92;
  wire[10:0] T93;
  wire[10:0] T94;
  reg[10:0] mcache_size_vec_5;
  wire T95;
  wire T96;
  wire T97;
  wire T98;
  wire T99;
  wire[10:0] T100;
  wire[10:0] T101;
  wire T102;
  wire[10:0] T103;
  reg[10:0] mcache_size_vec_6;
  wire T104;
  wire T105;
  wire T106;
  wire T107;
  wire T108;
  wire[10:0] T109;
  wire[10:0] T110;
  reg[10:0] mcache_size_vec_7;
  wire T111;
  wire T112;
  wire T113;
  wire T114;
  wire T115;
  wire[10:0] T116;
  wire[10:0] T117;
  wire T118;
  wire T119;
  wire T120;
  wire[10:0] T121;
  wire[10:0] T122;
  wire[10:0] T123;
  reg[10:0] mcache_size_vec_8;
  wire T124;
  wire T125;
  wire T126;
  wire T127;
  wire T128;
  wire[10:0] T129;
  wire[10:0] T130;
  reg[10:0] mcache_size_vec_9;
  wire T131;
  wire T132;
  wire T133;
  wire T134;
  wire T135;
  wire[10:0] T136;
  wire[10:0] T137;
  wire T138;
  wire[10:0] T139;
  reg[10:0] mcache_size_vec_10;
  wire T140;
  wire T141;
  wire T142;
  wire T143;
  wire T144;
  wire[10:0] T145;
  wire[10:0] T146;
  reg[10:0] mcache_size_vec_11;
  wire T147;
  wire T148;
  wire T149;
  wire T150;
  wire T151;
  wire[10:0] T152;
  wire[10:0] T153;
  wire T154;
  wire T155;
  wire[10:0] T156;
  wire[10:0] T157;
  reg[10:0] mcache_size_vec_12;
  wire T158;
  wire T159;
  wire T160;
  wire T161;
  wire T162;
  wire[10:0] T163;
  wire[10:0] T164;
  reg[10:0] mcache_size_vec_13;
  wire T165;
  wire T166;
  wire T167;
  wire T168;
  wire T169;
  wire[10:0] T170;
  wire[10:0] T171;
  wire T172;
  wire[10:0] T173;
  reg[10:0] mcache_size_vec_14;
  wire T174;
  wire T175;
  wire T176;
  wire T177;
  wire T178;
  wire[10:0] T179;
  wire[10:0] T180;
  reg[10:0] mcache_size_vec_15;
  wire T181;
  wire T182;
  wire T183;
  wire T184;
  wire T185;
  wire[10:0] T186;
  wire[10:0] T187;
  wire T188;
  wire T189;
  wire T190;
  wire T191;
  wire signed [11:0] T192;
  wire signed [11:0] T193;
  wire[11:0] T194;
  wire[10:0] T195;
  wire signed [11:0] T196;
  wire signed [11:0] T197;
  wire[11:0] T198;
  wire[10:0] T199;
  wire[10:0] T200;
  wire[10:0] T201;
  wire[10:0] T202;
  wire T203;
  wire[10:0] T204;
  wire T205;
  wire T206;
  wire[10:0] T207;
  wire[10:0] T208;
  wire T209;
  wire[10:0] T210;
  wire T211;
  wire T212;
  wire T213;
  wire[10:0] T214;
  wire[10:0] T215;
  wire[10:0] T216;
  wire T217;
  wire[10:0] T218;
  wire T219;
  wire T220;
  wire[10:0] T221;
  wire[10:0] T222;
  wire T223;
  wire[10:0] T224;
  wire T225;
  wire T226;
  wire T227;
  wire T228;
  wire T229;
  wire T230;
  wire[3:0] T231;
  wire[3:0] T232;
  wire[3:0] T233;
  wire[3:0] T234;
  wire[3:0] T235;
  wire T236;
  wire T237;
  wire T238;
  wire[15:0] T239;
  wire[30:0] T240;
  wire[3:0] T241;
  wire T242;
  wire T243;
  reg[31:0] mcache_addr_vec_0;
  wire T244;
  wire T245;
  wire[15:0] T246;
  wire[30:0] T247;
  wire[3:0] T248;
  wire T249;
  wire T250;
  wire[16:0] T251;
  wire[16:0] T252;
  wire T253;
  wire T254;
  wire T255;
  reg[0:0] mcache_valid_vec_1;
  wire T256;
  wire T257;
  wire T258;
  wire T259;
  wire T260;
  wire T261;
  wire T262;
  reg[31:0] mcache_addr_vec_1;
  wire T263;
  wire T264;
  wire T265;
  wire T266;
  reg[0:0] mcache_valid_vec_2;
  wire T267;
  wire T268;
  wire T269;
  wire T270;
  wire T271;
  wire T272;
  wire T273;
  reg[31:0] mcache_addr_vec_2;
  wire T274;
  wire T275;
  wire T276;
  wire T277;
  reg[0:0] mcache_valid_vec_3;
  wire T278;
  wire T279;
  wire T280;
  wire T281;
  wire T282;
  wire T283;
  wire T284;
  reg[31:0] mcache_addr_vec_3;
  wire T285;
  wire T286;
  wire T287;
  wire T288;
  reg[0:0] mcache_valid_vec_4;
  wire T289;
  wire T290;
  wire T291;
  wire T292;
  wire T293;
  wire T294;
  wire T295;
  reg[31:0] mcache_addr_vec_4;
  wire T296;
  wire T297;
  wire T298;
  wire T299;
  reg[0:0] mcache_valid_vec_5;
  wire T300;
  wire T301;
  wire T302;
  wire T303;
  wire T304;
  wire T305;
  wire T306;
  reg[31:0] mcache_addr_vec_5;
  wire T307;
  wire T308;
  wire T309;
  wire T310;
  reg[0:0] mcache_valid_vec_6;
  wire T311;
  wire T312;
  wire T313;
  wire T314;
  wire T315;
  wire T316;
  wire T317;
  reg[31:0] mcache_addr_vec_6;
  wire T318;
  wire T319;
  wire T320;
  wire T321;
  reg[0:0] mcache_valid_vec_7;
  wire T322;
  wire T323;
  wire T324;
  wire T325;
  wire T326;
  wire T327;
  wire T328;
  reg[31:0] mcache_addr_vec_7;
  wire T329;
  wire T330;
  wire T331;
  wire T332;
  reg[0:0] mcache_valid_vec_8;
  wire T333;
  wire T334;
  wire T335;
  wire T336;
  wire T337;
  wire T338;
  wire T339;
  reg[31:0] mcache_addr_vec_8;
  wire T340;
  wire T341;
  wire T342;
  wire T343;
  reg[0:0] mcache_valid_vec_9;
  wire T344;
  wire T345;
  wire T346;
  wire T347;
  wire T348;
  wire T349;
  wire T350;
  reg[31:0] mcache_addr_vec_9;
  wire T351;
  wire T352;
  wire T353;
  wire T354;
  reg[0:0] mcache_valid_vec_10;
  wire T355;
  wire T356;
  wire T357;
  wire T358;
  wire T359;
  wire T360;
  wire T361;
  reg[31:0] mcache_addr_vec_10;
  wire T362;
  wire T363;
  wire T364;
  wire T365;
  reg[0:0] mcache_valid_vec_11;
  wire T366;
  wire T367;
  wire T368;
  wire T369;
  wire T370;
  wire T371;
  wire T372;
  reg[31:0] mcache_addr_vec_11;
  wire T373;
  wire T374;
  wire T375;
  wire T376;
  reg[0:0] mcache_valid_vec_12;
  wire T377;
  wire T378;
  wire T379;
  wire T380;
  wire T381;
  wire T382;
  wire T383;
  reg[31:0] mcache_addr_vec_12;
  wire T384;
  wire T385;
  wire T386;
  wire T387;
  reg[0:0] mcache_valid_vec_13;
  wire T388;
  wire T389;
  wire T390;
  wire T391;
  wire T392;
  wire T393;
  wire T394;
  reg[31:0] mcache_addr_vec_13;
  wire T395;
  wire T396;
  wire T397;
  wire T398;
  reg[0:0] mcache_valid_vec_14;
  wire T399;
  wire T400;
  wire T401;
  wire T402;
  wire T403;
  wire T404;
  wire T405;
  reg[31:0] mcache_addr_vec_14;
  wire T406;
  wire T407;
  wire T408;
  wire T409;
  reg[0:0] mcache_valid_vec_15;
  wire T410;
  wire T411;
  wire T412;
  wire T413;
  wire T414;
  wire T415;
  wire T416;
  reg[31:0] mcache_addr_vec_15;
  wire T417;
  wire T418;
  wire[9:0] T419;
  reg[9:0] next_replace_pos;
  wire[9:0] T420;
  wire[9:0] T421;
  wire[9:0] T422;
  wire[9:0] mergePosVec_15;
  wire[9:0] T423;
  wire[9:0] T424;
  reg[9:0] mcache_pos_vec_15;
  wire T425;
  wire T426;
  wire[15:0] T427;
  wire[30:0] T428;
  wire[3:0] T429;
  wire[9:0] T430;
  wire[9:0] mergePosVec_14;
  wire[9:0] T431;
  wire[9:0] T432;
  reg[9:0] mcache_pos_vec_14;
  wire T433;
  wire T434;
  wire[9:0] T435;
  wire[9:0] mergePosVec_13;
  wire[9:0] T436;
  wire[9:0] T437;
  reg[9:0] mcache_pos_vec_13;
  wire T438;
  wire T439;
  wire[9:0] T440;
  wire[9:0] mergePosVec_12;
  wire[9:0] T441;
  wire[9:0] T442;
  reg[9:0] mcache_pos_vec_12;
  wire T443;
  wire T444;
  wire[9:0] T445;
  wire[9:0] mergePosVec_11;
  wire[9:0] T446;
  wire[9:0] T447;
  reg[9:0] mcache_pos_vec_11;
  wire T448;
  wire T449;
  wire[9:0] T450;
  wire[9:0] mergePosVec_10;
  wire[9:0] T451;
  wire[9:0] T452;
  reg[9:0] mcache_pos_vec_10;
  wire T453;
  wire T454;
  wire[9:0] T455;
  wire[9:0] mergePosVec_9;
  wire[9:0] T456;
  wire[9:0] T457;
  reg[9:0] mcache_pos_vec_9;
  wire T458;
  wire T459;
  wire[9:0] T460;
  wire[9:0] mergePosVec_8;
  wire[9:0] T461;
  wire[9:0] T462;
  reg[9:0] mcache_pos_vec_8;
  wire T463;
  wire T464;
  wire[9:0] T465;
  wire[9:0] mergePosVec_7;
  wire[9:0] T466;
  wire[9:0] T467;
  reg[9:0] mcache_pos_vec_7;
  wire T468;
  wire T469;
  wire[9:0] T470;
  wire[9:0] mergePosVec_6;
  wire[9:0] T471;
  wire[9:0] T472;
  reg[9:0] mcache_pos_vec_6;
  wire T473;
  wire T474;
  wire[9:0] T475;
  wire[9:0] mergePosVec_5;
  wire[9:0] T476;
  wire[9:0] T477;
  reg[9:0] mcache_pos_vec_5;
  wire T478;
  wire T479;
  wire[9:0] T480;
  wire[9:0] mergePosVec_4;
  wire[9:0] T481;
  wire[9:0] T482;
  reg[9:0] mcache_pos_vec_4;
  wire T483;
  wire T484;
  wire[9:0] T485;
  wire[9:0] mergePosVec_3;
  wire[9:0] T486;
  wire[9:0] T487;
  reg[9:0] mcache_pos_vec_3;
  wire T488;
  wire T489;
  wire[9:0] T490;
  wire[9:0] mergePosVec_2;
  wire[9:0] T491;
  wire[9:0] T492;
  reg[9:0] mcache_pos_vec_2;
  wire T493;
  wire T494;
  wire[9:0] T495;
  wire[9:0] mergePosVec_1;
  wire[9:0] T496;
  wire[9:0] T497;
  reg[9:0] mcache_pos_vec_1;
  wire T498;
  wire T499;
  wire[9:0] T500;
  wire[9:0] mergePosVec_0;
  wire[9:0] T501;
  wire[9:0] T502;
  reg[9:0] mcache_pos_vec_0;
  wire T503;
  wire T504;
  wire[9:0] T505;
  wire T506;
  wire wr_parity;
  wire T507;
  wire[10:0] T508;
  reg[0:0] hitReg;
  wire T509;
  wire T510;
  wire T511;
  wire T512;
  wire T513;
  wire T514;
  wire T515;
  wire T516;
  wire T517;
  wire T518;
  wire T519;
  wire T520;
  wire T521;
  wire T522;
  wire T523;
  wire T524;
  wire T525;
  wire T526;
  wire T527;
  wire T528;
  wire T529;
  wire T530;
  wire T531;
  wire T532;
  wire T533;
  wire T534;
  wire T535;
  wire T536;
  wire T537;
  wire T538;
  wire T539;
  wire T540;
  wire T541;
  wire[1:0] T542;
  reg[0:0] selMCacheReg;
  wire T543;
  wire[16:0] T544;
  wire[16:0] T545;
  reg[0:0] selIspmReg;
  wire T546;
  wire[17:0] T547;
  wire[17:0] T548;
  wire[31:0] reloc;
  wire[31:0] T549;
  wire[14:0] T550;
  wire[14:0] T551;
  wire[31:0] T552;
  wire[31:0] T553;
  wire[9:0] T554;
  reg[31:0] callRetBaseReg;
  wire[11:0] T555;
  wire[31:0] relPc;
  wire[31:0] T556;
  wire[13:0] relBase;
  wire[13:0] T557;
  wire[13:0] T558;
  wire[9:0] T559;
  reg[31:0] callAddrReg;
  wire[10:0] T560;
  wire[31:0] T561;
  wire[31:0] instr_b;
  reg[0:0] addr_parity_reg;
  reg[31:0] instr_bReg;
  wire T562;
  wire[31:0] T563;
  wire[31:0] instr_a;
  reg[31:0] instr_aReg;

  assign io_mcachemem_in_addr_odd = mcachemem_in_address;
  assign mcachemem_in_address = io_mcache_ctrlrepl_address[4'h9/* 9*/:1'h1/* 1*/];
  assign io_mcachemem_in_addr_even = T0;
  assign T0 = rd_parity ? T1 : mcachemem_in_address;
  assign T1 = mcachemem_in_address + T2;
  assign T2 = {8'h0/* 0*/, 1'h1/* 1*/};
  assign rd_parity = io_mcache_ctrlrepl_address[1'h0/* 0*/:1'h0/* 0*/];
  assign io_mcachemem_in_w_addr = mcachemem_w_address;
  assign mcachemem_w_address = T3[4'h9/* 9*/:1'h1/* 1*/];
  assign T3 = T4 + io_mcache_ctrlrepl_w_addr;
  assign T4 = {22'h0/* 0*/, wrPosReg};
  assign T5 = T249 || T6;
  assign T6 = T249 && hit;
  assign hit = T7;
  assign T7 = T408 ? 1'h1/* 1*/ : T8;
  assign T8 = T397 ? 1'h1/* 1*/ : T9;
  assign T9 = T386 ? 1'h1/* 1*/ : T10;
  assign T10 = T375 ? 1'h1/* 1*/ : T11;
  assign T11 = T364 ? 1'h1/* 1*/ : T12;
  assign T12 = T353 ? 1'h1/* 1*/ : T13;
  assign T13 = T342 ? 1'h1/* 1*/ : T14;
  assign T14 = T331 ? 1'h1/* 1*/ : T15;
  assign T15 = T320 ? 1'h1/* 1*/ : T16;
  assign T16 = T309 ? 1'h1/* 1*/ : T17;
  assign T17 = T298 ? 1'h1/* 1*/ : T18;
  assign T18 = T287 ? 1'h1/* 1*/ : T19;
  assign T19 = T276 ? 1'h1/* 1*/ : T20;
  assign T20 = T265 ? 1'h1/* 1*/ : T21;
  assign T21 = T254 ? 1'h1/* 1*/ : T22;
  assign T22 = T249 && T23;
  assign T23 = T243 && mcache_valid_vec_0;
  assign T24 = T237 || T25;
  assign T25 = T31 && T26;
  assign T26 = T27[1'h0/* 0*/:1'h0/* 0*/];
  assign T27 = T28[4'hf/* 15*/:1'h0/* 0*/];
  assign T28 = 16'h1/* 1*/ << T29;
  assign T29 = next_replace_tag;
  assign T30 = T229 || T31;
  assign T31 = $signed(free_space) < $signed(T32);
  assign T32 = {11'h0/* 0*/, 1'h0/* 0*/};
  assign T33 = io_mcache_ctrlrepl_w_tag || T31;
  assign T34 = T31 ? T196 : T35;
  assign T35 = $signed(T192) + $signed(T36);
  assign T36 = T37;
  assign T37 = {1'h0/* 0*/, T38};
  assign T38 = T191 ? T121 : T39;
  assign T39 = T120 ? T86 : T40;
  assign T40 = T85 ? T69 : T41;
  assign T41 = T68 ? mcache_size_vec_1 : mcache_size_vec_0;
  assign T42 = T48 || T43;
  assign T43 = T31 && T44;
  assign T44 = T45[1'h0/* 0*/:1'h0/* 0*/];
  assign T45 = T46[4'hf/* 15*/:1'h0/* 0*/];
  assign T46 = 16'h1/* 1*/ << T47;
  assign T47 = next_replace_tag;
  assign T48 = io_mcache_ctrlrepl_w_tag && T49;
  assign T49 = T50[1'h0/* 0*/:1'h0/* 0*/];
  assign T50 = T51[4'hf/* 15*/:1'h0/* 0*/];
  assign T51 = 16'h1/* 1*/ << T52;
  assign T52 = next_index_tag;
  assign T53 = T57 ? T56 : T54;
  assign T54 = next_index_tag + T55;
  assign T55 = {3'h0/* 0*/, 1'h1/* 1*/};
  assign T56 = {3'h0/* 0*/, 1'h0/* 0*/};
  assign T57 = next_index_tag == 4'hf/* 15*/;
  assign T58 = T43 ? T60 : T59;
  assign T59 = io_mcache_ctrlrepl_w_data[4'ha/* 10*/:1'h0/* 0*/];
  assign T60 = {10'h0/* 0*/, 1'h0/* 0*/};
  assign T61 = T64 || T62;
  assign T62 = T31 && T63;
  assign T63 = T45[1'h1/* 1*/:1'h1/* 1*/];
  assign T64 = io_mcache_ctrlrepl_w_tag && T65;
  assign T65 = T50[1'h1/* 1*/:1'h1/* 1*/];
  assign T66 = T62 ? T67 : T59;
  assign T67 = {10'h0/* 0*/, 1'h0/* 0*/};
  assign T68 = T52[1'h0/* 0*/:1'h0/* 0*/];
  assign T69 = T84 ? mcache_size_vec_3 : mcache_size_vec_2;
  assign T70 = T73 || T71;
  assign T71 = T31 && T72;
  assign T72 = T45[2'h2/* 2*/:2'h2/* 2*/];
  assign T73 = io_mcache_ctrlrepl_w_tag && T74;
  assign T74 = T50[2'h2/* 2*/:2'h2/* 2*/];
  assign T75 = T71 ? T76 : T59;
  assign T76 = {10'h0/* 0*/, 1'h0/* 0*/};
  assign T77 = T80 || T78;
  assign T78 = T31 && T79;
  assign T79 = T45[2'h3/* 3*/:2'h3/* 3*/];
  assign T80 = io_mcache_ctrlrepl_w_tag && T81;
  assign T81 = T50[2'h3/* 3*/:2'h3/* 3*/];
  assign T82 = T78 ? T83 : T59;
  assign T83 = {10'h0/* 0*/, 1'h0/* 0*/};
  assign T84 = T52[1'h0/* 0*/:1'h0/* 0*/];
  assign T85 = T52[1'h1/* 1*/:1'h1/* 1*/];
  assign T86 = T119 ? T103 : T87;
  assign T87 = T102 ? mcache_size_vec_5 : mcache_size_vec_4;
  assign T88 = T91 || T89;
  assign T89 = T31 && T90;
  assign T90 = T45[3'h4/* 4*/:3'h4/* 4*/];
  assign T91 = io_mcache_ctrlrepl_w_tag && T92;
  assign T92 = T50[3'h4/* 4*/:3'h4/* 4*/];
  assign T93 = T89 ? T94 : T59;
  assign T94 = {10'h0/* 0*/, 1'h0/* 0*/};
  assign T95 = T98 || T96;
  assign T96 = T31 && T97;
  assign T97 = T45[3'h5/* 5*/:3'h5/* 5*/];
  assign T98 = io_mcache_ctrlrepl_w_tag && T99;
  assign T99 = T50[3'h5/* 5*/:3'h5/* 5*/];
  assign T100 = T96 ? T101 : T59;
  assign T101 = {10'h0/* 0*/, 1'h0/* 0*/};
  assign T102 = T52[1'h0/* 0*/:1'h0/* 0*/];
  assign T103 = T118 ? mcache_size_vec_7 : mcache_size_vec_6;
  assign T104 = T107 || T105;
  assign T105 = T31 && T106;
  assign T106 = T45[3'h6/* 6*/:3'h6/* 6*/];
  assign T107 = io_mcache_ctrlrepl_w_tag && T108;
  assign T108 = T50[3'h6/* 6*/:3'h6/* 6*/];
  assign T109 = T105 ? T110 : T59;
  assign T110 = {10'h0/* 0*/, 1'h0/* 0*/};
  assign T111 = T114 || T112;
  assign T112 = T31 && T113;
  assign T113 = T45[3'h7/* 7*/:3'h7/* 7*/];
  assign T114 = io_mcache_ctrlrepl_w_tag && T115;
  assign T115 = T50[3'h7/* 7*/:3'h7/* 7*/];
  assign T116 = T112 ? T117 : T59;
  assign T117 = {10'h0/* 0*/, 1'h0/* 0*/};
  assign T118 = T52[1'h0/* 0*/:1'h0/* 0*/];
  assign T119 = T52[1'h1/* 1*/:1'h1/* 1*/];
  assign T120 = T52[2'h2/* 2*/:2'h2/* 2*/];
  assign T121 = T190 ? T156 : T122;
  assign T122 = T155 ? T139 : T123;
  assign T123 = T138 ? mcache_size_vec_9 : mcache_size_vec_8;
  assign T124 = T127 || T125;
  assign T125 = T31 && T126;
  assign T126 = T45[4'h8/* 8*/:4'h8/* 8*/];
  assign T127 = io_mcache_ctrlrepl_w_tag && T128;
  assign T128 = T50[4'h8/* 8*/:4'h8/* 8*/];
  assign T129 = T125 ? T130 : T59;
  assign T130 = {10'h0/* 0*/, 1'h0/* 0*/};
  assign T131 = T134 || T132;
  assign T132 = T31 && T133;
  assign T133 = T45[4'h9/* 9*/:4'h9/* 9*/];
  assign T134 = io_mcache_ctrlrepl_w_tag && T135;
  assign T135 = T50[4'h9/* 9*/:4'h9/* 9*/];
  assign T136 = T132 ? T137 : T59;
  assign T137 = {10'h0/* 0*/, 1'h0/* 0*/};
  assign T138 = T52[1'h0/* 0*/:1'h0/* 0*/];
  assign T139 = T154 ? mcache_size_vec_11 : mcache_size_vec_10;
  assign T140 = T143 || T141;
  assign T141 = T31 && T142;
  assign T142 = T45[4'ha/* 10*/:4'ha/* 10*/];
  assign T143 = io_mcache_ctrlrepl_w_tag && T144;
  assign T144 = T50[4'ha/* 10*/:4'ha/* 10*/];
  assign T145 = T141 ? T146 : T59;
  assign T146 = {10'h0/* 0*/, 1'h0/* 0*/};
  assign T147 = T150 || T148;
  assign T148 = T31 && T149;
  assign T149 = T45[4'hb/* 11*/:4'hb/* 11*/];
  assign T150 = io_mcache_ctrlrepl_w_tag && T151;
  assign T151 = T50[4'hb/* 11*/:4'hb/* 11*/];
  assign T152 = T148 ? T153 : T59;
  assign T153 = {10'h0/* 0*/, 1'h0/* 0*/};
  assign T154 = T52[1'h0/* 0*/:1'h0/* 0*/];
  assign T155 = T52[1'h1/* 1*/:1'h1/* 1*/];
  assign T156 = T189 ? T173 : T157;
  assign T157 = T172 ? mcache_size_vec_13 : mcache_size_vec_12;
  assign T158 = T161 || T159;
  assign T159 = T31 && T160;
  assign T160 = T45[4'hc/* 12*/:4'hc/* 12*/];
  assign T161 = io_mcache_ctrlrepl_w_tag && T162;
  assign T162 = T50[4'hc/* 12*/:4'hc/* 12*/];
  assign T163 = T159 ? T164 : T59;
  assign T164 = {10'h0/* 0*/, 1'h0/* 0*/};
  assign T165 = T168 || T166;
  assign T166 = T31 && T167;
  assign T167 = T45[4'hd/* 13*/:4'hd/* 13*/];
  assign T168 = io_mcache_ctrlrepl_w_tag && T169;
  assign T169 = T50[4'hd/* 13*/:4'hd/* 13*/];
  assign T170 = T166 ? T171 : T59;
  assign T171 = {10'h0/* 0*/, 1'h0/* 0*/};
  assign T172 = T52[1'h0/* 0*/:1'h0/* 0*/];
  assign T173 = T188 ? mcache_size_vec_15 : mcache_size_vec_14;
  assign T174 = T177 || T175;
  assign T175 = T31 && T176;
  assign T176 = T45[4'he/* 14*/:4'he/* 14*/];
  assign T177 = io_mcache_ctrlrepl_w_tag && T178;
  assign T178 = T50[4'he/* 14*/:4'he/* 14*/];
  assign T179 = T175 ? T180 : T59;
  assign T180 = {10'h0/* 0*/, 1'h0/* 0*/};
  assign T181 = T184 || T182;
  assign T182 = T31 && T183;
  assign T183 = T45[4'hf/* 15*/:4'hf/* 15*/];
  assign T184 = io_mcache_ctrlrepl_w_tag && T185;
  assign T185 = T50[4'hf/* 15*/:4'hf/* 15*/];
  assign T186 = T182 ? T187 : T59;
  assign T187 = {10'h0/* 0*/, 1'h0/* 0*/};
  assign T188 = T52[1'h0/* 0*/:1'h0/* 0*/];
  assign T189 = T52[1'h1/* 1*/:1'h1/* 1*/];
  assign T190 = T52[2'h2/* 2*/:2'h2/* 2*/];
  assign T191 = T52[2'h3/* 3*/:2'h3/* 3*/];
  assign T192 = $signed(free_space) - $signed(T193);
  assign T193 = T194;
  assign T194 = {1'h0/* 0*/, T195};
  assign T195 = io_mcache_ctrlrepl_w_data[4'ha/* 10*/:1'h0/* 0*/];
  assign T196 = $signed(free_space) + $signed(T197);
  assign T197 = T198;
  assign T198 = {1'h0/* 0*/, T199};
  assign T199 = T228 ? T214 : T200;
  assign T200 = T213 ? T207 : T201;
  assign T201 = T206 ? T204 : T202;
  assign T202 = T203 ? mcache_size_vec_1 : mcache_size_vec_0;
  assign T203 = T47[1'h0/* 0*/:1'h0/* 0*/];
  assign T204 = T205 ? mcache_size_vec_3 : mcache_size_vec_2;
  assign T205 = T47[1'h0/* 0*/:1'h0/* 0*/];
  assign T206 = T47[1'h1/* 1*/:1'h1/* 1*/];
  assign T207 = T212 ? T210 : T208;
  assign T208 = T209 ? mcache_size_vec_5 : mcache_size_vec_4;
  assign T209 = T47[1'h0/* 0*/:1'h0/* 0*/];
  assign T210 = T211 ? mcache_size_vec_7 : mcache_size_vec_6;
  assign T211 = T47[1'h0/* 0*/:1'h0/* 0*/];
  assign T212 = T47[1'h1/* 1*/:1'h1/* 1*/];
  assign T213 = T47[2'h2/* 2*/:2'h2/* 2*/];
  assign T214 = T227 ? T221 : T215;
  assign T215 = T220 ? T218 : T216;
  assign T216 = T217 ? mcache_size_vec_9 : mcache_size_vec_8;
  assign T217 = T47[1'h0/* 0*/:1'h0/* 0*/];
  assign T218 = T219 ? mcache_size_vec_11 : mcache_size_vec_10;
  assign T219 = T47[1'h0/* 0*/:1'h0/* 0*/];
  assign T220 = T47[1'h1/* 1*/:1'h1/* 1*/];
  assign T221 = T226 ? T224 : T222;
  assign T222 = T223 ? mcache_size_vec_13 : mcache_size_vec_12;
  assign T223 = T47[1'h0/* 0*/:1'h0/* 0*/];
  assign T224 = T225 ? mcache_size_vec_15 : mcache_size_vec_14;
  assign T225 = T47[1'h0/* 0*/:1'h0/* 0*/];
  assign T226 = T47[1'h1/* 1*/:1'h1/* 1*/];
  assign T227 = T47[2'h2/* 2*/:2'h2/* 2*/];
  assign T228 = T47[2'h3/* 3*/:2'h3/* 3*/];
  assign T229 = io_mcache_ctrlrepl_w_tag && T230;
  assign T230 = next_replace_tag == next_index_tag;
  assign T231 = T31 ? T232 : T53;
  assign T232 = T236 ? T235 : T233;
  assign T233 = next_replace_tag + T234;
  assign T234 = {3'h0/* 0*/, 1'h1/* 1*/};
  assign T235 = {3'h0/* 0*/, 1'h0/* 0*/};
  assign T236 = next_replace_tag == 4'hf/* 15*/;
  assign T237 = io_mcache_ctrlrepl_w_tag && T238;
  assign T238 = T239[1'h0/* 0*/:1'h0/* 0*/];
  assign T239 = T240[4'hf/* 15*/:1'h0/* 0*/];
  assign T240 = 16'h1/* 1*/ << T241;
  assign T241 = next_index_tag;
  assign T242 = T25 ? 1'h0/* 0*/ : 1'h1/* 1*/;
  assign T243 = io_exmcache_callRetBase == mcache_addr_vec_0;
  assign T244 = io_mcache_ctrlrepl_w_tag && T245;
  assign T245 = T246[1'h0/* 0*/:1'h0/* 0*/];
  assign T246 = T247[4'hf/* 15*/:1'h0/* 0*/];
  assign T247 = 16'h1/* 1*/ << T248;
  assign T248 = next_index_tag;
  assign T249 = T253 && T250;
  assign T250 = T252 >= T251;
  assign T251 = {16'h0/* 0*/, 1'h1/* 1*/};
  assign T252 = io_exmcache_callRetBase[5'h1f/* 31*/:4'hf/* 15*/];
  assign T253 = io_exmcache_doCallRet && io_ena_in;
  assign T254 = T249 && T255;
  assign T255 = T262 && mcache_valid_vec_1;
  assign T256 = T259 || T257;
  assign T257 = T31 && T258;
  assign T258 = T27[1'h1/* 1*/:1'h1/* 1*/];
  assign T259 = io_mcache_ctrlrepl_w_tag && T260;
  assign T260 = T239[1'h1/* 1*/:1'h1/* 1*/];
  assign T261 = T257 ? 1'h0/* 0*/ : 1'h1/* 1*/;
  assign T262 = io_exmcache_callRetBase == mcache_addr_vec_1;
  assign T263 = io_mcache_ctrlrepl_w_tag && T264;
  assign T264 = T246[1'h1/* 1*/:1'h1/* 1*/];
  assign T265 = T249 && T266;
  assign T266 = T273 && mcache_valid_vec_2;
  assign T267 = T270 || T268;
  assign T268 = T31 && T269;
  assign T269 = T27[2'h2/* 2*/:2'h2/* 2*/];
  assign T270 = io_mcache_ctrlrepl_w_tag && T271;
  assign T271 = T239[2'h2/* 2*/:2'h2/* 2*/];
  assign T272 = T268 ? 1'h0/* 0*/ : 1'h1/* 1*/;
  assign T273 = io_exmcache_callRetBase == mcache_addr_vec_2;
  assign T274 = io_mcache_ctrlrepl_w_tag && T275;
  assign T275 = T246[2'h2/* 2*/:2'h2/* 2*/];
  assign T276 = T249 && T277;
  assign T277 = T284 && mcache_valid_vec_3;
  assign T278 = T281 || T279;
  assign T279 = T31 && T280;
  assign T280 = T27[2'h3/* 3*/:2'h3/* 3*/];
  assign T281 = io_mcache_ctrlrepl_w_tag && T282;
  assign T282 = T239[2'h3/* 3*/:2'h3/* 3*/];
  assign T283 = T279 ? 1'h0/* 0*/ : 1'h1/* 1*/;
  assign T284 = io_exmcache_callRetBase == mcache_addr_vec_3;
  assign T285 = io_mcache_ctrlrepl_w_tag && T286;
  assign T286 = T246[2'h3/* 3*/:2'h3/* 3*/];
  assign T287 = T249 && T288;
  assign T288 = T295 && mcache_valid_vec_4;
  assign T289 = T292 || T290;
  assign T290 = T31 && T291;
  assign T291 = T27[3'h4/* 4*/:3'h4/* 4*/];
  assign T292 = io_mcache_ctrlrepl_w_tag && T293;
  assign T293 = T239[3'h4/* 4*/:3'h4/* 4*/];
  assign T294 = T290 ? 1'h0/* 0*/ : 1'h1/* 1*/;
  assign T295 = io_exmcache_callRetBase == mcache_addr_vec_4;
  assign T296 = io_mcache_ctrlrepl_w_tag && T297;
  assign T297 = T246[3'h4/* 4*/:3'h4/* 4*/];
  assign T298 = T249 && T299;
  assign T299 = T306 && mcache_valid_vec_5;
  assign T300 = T303 || T301;
  assign T301 = T31 && T302;
  assign T302 = T27[3'h5/* 5*/:3'h5/* 5*/];
  assign T303 = io_mcache_ctrlrepl_w_tag && T304;
  assign T304 = T239[3'h5/* 5*/:3'h5/* 5*/];
  assign T305 = T301 ? 1'h0/* 0*/ : 1'h1/* 1*/;
  assign T306 = io_exmcache_callRetBase == mcache_addr_vec_5;
  assign T307 = io_mcache_ctrlrepl_w_tag && T308;
  assign T308 = T246[3'h5/* 5*/:3'h5/* 5*/];
  assign T309 = T249 && T310;
  assign T310 = T317 && mcache_valid_vec_6;
  assign T311 = T314 || T312;
  assign T312 = T31 && T313;
  assign T313 = T27[3'h6/* 6*/:3'h6/* 6*/];
  assign T314 = io_mcache_ctrlrepl_w_tag && T315;
  assign T315 = T239[3'h6/* 6*/:3'h6/* 6*/];
  assign T316 = T312 ? 1'h0/* 0*/ : 1'h1/* 1*/;
  assign T317 = io_exmcache_callRetBase == mcache_addr_vec_6;
  assign T318 = io_mcache_ctrlrepl_w_tag && T319;
  assign T319 = T246[3'h6/* 6*/:3'h6/* 6*/];
  assign T320 = T249 && T321;
  assign T321 = T328 && mcache_valid_vec_7;
  assign T322 = T325 || T323;
  assign T323 = T31 && T324;
  assign T324 = T27[3'h7/* 7*/:3'h7/* 7*/];
  assign T325 = io_mcache_ctrlrepl_w_tag && T326;
  assign T326 = T239[3'h7/* 7*/:3'h7/* 7*/];
  assign T327 = T323 ? 1'h0/* 0*/ : 1'h1/* 1*/;
  assign T328 = io_exmcache_callRetBase == mcache_addr_vec_7;
  assign T329 = io_mcache_ctrlrepl_w_tag && T330;
  assign T330 = T246[3'h7/* 7*/:3'h7/* 7*/];
  assign T331 = T249 && T332;
  assign T332 = T339 && mcache_valid_vec_8;
  assign T333 = T336 || T334;
  assign T334 = T31 && T335;
  assign T335 = T27[4'h8/* 8*/:4'h8/* 8*/];
  assign T336 = io_mcache_ctrlrepl_w_tag && T337;
  assign T337 = T239[4'h8/* 8*/:4'h8/* 8*/];
  assign T338 = T334 ? 1'h0/* 0*/ : 1'h1/* 1*/;
  assign T339 = io_exmcache_callRetBase == mcache_addr_vec_8;
  assign T340 = io_mcache_ctrlrepl_w_tag && T341;
  assign T341 = T246[4'h8/* 8*/:4'h8/* 8*/];
  assign T342 = T249 && T343;
  assign T343 = T350 && mcache_valid_vec_9;
  assign T344 = T347 || T345;
  assign T345 = T31 && T346;
  assign T346 = T27[4'h9/* 9*/:4'h9/* 9*/];
  assign T347 = io_mcache_ctrlrepl_w_tag && T348;
  assign T348 = T239[4'h9/* 9*/:4'h9/* 9*/];
  assign T349 = T345 ? 1'h0/* 0*/ : 1'h1/* 1*/;
  assign T350 = io_exmcache_callRetBase == mcache_addr_vec_9;
  assign T351 = io_mcache_ctrlrepl_w_tag && T352;
  assign T352 = T246[4'h9/* 9*/:4'h9/* 9*/];
  assign T353 = T249 && T354;
  assign T354 = T361 && mcache_valid_vec_10;
  assign T355 = T358 || T356;
  assign T356 = T31 && T357;
  assign T357 = T27[4'ha/* 10*/:4'ha/* 10*/];
  assign T358 = io_mcache_ctrlrepl_w_tag && T359;
  assign T359 = T239[4'ha/* 10*/:4'ha/* 10*/];
  assign T360 = T356 ? 1'h0/* 0*/ : 1'h1/* 1*/;
  assign T361 = io_exmcache_callRetBase == mcache_addr_vec_10;
  assign T362 = io_mcache_ctrlrepl_w_tag && T363;
  assign T363 = T246[4'ha/* 10*/:4'ha/* 10*/];
  assign T364 = T249 && T365;
  assign T365 = T372 && mcache_valid_vec_11;
  assign T366 = T369 || T367;
  assign T367 = T31 && T368;
  assign T368 = T27[4'hb/* 11*/:4'hb/* 11*/];
  assign T369 = io_mcache_ctrlrepl_w_tag && T370;
  assign T370 = T239[4'hb/* 11*/:4'hb/* 11*/];
  assign T371 = T367 ? 1'h0/* 0*/ : 1'h1/* 1*/;
  assign T372 = io_exmcache_callRetBase == mcache_addr_vec_11;
  assign T373 = io_mcache_ctrlrepl_w_tag && T374;
  assign T374 = T246[4'hb/* 11*/:4'hb/* 11*/];
  assign T375 = T249 && T376;
  assign T376 = T383 && mcache_valid_vec_12;
  assign T377 = T380 || T378;
  assign T378 = T31 && T379;
  assign T379 = T27[4'hc/* 12*/:4'hc/* 12*/];
  assign T380 = io_mcache_ctrlrepl_w_tag && T381;
  assign T381 = T239[4'hc/* 12*/:4'hc/* 12*/];
  assign T382 = T378 ? 1'h0/* 0*/ : 1'h1/* 1*/;
  assign T383 = io_exmcache_callRetBase == mcache_addr_vec_12;
  assign T384 = io_mcache_ctrlrepl_w_tag && T385;
  assign T385 = T246[4'hc/* 12*/:4'hc/* 12*/];
  assign T386 = T249 && T387;
  assign T387 = T394 && mcache_valid_vec_13;
  assign T388 = T391 || T389;
  assign T389 = T31 && T390;
  assign T390 = T27[4'hd/* 13*/:4'hd/* 13*/];
  assign T391 = io_mcache_ctrlrepl_w_tag && T392;
  assign T392 = T239[4'hd/* 13*/:4'hd/* 13*/];
  assign T393 = T389 ? 1'h0/* 0*/ : 1'h1/* 1*/;
  assign T394 = io_exmcache_callRetBase == mcache_addr_vec_13;
  assign T395 = io_mcache_ctrlrepl_w_tag && T396;
  assign T396 = T246[4'hd/* 13*/:4'hd/* 13*/];
  assign T397 = T249 && T398;
  assign T398 = T405 && mcache_valid_vec_14;
  assign T399 = T402 || T400;
  assign T400 = T31 && T401;
  assign T401 = T27[4'he/* 14*/:4'he/* 14*/];
  assign T402 = io_mcache_ctrlrepl_w_tag && T403;
  assign T403 = T239[4'he/* 14*/:4'he/* 14*/];
  assign T404 = T400 ? 1'h0/* 0*/ : 1'h1/* 1*/;
  assign T405 = io_exmcache_callRetBase == mcache_addr_vec_14;
  assign T406 = io_mcache_ctrlrepl_w_tag && T407;
  assign T407 = T246[4'he/* 14*/:4'he/* 14*/];
  assign T408 = T249 && T409;
  assign T409 = T416 && mcache_valid_vec_15;
  assign T410 = T413 || T411;
  assign T411 = T31 && T412;
  assign T412 = T27[4'hf/* 15*/:4'hf/* 15*/];
  assign T413 = io_mcache_ctrlrepl_w_tag && T414;
  assign T414 = T239[4'hf/* 15*/:4'hf/* 15*/];
  assign T415 = T411 ? 1'h0/* 0*/ : 1'h1/* 1*/;
  assign T416 = io_exmcache_callRetBase == mcache_addr_vec_15;
  assign T417 = io_mcache_ctrlrepl_w_tag && T418;
  assign T418 = T246[4'hf/* 15*/:4'hf/* 15*/];
  assign T419 = T6 ? T422 : next_replace_pos;
  assign T420 = next_replace_pos + T421;
  assign T421 = io_mcache_ctrlrepl_w_data[4'h9/* 9*/:1'h0/* 0*/];
  assign T422 = T430 | mergePosVec_15;
  assign mergePosVec_15 = T423;
  assign T423 = T408 ? mcache_pos_vec_15 : T424;
  assign T424 = {9'h0/* 0*/, 1'h0/* 0*/};
  assign T425 = io_mcache_ctrlrepl_w_tag && T426;
  assign T426 = T427[4'hf/* 15*/:4'hf/* 15*/];
  assign T427 = T428[4'hf/* 15*/:1'h0/* 0*/];
  assign T428 = 16'h1/* 1*/ << T429;
  assign T429 = next_index_tag;
  assign T430 = T435 | mergePosVec_14;
  assign mergePosVec_14 = T431;
  assign T431 = T397 ? mcache_pos_vec_14 : T432;
  assign T432 = {9'h0/* 0*/, 1'h0/* 0*/};
  assign T433 = io_mcache_ctrlrepl_w_tag && T434;
  assign T434 = T427[4'he/* 14*/:4'he/* 14*/];
  assign T435 = T440 | mergePosVec_13;
  assign mergePosVec_13 = T436;
  assign T436 = T386 ? mcache_pos_vec_13 : T437;
  assign T437 = {9'h0/* 0*/, 1'h0/* 0*/};
  assign T438 = io_mcache_ctrlrepl_w_tag && T439;
  assign T439 = T427[4'hd/* 13*/:4'hd/* 13*/];
  assign T440 = T445 | mergePosVec_12;
  assign mergePosVec_12 = T441;
  assign T441 = T375 ? mcache_pos_vec_12 : T442;
  assign T442 = {9'h0/* 0*/, 1'h0/* 0*/};
  assign T443 = io_mcache_ctrlrepl_w_tag && T444;
  assign T444 = T427[4'hc/* 12*/:4'hc/* 12*/];
  assign T445 = T450 | mergePosVec_11;
  assign mergePosVec_11 = T446;
  assign T446 = T364 ? mcache_pos_vec_11 : T447;
  assign T447 = {9'h0/* 0*/, 1'h0/* 0*/};
  assign T448 = io_mcache_ctrlrepl_w_tag && T449;
  assign T449 = T427[4'hb/* 11*/:4'hb/* 11*/];
  assign T450 = T455 | mergePosVec_10;
  assign mergePosVec_10 = T451;
  assign T451 = T353 ? mcache_pos_vec_10 : T452;
  assign T452 = {9'h0/* 0*/, 1'h0/* 0*/};
  assign T453 = io_mcache_ctrlrepl_w_tag && T454;
  assign T454 = T427[4'ha/* 10*/:4'ha/* 10*/];
  assign T455 = T460 | mergePosVec_9;
  assign mergePosVec_9 = T456;
  assign T456 = T342 ? mcache_pos_vec_9 : T457;
  assign T457 = {9'h0/* 0*/, 1'h0/* 0*/};
  assign T458 = io_mcache_ctrlrepl_w_tag && T459;
  assign T459 = T427[4'h9/* 9*/:4'h9/* 9*/];
  assign T460 = T465 | mergePosVec_8;
  assign mergePosVec_8 = T461;
  assign T461 = T331 ? mcache_pos_vec_8 : T462;
  assign T462 = {9'h0/* 0*/, 1'h0/* 0*/};
  assign T463 = io_mcache_ctrlrepl_w_tag && T464;
  assign T464 = T427[4'h8/* 8*/:4'h8/* 8*/];
  assign T465 = T470 | mergePosVec_7;
  assign mergePosVec_7 = T466;
  assign T466 = T320 ? mcache_pos_vec_7 : T467;
  assign T467 = {9'h0/* 0*/, 1'h0/* 0*/};
  assign T468 = io_mcache_ctrlrepl_w_tag && T469;
  assign T469 = T427[3'h7/* 7*/:3'h7/* 7*/];
  assign T470 = T475 | mergePosVec_6;
  assign mergePosVec_6 = T471;
  assign T471 = T309 ? mcache_pos_vec_6 : T472;
  assign T472 = {9'h0/* 0*/, 1'h0/* 0*/};
  assign T473 = io_mcache_ctrlrepl_w_tag && T474;
  assign T474 = T427[3'h6/* 6*/:3'h6/* 6*/];
  assign T475 = T480 | mergePosVec_5;
  assign mergePosVec_5 = T476;
  assign T476 = T298 ? mcache_pos_vec_5 : T477;
  assign T477 = {9'h0/* 0*/, 1'h0/* 0*/};
  assign T478 = io_mcache_ctrlrepl_w_tag && T479;
  assign T479 = T427[3'h5/* 5*/:3'h5/* 5*/];
  assign T480 = T485 | mergePosVec_4;
  assign mergePosVec_4 = T481;
  assign T481 = T287 ? mcache_pos_vec_4 : T482;
  assign T482 = {9'h0/* 0*/, 1'h0/* 0*/};
  assign T483 = io_mcache_ctrlrepl_w_tag && T484;
  assign T484 = T427[3'h4/* 4*/:3'h4/* 4*/];
  assign T485 = T490 | mergePosVec_3;
  assign mergePosVec_3 = T486;
  assign T486 = T276 ? mcache_pos_vec_3 : T487;
  assign T487 = {9'h0/* 0*/, 1'h0/* 0*/};
  assign T488 = io_mcache_ctrlrepl_w_tag && T489;
  assign T489 = T427[2'h3/* 3*/:2'h3/* 3*/];
  assign T490 = T495 | mergePosVec_2;
  assign mergePosVec_2 = T491;
  assign T491 = T265 ? mcache_pos_vec_2 : T492;
  assign T492 = {9'h0/* 0*/, 1'h0/* 0*/};
  assign T493 = io_mcache_ctrlrepl_w_tag && T494;
  assign T494 = T427[2'h2/* 2*/:2'h2/* 2*/];
  assign T495 = T500 | mergePosVec_1;
  assign mergePosVec_1 = T496;
  assign T496 = T254 ? mcache_pos_vec_1 : T497;
  assign T497 = {9'h0/* 0*/, 1'h0/* 0*/};
  assign T498 = io_mcache_ctrlrepl_w_tag && T499;
  assign T499 = T427[1'h1/* 1*/:1'h1/* 1*/];
  assign T500 = T505 | mergePosVec_0;
  assign mergePosVec_0 = T501;
  assign T501 = T22 ? mcache_pos_vec_0 : T502;
  assign T502 = {9'h0/* 0*/, 1'h0/* 0*/};
  assign T503 = io_mcache_ctrlrepl_w_tag && T504;
  assign T504 = T427[1'h0/* 0*/:1'h0/* 0*/];
  assign T505 = {9'h0/* 0*/, 1'h0/* 0*/};
  assign io_mcachemem_in_w_data = io_mcache_ctrlrepl_w_data;
  assign io_mcachemem_in_w_odd = T506;
  assign T506 = wr_parity ? io_mcache_ctrlrepl_w_enable : 1'h0/* 0*/;
  assign wr_parity = io_mcache_ctrlrepl_w_addr[1'h0/* 0*/:1'h0/* 0*/];
  assign io_mcachemem_in_w_even = T507;
  assign T507 = wr_parity ? 1'h0/* 0*/ : io_mcache_ctrlrepl_w_enable;
  assign io_mcache_replctrl_pos_offset = T508;
  assign T508 = {1'h0/* 0*/, wrPosReg};
  assign io_mcache_replctrl_hit = hitReg;
  assign T509 = T510 || io_mcache_ctrlrepl_w_tag;
  assign T510 = T511 || T408;
  assign T511 = T512 || T397;
  assign T512 = T513 || T386;
  assign T513 = T514 || T375;
  assign T514 = T515 || T364;
  assign T515 = T516 || T353;
  assign T516 = T517 || T342;
  assign T517 = T518 || T331;
  assign T518 = T519 || T320;
  assign T519 = T520 || T309;
  assign T520 = T521 || T298;
  assign T521 = T522 || T287;
  assign T522 = T523 || T276;
  assign T523 = T524 || T265;
  assign T524 = T525 || T254;
  assign T525 = T249 || T22;
  assign T526 = io_mcache_ctrlrepl_w_tag ? 1'h1/* 1*/ : T527;
  assign T527 = T408 ? 1'h1/* 1*/ : T528;
  assign T528 = T397 ? 1'h1/* 1*/ : T529;
  assign T529 = T386 ? 1'h1/* 1*/ : T530;
  assign T530 = T375 ? 1'h1/* 1*/ : T531;
  assign T531 = T364 ? 1'h1/* 1*/ : T532;
  assign T532 = T353 ? 1'h1/* 1*/ : T533;
  assign T533 = T342 ? 1'h1/* 1*/ : T534;
  assign T534 = T331 ? 1'h1/* 1*/ : T535;
  assign T535 = T320 ? 1'h1/* 1*/ : T536;
  assign T536 = T309 ? 1'h1/* 1*/ : T537;
  assign T537 = T298 ? 1'h1/* 1*/ : T538;
  assign T538 = T287 ? 1'h1/* 1*/ : T539;
  assign T539 = T276 ? 1'h1/* 1*/ : T540;
  assign T540 = T265 ? 1'h1/* 1*/ : T541;
  assign T541 = T254 ? 1'h1/* 1*/ : T22;
  assign io_mcachefe_mem_sel = T542;
  assign T542 = {selIspmReg, selMCacheReg};
  assign T543 = T545 >= T544;
  assign T544 = {16'h0/* 0*/, 1'h1/* 1*/};
  assign T545 = io_exmcache_callRetBase[5'h1f/* 31*/:4'hf/* 15*/];
  assign T546 = T548 == T547;
  assign T547 = {17'h0/* 0*/, 1'h1/* 1*/};
  assign T548 = io_exmcache_callRetBase[5'h1f/* 31*/:4'he/* 14*/];
  assign io_mcachefe_reloc = reloc;
  assign reloc = selMCacheReg ? T552 : T549;
  assign T549 = {17'h0/* 0*/, T550};
  assign T550 = selIspmReg ? 15'h4000/* 16384*/ : T551;
  assign T551 = {14'h0/* 0*/, 1'h0/* 0*/};
  assign T552 = callRetBaseReg - T553;
  assign T553 = {22'h0/* 0*/, T554};
  assign T554 = posReg;
  assign io_mcachefe_relPc = T555;
  assign T555 = relPc[4'hb/* 11*/:1'h0/* 0*/];
  assign relPc = callAddrReg + T556;
  assign T556 = {18'h0/* 0*/, relBase};
  assign relBase = selMCacheReg ? T558 : T557;
  assign T557 = callRetBaseReg[4'hd/* 13*/:1'h0/* 0*/];
  assign T558 = {4'h0/* 0*/, T559};
  assign T559 = posReg;
  assign io_mcachefe_relBase = T560;
  assign T560 = relBase[4'ha/* 10*/:1'h0/* 0*/];
  assign io_mcachefe_instr_b = T561;
  assign T561 = io_mcache_ctrlrepl_instr_stall ? instr_bReg : instr_b;
  assign instr_b = addr_parity_reg ? io_mcachemem_out_instr_even : io_mcachemem_out_instr_odd;
  assign T562 = ! io_mcache_ctrlrepl_instr_stall;
  assign io_mcachefe_instr_a = T563;
  assign T563 = io_mcache_ctrlrepl_instr_stall ? instr_aReg : instr_a;
  assign instr_a = addr_parity_reg ? io_mcachemem_out_instr_odd : io_mcachemem_out_instr_even;
  assign io_hit_ena = hitReg;

  always @(posedge clk) begin
    if(reset) begin
      wrPosReg <= 10'h0/* 0*/;
    end else if(io_mcache_ctrlrepl_w_tag) begin
      wrPosReg <= posReg;
    end
    if(reset) begin
      posReg <= 10'h0/* 0*/;
    end else if(T5) begin
      posReg <= T419;
    end
    if(reset) begin
      mcache_valid_vec_0 <= 1'h0/* 0*/;
    end else if(T24) begin
      mcache_valid_vec_0 <= T242;
    end
    if(reset) begin
      next_replace_tag <= 4'h0/* 0*/;
    end else if(T30) begin
      next_replace_tag <= T231;
    end
    if(reset) begin
      free_space <= 12'h400/* 1024*/;
    end else if(T33) begin
      free_space <= T34;
    end
    if(reset) begin
      mcache_size_vec_0 <= 11'h0/* 0*/;
    end else if(T42) begin
      mcache_size_vec_0 <= T58;
    end
    if(reset) begin
      next_index_tag <= 4'h0/* 0*/;
    end else if(io_mcache_ctrlrepl_w_tag) begin
      next_index_tag <= T53;
    end
    if(reset) begin
      mcache_size_vec_1 <= 11'h0/* 0*/;
    end else if(T61) begin
      mcache_size_vec_1 <= T66;
    end
    if(reset) begin
      mcache_size_vec_2 <= 11'h0/* 0*/;
    end else if(T70) begin
      mcache_size_vec_2 <= T75;
    end
    if(reset) begin
      mcache_size_vec_3 <= 11'h0/* 0*/;
    end else if(T77) begin
      mcache_size_vec_3 <= T82;
    end
    if(reset) begin
      mcache_size_vec_4 <= 11'h0/* 0*/;
    end else if(T88) begin
      mcache_size_vec_4 <= T93;
    end
    if(reset) begin
      mcache_size_vec_5 <= 11'h0/* 0*/;
    end else if(T95) begin
      mcache_size_vec_5 <= T100;
    end
    if(reset) begin
      mcache_size_vec_6 <= 11'h0/* 0*/;
    end else if(T104) begin
      mcache_size_vec_6 <= T109;
    end
    if(reset) begin
      mcache_size_vec_7 <= 11'h0/* 0*/;
    end else if(T111) begin
      mcache_size_vec_7 <= T116;
    end
    if(reset) begin
      mcache_size_vec_8 <= 11'h0/* 0*/;
    end else if(T124) begin
      mcache_size_vec_8 <= T129;
    end
    if(reset) begin
      mcache_size_vec_9 <= 11'h0/* 0*/;
    end else if(T131) begin
      mcache_size_vec_9 <= T136;
    end
    if(reset) begin
      mcache_size_vec_10 <= 11'h0/* 0*/;
    end else if(T140) begin
      mcache_size_vec_10 <= T145;
    end
    if(reset) begin
      mcache_size_vec_11 <= 11'h0/* 0*/;
    end else if(T147) begin
      mcache_size_vec_11 <= T152;
    end
    if(reset) begin
      mcache_size_vec_12 <= 11'h0/* 0*/;
    end else if(T158) begin
      mcache_size_vec_12 <= T163;
    end
    if(reset) begin
      mcache_size_vec_13 <= 11'h0/* 0*/;
    end else if(T165) begin
      mcache_size_vec_13 <= T170;
    end
    if(reset) begin
      mcache_size_vec_14 <= 11'h0/* 0*/;
    end else if(T174) begin
      mcache_size_vec_14 <= T179;
    end
    if(reset) begin
      mcache_size_vec_15 <= 11'h0/* 0*/;
    end else if(T181) begin
      mcache_size_vec_15 <= T186;
    end
    if(reset) begin
      mcache_addr_vec_0 <= 32'h0/* 0*/;
    end else if(T244) begin
      mcache_addr_vec_0 <= io_mcache_ctrlrepl_w_addr;
    end
    if(reset) begin
      mcache_valid_vec_1 <= 1'h0/* 0*/;
    end else if(T256) begin
      mcache_valid_vec_1 <= T261;
    end
    if(reset) begin
      mcache_addr_vec_1 <= 32'h0/* 0*/;
    end else if(T263) begin
      mcache_addr_vec_1 <= io_mcache_ctrlrepl_w_addr;
    end
    if(reset) begin
      mcache_valid_vec_2 <= 1'h0/* 0*/;
    end else if(T267) begin
      mcache_valid_vec_2 <= T272;
    end
    if(reset) begin
      mcache_addr_vec_2 <= 32'h0/* 0*/;
    end else if(T274) begin
      mcache_addr_vec_2 <= io_mcache_ctrlrepl_w_addr;
    end
    if(reset) begin
      mcache_valid_vec_3 <= 1'h0/* 0*/;
    end else if(T278) begin
      mcache_valid_vec_3 <= T283;
    end
    if(reset) begin
      mcache_addr_vec_3 <= 32'h0/* 0*/;
    end else if(T285) begin
      mcache_addr_vec_3 <= io_mcache_ctrlrepl_w_addr;
    end
    if(reset) begin
      mcache_valid_vec_4 <= 1'h0/* 0*/;
    end else if(T289) begin
      mcache_valid_vec_4 <= T294;
    end
    if(reset) begin
      mcache_addr_vec_4 <= 32'h0/* 0*/;
    end else if(T296) begin
      mcache_addr_vec_4 <= io_mcache_ctrlrepl_w_addr;
    end
    if(reset) begin
      mcache_valid_vec_5 <= 1'h0/* 0*/;
    end else if(T300) begin
      mcache_valid_vec_5 <= T305;
    end
    if(reset) begin
      mcache_addr_vec_5 <= 32'h0/* 0*/;
    end else if(T307) begin
      mcache_addr_vec_5 <= io_mcache_ctrlrepl_w_addr;
    end
    if(reset) begin
      mcache_valid_vec_6 <= 1'h0/* 0*/;
    end else if(T311) begin
      mcache_valid_vec_6 <= T316;
    end
    if(reset) begin
      mcache_addr_vec_6 <= 32'h0/* 0*/;
    end else if(T318) begin
      mcache_addr_vec_6 <= io_mcache_ctrlrepl_w_addr;
    end
    if(reset) begin
      mcache_valid_vec_7 <= 1'h0/* 0*/;
    end else if(T322) begin
      mcache_valid_vec_7 <= T327;
    end
    if(reset) begin
      mcache_addr_vec_7 <= 32'h0/* 0*/;
    end else if(T329) begin
      mcache_addr_vec_7 <= io_mcache_ctrlrepl_w_addr;
    end
    if(reset) begin
      mcache_valid_vec_8 <= 1'h0/* 0*/;
    end else if(T333) begin
      mcache_valid_vec_8 <= T338;
    end
    if(reset) begin
      mcache_addr_vec_8 <= 32'h0/* 0*/;
    end else if(T340) begin
      mcache_addr_vec_8 <= io_mcache_ctrlrepl_w_addr;
    end
    if(reset) begin
      mcache_valid_vec_9 <= 1'h0/* 0*/;
    end else if(T344) begin
      mcache_valid_vec_9 <= T349;
    end
    if(reset) begin
      mcache_addr_vec_9 <= 32'h0/* 0*/;
    end else if(T351) begin
      mcache_addr_vec_9 <= io_mcache_ctrlrepl_w_addr;
    end
    if(reset) begin
      mcache_valid_vec_10 <= 1'h0/* 0*/;
    end else if(T355) begin
      mcache_valid_vec_10 <= T360;
    end
    if(reset) begin
      mcache_addr_vec_10 <= 32'h0/* 0*/;
    end else if(T362) begin
      mcache_addr_vec_10 <= io_mcache_ctrlrepl_w_addr;
    end
    if(reset) begin
      mcache_valid_vec_11 <= 1'h0/* 0*/;
    end else if(T366) begin
      mcache_valid_vec_11 <= T371;
    end
    if(reset) begin
      mcache_addr_vec_11 <= 32'h0/* 0*/;
    end else if(T373) begin
      mcache_addr_vec_11 <= io_mcache_ctrlrepl_w_addr;
    end
    if(reset) begin
      mcache_valid_vec_12 <= 1'h0/* 0*/;
    end else if(T377) begin
      mcache_valid_vec_12 <= T382;
    end
    if(reset) begin
      mcache_addr_vec_12 <= 32'h0/* 0*/;
    end else if(T384) begin
      mcache_addr_vec_12 <= io_mcache_ctrlrepl_w_addr;
    end
    if(reset) begin
      mcache_valid_vec_13 <= 1'h0/* 0*/;
    end else if(T388) begin
      mcache_valid_vec_13 <= T393;
    end
    if(reset) begin
      mcache_addr_vec_13 <= 32'h0/* 0*/;
    end else if(T395) begin
      mcache_addr_vec_13 <= io_mcache_ctrlrepl_w_addr;
    end
    if(reset) begin
      mcache_valid_vec_14 <= 1'h0/* 0*/;
    end else if(T399) begin
      mcache_valid_vec_14 <= T404;
    end
    if(reset) begin
      mcache_addr_vec_14 <= 32'h0/* 0*/;
    end else if(T406) begin
      mcache_addr_vec_14 <= io_mcache_ctrlrepl_w_addr;
    end
    if(reset) begin
      mcache_valid_vec_15 <= 1'h0/* 0*/;
    end else if(T410) begin
      mcache_valid_vec_15 <= T415;
    end
    if(reset) begin
      mcache_addr_vec_15 <= 32'h0/* 0*/;
    end else if(T417) begin
      mcache_addr_vec_15 <= io_mcache_ctrlrepl_w_addr;
    end
    if(reset) begin
      next_replace_pos <= 10'h0/* 0*/;
    end else if(io_mcache_ctrlrepl_w_tag) begin
      next_replace_pos <= T420;
    end
    if(reset) begin
      mcache_pos_vec_15 <= 10'h0/* 0*/;
    end else if(T425) begin
      mcache_pos_vec_15 <= next_replace_pos;
    end
    if(reset) begin
      mcache_pos_vec_14 <= 10'h0/* 0*/;
    end else if(T433) begin
      mcache_pos_vec_14 <= next_replace_pos;
    end
    if(reset) begin
      mcache_pos_vec_13 <= 10'h0/* 0*/;
    end else if(T438) begin
      mcache_pos_vec_13 <= next_replace_pos;
    end
    if(reset) begin
      mcache_pos_vec_12 <= 10'h0/* 0*/;
    end else if(T443) begin
      mcache_pos_vec_12 <= next_replace_pos;
    end
    if(reset) begin
      mcache_pos_vec_11 <= 10'h0/* 0*/;
    end else if(T448) begin
      mcache_pos_vec_11 <= next_replace_pos;
    end
    if(reset) begin
      mcache_pos_vec_10 <= 10'h0/* 0*/;
    end else if(T453) begin
      mcache_pos_vec_10 <= next_replace_pos;
    end
    if(reset) begin
      mcache_pos_vec_9 <= 10'h0/* 0*/;
    end else if(T458) begin
      mcache_pos_vec_9 <= next_replace_pos;
    end
    if(reset) begin
      mcache_pos_vec_8 <= 10'h0/* 0*/;
    end else if(T463) begin
      mcache_pos_vec_8 <= next_replace_pos;
    end
    if(reset) begin
      mcache_pos_vec_7 <= 10'h0/* 0*/;
    end else if(T468) begin
      mcache_pos_vec_7 <= next_replace_pos;
    end
    if(reset) begin
      mcache_pos_vec_6 <= 10'h0/* 0*/;
    end else if(T473) begin
      mcache_pos_vec_6 <= next_replace_pos;
    end
    if(reset) begin
      mcache_pos_vec_5 <= 10'h0/* 0*/;
    end else if(T478) begin
      mcache_pos_vec_5 <= next_replace_pos;
    end
    if(reset) begin
      mcache_pos_vec_4 <= 10'h0/* 0*/;
    end else if(T483) begin
      mcache_pos_vec_4 <= next_replace_pos;
    end
    if(reset) begin
      mcache_pos_vec_3 <= 10'h0/* 0*/;
    end else if(T488) begin
      mcache_pos_vec_3 <= next_replace_pos;
    end
    if(reset) begin
      mcache_pos_vec_2 <= 10'h0/* 0*/;
    end else if(T493) begin
      mcache_pos_vec_2 <= next_replace_pos;
    end
    if(reset) begin
      mcache_pos_vec_1 <= 10'h0/* 0*/;
    end else if(T498) begin
      mcache_pos_vec_1 <= next_replace_pos;
    end
    if(reset) begin
      mcache_pos_vec_0 <= 10'h0/* 0*/;
    end else if(T503) begin
      mcache_pos_vec_0 <= next_replace_pos;
    end
    if(reset) begin
      hitReg <= 1'h1/* 1*/;
    end else if(T509) begin
      hitReg <= T526;
    end
    if(reset) begin
      selMCacheReg <= 1'h0/* 0*/;
    end else if(T253) begin
      selMCacheReg <= T543;
    end
    if(reset) begin
      selIspmReg <= 1'h0/* 0*/;
    end else if(T253) begin
      selIspmReg <= T546;
    end
    if(reset) begin
      callRetBaseReg <= 32'h1/* 1*/;
    end else if(T253) begin
      callRetBaseReg <= io_exmcache_callRetBase;
    end
    if(reset) begin
      callAddrReg <= 32'h1/* 1*/;
    end else if(T253) begin
      callAddrReg <= io_exmcache_callRetAddr;
    end
    addr_parity_reg <= rd_parity;
    if(reset) begin
      instr_bReg <= 32'h0/* 0*/;
    end else if(T562) begin
      instr_bReg <= io_mcachefe_instr_b;
    end
    if(reset) begin
      instr_aReg <= 32'h0/* 0*/;
    end else if(T562) begin
      instr_aReg <= io_mcachefe_instr_a;
    end
  end
endmodule

module MCacheMem(input clk,
    input  io_mcachemem_in_w_even,
    input  io_mcachemem_in_w_odd,
    input [31:0] io_mcachemem_in_w_data,
    input [8:0] io_mcachemem_in_w_addr,
    input [8:0] io_mcachemem_in_addr_even,
    input [8:0] io_mcachemem_in_addr_odd,
    output[31:0] io_mcachemem_out_instr_even,
    output[31:0] io_mcachemem_out_instr_odd
);

  wire[31:0] T0;
  reg [31:0] ram_mcache_odd [511:0];
  wire[31:0] T1;
  wire[31:0] T2;
  reg[8:0] addrOddReg;
  wire[31:0] T3;
  reg [31:0] ram_mcache_even [511:0];
  wire[31:0] T4;
  wire[31:0] T5;
  reg[8:0] addrEvenReg;

  assign io_mcachemem_out_instr_odd = T0;
  assign T0 = ram_mcache_odd[addrOddReg];
  assign T2 = io_mcachemem_in_w_data;
  assign io_mcachemem_out_instr_even = T3;
  assign T3 = ram_mcache_even[addrEvenReg];
  assign T5 = io_mcachemem_in_w_data;

  always @(posedge clk) begin
    if (io_mcachemem_in_w_odd)
      ram_mcache_odd[io_mcachemem_in_w_addr] <= T2;
    addrOddReg <= io_mcachemem_in_addr_odd;
    if (io_mcachemem_in_w_even)
      ram_mcache_even[io_mcachemem_in_w_addr] <= T5;
    addrEvenReg <= io_mcachemem_in_addr_even;
  end
endmodule

module MCache(input clk, input reset,
    output io_ena_out,
    input  io_ena_in,
    input [31:0] io_femcache_address,
    input  io_femcache_request,
    input  io_femcache_doCallRet,
    input [31:0] io_femcache_callRetBase,
    input  io_exmcache_doCallRet,
    input [31:0] io_exmcache_callRetBase,
    input [31:0] io_exmcache_callRetAddr,
    output[31:0] io_mcachefe_instr_a,
    output[31:0] io_mcachefe_instr_b,
    output[10:0] io_mcachefe_relBase,
    output[11:0] io_mcachefe_relPc,
    output[31:0] io_mcachefe_reloc,
    output[1:0] io_mcachefe_mem_sel,
    output[2:0] io_ocp_port_M_Cmd,
    output[31:0] io_ocp_port_M_Addr,
    output[31:0] io_ocp_port_M_Data,
    output io_ocp_port_M_DataValid,
    output[3:0] io_ocp_port_M_DataByteEn,
    input [1:0] io_ocp_port_S_Resp,
    input [31:0] io_ocp_port_S_Data,
    input  io_ocp_port_S_CmdAccept,
    input  io_ocp_port_S_DataAccept
);

  wire[8:0] mcacherepl_io_mcachemem_in_addr_odd;
  wire[8:0] mcacherepl_io_mcachemem_in_addr_even;
  wire[8:0] mcacherepl_io_mcachemem_in_w_addr;
  wire[31:0] mcacherepl_io_mcachemem_in_w_data;
  wire mcacherepl_io_mcachemem_in_w_odd;
  wire mcacherepl_io_mcachemem_in_w_even;
  wire[31:0] mcachemem_io_mcachemem_out_instr_odd;
  wire[31:0] mcachemem_io_mcachemem_out_instr_even;
  wire mcachectrl_io_mcache_ctrlrepl_instr_stall;
  wire[9:0] mcachectrl_io_mcache_ctrlrepl_address;
  wire mcachectrl_io_mcache_ctrlrepl_w_tag;
  wire[31:0] mcachectrl_io_mcache_ctrlrepl_w_addr;
  wire[31:0] mcachectrl_io_mcache_ctrlrepl_w_data;
  wire mcachectrl_io_mcache_ctrlrepl_w_enable;
  wire[10:0] mcacherepl_io_mcache_replctrl_pos_offset;
  wire mcacherepl_io_mcache_replctrl_hit;
  wire[3:0] mcachectrl_io_ocp_port_M_DataByteEn;
  wire mcachectrl_io_ocp_port_M_DataValid;
  wire[31:0] mcachectrl_io_ocp_port_M_Data;
  wire[31:0] mcachectrl_io_ocp_port_M_Addr;
  wire[2:0] mcachectrl_io_ocp_port_M_Cmd;
  wire[1:0] mcacherepl_io_mcachefe_mem_sel;
  wire[31:0] mcacherepl_io_mcachefe_reloc;
  wire[11:0] mcacherepl_io_mcachefe_relPc;
  wire[10:0] mcacherepl_io_mcachefe_relBase;
  wire[31:0] mcacherepl_io_mcachefe_instr_b;
  wire[31:0] mcacherepl_io_mcachefe_instr_a;
  wire T0;
  wire mcacherepl_io_hit_ena;
  wire mcachectrl_io_fetch_ena;

  assign io_ocp_port_M_DataByteEn = mcachectrl_io_ocp_port_M_DataByteEn;
  assign io_ocp_port_M_DataValid = mcachectrl_io_ocp_port_M_DataValid;
  assign io_ocp_port_M_Data = mcachectrl_io_ocp_port_M_Data;
  assign io_ocp_port_M_Addr = mcachectrl_io_ocp_port_M_Addr;
  assign io_ocp_port_M_Cmd = mcachectrl_io_ocp_port_M_Cmd;
  assign io_mcachefe_mem_sel = mcacherepl_io_mcachefe_mem_sel;
  assign io_mcachefe_reloc = mcacherepl_io_mcachefe_reloc;
  assign io_mcachefe_relPc = mcacherepl_io_mcachefe_relPc;
  assign io_mcachefe_relBase = mcacherepl_io_mcachefe_relBase;
  assign io_mcachefe_instr_b = mcacherepl_io_mcachefe_instr_b;
  assign io_mcachefe_instr_a = mcacherepl_io_mcachefe_instr_a;
  assign io_ena_out = T0;
  assign T0 = mcachectrl_io_fetch_ena & mcacherepl_io_hit_ena;
  MCacheCtrl mcachectrl(.clk(clk), .reset(reset),
       .io_ena_in( io_ena_in ),
       .io_fetch_ena( mcachectrl_io_fetch_ena ),
       .io_mcache_ctrlrepl_w_enable( mcachectrl_io_mcache_ctrlrepl_w_enable ),
       .io_mcache_ctrlrepl_w_data( mcachectrl_io_mcache_ctrlrepl_w_data ),
       .io_mcache_ctrlrepl_w_addr( mcachectrl_io_mcache_ctrlrepl_w_addr ),
       .io_mcache_ctrlrepl_w_tag( mcachectrl_io_mcache_ctrlrepl_w_tag ),
       .io_mcache_ctrlrepl_address( mcachectrl_io_mcache_ctrlrepl_address ),
       .io_mcache_ctrlrepl_instr_stall( mcachectrl_io_mcache_ctrlrepl_instr_stall ),
       .io_mcache_replctrl_hit( mcacherepl_io_mcache_replctrl_hit ),
       .io_mcache_replctrl_pos_offset( mcacherepl_io_mcache_replctrl_pos_offset ),
       .io_femcache_address( io_femcache_address ),
       .io_femcache_request( io_femcache_request ),
       .io_femcache_doCallRet( io_femcache_doCallRet ),
       .io_femcache_callRetBase( io_femcache_callRetBase ),
       .io_exmcache_doCallRet( io_exmcache_doCallRet ),
       .io_exmcache_callRetBase( io_exmcache_callRetBase ),
       .io_exmcache_callRetAddr( io_exmcache_callRetAddr ),
       .io_ocp_port_M_Cmd( mcachectrl_io_ocp_port_M_Cmd ),
       .io_ocp_port_M_Addr( mcachectrl_io_ocp_port_M_Addr ),
       .io_ocp_port_M_Data( mcachectrl_io_ocp_port_M_Data ),
       .io_ocp_port_M_DataValid( mcachectrl_io_ocp_port_M_DataValid ),
       .io_ocp_port_M_DataByteEn( mcachectrl_io_ocp_port_M_DataByteEn ),
       .io_ocp_port_S_Resp( io_ocp_port_S_Resp ),
       .io_ocp_port_S_Data( io_ocp_port_S_Data ),
       .io_ocp_port_S_CmdAccept( io_ocp_port_S_CmdAccept ),
       .io_ocp_port_S_DataAccept( io_ocp_port_S_DataAccept )
  );
  MCacheReplFifo mcacherepl(.clk(clk), .reset(reset),
       .io_ena_in( io_ena_in ),
       .io_hit_ena( mcacherepl_io_hit_ena ),
       .io_exmcache_doCallRet( io_exmcache_doCallRet ),
       .io_exmcache_callRetBase( io_exmcache_callRetBase ),
       .io_exmcache_callRetAddr( io_exmcache_callRetAddr ),
       .io_mcachefe_instr_a( mcacherepl_io_mcachefe_instr_a ),
       .io_mcachefe_instr_b( mcacherepl_io_mcachefe_instr_b ),
       .io_mcachefe_relBase( mcacherepl_io_mcachefe_relBase ),
       .io_mcachefe_relPc( mcacherepl_io_mcachefe_relPc ),
       .io_mcachefe_reloc( mcacherepl_io_mcachefe_reloc ),
       .io_mcachefe_mem_sel( mcacherepl_io_mcachefe_mem_sel ),
       .io_mcache_ctrlrepl_w_enable( mcachectrl_io_mcache_ctrlrepl_w_enable ),
       .io_mcache_ctrlrepl_w_data( mcachectrl_io_mcache_ctrlrepl_w_data ),
       .io_mcache_ctrlrepl_w_addr( mcachectrl_io_mcache_ctrlrepl_w_addr ),
       .io_mcache_ctrlrepl_w_tag( mcachectrl_io_mcache_ctrlrepl_w_tag ),
       .io_mcache_ctrlrepl_address( mcachectrl_io_mcache_ctrlrepl_address ),
       .io_mcache_ctrlrepl_instr_stall( mcachectrl_io_mcache_ctrlrepl_instr_stall ),
       .io_mcache_replctrl_hit( mcacherepl_io_mcache_replctrl_hit ),
       .io_mcache_replctrl_pos_offset( mcacherepl_io_mcache_replctrl_pos_offset ),
       .io_mcachemem_in_w_even( mcacherepl_io_mcachemem_in_w_even ),
       .io_mcachemem_in_w_odd( mcacherepl_io_mcachemem_in_w_odd ),
       .io_mcachemem_in_w_data( mcacherepl_io_mcachemem_in_w_data ),
       .io_mcachemem_in_w_addr( mcacherepl_io_mcachemem_in_w_addr ),
       .io_mcachemem_in_addr_even( mcacherepl_io_mcachemem_in_addr_even ),
       .io_mcachemem_in_addr_odd( mcacherepl_io_mcachemem_in_addr_odd ),
       .io_mcachemem_out_instr_even( mcachemem_io_mcachemem_out_instr_even ),
       .io_mcachemem_out_instr_odd( mcachemem_io_mcachemem_out_instr_odd )
  );
  MCacheMem mcachemem(.clk(clk),
       .io_mcachemem_in_w_even( mcacherepl_io_mcachemem_in_w_even ),
       .io_mcachemem_in_w_odd( mcacherepl_io_mcachemem_in_w_odd ),
       .io_mcachemem_in_w_data( mcacherepl_io_mcachemem_in_w_data ),
       .io_mcachemem_in_w_addr( mcacherepl_io_mcachemem_in_w_addr ),
       .io_mcachemem_in_addr_even( mcacherepl_io_mcachemem_in_addr_even ),
       .io_mcachemem_in_addr_odd( mcacherepl_io_mcachemem_in_addr_odd ),
       .io_mcachemem_out_instr_even( mcachemem_io_mcachemem_out_instr_even ),
       .io_mcachemem_out_instr_odd( mcachemem_io_mcachemem_out_instr_odd )
  );
endmodule

module Fetch(input clk, input reset,
    input  io_ena,
    output[31:0] io_fedec_instr_a,
    output[31:0] io_fedec_instr_b,
    output[29:0] io_fedec_pc,
    output[31:0] io_fedec_reloc,
    output[10:0] io_femem_pc,
    input  io_exfe_doBranch,
    input [29:0] io_exfe_branchPc,
    input  io_memfe_doCallRet,
    input [29:0] io_memfe_callRetPc,
    input [29:0] io_memfe_callRetBase,
    input  io_memfe_store,
    input [31:0] io_memfe_addr,
    input [31:0] io_memfe_data,
    output[31:0] io_femcache_address,
    output io_femcache_request,
    output io_femcache_doCallRet,
    output[31:0] io_femcache_callRetBase,
    input [31:0] io_mcachefe_instr_a,
    input [31:0] io_mcachefe_instr_b,
    input [10:0] io_mcachefe_relBase,
    input [11:0] io_mcachefe_relPc,
    input [31:0] io_mcachefe_reloc,
    input [1:0] io_mcachefe_mem_sel
);

  wire[31:0] T0;
  reg[0:0] selMCache;
  wire T1;
  wire[31:0] T2;
  wire[29:0] T3;
  reg[29:0] pcReg;
  wire T4;
  wire T5;
  wire[29:0] pc_next;
  wire[29:0] T6;
  wire[29:0] pc_cont;
  wire[29:0] T7;
  wire[29:0] T8;
  wire[29:0] T9;
  wire[29:0] T10;
  wire b_valid;
  wire T11;
  wire[31:0] instr_a;
  wire[31:0] T12;
  wire[31:0] instr_a_rom;
  reg[31:0] data_odd;
  wire[31:0] T13;
  reg [31:0] romOdd [6:0];
  wire[2:0] T14;
  wire[29:0] addrOdd;
  wire[29:0] T15;
  reg[29:0] addrOddReg;
  wire[29:0] T16;
  wire[29:0] T17;
  wire[28:0] T18;
  reg[31:0] data_even;
  wire[31:0] T19;
  reg [31:0] romEven [6:0];
  wire[2:0] T20;
  wire[29:0] addrEven;
  wire[29:0] T21;
  reg[29:0] addrEvenReg;
  wire[29:0] T22;
  wire[29:0] T23;
  wire[28:0] T24;
  wire[29:0] pc_inc;
  wire[29:0] pc_next2;
  wire[29:0] T25;
  wire[29:0] pc_cont2;
  wire[29:0] T26;
  wire[29:0] T27;
  wire[29:0] T28;
  wire[29:0] T29;
  wire[29:0] T30;
  wire[29:0] T31;
  wire[29:0] T32;
  wire[11:0] T33;
  wire[11:0] T34;
  wire[11:0] T35;
  wire T36;
  wire T37;
  wire T38;
  wire[31:0] instr_a_ispm;
  wire[31:0] T39;
  reg [31:0] memOdd [1023:0];
  wire[31:0] T40;
  wire[31:0] T41;
  reg[31:0] dataReg;
  reg[0:0] wrOddReg;
  wire T42;
  wire T43;
  wire T44;
  wire selWrite;
  wire T45;
  wire[15:0] T46;
  wire[15:0] T47;
  wire[9:0] T48;
  reg[31:0] addrReg;
  wire[9:0] T49;
  wire[31:0] T50;
  reg [31:0] memEven [1023:0];
  wire[31:0] T51;
  wire[31:0] T52;
  reg[0:0] wrEvenReg;
  wire T53;
  wire T54;
  wire T55;
  wire[9:0] T56;
  wire[9:0] T57;
  wire T58;
  wire T59;
  reg[0:0] selIspm;
  wire T60;
  wire[29:0] T61;
  wire[11:0] T62;
  wire[10:0] T63;
  wire[29:0] T64;
  wire[29:0] T65;
  reg[10:0] relBaseReg;
  wire T66;
  reg[31:0] relocReg;
  wire[31:0] instr_b;
  wire[31:0] T67;
  wire[31:0] instr_b_rom;
  wire T68;
  wire T69;
  wire[31:0] instr_b_ispm;
  wire T70;
  wire T71;

  assign io_femcache_callRetBase = T0;
  assign T0 = {2'h0/* 0*/, io_memfe_callRetBase};
  assign io_femcache_doCallRet = io_memfe_doCallRet;
  assign io_femcache_request = selMCache;
  assign T1 = io_mcachefe_mem_sel[1'h0/* 0*/:1'h0/* 0*/];
  assign io_femcache_address = T2;
  assign T2 = {2'h0/* 0*/, T3};
  assign T3 = io_ena ? pc_next : pcReg;
  assign T4 = io_ena && T5;
  assign T5 = ! reset;
  assign pc_next = io_memfe_doCallRet ? T61 : T6;
  assign T6 = io_exfe_doBranch ? io_exfe_branchPc : pc_cont;
  assign pc_cont = b_valid ? T9 : T7;
  assign T7 = pcReg + T8;
  assign T8 = {29'h0/* 0*/, 1'h1/* 1*/};
  assign T9 = pcReg + T10;
  assign T10 = {28'h0/* 0*/, 2'h2/* 2*/};
  assign b_valid = T11 == 1'h1/* 1*/;
  assign T11 = instr_a[5'h1f/* 31*/:5'h1f/* 31*/];
  assign instr_a = selIspm ? instr_a_ispm : T12;
  assign T12 = selMCache ? io_mcachefe_instr_a : instr_a_rom;
  assign instr_a_rom = T37 ? data_even : data_odd;
  assign T13 = romOdd[T14];
  initial begin
    romOdd[0] = 32'h87fc0000/* -2013528064*/;
    romOdd[1] = 32'h87e00000/* -2015363072*/;
    romOdd[2] = 32'h400000/* 4194304*/;
    romOdd[3] = 32'h7010000/* 117506048*/;
    romOdd[4] = 32'h400000/* 4194304*/;
    romOdd[5] = 32'h400000/* 4194304*/;
    romOdd[6] = 1'h0/* 0*/;
  end
  assign T14 = addrOdd[2'h3/* 3*/:1'h1/* 1*/];
  assign addrOdd = T15;
  assign T15 = T4 ? T16 : addrOddReg;
  assign T16 = T17;
  assign T17 = {T18, 1'h1/* 1*/};
  assign T18 = pc_next[5'h1d/* 29*/:1'h1/* 1*/];
  assign T19 = romEven[T20];
  initial begin
    romEven[0] = 32'h28/* 40*/;
    romEven[1] = 32'h0/* 0*/;
    romEven[2] = 32'h40004/* 262148*/;
    romEven[3] = 32'h400000/* 4194304*/;
    romEven[4] = 32'h400000/* 4194304*/;
    romEven[5] = 32'h400000/* 4194304*/;
    romEven[6] = 32'h400000/* 4194304*/;
  end
  assign T20 = addrEven[2'h3/* 3*/:1'h1/* 1*/];
  assign addrEven = T21;
  assign T21 = T4 ? T22 : addrEvenReg;
  assign T22 = T23;
  assign T23 = {T24, 1'h0/* 0*/};
  assign T24 = pc_inc[5'h1d/* 29*/:1'h1/* 1*/];
  assign pc_inc = T36 ? pc_next2 : pc_next;
  assign pc_next2 = io_memfe_doCallRet ? T32 : T25;
  assign T25 = io_exfe_doBranch ? T30 : pc_cont2;
  assign pc_cont2 = b_valid ? T28 : T26;
  assign T26 = pcReg + T27;
  assign T27 = {28'h0/* 0*/, 2'h3/* 3*/};
  assign T28 = pcReg + T29;
  assign T29 = {27'h0/* 0*/, 3'h4/* 4*/};
  assign T30 = io_exfe_branchPc + T31;
  assign T31 = {28'h0/* 0*/, 2'h2/* 2*/};
  assign T32 = {18'h0/* 0*/, T33};
  assign T33 = T35 + T34;
  assign T34 = {10'h0/* 0*/, 2'h2/* 2*/};
  assign T35 = io_mcachefe_relPc;
  assign T36 = pc_next[1'h0/* 0*/:1'h0/* 0*/];
  assign T37 = T38 == 1'h0/* 0*/;
  assign T38 = pcReg[1'h0/* 0*/:1'h0/* 0*/];
  assign instr_a_ispm = T58 ? T50 : T39;
  assign T39 = memOdd[T49];
  assign T41 = dataReg;
  assign T42 = selWrite & T43;
  assign T43 = T44 == 1'h1/* 1*/;
  assign T44 = io_memfe_addr[2'h2/* 2*/:2'h2/* 2*/];
  assign selWrite = io_memfe_store & T45;
  assign T45 = T47 == T46;
  assign T46 = {15'h0/* 0*/, 1'h1/* 1*/};
  assign T47 = io_memfe_addr[5'h1f/* 31*/:5'h10/* 16*/];
  assign T48 = addrReg[4'hc/* 12*/:2'h3/* 3*/];
  assign T49 = addrOddReg[4'ha/* 10*/:1'h1/* 1*/];
  assign T50 = memEven[T57];
  assign T52 = dataReg;
  assign T53 = selWrite & T54;
  assign T54 = T55 == 1'h0/* 0*/;
  assign T55 = io_memfe_addr[2'h2/* 2*/:2'h2/* 2*/];
  assign T56 = addrReg[4'hc/* 12*/:2'h3/* 3*/];
  assign T57 = addrEvenReg[4'ha/* 10*/:1'h1/* 1*/];
  assign T58 = T59 == 1'h0/* 0*/;
  assign T59 = pcReg[1'h0/* 0*/:1'h0/* 0*/];
  assign T60 = io_mcachefe_mem_sel[1'h1/* 1*/:1'h1/* 1*/];
  assign T61 = {18'h0/* 0*/, T62};
  assign T62 = io_mcachefe_relPc;
  assign io_femem_pc = T63;
  assign T63 = T64[4'ha/* 10*/:1'h0/* 0*/];
  assign T64 = pc_cont - T65;
  assign T65 = {19'h0/* 0*/, relBaseReg};
  assign T66 = io_memfe_doCallRet && io_ena;
  assign io_fedec_reloc = relocReg;
  assign io_fedec_pc = pcReg;
  assign io_fedec_instr_b = instr_b;
  assign instr_b = selIspm ? instr_b_ispm : T67;
  assign T67 = selMCache ? io_mcachefe_instr_b : instr_b_rom;
  assign instr_b_rom = T68 ? data_odd : data_even;
  assign T68 = T69 == 1'h0/* 0*/;
  assign T69 = pcReg[1'h0/* 0*/:1'h0/* 0*/];
  assign instr_b_ispm = T70 ? T39 : T50;
  assign T70 = T71 == 1'h0/* 0*/;
  assign T71 = pcReg[1'h0/* 0*/:1'h0/* 0*/];
  assign io_fedec_instr_a = instr_a;

  always @(posedge clk) begin
    selMCache <= T1;
    if(reset) begin
      pcReg <= 30'h1/* 1*/;
    end else if(T4) begin
      pcReg <= pc_next;
    end
    data_odd <= T13;
    addrOddReg <= reset ? 30'h1/* 1*/ : addrOdd;
    data_even <= T19;
    addrEvenReg <= reset ? 30'h2/* 2*/ : addrEven;
    if (wrOddReg)
      memOdd[T48] <= T41;
    dataReg <= io_memfe_data;
    wrOddReg <= T42;
    addrReg <= io_memfe_addr;
    if (wrEvenReg)
      memEven[T56] <= T52;
    wrEvenReg <= T53;
    selIspm <= T60;
    if(reset) begin
      relBaseReg <= 11'h1/* 1*/;
    end else if(T66) begin
      relBaseReg <= io_mcachefe_relBase;
    end
    if(reset) begin
      relocReg <= 32'h0/* 0*/;
    end else if(T66) begin
      relocReg <= io_mcachefe_reloc;
    end
  end
endmodule

module RegisterFile(input clk,
    input  io_ena,
    input [4:0] io_rfRead_rsAddr_0,
    input [4:0] io_rfRead_rsAddr_1,
    input [4:0] io_rfRead_rsAddr_2,
    input [4:0] io_rfRead_rsAddr_3,
    output[31:0] io_rfRead_rsData_0,
    output[31:0] io_rfRead_rsData_1,
    output[31:0] io_rfRead_rsData_2,
    output[31:0] io_rfRead_rsData_3,
    input [4:0] io_rfWrite_0_addr,
    input [31:0] io_rfWrite_0_data,
    input  io_rfWrite_0_valid,
    input [4:0] io_rfWrite_1_addr,
    input [31:0] io_rfWrite_1_data,
    input  io_rfWrite_1_valid
);

  wire[31:0] T0;
  wire[31:0] T1;
  wire[31:0] T2;
  wire[31:0] T3;
  reg [31:0] rf [31:0];
  wire[31:0] T4;
  wire[31:0] T5;
  reg[31:0] wrReg_0_data;
  reg[0:0] wrReg_0_valid;
  wire[4:0] T6;
  reg[4:0] wrReg_0_addr;
  wire[31:0] T7;
  wire[31:0] T8;
  reg[31:0] wrReg_1_data;
  reg[0:0] wrReg_1_valid;
  wire[4:0] T9;
  reg[4:0] wrReg_1_addr;
  reg[4:0] addrReg_3;
  wire[4:0] T10;
  reg[0:0] fwReg_3_0;
  wire T11;
  wire T12;
  reg[0:0] fwReg_3_1;
  wire T13;
  wire T14;
  wire[31:0] T15;
  wire T16;
  wire[4:0] T17;
  wire[31:0] T18;
  wire[31:0] T19;
  wire[31:0] T20;
  wire[31:0] T21;
  reg[4:0] addrReg_2;
  wire[4:0] T22;
  reg[0:0] fwReg_2_0;
  wire T23;
  wire T24;
  reg[0:0] fwReg_2_1;
  wire T25;
  wire T26;
  wire[31:0] T27;
  wire T28;
  wire[4:0] T29;
  wire[31:0] T30;
  wire[31:0] T31;
  wire[31:0] T32;
  wire[31:0] T33;
  reg[4:0] addrReg_1;
  wire[4:0] T34;
  reg[0:0] fwReg_1_0;
  wire T35;
  wire T36;
  reg[0:0] fwReg_1_1;
  wire T37;
  wire T38;
  wire[31:0] T39;
  wire T40;
  wire[4:0] T41;
  wire[31:0] T42;
  wire[31:0] T43;
  wire[31:0] T44;
  wire[31:0] T45;
  reg[4:0] addrReg_0;
  wire[4:0] T46;
  reg[0:0] fwReg_0_0;
  wire T47;
  wire T48;
  reg[0:0] fwReg_0_1;
  wire T49;
  wire T50;
  wire[31:0] T51;
  wire T52;
  wire[4:0] T53;

  assign io_rfRead_rsData_3 = T0;
  assign T0 = T16 ? T15 : T1;
  assign T1 = fwReg_3_1 ? wrReg_1_data : T2;
  assign T2 = fwReg_3_0 ? wrReg_0_data : T3;
  assign T3 = rf[addrReg_3];
  assign T5 = wrReg_0_data;
  assign T6 = wrReg_0_addr;
  assign T8 = wrReg_1_data;
  assign T9 = wrReg_1_addr;
  assign T10 = io_rfRead_rsAddr_3;
  assign T11 = T12 && io_rfWrite_0_valid;
  assign T12 = io_rfRead_rsAddr_3 == io_rfWrite_0_addr;
  assign T13 = T14 && io_rfWrite_1_valid;
  assign T14 = io_rfRead_rsAddr_3 == io_rfWrite_1_addr;
  assign T15 = {31'h0/* 0*/, 1'h0/* 0*/};
  assign T16 = addrReg_3 == T17;
  assign T17 = {4'h0/* 0*/, 1'h0/* 0*/};
  assign io_rfRead_rsData_2 = T18;
  assign T18 = T28 ? T27 : T19;
  assign T19 = fwReg_2_1 ? wrReg_1_data : T20;
  assign T20 = fwReg_2_0 ? wrReg_0_data : T21;
  assign T21 = rf[addrReg_2];
  assign T22 = io_rfRead_rsAddr_2;
  assign T23 = T24 && io_rfWrite_0_valid;
  assign T24 = io_rfRead_rsAddr_2 == io_rfWrite_0_addr;
  assign T25 = T26 && io_rfWrite_1_valid;
  assign T26 = io_rfRead_rsAddr_2 == io_rfWrite_1_addr;
  assign T27 = {31'h0/* 0*/, 1'h0/* 0*/};
  assign T28 = addrReg_2 == T29;
  assign T29 = {4'h0/* 0*/, 1'h0/* 0*/};
  assign io_rfRead_rsData_1 = T30;
  assign T30 = T40 ? T39 : T31;
  assign T31 = fwReg_1_1 ? wrReg_1_data : T32;
  assign T32 = fwReg_1_0 ? wrReg_0_data : T33;
  assign T33 = rf[addrReg_1];
  assign T34 = io_rfRead_rsAddr_1;
  assign T35 = T36 && io_rfWrite_0_valid;
  assign T36 = io_rfRead_rsAddr_1 == io_rfWrite_0_addr;
  assign T37 = T38 && io_rfWrite_1_valid;
  assign T38 = io_rfRead_rsAddr_1 == io_rfWrite_1_addr;
  assign T39 = {31'h0/* 0*/, 1'h0/* 0*/};
  assign T40 = addrReg_1 == T41;
  assign T41 = {4'h0/* 0*/, 1'h0/* 0*/};
  assign io_rfRead_rsData_0 = T42;
  assign T42 = T52 ? T51 : T43;
  assign T43 = fwReg_0_1 ? wrReg_1_data : T44;
  assign T44 = fwReg_0_0 ? wrReg_0_data : T45;
  assign T45 = rf[addrReg_0];
  assign T46 = io_rfRead_rsAddr_0;
  assign T47 = T48 && io_rfWrite_0_valid;
  assign T48 = io_rfRead_rsAddr_0 == io_rfWrite_0_addr;
  assign T49 = T50 && io_rfWrite_1_valid;
  assign T50 = io_rfRead_rsAddr_0 == io_rfWrite_1_addr;
  assign T51 = {31'h0/* 0*/, 1'h0/* 0*/};
  assign T52 = addrReg_0 == T53;
  assign T53 = {4'h0/* 0*/, 1'h0/* 0*/};

  always @(posedge clk) begin
    if (wrReg_0_valid)
      rf[T6] <= T5;
    if(io_ena) begin
      wrReg_0_data <= io_rfWrite_0_data;
    end
    if(io_ena) begin
      wrReg_0_valid <= io_rfWrite_0_valid;
    end
    if(io_ena) begin
      wrReg_0_addr <= io_rfWrite_0_addr;
    end
    if (wrReg_1_valid)
      rf[T9] <= T8;
    if(io_ena) begin
      wrReg_1_data <= io_rfWrite_1_data;
    end
    if(io_ena) begin
      wrReg_1_valid <= io_rfWrite_1_valid;
    end
    if(io_ena) begin
      wrReg_1_addr <= io_rfWrite_1_addr;
    end
    if(io_ena) begin
      addrReg_3 <= T10;
    end
    if(io_ena) begin
      fwReg_3_0 <= T11;
    end
    if(io_ena) begin
      fwReg_3_1 <= T13;
    end
    if(io_ena) begin
      addrReg_2 <= T22;
    end
    if(io_ena) begin
      fwReg_2_0 <= T23;
    end
    if(io_ena) begin
      fwReg_2_1 <= T25;
    end
    if(io_ena) begin
      addrReg_1 <= T34;
    end
    if(io_ena) begin
      fwReg_1_0 <= T35;
    end
    if(io_ena) begin
      fwReg_1_1 <= T37;
    end
    if(io_ena) begin
      addrReg_0 <= T46;
    end
    if(io_ena) begin
      fwReg_0_0 <= T47;
    end
    if(io_ena) begin
      fwReg_0_1 <= T49;
    end
  end
endmodule

module Decode(input clk, input reset,
    input  io_ena,
    input [31:0] io_fedec_instr_a,
    input [31:0] io_fedec_instr_b,
    input [29:0] io_fedec_pc,
    input [31:0] io_fedec_reloc,
    output[29:0] io_decex_pc,
    output[3:0] io_decex_pred_0,
    output[3:0] io_decex_pred_1,
    output[3:0] io_decex_aluOp_0_func,
    output io_decex_aluOp_0_isMul,
    output io_decex_aluOp_0_isCmp,
    output io_decex_aluOp_0_isPred,
    output io_decex_aluOp_0_isMTS,
    output io_decex_aluOp_0_isMFS,
    output io_decex_aluOp_0_isSTC,
    output[3:0] io_decex_aluOp_1_func,
    output io_decex_aluOp_1_isMul,
    output io_decex_aluOp_1_isCmp,
    output io_decex_aluOp_1_isPred,
    output io_decex_aluOp_1_isMTS,
    output io_decex_aluOp_1_isMFS,
    output io_decex_aluOp_1_isSTC,
    output[1:0] io_decex_predOp_0_func,
    output[2:0] io_decex_predOp_0_dest,
    output[3:0] io_decex_predOp_0_s1Addr,
    output[3:0] io_decex_predOp_0_s2Addr,
    output[1:0] io_decex_predOp_1_func,
    output[2:0] io_decex_predOp_1_dest,
    output[3:0] io_decex_predOp_1_s1Addr,
    output[3:0] io_decex_predOp_1_s2Addr,
    output io_decex_jmpOp_branch,
    output[29:0] io_decex_jmpOp_target,
    output[31:0] io_decex_jmpOp_reloc,
    output io_decex_memOp_load,
    output io_decex_memOp_store,
    output io_decex_memOp_hword,
    output io_decex_memOp_byte,
    output io_decex_memOp_zext,
    output[1:0] io_decex_memOp_typ,
    output[4:0] io_decex_rsAddr_0,
    output[4:0] io_decex_rsAddr_1,
    output[4:0] io_decex_rsAddr_2,
    output[4:0] io_decex_rsAddr_3,
    output[31:0] io_decex_rsData_0,
    output[31:0] io_decex_rsData_1,
    output[31:0] io_decex_rsData_2,
    output[31:0] io_decex_rsData_3,
    output[4:0] io_decex_rdAddr_0,
    output[4:0] io_decex_rdAddr_1,
    output[31:0] io_decex_immVal_0,
    output[31:0] io_decex_immVal_1,
    output io_decex_immOp_0,
    output io_decex_immOp_1,
    output io_decex_wrRd_0,
    output io_decex_wrRd_1,
    output[31:0] io_decex_callAddr,
    output[31:0] io_decex_brcfAddr,
    output io_decex_call,
    output io_decex_ret,
    output io_decex_brcf,
    input [31:0] io_exdec_sp,
    input [4:0] io_rfWrite_0_addr,
    input [31:0] io_rfWrite_0_data,
    input  io_rfWrite_0_valid,
    input [4:0] io_rfWrite_1_addr,
    input [31:0] io_rfWrite_1_data,
    input  io_rfWrite_1_valid
);

  wire[4:0] T0;
  wire[4:0] T1;
  wire[4:0] T2;
  wire[4:0] T3;
  wire T4;
  wire T5;
  wire[4:0] opcode;
  reg[31:0] decReg_instr_a;
  wire[31:0] T6;
  wire[31:0] T7;
  wire T8;
  wire T9;
  wire[3:0] func;
  wire T10;
  wire T11;
  wire T12;
  wire T13;
  wire T14;
  wire T15;
  wire[31:0] T16;
  wire[33:0] T17;
  wire[1:0] T18;
  wire[31:0] T19;
  reg[31:0] decReg_reloc;
  wire[31:0] T20;
  wire[31:0] T21;
  wire[31:0] T22;
  wire[31:0] T23;
  wire[24:0] T24;
  wire[24:0] T25;
  wire[21:0] T26;
  wire T27;
  wire T28;
  wire T29;
  wire T30;
  wire T31;
  wire dual;
  wire T32;
  wire[4:0] T33;
  wire T34;
  wire T35;
  wire[1:0] T36;
  wire[4:0] T37;
  reg[31:0] decReg_instr_b;
  wire[31:0] T38;
  wire[31:0] T39;
  wire T40;
  wire T41;
  wire[2:0] T42;
  wire T43;
  wire T44;
  wire T45;
  wire T46;
  wire T47;
  wire T48;
  wire T49;
  wire T50;
  wire T51;
  wire T52;
  wire T53;
  wire T54;
  wire T55;
  wire T56;
  wire T57;
  wire T58;
  wire[1:0] T59;
  wire[4:0] T60;
  wire T61;
  wire T62;
  wire[2:0] T63;
  wire T64;
  wire T65;
  wire T66;
  wire T67;
  wire T68;
  wire T69;
  wire T70;
  wire T71;
  wire T72;
  wire T73;
  wire T74;
  wire T75;
  wire T76;
  wire T77;
  wire T78;
  wire T79;
  wire T80;
  wire T81;
  wire[3:0] stcfun;
  wire T82;
  wire T83;
  wire T84;
  wire T85;
  wire[31:0] T86;
  wire[12:0] T87;
  wire[11:0] T88;
  wire[31:0] T89;
  wire[31:0] T90;
  wire[31:0] T91;
  wire[31:0] T92;
  wire[31:0] T93;
  wire[12:0] T94;
  wire[11:0] T95;
  wire longImm;
  wire[31:0] T96;
  wire[9:0] addrImm;
  wire[9:0] T97;
  wire[9:0] T98;
  wire[8:0] T99;
  wire[8:0] T100;
  wire[7:0] T101;
  wire[6:0] T102;
  wire[8:0] T103;
  wire[6:0] T104;
  wire T105;
  wire[1:0] T106;
  wire[1:0] shamt;
  wire[1:0] T107;
  wire[1:0] T108;
  wire[1:0] T109;
  wire[1:0] T110;
  wire[1:0] T111;
  wire[1:0] T112;
  wire T113;
  wire T114;
  wire[2:0] ldsize;
  wire[1:0] T115;
  wire T116;
  wire T117;
  wire[1:0] T118;
  wire T119;
  wire T120;
  wire T121;
  wire T122;
  wire[2:0] stsize;
  wire T123;
  wire[1:0] T124;
  wire T125;
  wire T126;
  wire[9:0] T127;
  wire[6:0] T128;
  wire T129;
  wire isMem;
  wire T130;
  wire[31:0] T131;
  wire[31:0] T132;
  wire isStack;
  wire T133;
  wire T134;
  wire T135;
  wire[1:0] ldtype;
  wire T136;
  wire T137;
  wire[1:0] sttype;
  wire[31:0] stcVal;
  wire[31:0] T138;
  wire[31:0] T139;
  wire[31:0] T140;
  wire[31:0] T141;
  wire[20:0] stcImm;
  wire[20:0] T142;
  wire[17:0] T143;
  wire[31:0] T144;
  wire[31:0] T145;
  wire isSTC;
  wire T146;
  wire[4:0] T147;
  wire[4:0] dest;
  wire[4:0] T148;
  wire[4:0] T149;
  wire[4:0] T150;
  wire[31:0] rf_io_rfRead_rsData_3;
  wire[31:0] rf_io_rfRead_rsData_2;
  wire[31:0] rf_io_rfRead_rsData_1;
  wire[31:0] rf_io_rfRead_rsData_0;
  wire[4:0] T151;
  wire[4:0] T152;
  wire[4:0] T153;
  wire[4:0] T154;
  wire[1:0] T155;
  wire[1:0] T156;
  wire T157;
  wire T158;
  wire T159;
  wire T160;
  wire T161;
  wire T162;
  wire T163;
  wire T164;
  wire T165;
  wire T166;
  wire T167;
  wire[29:0] T168;
  wire[29:0] T169;
  wire[21:0] T170;
  wire[7:0] T171;
  wire T172;
  reg[29:0] decReg_pc;
  wire[29:0] T173;
  wire[29:0] T174;
  wire T175;
  wire T176;
  wire T177;
  wire[3:0] T178;
  wire[3:0] T179;
  wire[2:0] T180;
  wire[1:0] T181;
  wire T182;
  wire T183;
  wire[3:0] T184;
  wire[3:0] T185;
  wire[2:0] T186;
  wire[1:0] T187;
  wire T188;
  wire T189;
  wire T190;
  wire T191;
  wire T192;
  wire T193;
  wire T194;
  wire T195;
  wire T196;
  wire T197;
  wire T198;
  wire T199;
  wire T200;
  wire T201;
  wire T202;
  wire[3:0] T203;
  wire[3:0] T204;
  wire[3:0] T205;
  wire[2:0] T206;
  wire T207;
  wire T208;
  wire T209;
  wire T210;
  wire T211;
  wire T212;
  wire T213;
  wire T214;
  wire T215;
  wire[3:0] T216;
  wire[3:0] T217;
  wire[3:0] T218;
  wire[3:0] T219;
  wire[2:0] T220;
  wire[3:0] T221;
  wire[3:0] T222;

  assign T0 = io_fedec_instr_b[4'hb/* 11*/:3'h7/* 7*/];
  assign T1 = io_fedec_instr_b[5'h10/* 16*/:4'hc/* 12*/];
  assign T2 = io_fedec_instr_a[4'hb/* 11*/:3'h7/* 7*/];
  assign T3 = io_fedec_instr_a[5'h10/* 16*/:4'hc/* 12*/];
  assign io_decex_brcf = T4;
  assign T4 = T8 ? 1'h1/* 1*/ : T5;
  assign T5 = opcode == 5'b11010/* 0*/;
  assign opcode = decReg_instr_a[5'h1a/* 26*/:5'h16/* 22*/];
  assign T6 = T7;
  assign T7 = {31'h0/* 0*/, 1'h0/* 0*/};
  assign T8 = T10 && T9;
  assign T9 = func == 4'b0010/* 0*/;
  assign func = decReg_instr_a[2'h3/* 3*/:1'h0/* 0*/];
  assign T10 = opcode == 5'b11100/* 0*/;
  assign io_decex_ret = T11;
  assign T11 = opcode == 5'b11110/* 0*/;
  assign io_decex_call = T12;
  assign T12 = T14 ? 1'h1/* 1*/ : T13;
  assign T13 = opcode == 5'b11000/* 0*/;
  assign T14 = T10 && T15;
  assign T15 = func == 4'b0000/* 0*/;
  assign io_decex_brcfAddr = T16;
  assign T16 = T17[5'h1f/* 31*/:1'h0/* 0*/];
  assign T17 = {T19, T18};
  assign T18 = 2'b00/* 0*/;
  assign T19 = T22 + decReg_reloc;
  assign T20 = T21;
  assign T21 = {31'h0/* 0*/, 1'h0/* 0*/};
  assign T22 = {2'h0/* 0*/, io_decex_jmpOp_target};
  assign io_decex_callAddr = T23;
  assign T23 = {7'h0/* 0*/, T24};
  assign T24 = T25;
  assign T25 = {1'h0/* 0*/, T26, 2'b00/* 0*/};
  assign T26 = decReg_instr_a[5'h15/* 21*/:1'h0/* 0*/];
  assign io_decex_wrRd_1 = T27;
  assign T27 = T49 ? 1'h0/* 0*/ : T28;
  assign T28 = T46 ? dual : T29;
  assign T29 = T44 ? dual : T30;
  assign T30 = T40 ? dual : T31;
  assign T31 = T35 ? dual : 1'h0/* 0*/;
  assign dual = T34 && T32;
  assign T32 = T33 != 5'b11111/* 0*/;
  assign T33 = decReg_instr_a[5'h1a/* 26*/:5'h16/* 22*/];
  assign T34 = decReg_instr_a[5'h1f/* 31*/:5'h1f/* 31*/];
  assign T35 = T36 == 2'b00/* 0*/;
  assign T36 = T37[3'h4/* 4*/:2'h3/* 3*/];
  assign T37 = decReg_instr_b[5'h1a/* 26*/:5'h16/* 22*/];
  assign T38 = T39;
  assign T39 = {31'h0/* 0*/, 1'h0/* 0*/};
  assign T40 = T43 && T41;
  assign T41 = T42 == 3'b000/* 0*/;
  assign T42 = decReg_instr_b[3'h6/* 6*/:3'h4/* 4*/];
  assign T43 = T37 == 5'b01000/* 0*/;
  assign T44 = T43 && T45;
  assign T45 = T42 == 3'b001/* 0*/;
  assign T46 = T48 && T47;
  assign T47 = T42 == 3'b011/* 0*/;
  assign T48 = T37 == 5'b01001/* 0*/;
  assign T49 = io_decex_rdAddr_1 == 5'b00000/* 0*/;
  assign io_decex_wrRd_0 = T50;
  assign T50 = T72 ? 1'h0/* 0*/ : T51;
  assign T51 = T71 ? 1'h1/* 1*/ : T52;
  assign T52 = T14 ? 1'h1/* 1*/ : T53;
  assign T53 = T13 ? 1'h1/* 1*/ : T54;
  assign T54 = T70 ? 1'h1/* 1*/ : T55;
  assign T55 = T67 ? 1'h1/* 1*/ : T56;
  assign T56 = T65 ? 1'h1/* 1*/ : T57;
  assign T57 = T61 ? 1'h1/* 1*/ : T58;
  assign T58 = T59 == 2'b00/* 0*/;
  assign T59 = T60[3'h4/* 4*/:2'h3/* 3*/];
  assign T60 = decReg_instr_a[5'h1a/* 26*/:5'h16/* 22*/];
  assign T61 = T64 && T62;
  assign T62 = T63 == 3'b000/* 0*/;
  assign T63 = decReg_instr_a[3'h6/* 6*/:3'h4/* 4*/];
  assign T64 = T60 == 5'b01000/* 0*/;
  assign T65 = T64 && T66;
  assign T66 = T63 == 3'b001/* 0*/;
  assign T67 = T69 && T68;
  assign T68 = T63 == 3'b011/* 0*/;
  assign T69 = T60 == 5'b01001/* 0*/;
  assign T70 = opcode == 5'b11111/* 0*/;
  assign T71 = opcode == 5'b01010/* 0*/;
  assign T72 = io_decex_rdAddr_0 == 5'b00000/* 0*/;
  assign io_decex_immOp_1 = T73;
  assign T73 = T35 ? dual : 1'h0/* 0*/;
  assign io_decex_immOp_0 = T74;
  assign T74 = T5 ? 1'h1/* 1*/ : T75;
  assign T75 = T85 ? 1'h1/* 1*/ : T76;
  assign T76 = T13 ? 1'h1/* 1*/ : T77;
  assign T77 = T83 ? 1'h1/* 1*/ : T78;
  assign T78 = T80 ? 1'h1/* 1*/ : T79;
  assign T79 = T70 ? 1'h1/* 1*/ : T58;
  assign T80 = T82 && T81;
  assign T81 = stcfun == 4'b0000/* 0*/;
  assign stcfun = decReg_instr_a[5'h15/* 21*/:5'h12/* 18*/];
  assign T82 = opcode == 5'b01100/* 0*/;
  assign T83 = T82 && T84;
  assign T84 = stcfun == 4'b1000/* 0*/;
  assign T85 = opcode == 5'b11001/* 0*/;
  assign io_decex_immVal_1 = T86;
  assign T86 = {19'h0/* 0*/, T87};
  assign T87 = {1'h0/* 0*/, T88};
  assign T88 = decReg_instr_b[4'hb/* 11*/:1'h0/* 0*/];
  assign io_decex_immVal_0 = T89;
  assign T89 = isSTC ? stcVal : T90;
  assign T90 = isStack ? T131 : T91;
  assign T91 = isMem ? T96 : T92;
  assign T92 = longImm ? decReg_instr_b : T93;
  assign T93 = {19'h0/* 0*/, T94};
  assign T94 = {1'h0/* 0*/, T95};
  assign T95 = decReg_instr_a[4'hb/* 11*/:1'h0/* 0*/];
  assign longImm = T70;
  assign T96 = {22'h0/* 0*/, addrImm};
  assign addrImm = T97;
  assign T97 = T129 ? T127 : T98;
  assign T98 = {1'h0/* 0*/, T99};
  assign T99 = T105 ? T103 : T100;
  assign T100 = {1'h0/* 0*/, T101};
  assign T101 = {1'h0/* 0*/, T102};
  assign T102 = decReg_instr_a[3'h6/* 6*/:1'h0/* 0*/];
  assign T103 = {1'h0/* 0*/, T104, 1'h0/* 0*/};
  assign T104 = decReg_instr_a[3'h6/* 6*/:1'h0/* 0*/];
  assign T105 = shamt == T106;
  assign T106 = {1'h0/* 0*/, 1'h1/* 1*/};
  assign shamt = T107;
  assign T107 = T125 ? T124 : T108;
  assign T108 = T121 ? 2'h2/* 2*/ : T109;
  assign T109 = T119 ? T118 : T110;
  assign T110 = T116 ? T115 : T111;
  assign T111 = T113 ? 2'h2/* 2*/ : T112;
  assign T112 = {1'h0/* 0*/, 1'h0/* 0*/};
  assign T113 = T71 && T114;
  assign T114 = ldsize == 3'b000/* 0*/;
  assign ldsize = decReg_instr_a[4'hb/* 11*/:4'h9/* 9*/];
  assign T115 = {1'h0/* 0*/, 1'h1/* 1*/};
  assign T116 = T71 && T117;
  assign T117 = ldsize == 3'b001/* 0*/;
  assign T118 = {1'h0/* 0*/, 1'h1/* 1*/};
  assign T119 = T71 && T120;
  assign T120 = ldsize == 3'b011/* 0*/;
  assign T121 = T123 && T122;
  assign T122 = stsize == 3'b000/* 0*/;
  assign stsize = decReg_instr_a[5'h15/* 21*/:5'h13/* 19*/];
  assign T123 = opcode == 5'b01011/* 0*/;
  assign T124 = {1'h0/* 0*/, 1'h1/* 1*/};
  assign T125 = T123 && T126;
  assign T126 = stsize == 3'b001/* 0*/;
  assign T127 = {1'h0/* 0*/, T128, 2'h0/* 0*/};
  assign T128 = decReg_instr_a[3'h6/* 6*/:1'h0/* 0*/];
  assign T129 = shamt == 2'h2/* 2*/;
  assign isMem = T130;
  assign T130 = T123 ? 1'h1/* 1*/ : T71;
  assign T131 = T132 + io_exdec_sp;
  assign T132 = {22'h0/* 0*/, addrImm};
  assign isStack = T133;
  assign T133 = T136 ? 1'h1/* 1*/ : T134;
  assign T134 = T71 && T135;
  assign T135 = ldtype == 2'b00/* 0*/;
  assign ldtype = decReg_instr_a[4'h8/* 8*/:3'h7/* 7*/];
  assign T136 = T123 && T137;
  assign T137 = sttype == 2'b00/* 0*/;
  assign sttype = decReg_instr_a[5'h12/* 18*/:5'h11/* 17*/];
  assign stcVal = T138;
  assign T138 = T83 ? T144 : T139;
  assign T139 = T80 ? T140 : io_exdec_sp;
  assign T140 = io_exdec_sp - T141;
  assign T141 = {11'h0/* 0*/, stcImm};
  assign stcImm = T142;
  assign T142 = {1'h0/* 0*/, T143, 2'b00/* 0*/};
  assign T143 = decReg_instr_a[5'h11/* 17*/:1'h0/* 0*/];
  assign T144 = io_exdec_sp + T145;
  assign T145 = {11'h0/* 0*/, stcImm};
  assign isSTC = T146;
  assign T146 = T83 ? 1'h1/* 1*/ : T80;
  assign io_decex_rdAddr_1 = T147;
  assign T147 = decReg_instr_b[5'h15/* 21*/:5'h11/* 17*/];
  assign io_decex_rdAddr_0 = dest;
  assign dest = T148;
  assign T148 = T14 ? 5'b11111/* 0*/ : T149;
  assign T149 = T13 ? 5'b11111/* 0*/ : T150;
  assign T150 = decReg_instr_a[5'h15/* 21*/:5'h11/* 17*/];
  assign io_decex_rsData_3 = rf_io_rfRead_rsData_3;
  assign io_decex_rsData_2 = rf_io_rfRead_rsData_2;
  assign io_decex_rsData_1 = rf_io_rfRead_rsData_1;
  assign io_decex_rsData_0 = rf_io_rfRead_rsData_0;
  assign io_decex_rsAddr_3 = T151;
  assign T151 = decReg_instr_b[4'hb/* 11*/:3'h7/* 7*/];
  assign io_decex_rsAddr_2 = T152;
  assign T152 = decReg_instr_b[5'h10/* 16*/:4'hc/* 12*/];
  assign io_decex_rsAddr_1 = T153;
  assign T153 = decReg_instr_a[4'hb/* 11*/:3'h7/* 7*/];
  assign io_decex_rsAddr_0 = T154;
  assign T154 = decReg_instr_a[5'h10/* 16*/:4'hc/* 12*/];
  assign io_decex_memOp_typ = T155;
  assign T155 = T123 ? sttype : T156;
  assign T156 = T71 ? ldtype : ldtype;
  assign io_decex_memOp_zext = T157;
  assign T157 = T158 ? 1'h1/* 1*/ : T119;
  assign T158 = T71 && T159;
  assign T159 = ldsize == 3'b100/* 0*/;
  assign io_decex_memOp_byte = T160;
  assign T160 = T164 ? 1'h1/* 1*/ : T161;
  assign T161 = T158 ? 1'h1/* 1*/ : T162;
  assign T162 = T71 && T163;
  assign T163 = ldsize == 3'b010/* 0*/;
  assign T164 = T123 && T165;
  assign T165 = stsize == 3'b010/* 0*/;
  assign io_decex_memOp_hword = T166;
  assign T166 = T125 ? 1'h1/* 1*/ : T167;
  assign T167 = T119 ? 1'h1/* 1*/ : T116;
  assign io_decex_memOp_store = T123;
  assign io_decex_memOp_load = T71;
  assign io_decex_jmpOp_reloc = decReg_reloc;
  assign io_decex_jmpOp_target = T168;
  assign T168 = decReg_pc + T169;
  assign T169 = {T171, T170};
  assign T170 = decReg_instr_a[5'h15/* 21*/:1'h0/* 0*/];
  assign T171 = {4'h8/* 8*/{T172}};
  assign T172 = decReg_instr_a[5'h15/* 21*/:5'h15/* 21*/];
  assign T173 = T174;
  assign T174 = {29'h0/* 0*/, 1'h0/* 0*/};
  assign io_decex_jmpOp_branch = T175;
  assign T175 = T176 ? 1'h1/* 1*/ : T85;
  assign T176 = T10 && T177;
  assign T177 = func == 4'b0001/* 0*/;
  assign io_decex_predOp_1_s2Addr = T178;
  assign T178 = decReg_instr_b[4'ha/* 10*/:3'h7/* 7*/];
  assign io_decex_predOp_1_s1Addr = T179;
  assign T179 = decReg_instr_b[4'hf/* 15*/:4'hc/* 12*/];
  assign io_decex_predOp_1_dest = T180;
  assign T180 = decReg_instr_b[5'h13/* 19*/:5'h11/* 17*/];
  assign io_decex_predOp_1_func = T181;
  assign T181 = {T183, T182};
  assign T182 = decReg_instr_b[1'h0/* 0*/:1'h0/* 0*/];
  assign T183 = decReg_instr_b[2'h3/* 3*/:2'h3/* 3*/];
  assign io_decex_predOp_0_s2Addr = T184;
  assign T184 = decReg_instr_a[4'ha/* 10*/:3'h7/* 7*/];
  assign io_decex_predOp_0_s1Addr = T185;
  assign T185 = decReg_instr_a[4'hf/* 15*/:4'hc/* 12*/];
  assign io_decex_predOp_0_dest = T186;
  assign T186 = decReg_instr_a[5'h13/* 19*/:5'h11/* 17*/];
  assign io_decex_predOp_0_func = T187;
  assign T187 = {T189, T188};
  assign T188 = decReg_instr_a[1'h0/* 0*/:1'h0/* 0*/];
  assign T189 = decReg_instr_a[2'h3/* 3*/:2'h3/* 3*/];
  assign io_decex_aluOp_1_isSTC = 1'h0/* 0*/;
  assign io_decex_aluOp_1_isMFS = T190;
  assign T190 = T46 ? dual : 1'h0/* 0*/;
  assign io_decex_aluOp_1_isMTS = T191;
  assign T191 = T192 ? dual : 1'h0/* 0*/;
  assign T192 = T48 && T193;
  assign T193 = T42 == 3'b010/* 0*/;
  assign io_decex_aluOp_1_isPred = T194;
  assign T194 = T195 ? dual : 1'h0/* 0*/;
  assign T195 = T43 && T196;
  assign T196 = T42 == 3'b100/* 0*/;
  assign io_decex_aluOp_1_isCmp = T197;
  assign T197 = T198 ? dual : 1'h0/* 0*/;
  assign T198 = T43 && T199;
  assign T199 = T42 == 3'b011/* 0*/;
  assign io_decex_aluOp_1_isMul = T200;
  assign T200 = T201 ? dual : 1'h0/* 0*/;
  assign T201 = T43 && T202;
  assign T202 = T42 == 3'b010/* 0*/;
  assign io_decex_aluOp_1_func = T203;
  assign T203 = T35 ? T205 : T204;
  assign T204 = decReg_instr_b[2'h3/* 3*/:1'h0/* 0*/];
  assign T205 = {1'h0/* 0*/, T206};
  assign T206 = decReg_instr_b[5'h18/* 24*/:5'h16/* 22*/];
  assign io_decex_aluOp_0_isSTC = T207;
  assign T207 = T83 ? 1'h1/* 1*/ : T80;
  assign io_decex_aluOp_0_isMFS = T67;
  assign io_decex_aluOp_0_isMTS = T208;
  assign T208 = T69 && T209;
  assign T209 = T63 == 3'b010/* 0*/;
  assign io_decex_aluOp_0_isPred = T210;
  assign T210 = T64 && T211;
  assign T211 = T63 == 3'b100/* 0*/;
  assign io_decex_aluOp_0_isCmp = T212;
  assign T212 = T64 && T213;
  assign T213 = T63 == 3'b011/* 0*/;
  assign io_decex_aluOp_0_isMul = T214;
  assign T214 = T64 && T215;
  assign T215 = T63 == 3'b010/* 0*/;
  assign io_decex_aluOp_0_func = T216;
  assign T216 = T70 ? func : T217;
  assign T217 = T58 ? T219 : T218;
  assign T218 = decReg_instr_a[2'h3/* 3*/:1'h0/* 0*/];
  assign T219 = {1'h0/* 0*/, T220};
  assign T220 = decReg_instr_a[5'h18/* 24*/:5'h16/* 22*/];
  assign io_decex_pred_1 = T221;
  assign T221 = decReg_instr_b[5'h1e/* 30*/:5'h1b/* 27*/];
  assign io_decex_pred_0 = T222;
  assign T222 = decReg_instr_a[5'h1e/* 30*/:5'h1b/* 27*/];
  assign io_decex_pc = decReg_pc;
  RegisterFile rf(.clk(clk),
       .io_ena( io_ena ),
       .io_rfRead_rsAddr_0( T3 ),
       .io_rfRead_rsAddr_1( T2 ),
       .io_rfRead_rsAddr_2( T1 ),
       .io_rfRead_rsAddr_3( T0 ),
       .io_rfRead_rsData_0( rf_io_rfRead_rsData_0 ),
       .io_rfRead_rsData_1( rf_io_rfRead_rsData_1 ),
       .io_rfRead_rsData_2( rf_io_rfRead_rsData_2 ),
       .io_rfRead_rsData_3( rf_io_rfRead_rsData_3 ),
       .io_rfWrite_0_addr( io_rfWrite_0_addr ),
       .io_rfWrite_0_data( io_rfWrite_0_data ),
       .io_rfWrite_0_valid( io_rfWrite_0_valid ),
       .io_rfWrite_1_addr( io_rfWrite_1_addr ),
       .io_rfWrite_1_data( io_rfWrite_1_data ),
       .io_rfWrite_1_valid( io_rfWrite_1_valid )
  );

  always @(posedge clk) begin
    if(reset) begin
      decReg_instr_a <= T6;
    end else if(io_ena) begin
      decReg_instr_a <= io_fedec_instr_a;
    end
    if(reset) begin
      decReg_reloc <= T20;
    end else if(io_ena) begin
      decReg_reloc <= io_fedec_reloc;
    end
    if(reset) begin
      decReg_instr_b <= T38;
    end else if(io_ena) begin
      decReg_instr_b <= io_fedec_instr_b;
    end
    if(reset) begin
      decReg_pc <= T173;
    end else if(io_ena) begin
      decReg_pc <= io_fedec_pc;
    end
  end
endmodule

module Execute(input clk, input reset,
    input  io_ena,
    input [29:0] io_decex_pc,
    input [3:0] io_decex_pred_0,
    input [3:0] io_decex_pred_1,
    input [3:0] io_decex_aluOp_0_func,
    input  io_decex_aluOp_0_isMul,
    input  io_decex_aluOp_0_isCmp,
    input  io_decex_aluOp_0_isPred,
    input  io_decex_aluOp_0_isMTS,
    input  io_decex_aluOp_0_isMFS,
    input  io_decex_aluOp_0_isSTC,
    input [3:0] io_decex_aluOp_1_func,
    input  io_decex_aluOp_1_isMul,
    input  io_decex_aluOp_1_isCmp,
    input  io_decex_aluOp_1_isPred,
    input  io_decex_aluOp_1_isMTS,
    input  io_decex_aluOp_1_isMFS,
    input  io_decex_aluOp_1_isSTC,
    input [1:0] io_decex_predOp_0_func,
    input [2:0] io_decex_predOp_0_dest,
    input [3:0] io_decex_predOp_0_s1Addr,
    input [3:0] io_decex_predOp_0_s2Addr,
    input [1:0] io_decex_predOp_1_func,
    input [2:0] io_decex_predOp_1_dest,
    input [3:0] io_decex_predOp_1_s1Addr,
    input [3:0] io_decex_predOp_1_s2Addr,
    input  io_decex_jmpOp_branch,
    input [29:0] io_decex_jmpOp_target,
    input [31:0] io_decex_jmpOp_reloc,
    input  io_decex_memOp_load,
    input  io_decex_memOp_store,
    input  io_decex_memOp_hword,
    input  io_decex_memOp_byte,
    input  io_decex_memOp_zext,
    input [1:0] io_decex_memOp_typ,
    input [4:0] io_decex_rsAddr_0,
    input [4:0] io_decex_rsAddr_1,
    input [4:0] io_decex_rsAddr_2,
    input [4:0] io_decex_rsAddr_3,
    input [31:0] io_decex_rsData_0,
    input [31:0] io_decex_rsData_1,
    input [31:0] io_decex_rsData_2,
    input [31:0] io_decex_rsData_3,
    input [4:0] io_decex_rdAddr_0,
    input [4:0] io_decex_rdAddr_1,
    input [31:0] io_decex_immVal_0,
    input [31:0] io_decex_immVal_1,
    input  io_decex_immOp_0,
    input  io_decex_immOp_1,
    input  io_decex_wrRd_0,
    input  io_decex_wrRd_1,
    input [31:0] io_decex_callAddr,
    input [31:0] io_decex_brcfAddr,
    input  io_decex_call,
    input  io_decex_ret,
    input  io_decex_brcf,
    output[31:0] io_exdec_sp,
    output[4:0] io_exmem_rd_0_addr,
    output[31:0] io_exmem_rd_0_data,
    output io_exmem_rd_0_valid,
    output[4:0] io_exmem_rd_1_addr,
    output[31:0] io_exmem_rd_1_data,
    output io_exmem_rd_1_valid,
    output io_exmem_mem_load,
    output io_exmem_mem_store,
    output io_exmem_mem_hword,
    output io_exmem_mem_byte,
    output io_exmem_mem_zext,
    output[1:0] io_exmem_mem_typ,
    output[31:0] io_exmem_mem_addr,
    output[31:0] io_exmem_mem_data,
    output io_exmem_mem_call,
    output io_exmem_mem_ret,
    output io_exmem_mem_brcf,
    output[31:0] io_exmem_mem_callRetAddr,
    output[31:0] io_exmem_mem_callRetBase,
    output[29:0] io_exmem_pc,
    output io_exmcache_doCallRet,
    output[31:0] io_exmcache_callRetBase,
    output[31:0] io_exmcache_callRetAddr,
    input [4:0] io_exResult_0_addr,
    input [31:0] io_exResult_0_data,
    input  io_exResult_0_valid,
    input [4:0] io_exResult_1_addr,
    input [31:0] io_exResult_1_data,
    input  io_exResult_1_valid,
    input [4:0] io_memResult_0_addr,
    input [31:0] io_memResult_0_data,
    input  io_memResult_0_valid,
    input [4:0] io_memResult_1_addr,
    input [31:0] io_memResult_1_data,
    input  io_memResult_1_valid,
    output io_exfe_doBranch,
    output[29:0] io_exfe_branchPc
);

  wire[29:0] T0;
  wire[31:0] target;
  wire[31:0] T1;
  reg[31:0] exReg_jmpOp_reloc;
  wire[31:0] T2;
  wire[31:0] T3;
  wire[31:0] T4;
  wire[31:0] T5;
  wire[29:0] T6;
  wire[29:0] T7;
  wire[31:0] op_0;
  wire[31:0] T8;
  wire[31:0] T9;
  wire[31:0] T10;
  wire[31:0] T11;
  reg[31:0] exReg_rsData_0;
  wire[31:0] T12;
  wire[31:0] T13;
  reg[31:0] memResultDataReg_0;
  reg[0:0] fwMemReg_0_0;
  wire T14;
  wire T15;
  wire T16;
  wire T17;
  reg[31:0] memResultDataReg_1;
  reg[0:0] fwMemReg_0_1;
  wire T18;
  wire T19;
  wire T20;
  wire T21;
  reg[31:0] exResultDataReg_0;
  reg[0:0] fwExReg_0_0;
  wire T22;
  wire T23;
  wire T24;
  wire T25;
  reg[31:0] exResultDataReg_1;
  reg[0:0] fwExReg_0_1;
  wire T26;
  wire T27;
  wire T28;
  wire T29;
  wire[31:0] T30;
  reg[29:0] exReg_jmpOp_target;
  wire[29:0] T31;
  wire[29:0] T32;
  wire[29:0] T33;
  reg[0:0] exReg_immOp_0;
  wire T34;
  wire T35;
  wire doExecute_0;
  wire T36;
  wire T37;
  reg[3:0] exReg_pred_0;
  wire[3:0] T38;
  wire[3:0] T39;
  wire T40;
  wire T41;
  wire T42;
  reg[0:0] predReg_0;
  wire T43;
  wire T44;
  wire T45;
  wire[7:0] T46;
  wire[7:0] T47;
  wire[31:0] op_2;
  wire[31:0] T48;
  wire[31:0] T49;
  wire[31:0] T50;
  wire[31:0] T51;
  reg[31:0] exReg_rsData_2;
  wire[31:0] T52;
  wire[31:0] T53;
  reg[0:0] fwMemReg_2_0;
  wire T54;
  wire T55;
  wire T56;
  wire T57;
  reg[0:0] fwMemReg_2_1;
  wire T58;
  wire T59;
  wire T60;
  wire T61;
  reg[0:0] fwExReg_2_0;
  wire T62;
  wire T63;
  wire T64;
  wire T65;
  reg[0:0] fwExReg_2_1;
  wire T66;
  wire T67;
  wire T68;
  wire T69;
  wire T70;
  wire T71;
  reg[3:0] exReg_aluOp_1_func;
  wire[3:0] T72;
  wire[3:0] T73;
  wire[3:0] T74;
  wire T75;
  wire T76;
  wire doExecute_1;
  wire T77;
  wire T78;
  reg[3:0] exReg_pred_1;
  wire[3:0] T79;
  wire[3:0] T80;
  wire T81;
  wire T82;
  wire T83;
  reg[0:0] predReg_1;
  wire T84;
  wire T85;
  wire T86;
  wire T87;
  wire[7:0] T88;
  wire[14:0] T89;
  wire[2:0] T90;
  reg[2:0] exReg_predOp_1_dest;
  wire[2:0] T91;
  wire[2:0] T92;
  wire[2:0] T93;
  wire T94;
  wire T95;
  wire T96;
  reg[0:0] exReg_aluOp_1_isPred;
  wire T97;
  wire T98;
  reg[0:0] exReg_aluOp_1_isCmp;
  wire T99;
  wire T100;
  wire T101;
  wire T102;
  wire T103;
  reg[3:0] exReg_aluOp_0_func;
  wire[3:0] T104;
  wire T105;
  wire T106;
  reg[0:0] exReg_aluOp_0_isMTS;
  wire T107;
  wire T108;
  wire T109;
  wire T110;
  wire[7:0] T111;
  wire[14:0] T112;
  wire[2:0] T113;
  reg[2:0] exReg_predOp_0_dest;
  wire[2:0] T114;
  wire T115;
  wire T116;
  wire T117;
  reg[0:0] exReg_aluOp_0_isPred;
  wire T118;
  reg[0:0] exReg_aluOp_0_isCmp;
  wire T119;
  wire T120;
  wire T121;
  wire T122;
  wire T123;
  wire T124;
  wire T125;
  wire T126;
  wire T127;
  wire T128;
  wire T129;
  wire T130;
  wire T131;
  reg[3:0] exReg_predOp_0_s2Addr;
  wire[3:0] T132;
  wire[3:0] T133;
  wire[3:0] T134;
  wire T135;
  wire T136;
  wire T137;
  wire T138;
  wire[2:0] T139;
  wire[2:0] T140;
  wire T141;
  reg[0:0] predReg_2;
  wire T142;
  wire T143;
  wire T144;
  wire T145;
  wire T146;
  wire T147;
  wire T148;
  wire T149;
  wire T150;
  wire T151;
  wire T152;
  wire[7:0] T153;
  wire[7:0] T154;
  wire T155;
  wire T156;
  wire T157;
  wire T158;
  wire T159;
  wire T160;
  wire T161;
  wire T162;
  wire T163;
  reg[3:0] exReg_predOp_1_s2Addr;
  wire[3:0] T164;
  wire T165;
  wire T166;
  wire T167;
  wire T168;
  wire[2:0] T169;
  wire[2:0] T170;
  wire T171;
  reg[0:0] predReg_3;
  wire T172;
  wire T173;
  wire T174;
  wire T175;
  wire T176;
  wire T177;
  wire T178;
  wire T179;
  wire T180;
  wire T181;
  wire T182;
  wire T183;
  wire T184;
  wire T185;
  wire T186;
  wire T187;
  reg[0:0] predReg_4;
  wire T188;
  wire T189;
  wire T190;
  wire T191;
  wire T192;
  wire T193;
  wire T194;
  wire T195;
  wire T196;
  wire T197;
  wire T198;
  wire T199;
  reg[0:0] predReg_5;
  wire T200;
  wire T201;
  wire T202;
  wire T203;
  wire T204;
  wire T205;
  wire T206;
  wire T207;
  wire T208;
  wire T209;
  wire T210;
  wire T211;
  wire T212;
  wire T213;
  reg[0:0] predReg_6;
  wire T214;
  wire T215;
  wire T216;
  wire T217;
  wire T218;
  wire T219;
  wire T220;
  wire T221;
  wire T222;
  wire T223;
  wire T224;
  wire T225;
  reg[0:0] predReg_7;
  wire T226;
  wire T227;
  wire T228;
  wire T229;
  wire T230;
  wire T231;
  wire T232;
  wire T233;
  wire T234;
  wire T235;
  wire T236;
  wire T237;
  wire T238;
  wire T239;
  wire T240;
  wire T241;
  wire T242;
  reg[3:0] exReg_predOp_1_s1Addr;
  wire[3:0] T243;
  wire[3:0] T244;
  wire[3:0] T245;
  wire T246;
  wire T247;
  wire T248;
  wire T249;
  wire[2:0] T250;
  wire[2:0] T251;
  wire T252;
  wire T253;
  wire T254;
  wire T255;
  wire T256;
  wire T257;
  wire T258;
  wire T259;
  wire T260;
  wire T261;
  wire T262;
  wire[1:0] T263;
  reg[1:0] exReg_predOp_1_func;
  wire[1:0] T264;
  wire[1:0] T265;
  wire[1:0] T266;
  wire T267;
  wire T268;
  wire T269;
  wire T270;
  wire T271;
  wire T272;
  wire T273;
  wire T274;
  wire T275;
  wire T276;
  wire T277;
  wire T278;
  wire T279;
  wire T280;
  wire[4:0] T281;
  wire[4:0] T282;
  wire[31:0] op_3;
  wire[31:0] T283;
  wire[31:0] T284;
  wire[31:0] T285;
  wire[31:0] T286;
  wire[31:0] T287;
  reg[31:0] exReg_rsData_3;
  wire[31:0] T288;
  wire[31:0] T289;
  reg[0:0] fwMemReg_3_0;
  wire T290;
  wire T291;
  wire T292;
  wire T293;
  reg[0:0] fwMemReg_3_1;
  wire T294;
  wire T295;
  wire T296;
  wire T297;
  reg[0:0] fwExReg_3_0;
  wire T298;
  wire T299;
  wire T300;
  wire T301;
  reg[0:0] fwExReg_3_1;
  wire T302;
  wire T303;
  wire T304;
  wire T305;
  reg[31:0] exReg_immVal_1;
  wire[31:0] T306;
  wire[31:0] T307;
  reg[0:0] exReg_immOp_1;
  wire T308;
  wire T309;
  wire[3:0] T310;
  wire T311;
  wire T312;
  wire T313;
  wire T314;
  wire T315;
  wire T316;
  wire signed  T317;
  wire signed [31:0] T318;
  wire signed [31:0] T319;
  wire T320;
  wire T321;
  wire T322;
  wire T323;
  wire T324;
  wire T325;
  wire T326;
  wire T327;
  wire T328;
  wire T329;
  wire T330;
  wire T331;
  wire T332;
  wire T333;
  wire T334;
  wire T335;
  wire T336;
  reg[3:0] exReg_predOp_0_s1Addr;
  wire[3:0] T337;
  wire T338;
  wire T339;
  wire T340;
  wire T341;
  wire[2:0] T342;
  wire[2:0] T343;
  wire T344;
  wire T345;
  wire T346;
  wire T347;
  wire T348;
  wire T349;
  wire T350;
  wire T351;
  wire T352;
  wire T353;
  wire T354;
  wire[1:0] T355;
  reg[1:0] exReg_predOp_0_func;
  wire[1:0] T356;
  wire T357;
  wire T358;
  wire T359;
  wire T360;
  wire T361;
  wire T362;
  wire T363;
  wire T364;
  wire T365;
  wire T366;
  wire T367;
  wire T368;
  wire T369;
  wire T370;
  wire[4:0] T371;
  wire[4:0] T372;
  wire[31:0] op_1;
  wire[31:0] T373;
  wire[31:0] T374;
  wire[31:0] T375;
  wire[31:0] T376;
  wire[31:0] T377;
  reg[31:0] exReg_rsData_1;
  wire[31:0] T378;
  wire[31:0] T379;
  reg[0:0] fwMemReg_1_0;
  wire T380;
  wire T381;
  wire T382;
  wire T383;
  reg[0:0] fwMemReg_1_1;
  wire T384;
  wire T385;
  wire T386;
  wire T387;
  reg[0:0] fwExReg_1_0;
  wire T388;
  wire T389;
  wire T390;
  wire T391;
  reg[0:0] fwExReg_1_1;
  wire T392;
  wire T393;
  wire T394;
  wire T395;
  reg[31:0] exReg_immVal_0;
  wire[31:0] T396;
  wire[31:0] T397;
  wire T398;
  wire[3:0] T399;
  wire T400;
  wire T401;
  wire T402;
  wire T403;
  wire T404;
  wire T405;
  wire signed  T406;
  wire signed [31:0] T407;
  wire signed [31:0] T408;
  wire T409;
  wire T410;
  wire T411;
  wire T412;
  wire T413;
  wire T414;
  wire T415;
  wire T416;
  wire[2:0] T417;
  wire[2:0] T418;
  wire T419;
  wire T420;
  wire T421;
  wire T422;
  wire T423;
  wire T424;
  wire T425;
  wire T426;
  wire T427;
  wire T428;
  reg[0:0] exReg_aluOp_1_isMTS;
  wire T429;
  wire T430;
  wire[2:0] T431;
  wire[2:0] T432;
  wire T433;
  wire T434;
  wire T435;
  wire T436;
  wire T437;
  wire T438;
  wire T439;
  wire T440;
  wire T441;
  wire T442;
  reg[0:0] exReg_jmpOp_branch;
  wire T443;
  wire T444;
  wire[31:0] T445;
  wire[29:0] T446;
  wire[31:0] T447;
  wire[29:0] T448;
  wire T449;
  wire T450;
  reg[0:0] exReg_brcf;
  wire T451;
  wire T452;
  reg[0:0] exReg_ret;
  wire T453;
  reg[0:0] exReg_call;
  wire T454;
  reg[29:0] exReg_pc;
  wire[29:0] T455;
  wire[29:0] T456;
  wire[31:0] T457;
  wire[31:0] T458;
  wire[31:0] T459;
  wire[31:0] brcfAddr;
  wire[31:0] T460;
  reg[31:0] exReg_brcfAddr;
  wire[31:0] T461;
  wire[31:0] T462;
  wire[31:0] callAddr;
  wire[31:0] T463;
  reg[31:0] exReg_callAddr;
  wire[31:0] T464;
  wire[31:0] T465;
  wire[31:0] T466;
  wire[31:0] T467;
  wire[31:0] T468;
  wire T469;
  wire T470;
  wire T471;
  wire T472;
  wire[31:0] T473;
  reg[1:0] exReg_memOp_typ;
  wire[1:0] T474;
  wire[1:0] T475;
  wire[1:0] T476;
  reg[0:0] exReg_memOp_zext;
  wire T477;
  wire T478;
  reg[0:0] exReg_memOp_byte;
  wire T479;
  wire T480;
  reg[0:0] exReg_memOp_hword;
  wire T481;
  wire T482;
  wire T483;
  reg[0:0] exReg_memOp_store;
  wire T484;
  wire T485;
  wire T486;
  reg[0:0] exReg_memOp_load;
  wire T487;
  wire T488;
  wire T489;
  reg[0:0] exReg_wrRd_1;
  wire T490;
  wire[31:0] T491;
  wire[31:0] T492;
  wire[31:0] T493;
  wire[62:0] T494;
  wire[62:0] T495;
  wire[62:0] T496;
  wire[62:0] T497;
  wire[62:0] T498;
  wire[62:0] T499;
  wire[62:0] T500;
  wire[62:0] T501;
  wire[62:0] T502;
  wire[34:0] T503;
  wire[34:0] T504;
  wire[34:0] T505;
  wire[34:0] T506;
  wire[34:0] T507;
  wire[34:0] T508;
  wire[1:0] T509;
  wire[1:0] T510;
  wire T511;
  wire T512;
  wire T513;
  wire[34:0] T514;
  wire[31:0] T515;
  wire T516;
  wire[34:0] T517;
  wire[31:0] T518;
  wire[31:0] T519;
  wire T520;
  wire[62:0] T521;
  wire[62:0] T522;
  wire[4:0] T523;
  wire[4:0] T524;
  wire T525;
  wire[62:0] T526;
  wire[31:0] T527;
  wire[31:0] T528;
  wire T529;
  wire[62:0] T530;
  wire[31:0] T531;
  wire signed [31:0] T532;
  wire signed [31:0] T533;
  wire T534;
  wire[62:0] T535;
  wire[31:0] T536;
  wire[31:0] T537;
  wire T538;
  wire[62:0] T539;
  wire[31:0] T540;
  wire[31:0] T541;
  wire T542;
  wire[62:0] T543;
  wire[31:0] T544;
  wire[31:0] T545;
  wire[31:0] T546;
  wire T547;
  wire[62:0] T548;
  wire T549;
  wire[62:0] T550;
  wire T551;
  wire[31:0] T552;
  wire[31:0] T553;
  wire[31:0] T554;
  wire[31:0] T555;
  wire[31:0] T556;
  wire[31:0] T557;
  wire[31:0] T558;
  wire[31:0] T559;
  wire[7:0] T560;
  wire T561;
  wire T562;
  wire T563;
  wire T564;
  wire T565;
  wire T566;
  wire T567;
  wire T568;
  wire T569;
  reg[31:0] mulLoReg;
  wire T570;
  wire T571;
  wire T572;
  wire T573;
  wire T574;
  wire T575;
  wire T576;
  reg[0:0] mulPipeReg;
  wire T577;
  reg[0:0] exReg_aluOp_0_isMul;
  wire T578;
  wire T579;
  wire[31:0] T580;
  wire[31:0] T581;
  wire[31:0] T582;
  wire[63:0] T583;
  wire[63:0] T584;
  reg[31:0] mulLHReg;
  wire T585;
  wire T586;
  wire T587;
  wire[31:0] T588;
  wire[31:0] T589;
  wire[15:0] T590;
  wire[15:0] T591;
  wire[15:0] T592;
  wire[15:0] T593;
  wire[31:0] T594;
  wire[47:0] T595;
  wire[47:0] T596;
  wire[31:0] T597;
  wire signed [15:0] T598;
  wire[15:0] T599;
  wire T600;
  wire[15:0] T601;
  wire[15:0] T602;
  wire T603;
  wire[63:0] T604;
  wire[63:0] T605;
  reg[31:0] mulHLReg;
  wire T606;
  wire[31:0] T607;
  wire[31:0] T608;
  wire[15:0] T609;
  wire[15:0] T610;
  wire[15:0] T611;
  wire[15:0] T612;
  wire[31:0] T613;
  wire[47:0] T614;
  wire[47:0] T615;
  wire[15:0] T616;
  wire[31:0] T617;
  wire signed [15:0] T618;
  wire[15:0] T619;
  wire T620;
  wire[15:0] T621;
  wire T622;
  wire[63:0] T623;
  reg[31:0] mulLLReg;
  wire T624;
  wire[31:0] T625;
  wire[31:0] T626;
  wire[15:0] T627;
  wire[15:0] T628;
  wire[31:0] T629;
  wire[31:0] T630;
  wire[31:0] T631;
  wire[15:0] T632;
  wire[15:0] T633;
  reg[31:0] mulHHReg;
  wire T634;
  wire[31:0] T635;
  wire[31:0] T636;
  wire[15:0] T637;
  wire[15:0] T638;
  wire[31:0] T639;
  wire[63:0] T640;
  wire[63:0] T641;
  wire[31:0] T642;
  wire[31:0] T643;
  wire T644;
  reg[31:0] mulHiReg;
  wire T645;
  wire T646;
  wire T647;
  wire T648;
  wire T649;
  wire T650;
  wire[31:0] T651;
  wire[31:0] T652;
  wire[31:0] T653;
  wire[31:0] T654;
  wire[31:0] T655;
  wire T656;
  reg[31:0] stackTopReg;
  wire T657;
  wire T658;
  wire T659;
  wire T660;
  wire T661;
  wire T662;
  reg[0:0] exReg_aluOp_1_isSTC;
  wire T663;
  wire T664;
  wire T665;
  wire T666;
  wire T667;
  wire T668;
  wire T669;
  reg[0:0] exReg_aluOp_0_isSTC;
  wire T670;
  wire[31:0] T671;
  wire[31:0] T672;
  wire[31:0] T673;
  wire[31:0] T674;
  wire[31:0] T675;
  wire[31:0] T676;
  wire[31:0] T677;
  wire T678;
  reg[31:0] stackSpillReg;
  wire T679;
  wire T680;
  wire T681;
  wire T682;
  wire T683;
  wire[31:0] T684;
  wire[31:0] T685;
  wire[31:0] T686;
  wire T687;
  reg[0:0] exReg_aluOp_1_isMFS;
  wire T688;
  wire T689;
  reg[4:0] exReg_rdAddr_1;
  wire[4:0] T690;
  wire[4:0] T691;
  wire T692;
  reg[0:0] exReg_wrRd_0;
  wire T693;
  wire[31:0] T694;
  wire[31:0] T695;
  wire[31:0] T696;
  wire[62:0] T697;
  wire[62:0] T698;
  wire[62:0] T699;
  wire[62:0] T700;
  wire[62:0] T701;
  wire[62:0] T702;
  wire[62:0] T703;
  wire[62:0] T704;
  wire[62:0] T705;
  wire[34:0] T706;
  wire[34:0] T707;
  wire[34:0] T708;
  wire[34:0] T709;
  wire[34:0] T710;
  wire[34:0] T711;
  wire[1:0] T712;
  wire[1:0] T713;
  wire T714;
  wire T715;
  wire T716;
  wire[34:0] T717;
  wire[31:0] T718;
  wire T719;
  wire[34:0] T720;
  wire[31:0] T721;
  wire[31:0] T722;
  wire T723;
  wire[62:0] T724;
  wire[62:0] T725;
  wire[4:0] T726;
  wire[4:0] T727;
  wire T728;
  wire[62:0] T729;
  wire[31:0] T730;
  wire[31:0] T731;
  wire T732;
  wire[62:0] T733;
  wire[31:0] T734;
  wire signed [31:0] T735;
  wire signed [31:0] T736;
  wire T737;
  wire[62:0] T738;
  wire[31:0] T739;
  wire[31:0] T740;
  wire T741;
  wire[62:0] T742;
  wire[31:0] T743;
  wire[31:0] T744;
  wire T745;
  wire[62:0] T746;
  wire[31:0] T747;
  wire[31:0] T748;
  wire[31:0] T749;
  wire T750;
  wire[62:0] T751;
  wire T752;
  wire[62:0] T753;
  wire T754;
  wire[31:0] T755;
  wire[31:0] T756;
  wire[31:0] T757;
  wire[31:0] T758;
  wire[31:0] T759;
  wire[31:0] T760;
  wire[31:0] T761;
  wire[31:0] T762;
  wire[7:0] T763;
  wire T764;
  wire T765;
  wire T766;
  wire T767;
  wire T768;
  wire T769;
  wire T770;
  wire T771;
  wire T772;
  wire T773;
  wire T774;
  wire T775;
  wire T776;
  reg[0:0] exReg_aluOp_0_isMFS;
  wire T777;
  reg[4:0] exReg_rdAddr_0;
  wire[4:0] T778;
  wire[4:0] T779;
  wire[31:0] T780;
  wire[31:0] T781;
  wire[31:0] T782;
  wire[31:0] T783;
  wire[31:0] T784;
  wire[31:0] T785;
  wire T786;
  wire T787;
  wire T788;
  wire[31:0] T789;
  wire[31:0] T790;
  wire T791;
  wire T792;
  wire T793;

  assign io_exfe_branchPc = T0;
  assign T0 = target[5'h1d/* 29*/:1'h0/* 0*/];
  assign target = exReg_immOp_0 ? T30 : T1;
  assign T1 = T5 - exReg_jmpOp_reloc;
  assign T2 = T3;
  assign T3 = T4;
  assign T4 = {31'h0/* 0*/, 1'h0/* 0*/};
  assign T5 = {2'h0/* 0*/, T6};
  assign T6 = T7;
  assign T7 = op_0[5'h1f/* 31*/:2'h2/* 2*/];
  assign op_0 = T8;
  assign T8 = fwExReg_0_1 ? exResultDataReg_1 : T9;
  assign T9 = fwExReg_0_0 ? exResultDataReg_0 : T10;
  assign T10 = fwMemReg_0_1 ? memResultDataReg_1 : T11;
  assign T11 = fwMemReg_0_0 ? memResultDataReg_0 : exReg_rsData_0;
  assign T12 = T13;
  assign T13 = {31'h0/* 0*/, 1'h0/* 0*/};
  assign T14 = io_ena || T15;
  assign T15 = io_ena && T16;
  assign T16 = T17 && io_memResult_0_valid;
  assign T17 = io_decex_rsAddr_0 == io_memResult_0_addr;
  assign T18 = io_ena || T19;
  assign T19 = io_ena && T20;
  assign T20 = T21 && io_memResult_1_valid;
  assign T21 = io_decex_rsAddr_0 == io_memResult_1_addr;
  assign T22 = io_ena || T23;
  assign T23 = io_ena && T24;
  assign T24 = T25 && io_exResult_0_valid;
  assign T25 = io_decex_rsAddr_0 == io_exResult_0_addr;
  assign T26 = io_ena || T27;
  assign T27 = io_ena && T28;
  assign T28 = T29 && io_exResult_1_valid;
  assign T29 = io_decex_rsAddr_0 == io_exResult_1_addr;
  assign T30 = {2'h0/* 0*/, exReg_jmpOp_target};
  assign T31 = T32;
  assign T32 = T33;
  assign T33 = {29'h0/* 0*/, 1'h0/* 0*/};
  assign T34 = 1'h0/* 0*/;
  assign io_exfe_doBranch = T35;
  assign T35 = exReg_jmpOp_branch && doExecute_0;
  assign doExecute_0 = T36;
  assign T36 = T40 ^ T37;
  assign T37 = exReg_pred_0[2'h3/* 3*/:2'h3/* 3*/];
  assign T38 = T39;
  assign T39 = {3'h0/* 0*/, 1'h0/* 0*/};
  assign T40 = T442 ? T436 : T41;
  assign T41 = T435 ? T433 : T42;
  assign T42 = T430 ? predReg_1 : predReg_0;
  assign T43 = T70 ? 1'h1/* 1*/ : T44;
  assign T44 = T70 ? T45 : 1'h1/* 1*/;
  assign T45 = T46[1'h0/* 0*/:1'h0/* 0*/];
  assign T46 = T47;
  assign T47 = op_2[3'h7/* 7*/:1'h0/* 0*/];
  assign op_2 = T48;
  assign T48 = fwExReg_2_1 ? exResultDataReg_1 : T49;
  assign T49 = fwExReg_2_0 ? exResultDataReg_0 : T50;
  assign T50 = fwMemReg_2_1 ? memResultDataReg_1 : T51;
  assign T51 = fwMemReg_2_0 ? memResultDataReg_0 : exReg_rsData_2;
  assign T52 = T53;
  assign T53 = {31'h0/* 0*/, 1'h0/* 0*/};
  assign T54 = io_ena || T55;
  assign T55 = io_ena && T56;
  assign T56 = T57 && io_memResult_0_valid;
  assign T57 = io_decex_rsAddr_2 == io_memResult_0_addr;
  assign T58 = io_ena || T59;
  assign T59 = io_ena && T60;
  assign T60 = T61 && io_memResult_1_valid;
  assign T61 = io_decex_rsAddr_2 == io_memResult_1_addr;
  assign T62 = io_ena || T63;
  assign T63 = io_ena && T64;
  assign T64 = T65 && io_exResult_0_valid;
  assign T65 = io_decex_rsAddr_2 == io_exResult_0_addr;
  assign T66 = io_ena || T67;
  assign T67 = io_ena && T68;
  assign T68 = T69 && io_exResult_1_valid;
  assign T69 = io_decex_rsAddr_2 == io_exResult_1_addr;
  assign T70 = T75 && T71;
  assign T71 = exReg_aluOp_1_func == 4'b0000/* 0*/;
  assign T72 = T73;
  assign T73 = T74;
  assign T74 = {3'h0/* 0*/, 1'h0/* 0*/};
  assign T75 = T76 && io_ena;
  assign T76 = exReg_aluOp_1_isMTS && doExecute_1;
  assign doExecute_1 = T77;
  assign T77 = T81 ^ T78;
  assign T78 = exReg_pred_1[2'h3/* 3*/:2'h3/* 3*/];
  assign T79 = T80;
  assign T80 = {3'h0/* 0*/, 1'h0/* 0*/};
  assign T81 = T428 ? T422 : T82;
  assign T82 = T421 ? T419 : T83;
  assign T83 = T416 ? predReg_1 : predReg_0;
  assign T84 = T85 || T70;
  assign T85 = T101 || T86;
  assign T86 = T94 && T87;
  assign T87 = T88[1'h1/* 1*/:1'h1/* 1*/];
  assign T88 = T89[3'h7/* 7*/:1'h0/* 0*/];
  assign T89 = 8'h1/* 1*/ << T90;
  assign T90 = exReg_predOp_1_dest;
  assign T91 = T92;
  assign T92 = T93;
  assign T93 = {2'h0/* 0*/, 1'h0/* 0*/};
  assign T94 = T95 && io_ena;
  assign T95 = T96 && doExecute_1;
  assign T96 = exReg_aluOp_1_isCmp || exReg_aluOp_1_isPred;
  assign T97 = T98;
  assign T98 = 1'h0/* 0*/;
  assign T99 = T100;
  assign T100 = 1'h0/* 0*/;
  assign T101 = T109 || T102;
  assign T102 = T105 && T103;
  assign T103 = exReg_aluOp_0_func == 4'b0000/* 0*/;
  assign T104 = T73;
  assign T105 = T106 && io_ena;
  assign T106 = exReg_aluOp_0_isMTS && doExecute_0;
  assign T107 = T108;
  assign T108 = 1'h0/* 0*/;
  assign T109 = T115 && T110;
  assign T110 = T111[1'h1/* 1*/:1'h1/* 1*/];
  assign T111 = T112[3'h7/* 7*/:1'h0/* 0*/];
  assign T112 = 8'h1/* 1*/ << T113;
  assign T113 = exReg_predOp_0_dest;
  assign T114 = T92;
  assign T115 = T116 && io_ena;
  assign T116 = T117 && doExecute_0;
  assign T117 = exReg_aluOp_0_isCmp || exReg_aluOp_0_isPred;
  assign T118 = T98;
  assign T119 = T100;
  assign T120 = T70 ? T415 : T121;
  assign T121 = T86 ? T155 : T122;
  assign T122 = T102 ? T414 : T123;
  assign T123 = exReg_aluOp_0_isCmp ? T363 : T124;
  assign T124 = T362 ? T361 : T125;
  assign T125 = T360 ? T359 : T126;
  assign T126 = T358 ? T357 : T127;
  assign T127 = T354 ? T128 : 1'h0/* 0*/;
  assign T128 = ~ T129;
  assign T129 = T335 | T130;
  assign T130 = T135 ^ T131;
  assign T131 = exReg_predOp_0_s2Addr[2'h3/* 3*/:2'h3/* 3*/];
  assign T132 = T133;
  assign T133 = T134;
  assign T134 = {3'h0/* 0*/, 1'h0/* 0*/};
  assign T135 = T334 ? T328 : T136;
  assign T136 = T327 ? T141 : T137;
  assign T137 = T138 ? predReg_1 : predReg_0;
  assign T138 = T139[1'h0/* 0*/:1'h0/* 0*/];
  assign T139 = T140;
  assign T140 = exReg_predOp_0_s2Addr[2'h2/* 2*/:1'h0/* 0*/];
  assign T141 = T326 ? predReg_3 : predReg_2;
  assign T142 = T143 || T70;
  assign T143 = T146 || T144;
  assign T144 = T94 && T145;
  assign T145 = T88[2'h2/* 2*/:2'h2/* 2*/];
  assign T146 = T147 || T102;
  assign T147 = T115 && T148;
  assign T148 = T111[2'h2/* 2*/:2'h2/* 2*/];
  assign T149 = T70 ? T325 : T150;
  assign T150 = T144 ? T155 : T151;
  assign T151 = T102 ? T152 : T123;
  assign T152 = T153[2'h2/* 2*/:2'h2/* 2*/];
  assign T153 = T154;
  assign T154 = op_0[3'h7/* 7*/:1'h0/* 0*/];
  assign T155 = exReg_aluOp_1_isCmp ? T273 : T156;
  assign T156 = T272 ? T271 : T157;
  assign T157 = T270 ? T269 : T158;
  assign T158 = T268 ? T267 : T159;
  assign T159 = T262 ? T160 : 1'h0/* 0*/;
  assign T160 = ~ T161;
  assign T161 = T241 | T162;
  assign T162 = T165 ^ T163;
  assign T163 = exReg_predOp_1_s2Addr[2'h3/* 3*/:2'h3/* 3*/];
  assign T164 = T133;
  assign T165 = T240 ? T186 : T166;
  assign T166 = T185 ? T171 : T167;
  assign T167 = T168 ? predReg_1 : predReg_0;
  assign T168 = T169[1'h0/* 0*/:1'h0/* 0*/];
  assign T169 = T170;
  assign T170 = exReg_predOp_1_s2Addr[2'h2/* 2*/:1'h0/* 0*/];
  assign T171 = T184 ? predReg_3 : predReg_2;
  assign T172 = T173 || T70;
  assign T173 = T176 || T174;
  assign T174 = T94 && T175;
  assign T175 = T88[2'h3/* 3*/:2'h3/* 3*/];
  assign T176 = T177 || T102;
  assign T177 = T115 && T178;
  assign T178 = T111[2'h3/* 3*/:2'h3/* 3*/];
  assign T179 = T70 ? T183 : T180;
  assign T180 = T174 ? T155 : T181;
  assign T181 = T102 ? T182 : T123;
  assign T182 = T153[2'h3/* 3*/:2'h3/* 3*/];
  assign T183 = T46[2'h3/* 3*/:2'h3/* 3*/];
  assign T184 = T169[1'h0/* 0*/:1'h0/* 0*/];
  assign T185 = T169[1'h1/* 1*/:1'h1/* 1*/];
  assign T186 = T239 ? T213 : T187;
  assign T187 = T212 ? predReg_5 : predReg_4;
  assign T188 = T189 || T70;
  assign T189 = T192 || T190;
  assign T190 = T94 && T191;
  assign T191 = T88[3'h4/* 4*/:3'h4/* 4*/];
  assign T192 = T193 || T102;
  assign T193 = T115 && T194;
  assign T194 = T111[3'h4/* 4*/:3'h4/* 4*/];
  assign T195 = T70 ? T199 : T196;
  assign T196 = T190 ? T155 : T197;
  assign T197 = T102 ? T198 : T123;
  assign T198 = T153[3'h4/* 4*/:3'h4/* 4*/];
  assign T199 = T46[3'h4/* 4*/:3'h4/* 4*/];
  assign T200 = T201 || T70;
  assign T201 = T204 || T202;
  assign T202 = T94 && T203;
  assign T203 = T88[3'h5/* 5*/:3'h5/* 5*/];
  assign T204 = T205 || T102;
  assign T205 = T115 && T206;
  assign T206 = T111[3'h5/* 5*/:3'h5/* 5*/];
  assign T207 = T70 ? T211 : T208;
  assign T208 = T202 ? T155 : T209;
  assign T209 = T102 ? T210 : T123;
  assign T210 = T153[3'h5/* 5*/:3'h5/* 5*/];
  assign T211 = T46[3'h5/* 5*/:3'h5/* 5*/];
  assign T212 = T169[1'h0/* 0*/:1'h0/* 0*/];
  assign T213 = T238 ? predReg_7 : predReg_6;
  assign T214 = T215 || T70;
  assign T215 = T218 || T216;
  assign T216 = T94 && T217;
  assign T217 = T88[3'h6/* 6*/:3'h6/* 6*/];
  assign T218 = T219 || T102;
  assign T219 = T115 && T220;
  assign T220 = T111[3'h6/* 6*/:3'h6/* 6*/];
  assign T221 = T70 ? T225 : T222;
  assign T222 = T216 ? T155 : T223;
  assign T223 = T102 ? T224 : T123;
  assign T224 = T153[3'h6/* 6*/:3'h6/* 6*/];
  assign T225 = T46[3'h6/* 6*/:3'h6/* 6*/];
  assign T226 = T227 || T70;
  assign T227 = T230 || T228;
  assign T228 = T94 && T229;
  assign T229 = T88[3'h7/* 7*/:3'h7/* 7*/];
  assign T230 = T231 || T102;
  assign T231 = T115 && T232;
  assign T232 = T111[3'h7/* 7*/:3'h7/* 7*/];
  assign T233 = T70 ? T237 : T234;
  assign T234 = T228 ? T155 : T235;
  assign T235 = T102 ? T236 : T123;
  assign T236 = T153[3'h7/* 7*/:3'h7/* 7*/];
  assign T237 = T46[3'h7/* 7*/:3'h7/* 7*/];
  assign T238 = T169[1'h0/* 0*/:1'h0/* 0*/];
  assign T239 = T169[1'h1/* 1*/:1'h1/* 1*/];
  assign T240 = T169[2'h2/* 2*/:2'h2/* 2*/];
  assign T241 = T246 ^ T242;
  assign T242 = exReg_predOp_1_s1Addr[2'h3/* 3*/:2'h3/* 3*/];
  assign T243 = T244;
  assign T244 = T245;
  assign T245 = {3'h0/* 0*/, 1'h0/* 0*/};
  assign T246 = T261 ? T255 : T247;
  assign T247 = T254 ? T252 : T248;
  assign T248 = T249 ? predReg_1 : predReg_0;
  assign T249 = T250[1'h0/* 0*/:1'h0/* 0*/];
  assign T250 = T251;
  assign T251 = exReg_predOp_1_s1Addr[2'h2/* 2*/:1'h0/* 0*/];
  assign T252 = T253 ? predReg_3 : predReg_2;
  assign T253 = T250[1'h0/* 0*/:1'h0/* 0*/];
  assign T254 = T250[1'h1/* 1*/:1'h1/* 1*/];
  assign T255 = T260 ? T258 : T256;
  assign T256 = T257 ? predReg_5 : predReg_4;
  assign T257 = T250[1'h0/* 0*/:1'h0/* 0*/];
  assign T258 = T259 ? predReg_7 : predReg_6;
  assign T259 = T250[1'h0/* 0*/:1'h0/* 0*/];
  assign T260 = T250[1'h1/* 1*/:1'h1/* 1*/];
  assign T261 = T250[2'h2/* 2*/:2'h2/* 2*/];
  assign T262 = T263 == 2'b11/* 0*/;
  assign T263 = exReg_predOp_1_func;
  assign T264 = T265;
  assign T265 = T266;
  assign T266 = {1'h0/* 0*/, 1'h0/* 0*/};
  assign T267 = T241 ^ T162;
  assign T268 = T263 == 2'b10/* 0*/;
  assign T269 = T241 & T162;
  assign T270 = T263 == 2'b01/* 0*/;
  assign T271 = T241 | T162;
  assign T272 = T263 == 2'b00/* 0*/;
  assign T273 = T324 ? T312 : T274;
  assign T274 = T323 ? T322 : T275;
  assign T275 = T321 ? T317 : T276;
  assign T276 = T320 ? T316 : T277;
  assign T277 = T315 ? T313 : T278;
  assign T278 = T314 ? T311 : T279;
  assign T279 = T309 ? T280 : 1'h0/* 0*/;
  assign T280 = op_2[T281];
  assign T281 = T282;
  assign T282 = op_3[3'h4/* 4*/:1'h0/* 0*/];
  assign op_3 = T283;
  assign T283 = exReg_immOp_1 ? exReg_immVal_1 : T284;
  assign T284 = fwExReg_3_1 ? exResultDataReg_1 : T285;
  assign T285 = fwExReg_3_0 ? exResultDataReg_0 : T286;
  assign T286 = fwMemReg_3_1 ? memResultDataReg_1 : T287;
  assign T287 = fwMemReg_3_0 ? memResultDataReg_0 : exReg_rsData_3;
  assign T288 = T289;
  assign T289 = {31'h0/* 0*/, 1'h0/* 0*/};
  assign T290 = io_ena || T291;
  assign T291 = io_ena && T292;
  assign T292 = T293 && io_memResult_0_valid;
  assign T293 = io_decex_rsAddr_3 == io_memResult_0_addr;
  assign T294 = io_ena || T295;
  assign T295 = io_ena && T296;
  assign T296 = T297 && io_memResult_1_valid;
  assign T297 = io_decex_rsAddr_3 == io_memResult_1_addr;
  assign T298 = io_ena || T299;
  assign T299 = io_ena && T300;
  assign T300 = T301 && io_exResult_0_valid;
  assign T301 = io_decex_rsAddr_3 == io_exResult_0_addr;
  assign T302 = io_ena || T303;
  assign T303 = io_ena && T304;
  assign T304 = T305 && io_exResult_1_valid;
  assign T305 = io_decex_rsAddr_3 == io_exResult_1_addr;
  assign T306 = T307;
  assign T307 = {31'h0/* 0*/, 1'h0/* 0*/};
  assign T308 = 1'h0/* 0*/;
  assign T309 = T310 == 4'b0110/* 0*/;
  assign T310 = exReg_aluOp_1_func;
  assign T311 = T313 | T312;
  assign T312 = op_2 == op_3;
  assign T313 = op_2 < op_3;
  assign T314 = T310 == 4'b0101/* 0*/;
  assign T315 = T310 == 4'b0100/* 0*/;
  assign T316 = T317 | T312;
  assign T317 = $signed(T319) < $signed(T318);
  assign T318 = op_3;
  assign T319 = op_2;
  assign T320 = T310 == 4'b0011/* 0*/;
  assign T321 = T310 == 4'b0010/* 0*/;
  assign T322 = ! T312;
  assign T323 = T310 == 4'b0001/* 0*/;
  assign T324 = T310 == 4'b0000/* 0*/;
  assign T325 = T46[2'h2/* 2*/:2'h2/* 2*/];
  assign T326 = T139[1'h0/* 0*/:1'h0/* 0*/];
  assign T327 = T139[1'h1/* 1*/:1'h1/* 1*/];
  assign T328 = T333 ? T331 : T329;
  assign T329 = T330 ? predReg_5 : predReg_4;
  assign T330 = T139[1'h0/* 0*/:1'h0/* 0*/];
  assign T331 = T332 ? predReg_7 : predReg_6;
  assign T332 = T139[1'h0/* 0*/:1'h0/* 0*/];
  assign T333 = T139[1'h1/* 1*/:1'h1/* 1*/];
  assign T334 = T139[2'h2/* 2*/:2'h2/* 2*/];
  assign T335 = T338 ^ T336;
  assign T336 = exReg_predOp_0_s1Addr[2'h3/* 3*/:2'h3/* 3*/];
  assign T337 = T244;
  assign T338 = T353 ? T347 : T339;
  assign T339 = T346 ? T344 : T340;
  assign T340 = T341 ? predReg_1 : predReg_0;
  assign T341 = T342[1'h0/* 0*/:1'h0/* 0*/];
  assign T342 = T343;
  assign T343 = exReg_predOp_0_s1Addr[2'h2/* 2*/:1'h0/* 0*/];
  assign T344 = T345 ? predReg_3 : predReg_2;
  assign T345 = T342[1'h0/* 0*/:1'h0/* 0*/];
  assign T346 = T342[1'h1/* 1*/:1'h1/* 1*/];
  assign T347 = T352 ? T350 : T348;
  assign T348 = T349 ? predReg_5 : predReg_4;
  assign T349 = T342[1'h0/* 0*/:1'h0/* 0*/];
  assign T350 = T351 ? predReg_7 : predReg_6;
  assign T351 = T342[1'h0/* 0*/:1'h0/* 0*/];
  assign T352 = T342[1'h1/* 1*/:1'h1/* 1*/];
  assign T353 = T342[2'h2/* 2*/:2'h2/* 2*/];
  assign T354 = T355 == 2'b11/* 0*/;
  assign T355 = exReg_predOp_0_func;
  assign T356 = T265;
  assign T357 = T335 ^ T130;
  assign T358 = T355 == 2'b10/* 0*/;
  assign T359 = T335 & T130;
  assign T360 = T355 == 2'b01/* 0*/;
  assign T361 = T335 | T130;
  assign T362 = T355 == 2'b00/* 0*/;
  assign T363 = T413 ? T401 : T364;
  assign T364 = T412 ? T411 : T365;
  assign T365 = T410 ? T406 : T366;
  assign T366 = T409 ? T405 : T367;
  assign T367 = T404 ? T402 : T368;
  assign T368 = T403 ? T400 : T369;
  assign T369 = T398 ? T370 : 1'h0/* 0*/;
  assign T370 = op_0[T371];
  assign T371 = T372;
  assign T372 = op_1[3'h4/* 4*/:1'h0/* 0*/];
  assign op_1 = T373;
  assign T373 = exReg_immOp_0 ? exReg_immVal_0 : T374;
  assign T374 = fwExReg_1_1 ? exResultDataReg_1 : T375;
  assign T375 = fwExReg_1_0 ? exResultDataReg_0 : T376;
  assign T376 = fwMemReg_1_1 ? memResultDataReg_1 : T377;
  assign T377 = fwMemReg_1_0 ? memResultDataReg_0 : exReg_rsData_1;
  assign T378 = T379;
  assign T379 = {31'h0/* 0*/, 1'h0/* 0*/};
  assign T380 = io_ena || T381;
  assign T381 = io_ena && T382;
  assign T382 = T383 && io_memResult_0_valid;
  assign T383 = io_decex_rsAddr_1 == io_memResult_0_addr;
  assign T384 = io_ena || T385;
  assign T385 = io_ena && T386;
  assign T386 = T387 && io_memResult_1_valid;
  assign T387 = io_decex_rsAddr_1 == io_memResult_1_addr;
  assign T388 = io_ena || T389;
  assign T389 = io_ena && T390;
  assign T390 = T391 && io_exResult_0_valid;
  assign T391 = io_decex_rsAddr_1 == io_exResult_0_addr;
  assign T392 = io_ena || T393;
  assign T393 = io_ena && T394;
  assign T394 = T395 && io_exResult_1_valid;
  assign T395 = io_decex_rsAddr_1 == io_exResult_1_addr;
  assign T396 = T397;
  assign T397 = {31'h0/* 0*/, 1'h0/* 0*/};
  assign T398 = T399 == 4'b0110/* 0*/;
  assign T399 = exReg_aluOp_0_func;
  assign T400 = T402 | T401;
  assign T401 = op_0 == op_1;
  assign T402 = op_0 < op_1;
  assign T403 = T399 == 4'b0101/* 0*/;
  assign T404 = T399 == 4'b0100/* 0*/;
  assign T405 = T406 | T401;
  assign T406 = $signed(T408) < $signed(T407);
  assign T407 = op_1;
  assign T408 = op_0;
  assign T409 = T399 == 4'b0011/* 0*/;
  assign T410 = T399 == 4'b0010/* 0*/;
  assign T411 = ! T401;
  assign T412 = T399 == 4'b0001/* 0*/;
  assign T413 = T399 == 4'b0000/* 0*/;
  assign T414 = T153[1'h1/* 1*/:1'h1/* 1*/];
  assign T415 = T46[1'h1/* 1*/:1'h1/* 1*/];
  assign T416 = T417[1'h0/* 0*/:1'h0/* 0*/];
  assign T417 = T418;
  assign T418 = exReg_pred_1[2'h2/* 2*/:1'h0/* 0*/];
  assign T419 = T420 ? predReg_3 : predReg_2;
  assign T420 = T417[1'h0/* 0*/:1'h0/* 0*/];
  assign T421 = T417[1'h1/* 1*/:1'h1/* 1*/];
  assign T422 = T427 ? T425 : T423;
  assign T423 = T424 ? predReg_5 : predReg_4;
  assign T424 = T417[1'h0/* 0*/:1'h0/* 0*/];
  assign T425 = T426 ? predReg_7 : predReg_6;
  assign T426 = T417[1'h0/* 0*/:1'h0/* 0*/];
  assign T427 = T417[1'h1/* 1*/:1'h1/* 1*/];
  assign T428 = T417[2'h2/* 2*/:2'h2/* 2*/];
  assign T429 = T108;
  assign T430 = T431[1'h0/* 0*/:1'h0/* 0*/];
  assign T431 = T432;
  assign T432 = exReg_pred_0[2'h2/* 2*/:1'h0/* 0*/];
  assign T433 = T434 ? predReg_3 : predReg_2;
  assign T434 = T431[1'h0/* 0*/:1'h0/* 0*/];
  assign T435 = T431[1'h1/* 1*/:1'h1/* 1*/];
  assign T436 = T441 ? T439 : T437;
  assign T437 = T438 ? predReg_5 : predReg_4;
  assign T438 = T431[1'h0/* 0*/:1'h0/* 0*/];
  assign T439 = T440 ? predReg_7 : predReg_6;
  assign T440 = T431[1'h0/* 0*/:1'h0/* 0*/];
  assign T441 = T431[1'h1/* 1*/:1'h1/* 1*/];
  assign T442 = T431[2'h2/* 2*/:2'h2/* 2*/];
  assign T443 = T444;
  assign T444 = 1'h0/* 0*/;
  assign io_exmcache_callRetAddr = T445;
  assign T445 = {2'h0/* 0*/, T446};
  assign T446 = io_exmem_mem_callRetAddr[5'h1f/* 31*/:2'h2/* 2*/];
  assign io_exmcache_callRetBase = T447;
  assign T447 = {2'h0/* 0*/, T448};
  assign T448 = io_exmem_mem_callRetBase[5'h1f/* 31*/:2'h2/* 2*/];
  assign io_exmcache_doCallRet = T449;
  assign T449 = T450 && doExecute_0;
  assign T450 = T452 || exReg_brcf;
  assign T451 = 1'h0/* 0*/;
  assign T452 = exReg_call || exReg_ret;
  assign T453 = 1'h0/* 0*/;
  assign T454 = 1'h0/* 0*/;
  assign io_exmem_pc = exReg_pc;
  assign T455 = T456;
  assign T456 = {29'h0/* 0*/, 1'h0/* 0*/};
  assign io_exmem_mem_callRetBase = T457;
  assign T457 = exReg_call ? callAddr : T458;
  assign T458 = exReg_brcf ? brcfAddr : T459;
  assign T459 = op_0;
  assign brcfAddr = exReg_immOp_0 ? exReg_brcfAddr : T460;
  assign T460 = op_0;
  assign T461 = T462;
  assign T462 = {31'h0/* 0*/, 1'h0/* 0*/};
  assign callAddr = exReg_immOp_0 ? exReg_callAddr : T463;
  assign T463 = op_0;
  assign T464 = T465;
  assign T465 = {31'h0/* 0*/, 1'h0/* 0*/};
  assign io_exmem_mem_callRetAddr = T466;
  assign T466 = T469 ? T468 : T467;
  assign T467 = op_1;
  assign T468 = {31'h0/* 0*/, 1'h0/* 0*/};
  assign T469 = exReg_call || exReg_brcf;
  assign io_exmem_mem_brcf = T470;
  assign T470 = exReg_brcf && doExecute_0;
  assign io_exmem_mem_ret = T471;
  assign T471 = exReg_ret && doExecute_0;
  assign io_exmem_mem_call = T472;
  assign T472 = exReg_call && doExecute_0;
  assign io_exmem_mem_data = op_1;
  assign io_exmem_mem_addr = T473;
  assign T473 = op_0 + exReg_immVal_0;
  assign io_exmem_mem_typ = exReg_memOp_typ;
  assign T474 = T475;
  assign T475 = T476;
  assign T476 = {1'h0/* 0*/, 1'h0/* 0*/};
  assign io_exmem_mem_zext = exReg_memOp_zext;
  assign T477 = T478;
  assign T478 = 1'h0/* 0*/;
  assign io_exmem_mem_byte = exReg_memOp_byte;
  assign T479 = T480;
  assign T480 = 1'h0/* 0*/;
  assign io_exmem_mem_hword = exReg_memOp_hword;
  assign T481 = T482;
  assign T482 = 1'h0/* 0*/;
  assign io_exmem_mem_store = T483;
  assign T483 = exReg_memOp_store && doExecute_0;
  assign T484 = T485;
  assign T485 = 1'h0/* 0*/;
  assign io_exmem_mem_load = T486;
  assign T486 = exReg_memOp_load && doExecute_0;
  assign T487 = T488;
  assign T488 = 1'h0/* 0*/;
  assign io_exmem_rd_1_valid = T489;
  assign T489 = exReg_wrRd_1 && doExecute_1;
  assign T490 = 1'h0/* 0*/;
  assign io_exmem_rd_1_data = T491;
  assign T491 = exReg_aluOp_1_isMFS ? T552 : T492;
  assign T492 = T493;
  assign T493 = T494[5'h1f/* 31*/:1'h0/* 0*/];
  assign T494 = T551 ? T550 : T495;
  assign T495 = T549 ? T548 : T496;
  assign T496 = T547 ? T543 : T497;
  assign T497 = T542 ? T539 : T498;
  assign T498 = T538 ? T535 : T499;
  assign T499 = T534 ? T530 : T500;
  assign T500 = T529 ? T526 : T501;
  assign T501 = T525 ? T521 : T502;
  assign T502 = {28'h0/* 0*/, T503};
  assign T503 = T520 ? T517 : T504;
  assign T504 = T516 ? T514 : T505;
  assign T505 = T513 ? T506 : T506;
  assign T506 = T508 + T507;
  assign T507 = {3'h0/* 0*/, op_3};
  assign T508 = op_2 << T509;
  assign T509 = T512 ? 2'h2/* 2*/ : T510;
  assign T510 = {1'h0/* 0*/, T511};
  assign T511 = exReg_aluOp_1_func == 4'b1100/* 0*/;
  assign T512 = exReg_aluOp_1_func == 4'b1101/* 0*/;
  assign T513 = exReg_aluOp_1_func == 4'b0000/* 0*/;
  assign T514 = {3'h0/* 0*/, T515};
  assign T515 = op_2 - op_3;
  assign T516 = exReg_aluOp_1_func == 4'b0001/* 0*/;
  assign T517 = {3'h0/* 0*/, T518};
  assign T518 = T519;
  assign T519 = op_2 ^ op_3;
  assign T520 = exReg_aluOp_1_func == 4'b0010/* 0*/;
  assign T521 = T522;
  assign T522 = op_2 << T523;
  assign T523 = T524;
  assign T524 = op_3[3'h4/* 4*/:1'h0/* 0*/];
  assign T525 = exReg_aluOp_1_func == 4'b0011/* 0*/;
  assign T526 = {31'h0/* 0*/, T527};
  assign T527 = T528;
  assign T528 = op_2 >> T523;
  assign T529 = exReg_aluOp_1_func == 4'b0100/* 0*/;
  assign T530 = {31'h0/* 0*/, T531};
  assign T531 = T532;
  assign T532 = $signed(T533) >>> T523;
  assign T533 = op_2;
  assign T534 = exReg_aluOp_1_func == 4'b0101/* 0*/;
  assign T535 = {31'h0/* 0*/, T536};
  assign T536 = T537;
  assign T537 = op_2 | op_3;
  assign T538 = exReg_aluOp_1_func == 4'b0110/* 0*/;
  assign T539 = {31'h0/* 0*/, T540};
  assign T540 = T541;
  assign T541 = op_2 & op_3;
  assign T542 = exReg_aluOp_1_func == 4'b0111/* 0*/;
  assign T543 = {31'h0/* 0*/, T544};
  assign T544 = T545;
  assign T545 = ~ T546;
  assign T546 = op_2 | op_3;
  assign T547 = exReg_aluOp_1_func == 4'b1011/* 0*/;
  assign T548 = {28'h0/* 0*/, T506};
  assign T549 = exReg_aluOp_1_func == 4'b1100/* 0*/;
  assign T550 = {28'h0/* 0*/, T506};
  assign T551 = exReg_aluOp_1_func == 4'b1101/* 0*/;
  assign T552 = T553;
  assign T553 = T687 ? stackSpillReg : T554;
  assign T554 = T678 ? stackTopReg : T555;
  assign T555 = T656 ? mulHiReg : T556;
  assign T556 = T644 ? mulLoReg : T557;
  assign T557 = T569 ? T558 : 32'h0/* 0*/;
  assign T558 = T559;
  assign T559 = {24'h0/* 0*/, T560};
  assign T560 = {T568, T567, T566, T565, T564, T563, T562, T561};
  assign T561 = predReg_0;
  assign T562 = predReg_1;
  assign T563 = predReg_2;
  assign T564 = predReg_3;
  assign T565 = predReg_4;
  assign T566 = predReg_5;
  assign T567 = predReg_6;
  assign T568 = predReg_7;
  assign T569 = exReg_aluOp_1_func == 4'b0000/* 0*/;
  assign T570 = T573 || T571;
  assign T571 = T75 && T572;
  assign T572 = exReg_aluOp_1_func == 4'b0010/* 0*/;
  assign T573 = T576 || T574;
  assign T574 = T105 && T575;
  assign T575 = exReg_aluOp_0_func == 4'b0010/* 0*/;
  assign T576 = io_ena && mulPipeReg;
  assign T577 = exReg_aluOp_0_isMul && doExecute_0;
  assign T578 = T579;
  assign T579 = 1'h0/* 0*/;
  assign T580 = T571 ? T643 : T581;
  assign T581 = T574 ? T642 : T582;
  assign T582 = T583[5'h1f/* 31*/:1'h0/* 0*/];
  assign T583 = T604 + T584;
  assign T584 = {T602, mulLHReg, 16'h0/* 0*/};
  assign T585 = io_ena || T586;
  assign T586 = io_ena && T587;
  assign T587 = exReg_aluOp_0_func == 4'b0000/* 0*/;
  assign T588 = T586 ? T594 : T589;
  assign T589 = T592 * T590;
  assign T590 = T591;
  assign T591 = op_1[5'h1f/* 31*/:5'h10/* 16*/];
  assign T592 = T593;
  assign T593 = op_0[4'hf/* 15*/:1'h0/* 0*/];
  assign T594 = T595[5'h1f/* 31*/:1'h0/* 0*/];
  assign T595 = T596;
  assign T596 = T601 * T597;
  assign T597 = {T599, T598};
  assign T598 = T591;
  assign T599 = {5'h10/* 16*/{T600}};
  assign T600 = T591[4'hf/* 15*/:4'hf/* 15*/];
  assign T601 = T593;
  assign T602 = {5'h10/* 16*/{T603}};
  assign T603 = mulLHReg[5'h1f/* 31*/:5'h1f/* 31*/];
  assign T604 = T623 + T605;
  assign T605 = {T621, mulHLReg, 16'h0/* 0*/};
  assign T606 = io_ena || T586;
  assign T607 = T586 ? T613 : T608;
  assign T608 = T611 * T609;
  assign T609 = T610;
  assign T610 = op_1[4'hf/* 15*/:1'h0/* 0*/];
  assign T611 = T612;
  assign T612 = op_0[5'h1f/* 31*/:5'h10/* 16*/];
  assign T613 = T614[5'h1f/* 31*/:1'h0/* 0*/];
  assign T614 = T615;
  assign T615 = T617 * T616;
  assign T616 = T610;
  assign T617 = {T619, T618};
  assign T618 = T612;
  assign T619 = {5'h10/* 16*/{T620}};
  assign T620 = T612[4'hf/* 15*/:4'hf/* 15*/];
  assign T621 = {5'h10/* 16*/{T622}};
  assign T622 = mulHLReg[5'h1f/* 31*/:5'h1f/* 31*/];
  assign T623 = {mulHHReg, mulLLReg};
  assign T624 = io_ena || T586;
  assign T625 = T586 ? T629 : T626;
  assign T626 = T628 * T627;
  assign T627 = T610;
  assign T628 = T593;
  assign T629 = T630[5'h1f/* 31*/:1'h0/* 0*/];
  assign T630 = T631;
  assign T631 = T633 * T632;
  assign T632 = T610;
  assign T633 = T593;
  assign T634 = io_ena || T586;
  assign T635 = T586 ? T639 : T636;
  assign T636 = T638 * T637;
  assign T637 = T591;
  assign T638 = T612;
  assign T639 = T640[5'h1f/* 31*/:1'h0/* 0*/];
  assign T640 = T641;
  assign T641 = T617 * T597;
  assign T642 = op_0;
  assign T643 = op_2;
  assign T644 = exReg_aluOp_1_func == 4'b0010/* 0*/;
  assign T645 = T648 || T646;
  assign T646 = T75 && T647;
  assign T647 = exReg_aluOp_1_func == 4'b0011/* 0*/;
  assign T648 = T576 || T649;
  assign T649 = T105 && T650;
  assign T650 = exReg_aluOp_0_func == 4'b0011/* 0*/;
  assign T651 = T646 ? T655 : T652;
  assign T652 = T649 ? T654 : T653;
  assign T653 = T583[6'h3f/* 63*/:6'h20/* 32*/];
  assign T654 = op_0;
  assign T655 = op_2;
  assign T656 = exReg_aluOp_1_func == 4'b0011/* 0*/;
  assign T657 = T660 || T658;
  assign T658 = T75 && T659;
  assign T659 = exReg_aluOp_1_func == 4'b0110/* 0*/;
  assign T660 = T665 || T661;
  assign T661 = T662 && io_ena;
  assign T662 = exReg_aluOp_1_isSTC && doExecute_1;
  assign T663 = T664;
  assign T664 = 1'h0/* 0*/;
  assign T665 = T668 || T666;
  assign T666 = T105 && T667;
  assign T667 = exReg_aluOp_0_func == 4'b0110/* 0*/;
  assign T668 = T669 && io_ena;
  assign T669 = exReg_aluOp_0_isSTC && doExecute_0;
  assign T670 = T664;
  assign T671 = T658 ? T677 : T672;
  assign T672 = T661 ? T676 : T673;
  assign T673 = T666 ? T675 : T674;
  assign T674 = op_1;
  assign T675 = op_0;
  assign T676 = op_3;
  assign T677 = op_2;
  assign T678 = exReg_aluOp_1_func == 4'b0110/* 0*/;
  assign T679 = T682 || T680;
  assign T680 = T75 && T681;
  assign T681 = exReg_aluOp_1_func == 4'b0101/* 0*/;
  assign T682 = T105 && T683;
  assign T683 = exReg_aluOp_0_func == 4'b0101/* 0*/;
  assign T684 = T680 ? T686 : T685;
  assign T685 = op_0;
  assign T686 = op_2;
  assign T687 = exReg_aluOp_1_func == 4'b0101/* 0*/;
  assign T688 = T689;
  assign T689 = 1'h0/* 0*/;
  assign io_exmem_rd_1_addr = exReg_rdAddr_1;
  assign T690 = T691;
  assign T691 = {4'h0/* 0*/, 1'h0/* 0*/};
  assign io_exmem_rd_0_valid = T692;
  assign T692 = exReg_wrRd_0 && doExecute_0;
  assign T693 = 1'h0/* 0*/;
  assign io_exmem_rd_0_data = T694;
  assign T694 = exReg_aluOp_0_isMFS ? T755 : T695;
  assign T695 = T696;
  assign T696 = T697[5'h1f/* 31*/:1'h0/* 0*/];
  assign T697 = T754 ? T753 : T698;
  assign T698 = T752 ? T751 : T699;
  assign T699 = T750 ? T746 : T700;
  assign T700 = T745 ? T742 : T701;
  assign T701 = T741 ? T738 : T702;
  assign T702 = T737 ? T733 : T703;
  assign T703 = T732 ? T729 : T704;
  assign T704 = T728 ? T724 : T705;
  assign T705 = {28'h0/* 0*/, T706};
  assign T706 = T723 ? T720 : T707;
  assign T707 = T719 ? T717 : T708;
  assign T708 = T716 ? T709 : T709;
  assign T709 = T711 + T710;
  assign T710 = {3'h0/* 0*/, op_1};
  assign T711 = op_0 << T712;
  assign T712 = T715 ? 2'h2/* 2*/ : T713;
  assign T713 = {1'h0/* 0*/, T714};
  assign T714 = exReg_aluOp_0_func == 4'b1100/* 0*/;
  assign T715 = exReg_aluOp_0_func == 4'b1101/* 0*/;
  assign T716 = exReg_aluOp_0_func == 4'b0000/* 0*/;
  assign T717 = {3'h0/* 0*/, T718};
  assign T718 = op_0 - op_1;
  assign T719 = exReg_aluOp_0_func == 4'b0001/* 0*/;
  assign T720 = {3'h0/* 0*/, T721};
  assign T721 = T722;
  assign T722 = op_0 ^ op_1;
  assign T723 = exReg_aluOp_0_func == 4'b0010/* 0*/;
  assign T724 = T725;
  assign T725 = op_0 << T726;
  assign T726 = T727;
  assign T727 = op_1[3'h4/* 4*/:1'h0/* 0*/];
  assign T728 = exReg_aluOp_0_func == 4'b0011/* 0*/;
  assign T729 = {31'h0/* 0*/, T730};
  assign T730 = T731;
  assign T731 = op_0 >> T726;
  assign T732 = exReg_aluOp_0_func == 4'b0100/* 0*/;
  assign T733 = {31'h0/* 0*/, T734};
  assign T734 = T735;
  assign T735 = $signed(T736) >>> T726;
  assign T736 = op_0;
  assign T737 = exReg_aluOp_0_func == 4'b0101/* 0*/;
  assign T738 = {31'h0/* 0*/, T739};
  assign T739 = T740;
  assign T740 = op_0 | op_1;
  assign T741 = exReg_aluOp_0_func == 4'b0110/* 0*/;
  assign T742 = {31'h0/* 0*/, T743};
  assign T743 = T744;
  assign T744 = op_0 & op_1;
  assign T745 = exReg_aluOp_0_func == 4'b0111/* 0*/;
  assign T746 = {31'h0/* 0*/, T747};
  assign T747 = T748;
  assign T748 = ~ T749;
  assign T749 = op_0 | op_1;
  assign T750 = exReg_aluOp_0_func == 4'b1011/* 0*/;
  assign T751 = {28'h0/* 0*/, T709};
  assign T752 = exReg_aluOp_0_func == 4'b1100/* 0*/;
  assign T753 = {28'h0/* 0*/, T709};
  assign T754 = exReg_aluOp_0_func == 4'b1101/* 0*/;
  assign T755 = T756;
  assign T756 = T776 ? stackSpillReg : T757;
  assign T757 = T775 ? stackTopReg : T758;
  assign T758 = T774 ? mulHiReg : T759;
  assign T759 = T773 ? mulLoReg : T760;
  assign T760 = T772 ? T761 : 32'h0/* 0*/;
  assign T761 = T762;
  assign T762 = {24'h0/* 0*/, T763};
  assign T763 = {T771, T770, T769, T768, T767, T766, T765, T764};
  assign T764 = predReg_0;
  assign T765 = predReg_1;
  assign T766 = predReg_2;
  assign T767 = predReg_3;
  assign T768 = predReg_4;
  assign T769 = predReg_5;
  assign T770 = predReg_6;
  assign T771 = predReg_7;
  assign T772 = exReg_aluOp_0_func == 4'b0000/* 0*/;
  assign T773 = exReg_aluOp_0_func == 4'b0010/* 0*/;
  assign T774 = exReg_aluOp_0_func == 4'b0011/* 0*/;
  assign T775 = exReg_aluOp_0_func == 4'b0110/* 0*/;
  assign T776 = exReg_aluOp_0_func == 4'b0101/* 0*/;
  assign T777 = T689;
  assign io_exmem_rd_0_addr = exReg_rdAddr_0;
  assign T778 = T779;
  assign T779 = {4'h0/* 0*/, 1'h0/* 0*/};
  assign io_exdec_sp = T780;
  assign T780 = T791 ? T790 : T781;
  assign T781 = T662 ? T789 : T782;
  assign T782 = T786 ? T785 : T783;
  assign T783 = T669 ? T784 : stackTopReg;
  assign T784 = op_1;
  assign T785 = op_0;
  assign T786 = T788 && T787;
  assign T787 = exReg_aluOp_0_func == 4'b0110/* 0*/;
  assign T788 = exReg_aluOp_0_isMTS && doExecute_0;
  assign T789 = op_3;
  assign T790 = op_2;
  assign T791 = T793 && T792;
  assign T792 = exReg_aluOp_1_func == 4'b0110/* 0*/;
  assign T793 = exReg_aluOp_1_isMTS && doExecute_1;

  always @(posedge clk) begin
    if(reset) begin
      exReg_jmpOp_reloc <= T2;
    end else if(io_ena) begin
      exReg_jmpOp_reloc <= io_decex_jmpOp_reloc;
    end
    if(reset) begin
      exReg_rsData_0 <= T12;
    end else if(io_ena) begin
      exReg_rsData_0 <= io_decex_rsData_0;
    end
    if(io_ena) begin
      memResultDataReg_0 <= io_memResult_0_data;
    end
    if(reset) begin
      fwMemReg_0_0 <= 1'h0/* 0*/;
    end else if(T14) begin
      fwMemReg_0_0 <= T15;
    end
    if(io_ena) begin
      memResultDataReg_1 <= io_memResult_1_data;
    end
    if(reset) begin
      fwMemReg_0_1 <= 1'h0/* 0*/;
    end else if(T18) begin
      fwMemReg_0_1 <= T19;
    end
    if(io_ena) begin
      exResultDataReg_0 <= io_exResult_0_data;
    end
    if(reset) begin
      fwExReg_0_0 <= 1'h0/* 0*/;
    end else if(T22) begin
      fwExReg_0_0 <= T23;
    end
    if(io_ena) begin
      exResultDataReg_1 <= io_exResult_1_data;
    end
    if(reset) begin
      fwExReg_0_1 <= 1'h0/* 0*/;
    end else if(T26) begin
      fwExReg_0_1 <= T27;
    end
    if(reset) begin
      exReg_jmpOp_target <= T31;
    end else if(io_ena) begin
      exReg_jmpOp_target <= io_decex_jmpOp_target;
    end
    if(reset) begin
      exReg_immOp_0 <= T34;
    end else if(io_ena) begin
      exReg_immOp_0 <= io_decex_immOp_0;
    end
    if(reset) begin
      exReg_pred_0 <= T38;
    end else if(io_ena) begin
      exReg_pred_0 <= io_decex_pred_0;
    end
    predReg_0 <= reset ? 1'h0/* 0*/ : T43;
    if(reset) begin
      exReg_rsData_2 <= T52;
    end else if(io_ena) begin
      exReg_rsData_2 <= io_decex_rsData_2;
    end
    if(reset) begin
      fwMemReg_2_0 <= 1'h0/* 0*/;
    end else if(T54) begin
      fwMemReg_2_0 <= T55;
    end
    if(reset) begin
      fwMemReg_2_1 <= 1'h0/* 0*/;
    end else if(T58) begin
      fwMemReg_2_1 <= T59;
    end
    if(reset) begin
      fwExReg_2_0 <= 1'h0/* 0*/;
    end else if(T62) begin
      fwExReg_2_0 <= T63;
    end
    if(reset) begin
      fwExReg_2_1 <= 1'h0/* 0*/;
    end else if(T66) begin
      fwExReg_2_1 <= T67;
    end
    if(reset) begin
      exReg_aluOp_1_func <= T72;
    end else if(io_ena) begin
      exReg_aluOp_1_func <= io_decex_aluOp_1_func;
    end
    if(reset) begin
      exReg_pred_1 <= T79;
    end else if(io_ena) begin
      exReg_pred_1 <= io_decex_pred_1;
    end
    if(reset) begin
      predReg_1 <= 1'h0/* 0*/;
    end else if(T84) begin
      predReg_1 <= T120;
    end
    if(reset) begin
      exReg_predOp_1_dest <= T91;
    end else if(io_ena) begin
      exReg_predOp_1_dest <= io_decex_predOp_1_dest;
    end
    if(reset) begin
      exReg_aluOp_1_isPred <= T97;
    end else if(io_ena) begin
      exReg_aluOp_1_isPred <= io_decex_aluOp_1_isPred;
    end
    if(reset) begin
      exReg_aluOp_1_isCmp <= T99;
    end else if(io_ena) begin
      exReg_aluOp_1_isCmp <= io_decex_aluOp_1_isCmp;
    end
    if(reset) begin
      exReg_aluOp_0_func <= T104;
    end else if(io_ena) begin
      exReg_aluOp_0_func <= io_decex_aluOp_0_func;
    end
    if(reset) begin
      exReg_aluOp_0_isMTS <= T107;
    end else if(io_ena) begin
      exReg_aluOp_0_isMTS <= io_decex_aluOp_0_isMTS;
    end
    if(reset) begin
      exReg_predOp_0_dest <= T114;
    end else if(io_ena) begin
      exReg_predOp_0_dest <= io_decex_predOp_0_dest;
    end
    if(reset) begin
      exReg_aluOp_0_isPred <= T118;
    end else if(io_ena) begin
      exReg_aluOp_0_isPred <= io_decex_aluOp_0_isPred;
    end
    if(reset) begin
      exReg_aluOp_0_isCmp <= T119;
    end else if(io_ena) begin
      exReg_aluOp_0_isCmp <= io_decex_aluOp_0_isCmp;
    end
    if(reset) begin
      exReg_predOp_0_s2Addr <= T132;
    end else if(io_ena) begin
      exReg_predOp_0_s2Addr <= io_decex_predOp_0_s2Addr;
    end
    if(reset) begin
      predReg_2 <= 1'h0/* 0*/;
    end else if(T142) begin
      predReg_2 <= T149;
    end
    if(reset) begin
      exReg_predOp_1_s2Addr <= T164;
    end else if(io_ena) begin
      exReg_predOp_1_s2Addr <= io_decex_predOp_1_s2Addr;
    end
    if(reset) begin
      predReg_3 <= 1'h0/* 0*/;
    end else if(T172) begin
      predReg_3 <= T179;
    end
    if(reset) begin
      predReg_4 <= 1'h0/* 0*/;
    end else if(T188) begin
      predReg_4 <= T195;
    end
    if(reset) begin
      predReg_5 <= 1'h0/* 0*/;
    end else if(T200) begin
      predReg_5 <= T207;
    end
    if(reset) begin
      predReg_6 <= 1'h0/* 0*/;
    end else if(T214) begin
      predReg_6 <= T221;
    end
    if(reset) begin
      predReg_7 <= 1'h0/* 0*/;
    end else if(T226) begin
      predReg_7 <= T233;
    end
    if(reset) begin
      exReg_predOp_1_s1Addr <= T243;
    end else if(io_ena) begin
      exReg_predOp_1_s1Addr <= io_decex_predOp_1_s1Addr;
    end
    if(reset) begin
      exReg_predOp_1_func <= T264;
    end else if(io_ena) begin
      exReg_predOp_1_func <= io_decex_predOp_1_func;
    end
    if(reset) begin
      exReg_rsData_3 <= T288;
    end else if(io_ena) begin
      exReg_rsData_3 <= io_decex_rsData_3;
    end
    if(reset) begin
      fwMemReg_3_0 <= 1'h0/* 0*/;
    end else if(T290) begin
      fwMemReg_3_0 <= T291;
    end
    if(reset) begin
      fwMemReg_3_1 <= 1'h0/* 0*/;
    end else if(T294) begin
      fwMemReg_3_1 <= T295;
    end
    if(reset) begin
      fwExReg_3_0 <= 1'h0/* 0*/;
    end else if(T298) begin
      fwExReg_3_0 <= T299;
    end
    if(reset) begin
      fwExReg_3_1 <= 1'h0/* 0*/;
    end else if(T302) begin
      fwExReg_3_1 <= T303;
    end
    if(reset) begin
      exReg_immVal_1 <= T306;
    end else if(io_ena) begin
      exReg_immVal_1 <= io_decex_immVal_1;
    end
    if(reset) begin
      exReg_immOp_1 <= T308;
    end else if(io_ena) begin
      exReg_immOp_1 <= io_decex_immOp_1;
    end
    if(reset) begin
      exReg_predOp_0_s1Addr <= T337;
    end else if(io_ena) begin
      exReg_predOp_0_s1Addr <= io_decex_predOp_0_s1Addr;
    end
    if(reset) begin
      exReg_predOp_0_func <= T356;
    end else if(io_ena) begin
      exReg_predOp_0_func <= io_decex_predOp_0_func;
    end
    if(reset) begin
      exReg_rsData_1 <= T378;
    end else if(io_ena) begin
      exReg_rsData_1 <= io_decex_rsData_1;
    end
    if(reset) begin
      fwMemReg_1_0 <= 1'h0/* 0*/;
    end else if(T380) begin
      fwMemReg_1_0 <= T381;
    end
    if(reset) begin
      fwMemReg_1_1 <= 1'h0/* 0*/;
    end else if(T384) begin
      fwMemReg_1_1 <= T385;
    end
    if(reset) begin
      fwExReg_1_0 <= 1'h0/* 0*/;
    end else if(T388) begin
      fwExReg_1_0 <= T389;
    end
    if(reset) begin
      fwExReg_1_1 <= 1'h0/* 0*/;
    end else if(T392) begin
      fwExReg_1_1 <= T393;
    end
    if(reset) begin
      exReg_immVal_0 <= T396;
    end else if(io_ena) begin
      exReg_immVal_0 <= io_decex_immVal_0;
    end
    if(reset) begin
      exReg_aluOp_1_isMTS <= T429;
    end else if(io_ena) begin
      exReg_aluOp_1_isMTS <= io_decex_aluOp_1_isMTS;
    end
    if(reset) begin
      exReg_jmpOp_branch <= T443;
    end else if(io_ena) begin
      exReg_jmpOp_branch <= io_decex_jmpOp_branch;
    end
    if(reset) begin
      exReg_brcf <= T451;
    end else if(io_ena) begin
      exReg_brcf <= io_decex_brcf;
    end
    if(reset) begin
      exReg_ret <= T453;
    end else if(io_ena) begin
      exReg_ret <= io_decex_ret;
    end
    if(reset) begin
      exReg_call <= T454;
    end else if(io_ena) begin
      exReg_call <= io_decex_call;
    end
    if(reset) begin
      exReg_pc <= T455;
    end else if(io_ena) begin
      exReg_pc <= io_decex_pc;
    end
    if(reset) begin
      exReg_brcfAddr <= T461;
    end else if(io_ena) begin
      exReg_brcfAddr <= io_decex_brcfAddr;
    end
    if(reset) begin
      exReg_callAddr <= T464;
    end else if(io_ena) begin
      exReg_callAddr <= io_decex_callAddr;
    end
    if(reset) begin
      exReg_memOp_typ <= T474;
    end else if(io_ena) begin
      exReg_memOp_typ <= io_decex_memOp_typ;
    end
    if(reset) begin
      exReg_memOp_zext <= T477;
    end else if(io_ena) begin
      exReg_memOp_zext <= io_decex_memOp_zext;
    end
    if(reset) begin
      exReg_memOp_byte <= T479;
    end else if(io_ena) begin
      exReg_memOp_byte <= io_decex_memOp_byte;
    end
    if(reset) begin
      exReg_memOp_hword <= T481;
    end else if(io_ena) begin
      exReg_memOp_hword <= io_decex_memOp_hword;
    end
    if(reset) begin
      exReg_memOp_store <= T484;
    end else if(io_ena) begin
      exReg_memOp_store <= io_decex_memOp_store;
    end
    if(reset) begin
      exReg_memOp_load <= T487;
    end else if(io_ena) begin
      exReg_memOp_load <= io_decex_memOp_load;
    end
    if(reset) begin
      exReg_wrRd_1 <= T490;
    end else if(io_ena) begin
      exReg_wrRd_1 <= io_decex_wrRd_1;
    end
    if(reset) begin
      mulLoReg <= 32'h0/* 0*/;
    end else if(T570) begin
      mulLoReg <= T580;
    end
    if(reset) begin
      mulPipeReg <= 1'h0/* 0*/;
    end else if(io_ena) begin
      mulPipeReg <= T577;
    end
    if(reset) begin
      exReg_aluOp_0_isMul <= T578;
    end else if(io_ena) begin
      exReg_aluOp_0_isMul <= io_decex_aluOp_0_isMul;
    end
    if(reset) begin
      mulLHReg <= 32'h0/* 0*/;
    end else if(T585) begin
      mulLHReg <= T588;
    end
    if(reset) begin
      mulHLReg <= 32'h0/* 0*/;
    end else if(T606) begin
      mulHLReg <= T607;
    end
    if(reset) begin
      mulLLReg <= 32'h0/* 0*/;
    end else if(T624) begin
      mulLLReg <= T625;
    end
    if(reset) begin
      mulHHReg <= 32'h0/* 0*/;
    end else if(T634) begin
      mulHHReg <= T635;
    end
    if(reset) begin
      mulHiReg <= 32'h0/* 0*/;
    end else if(T645) begin
      mulHiReg <= T651;
    end
    if(reset) begin
      stackTopReg <= 32'h0/* 0*/;
    end else if(T657) begin
      stackTopReg <= T671;
    end
    if(reset) begin
      exReg_aluOp_1_isSTC <= T663;
    end else if(io_ena) begin
      exReg_aluOp_1_isSTC <= io_decex_aluOp_1_isSTC;
    end
    if(reset) begin
      exReg_aluOp_0_isSTC <= T670;
    end else if(io_ena) begin
      exReg_aluOp_0_isSTC <= io_decex_aluOp_0_isSTC;
    end
    if(reset) begin
      stackSpillReg <= 32'h0/* 0*/;
    end else if(T679) begin
      stackSpillReg <= T684;
    end
    if(reset) begin
      exReg_aluOp_1_isMFS <= T688;
    end else if(io_ena) begin
      exReg_aluOp_1_isMFS <= io_decex_aluOp_1_isMFS;
    end
    if(reset) begin
      exReg_rdAddr_1 <= T690;
    end else if(io_ena) begin
      exReg_rdAddr_1 <= io_decex_rdAddr_1;
    end
    if(reset) begin
      exReg_wrRd_0 <= T693;
    end else if(io_ena) begin
      exReg_wrRd_0 <= io_decex_wrRd_0;
    end
    if(reset) begin
      exReg_aluOp_0_isMFS <= T777;
    end else if(io_ena) begin
      exReg_aluOp_0_isMFS <= io_decex_aluOp_0_isMFS;
    end
    if(reset) begin
      exReg_rdAddr_0 <= T778;
    end else if(io_ena) begin
      exReg_rdAddr_0 <= io_decex_rdAddr_0;
    end
  end
endmodule

module Memory(input clk, input reset,
    output io_ena_out,
    input  io_ena_in,
    input [4:0] io_exmem_rd_0_addr,
    input [31:0] io_exmem_rd_0_data,
    input  io_exmem_rd_0_valid,
    input [4:0] io_exmem_rd_1_addr,
    input [31:0] io_exmem_rd_1_data,
    input  io_exmem_rd_1_valid,
    input  io_exmem_mem_load,
    input  io_exmem_mem_store,
    input  io_exmem_mem_hword,
    input  io_exmem_mem_byte,
    input  io_exmem_mem_zext,
    input [1:0] io_exmem_mem_typ,
    input [31:0] io_exmem_mem_addr,
    input [31:0] io_exmem_mem_data,
    input  io_exmem_mem_call,
    input  io_exmem_mem_ret,
    input  io_exmem_mem_brcf,
    input [31:0] io_exmem_mem_callRetAddr,
    input [31:0] io_exmem_mem_callRetBase,
    input [29:0] io_exmem_pc,
    output[4:0] io_memwb_rd_0_addr,
    output[31:0] io_memwb_rd_0_data,
    output io_memwb_rd_0_valid,
    output[4:0] io_memwb_rd_1_addr,
    output[31:0] io_memwb_rd_1_data,
    output io_memwb_rd_1_valid,
    output[29:0] io_memwb_pc,
    output io_memfe_doCallRet,
    output[29:0] io_memfe_callRetPc,
    output[29:0] io_memfe_callRetBase,
    output io_memfe_store,
    output[31:0] io_memfe_addr,
    output[31:0] io_memfe_data,
    input [10:0] io_femem_pc,
    output[4:0] io_exResult_0_addr,
    output[31:0] io_exResult_0_data,
    output io_exResult_0_valid,
    output[4:0] io_exResult_1_addr,
    output[31:0] io_exResult_1_data,
    output io_exResult_1_valid,
    output[2:0] io_localInOut_M_Cmd,
    output[31:0] io_localInOut_M_Addr,
    output[31:0] io_localInOut_M_Data,
    output[3:0] io_localInOut_M_ByteEn,
    input [1:0] io_localInOut_S_Resp,
    input [31:0] io_localInOut_S_Data,
    output[2:0] io_globalInOut_M_Cmd,
    output[31:0] io_globalInOut_M_Addr,
    output[31:0] io_globalInOut_M_Data,
    output[3:0] io_globalInOut_M_ByteEn,
    output[1:0] io_globalInOut_M_AddrSpace,
    input [1:0] io_globalInOut_S_Resp,
    input [31:0] io_globalInOut_S_Data
);

  wire[1:0] T0;
  wire[1:0] T1;
  wire T2;
  wire T3;
  wire[3:0] byteEn;
  wire[3:0] T4;
  wire[3:0] T5;
  wire[3:0] T6;
  wire[3:0] T7;
  wire[3:0] T8;
  wire[3:0] T9;
  wire T10;
  wire T11;
  wire T12;
  wire T13;
  wire T14;
  wire T15;
  wire T16;
  wire[1:0] T17;
  wire T18;
  wire T19;
  wire T20;
  wire T21;
  wire T22;
  wire T23;
  wire[31:0] T24;
  wire[7:0] wrData_0;
  wire[7:0] T25;
  wire[7:0] T26;
  wire[7:0] T27;
  wire[7:0] T28;
  wire[7:0] T29;
  wire[7:0] wrData_1;
  wire[7:0] T30;
  wire[7:0] T31;
  wire[7:0] T32;
  wire[7:0] T33;
  wire[7:0] T34;
  wire[7:0] wrData_2;
  wire[7:0] T35;
  wire[7:0] T36;
  wire[7:0] T37;
  wire[7:0] T38;
  wire[7:0] T39;
  wire[7:0] wrData_3;
  wire[7:0] T40;
  wire[7:0] T41;
  wire[7:0] T42;
  wire[7:0] T43;
  wire[7:0] T44;
  wire[31:0] T45;
  wire[29:0] T46;
  wire[2:0] T47;
  wire[2:0] cmd;
  wire[2:0] T48;
  wire[2:0] T49;
  wire T50;
  wire T51;
  wire enable;
  wire T52;
  wire T53;
  wire T54;
  reg[0:0] mayStallReg;
  wire T55;
  wire T56;
  wire T57;
  wire[31:0] T58;
  wire[31:0] T59;
  wire[29:0] T60;
  wire[2:0] T61;
  wire T62;
  wire[31:0] T63;
  wire T64;
  wire[29:0] T65;
  reg[31:0] memReg_mem_callRetBase;
  wire[31:0] T66;
  wire[31:0] T67;
  wire[31:0] T68;
  wire[29:0] T69;
  reg[31:0] memReg_mem_callRetAddr;
  wire[31:0] T70;
  wire[31:0] T71;
  wire[31:0] T72;
  wire T73;
  reg[0:0] memReg_mem_brcf;
  wire T74;
  wire T75;
  wire T76;
  reg[0:0] memReg_mem_ret;
  wire T77;
  wire T78;
  reg[0:0] memReg_mem_call;
  wire T79;
  wire T80;
  reg[29:0] memReg_pc;
  wire[29:0] T81;
  wire[29:0] T82;
  reg[0:0] memReg_rd_1_valid;
  wire T83;
  wire T84;
  reg[31:0] memReg_rd_1_data;
  wire[31:0] T85;
  wire[31:0] T86;
  wire[31:0] T87;
  reg[4:0] memReg_rd_1_addr;
  wire[4:0] T88;
  wire[4:0] T89;
  wire[4:0] T90;
  reg[0:0] memReg_rd_0_valid;
  wire T91;
  wire[31:0] T92;
  wire[31:0] T93;
  reg[31:0] memReg_rd_0_data;
  wire[31:0] T94;
  wire[31:0] T95;
  wire[12:0] T96;
  wire[31:0] dout;
  wire[31:0] T97;
  wire[31:0] T98;
  wire[31:0] T99;
  wire[31:0] T100;
  wire[31:0] T101;
  wire[7:0] rdData_0;
  wire[7:0] T102;
  wire[31:0] T103;
  wire T104;
  reg[1:0] memReg_mem_typ;
  wire[1:0] T105;
  wire[1:0] T106;
  wire[1:0] T107;
  wire[7:0] rdData_1;
  wire[7:0] T108;
  wire[7:0] rdData_2;
  wire[7:0] T109;
  wire[7:0] rdData_3;
  wire[7:0] T110;
  wire[31:0] T111;
  wire[7:0] bval;
  wire[7:0] T112;
  wire[7:0] T113;
  wire[7:0] T114;
  wire T115;
  wire[1:0] T116;
  reg[31:0] memReg_mem_addr;
  wire[31:0] T117;
  wire[31:0] T118;
  wire[31:0] T119;
  wire T120;
  wire T121;
  wire T122;
  wire[23:0] T123;
  wire T124;
  reg[0:0] memReg_mem_byte;
  wire T125;
  wire T126;
  wire[31:0] T127;
  wire T128;
  reg[0:0] memReg_mem_zext;
  wire T129;
  wire T130;
  wire[31:0] T131;
  wire[15:0] hval;
  wire[15:0] T132;
  wire[15:0] T133;
  wire[15:0] T134;
  wire T135;
  wire T136;
  wire[15:0] T137;
  wire T138;
  wire[15:0] T139;
  wire T140;
  reg[0:0] memReg_mem_hword;
  wire T141;
  wire T142;
  wire[31:0] T143;
  wire T144;
  reg[0:0] memReg_mem_load;
  wire T145;
  wire T146;
  reg[4:0] memReg_rd_0_addr;
  wire[4:0] T147;

  assign io_globalInOut_M_AddrSpace = T0;
  assign T0 = T3 ? 2'b00/* 0*/ : T1;
  assign T1 = T2 ? 2'b10/* 0*/ : 2'b11/* 0*/;
  assign T2 = io_exmem_mem_typ == 2'b10/* 0*/;
  assign T3 = io_exmem_mem_typ == 2'b00/* 0*/;
  assign io_globalInOut_M_ByteEn = byteEn;
  assign byteEn = T4;
  assign T4 = T22 ? 4'b0001/* 0*/ : T5;
  assign T5 = T20 ? 4'b0010/* 0*/ : T6;
  assign T6 = T18 ? 4'b0100/* 0*/ : T7;
  assign T7 = T15 ? 4'b1000/* 0*/ : T8;
  assign T8 = T13 ? 4'b0011/* 0*/ : T9;
  assign T9 = T10 ? 4'b1100/* 0*/ : 4'b1111/* 0*/;
  assign T10 = io_exmem_mem_hword && T11;
  assign T11 = T12 == 1'b0/* 0*/;
  assign T12 = io_exmem_mem_addr[1'h1/* 1*/:1'h1/* 1*/];
  assign T13 = io_exmem_mem_hword && T14;
  assign T14 = T12 == 1'b1/* 0*/;
  assign T15 = io_exmem_mem_byte && T16;
  assign T16 = T17 == 2'b00/* 0*/;
  assign T17 = io_exmem_mem_addr[1'h1/* 1*/:1'h0/* 0*/];
  assign T18 = io_exmem_mem_byte && T19;
  assign T19 = T17 == 2'b01/* 0*/;
  assign T20 = io_exmem_mem_byte && T21;
  assign T21 = T17 == 2'b10/* 0*/;
  assign T22 = io_exmem_mem_byte && T23;
  assign T23 = T17 == 2'b11/* 0*/;
  assign io_globalInOut_M_Data = T24;
  assign T24 = {wrData_3, wrData_2, wrData_1, wrData_0};
  assign wrData_0 = T25;
  assign T25 = T22 ? T29 : T26;
  assign T26 = T13 ? T28 : T27;
  assign T27 = io_exmem_mem_data[3'h7/* 7*/:1'h0/* 0*/];
  assign T28 = io_exmem_mem_data[3'h7/* 7*/:1'h0/* 0*/];
  assign T29 = io_exmem_mem_data[3'h7/* 7*/:1'h0/* 0*/];
  assign wrData_1 = T30;
  assign T30 = T20 ? T34 : T31;
  assign T31 = T13 ? T33 : T32;
  assign T32 = io_exmem_mem_data[4'hf/* 15*/:4'h8/* 8*/];
  assign T33 = io_exmem_mem_data[4'hf/* 15*/:4'h8/* 8*/];
  assign T34 = io_exmem_mem_data[3'h7/* 7*/:1'h0/* 0*/];
  assign wrData_2 = T35;
  assign T35 = T18 ? T39 : T36;
  assign T36 = T10 ? T38 : T37;
  assign T37 = io_exmem_mem_data[5'h17/* 23*/:5'h10/* 16*/];
  assign T38 = io_exmem_mem_data[3'h7/* 7*/:1'h0/* 0*/];
  assign T39 = io_exmem_mem_data[3'h7/* 7*/:1'h0/* 0*/];
  assign wrData_3 = T40;
  assign T40 = T15 ? T44 : T41;
  assign T41 = T10 ? T43 : T42;
  assign T42 = io_exmem_mem_data[5'h1f/* 31*/:5'h18/* 24*/];
  assign T43 = io_exmem_mem_data[4'hf/* 15*/:4'h8/* 8*/];
  assign T44 = io_exmem_mem_data[3'h7/* 7*/:1'h0/* 0*/];
  assign io_globalInOut_M_Addr = T45;
  assign T45 = {T46, 2'b00/* 0*/};
  assign T46 = io_exmem_mem_addr[5'h1f/* 31*/:2'h2/* 2*/];
  assign io_globalInOut_M_Cmd = T47;
  assign T47 = T57 ? cmd : 3'b000/* 0*/;
  assign cmd = T51 ? T48 : 3'b000/* 0*/;
  assign T48 = io_exmem_mem_load ? 3'b010/* 0*/ : T49;
  assign T49 = {2'h0/* 0*/, T50};
  assign T50 = io_exmem_mem_store;
  assign T51 = enable && io_ena_in;
  assign enable = mayStallReg ? T52 : 1'h1/* 1*/;
  assign T52 = T54 || T53;
  assign T53 = io_globalInOut_S_Resp == 2'b01/* 0*/;
  assign T54 = io_localInOut_S_Resp == 2'b01/* 0*/;
  assign T55 = enable && io_ena_in;
  assign T56 = io_exmem_mem_load || io_exmem_mem_store;
  assign T57 = io_exmem_mem_typ != 2'b01/* 0*/;
  assign io_localInOut_M_ByteEn = byteEn;
  assign io_localInOut_M_Data = T58;
  assign T58 = {wrData_3, wrData_2, wrData_1, wrData_0};
  assign io_localInOut_M_Addr = T59;
  assign T59 = {T60, 2'b00/* 0*/};
  assign T60 = io_exmem_mem_addr[5'h1f/* 31*/:2'h2/* 2*/];
  assign io_localInOut_M_Cmd = T61;
  assign T61 = T62 ? cmd : 3'b000/* 0*/;
  assign T62 = io_exmem_mem_typ == 2'b01/* 0*/;
  assign io_exResult_1_valid = io_exmem_rd_1_valid;
  assign io_exResult_1_data = io_exmem_rd_1_data;
  assign io_exResult_1_addr = io_exmem_rd_1_addr;
  assign io_exResult_0_valid = io_exmem_rd_0_valid;
  assign io_exResult_0_data = io_exmem_rd_0_data;
  assign io_exResult_0_addr = io_exmem_rd_0_addr;
  assign io_memfe_data = T63;
  assign T63 = {wrData_3, wrData_2, wrData_1, wrData_0};
  assign io_memfe_addr = io_exmem_mem_addr;
  assign io_memfe_store = T64;
  assign T64 = io_localInOut_M_Cmd == 3'b001/* 0*/;
  assign io_memfe_callRetBase = T65;
  assign T65 = memReg_mem_callRetBase[5'h1f/* 31*/:2'h2/* 2*/];
  assign T66 = T67;
  assign T67 = T68;
  assign T68 = {31'h0/* 0*/, 1'h0/* 0*/};
  assign io_memfe_callRetPc = T69;
  assign T69 = memReg_mem_callRetAddr[5'h1f/* 31*/:2'h2/* 2*/];
  assign T70 = T71;
  assign T71 = T72;
  assign T72 = {31'h0/* 0*/, 1'h0/* 0*/};
  assign io_memfe_doCallRet = T73;
  assign T73 = T76 || memReg_mem_brcf;
  assign T74 = T75;
  assign T75 = 1'h0/* 0*/;
  assign T76 = memReg_mem_call || memReg_mem_ret;
  assign T77 = T78;
  assign T78 = 1'h0/* 0*/;
  assign T79 = T80;
  assign T80 = 1'h0/* 0*/;
  assign io_memwb_pc = memReg_pc;
  assign T81 = T82;
  assign T82 = {29'h0/* 0*/, 1'h0/* 0*/};
  assign io_memwb_rd_1_valid = memReg_rd_1_valid;
  assign T83 = T84;
  assign T84 = 1'h0/* 0*/;
  assign io_memwb_rd_1_data = memReg_rd_1_data;
  assign T85 = T86;
  assign T86 = T87;
  assign T87 = {31'h0/* 0*/, 1'h0/* 0*/};
  assign io_memwb_rd_1_addr = memReg_rd_1_addr;
  assign T88 = T89;
  assign T89 = T90;
  assign T90 = {4'h0/* 0*/, 1'h0/* 0*/};
  assign io_memwb_rd_0_valid = memReg_rd_0_valid;
  assign T91 = T84;
  assign io_memwb_rd_0_data = T92;
  assign T92 = memReg_mem_load ? dout : T93;
  assign T93 = memReg_mem_call ? T95 : memReg_rd_0_data;
  assign T94 = T86;
  assign T95 = {19'h0/* 0*/, T96};
  assign T96 = {io_femem_pc, 2'b00/* 0*/};
  assign dout = T97;
  assign T97 = T144 ? T143 : T98;
  assign T98 = memReg_mem_hword ? T131 : T99;
  assign T99 = T128 ? T127 : T100;
  assign T100 = memReg_mem_byte ? T111 : T101;
  assign T101 = {rdData_3, rdData_2, rdData_1, rdData_0};
  assign rdData_0 = T102;
  assign T102 = T103[3'h7/* 7*/:1'h0/* 0*/];
  assign T103 = T104 ? io_localInOut_S_Data : io_globalInOut_S_Data;
  assign T104 = memReg_mem_typ == 2'b01/* 0*/;
  assign T105 = T106;
  assign T106 = T107;
  assign T107 = {1'h0/* 0*/, 1'h0/* 0*/};
  assign rdData_1 = T108;
  assign T108 = T103[4'hf/* 15*/:4'h8/* 8*/];
  assign rdData_2 = T109;
  assign T109 = T103[5'h17/* 23*/:5'h10/* 16*/];
  assign rdData_3 = T110;
  assign T110 = T103[5'h1f/* 31*/:5'h18/* 24*/];
  assign T111 = {T123, bval};
  assign bval = T122 ? rdData_3 : T112;
  assign T112 = T121 ? rdData_2 : T113;
  assign T113 = T120 ? rdData_1 : T114;
  assign T114 = T115 ? rdData_0 : rdData_0;
  assign T115 = T116 == 2'b11/* 0*/;
  assign T116 = memReg_mem_addr[1'h1/* 1*/:1'h0/* 0*/];
  assign T117 = T118;
  assign T118 = T119;
  assign T119 = {31'h0/* 0*/, 1'h0/* 0*/};
  assign T120 = T116 == 2'b10/* 0*/;
  assign T121 = T116 == 2'b01/* 0*/;
  assign T122 = T116 == 2'b00/* 0*/;
  assign T123 = {5'h18/* 24*/{T124}};
  assign T124 = bval[3'h7/* 7*/:3'h7/* 7*/];
  assign T125 = T126;
  assign T126 = 1'h0/* 0*/;
  assign T127 = {24'h0/* 0*/, bval};
  assign T128 = memReg_mem_byte && memReg_mem_zext;
  assign T129 = T130;
  assign T130 = 1'h0/* 0*/;
  assign T131 = {T139, hval};
  assign hval = T138 ? T137 : T132;
  assign T132 = T135 ? T134 : T133;
  assign T133 = {rdData_2, rdData_3};
  assign T134 = {rdData_1, rdData_0};
  assign T135 = T136 == 1'b1/* 0*/;
  assign T136 = memReg_mem_addr[1'h1/* 1*/:1'h1/* 1*/];
  assign T137 = {rdData_3, rdData_2};
  assign T138 = T136 == 1'b0/* 0*/;
  assign T139 = {5'h10/* 16*/{T140}};
  assign T140 = hval[4'hf/* 15*/:4'hf/* 15*/];
  assign T141 = T142;
  assign T142 = 1'h0/* 0*/;
  assign T143 = {16'h0/* 0*/, hval};
  assign T144 = memReg_mem_hword && memReg_mem_zext;
  assign T145 = T146;
  assign T146 = 1'h0/* 0*/;
  assign io_memwb_rd_0_addr = memReg_rd_0_addr;
  assign T147 = T89;
  assign io_ena_out = enable;

  always @(posedge clk) begin
    if(reset) begin
      mayStallReg <= 1'h0/* 0*/;
    end else if(T55) begin
      mayStallReg <= T56;
    end
    if(reset) begin
      memReg_mem_callRetBase <= T66;
    end else if(T55) begin
      memReg_mem_callRetBase <= io_exmem_mem_callRetBase;
    end
    if(reset) begin
      memReg_mem_callRetAddr <= T70;
    end else if(T55) begin
      memReg_mem_callRetAddr <= io_exmem_mem_callRetAddr;
    end
    if(reset) begin
      memReg_mem_brcf <= T74;
    end else if(T55) begin
      memReg_mem_brcf <= io_exmem_mem_brcf;
    end
    if(reset) begin
      memReg_mem_ret <= T77;
    end else if(T55) begin
      memReg_mem_ret <= io_exmem_mem_ret;
    end
    if(reset) begin
      memReg_mem_call <= T79;
    end else if(T55) begin
      memReg_mem_call <= io_exmem_mem_call;
    end
    if(reset) begin
      memReg_pc <= T81;
    end else if(T55) begin
      memReg_pc <= io_exmem_pc;
    end
    if(reset) begin
      memReg_rd_1_valid <= T83;
    end else if(T55) begin
      memReg_rd_1_valid <= io_exmem_rd_1_valid;
    end
    if(reset) begin
      memReg_rd_1_data <= T85;
    end else if(T55) begin
      memReg_rd_1_data <= io_exmem_rd_1_data;
    end
    if(reset) begin
      memReg_rd_1_addr <= T88;
    end else if(T55) begin
      memReg_rd_1_addr <= io_exmem_rd_1_addr;
    end
    if(reset) begin
      memReg_rd_0_valid <= T91;
    end else if(T55) begin
      memReg_rd_0_valid <= io_exmem_rd_0_valid;
    end
    if(reset) begin
      memReg_rd_0_data <= T94;
    end else if(T55) begin
      memReg_rd_0_data <= io_exmem_rd_0_data;
    end
    if(reset) begin
      memReg_mem_typ <= T105;
    end else if(T55) begin
      memReg_mem_typ <= io_exmem_mem_typ;
    end
    if(reset) begin
      memReg_mem_addr <= T117;
    end else if(T55) begin
      memReg_mem_addr <= io_exmem_mem_addr;
    end
    if(reset) begin
      memReg_mem_byte <= T125;
    end else if(T55) begin
      memReg_mem_byte <= io_exmem_mem_byte;
    end
    if(reset) begin
      memReg_mem_zext <= T129;
    end else if(T55) begin
      memReg_mem_zext <= io_exmem_mem_zext;
    end
    if(reset) begin
      memReg_mem_hword <= T141;
    end else if(T55) begin
      memReg_mem_hword <= io_exmem_mem_hword;
    end
    if(reset) begin
      memReg_mem_load <= T145;
    end else if(T55) begin
      memReg_mem_load <= io_exmem_mem_load;
    end
    if(reset) begin
      memReg_rd_0_addr <= T147;
    end else if(T55) begin
      memReg_rd_0_addr <= io_exmem_rd_0_addr;
    end
  end
endmodule

module WriteBack(
    input  io_ena,
    input [4:0] io_memwb_rd_0_addr,
    input [31:0] io_memwb_rd_0_data,
    input  io_memwb_rd_0_valid,
    input [4:0] io_memwb_rd_1_addr,
    input [31:0] io_memwb_rd_1_data,
    input  io_memwb_rd_1_valid,
    input [29:0] io_memwb_pc,
    output[4:0] io_rfWrite_0_addr,
    output[31:0] io_rfWrite_0_data,
    output io_rfWrite_0_valid,
    output[4:0] io_rfWrite_1_addr,
    output[31:0] io_rfWrite_1_data,
    output io_rfWrite_1_valid,
    output[4:0] io_memResult_0_addr,
    output[31:0] io_memResult_0_data,
    output io_memResult_0_valid,
    output[4:0] io_memResult_1_addr,
    output[31:0] io_memResult_1_data,
    output io_memResult_1_valid
);


  assign io_memResult_1_valid = io_memwb_rd_1_valid;
  assign io_memResult_1_data = io_memwb_rd_1_data;
  assign io_memResult_1_addr = io_memwb_rd_1_addr;
  assign io_memResult_0_valid = io_memwb_rd_0_valid;
  assign io_memResult_0_data = io_memwb_rd_0_data;
  assign io_memResult_0_addr = io_memwb_rd_0_addr;
  assign io_rfWrite_1_valid = io_memwb_rd_1_valid;
  assign io_rfWrite_1_data = io_memwb_rd_1_data;
  assign io_rfWrite_1_addr = io_memwb_rd_1_addr;
  assign io_rfWrite_0_valid = io_memwb_rd_0_valid;
  assign io_rfWrite_0_data = io_memwb_rd_0_data;
  assign io_rfWrite_0_addr = io_memwb_rd_0_addr;
endmodule

module Spm(input clk,
    input [2:0] io_M_Cmd,
    input [10:0] io_M_Addr,
    input [31:0] io_M_Data,
    input [3:0] io_M_ByteEn,
    output[1:0] io_S_Resp,
    output[31:0] io_S_Data
);

  wire[31:0] rdData;
  wire[7:0] T0;
  reg [7:0] mem0 [511:0];
  wire[8:0] T1;
  wire[7:0] T2;
  wire[7:0] T3;
  reg[31:0] masterReg_Data;
  wire T4;
  reg[3:0] stmskReg;
  wire[3:0] stmsk;
  wire T5;
  wire[8:0] T6;
  reg[10:0] masterReg_Addr;
  wire[8:0] T7;
  wire[7:0] T8;
  reg [7:0] mem1 [511:0];
  wire[8:0] T9;
  wire[7:0] T10;
  wire[7:0] T11;
  wire T12;
  wire[8:0] T13;
  wire[8:0] T14;
  wire[7:0] T15;
  reg [7:0] mem2 [511:0];
  wire[8:0] T16;
  wire[7:0] T17;
  wire[7:0] T18;
  wire T19;
  wire[8:0] T20;
  wire[8:0] T21;
  wire[7:0] T22;
  reg [7:0] mem3 [511:0];
  wire[8:0] T23;
  wire[7:0] T24;
  wire[7:0] T25;
  wire T26;
  wire[8:0] T27;
  wire[8:0] T28;
  wire[1:0] T29;
  wire T30;
  wire T31;
  wire T32;
  reg[2:0] masterReg_Cmd;
  wire T33;

  assign io_S_Data = rdData;
  assign rdData = {T22, T15, T8, T0};
  assign T0 = mem0[T7];
  assign T2 = T3;
  assign T3 = masterReg_Data[3'h7/* 7*/:1'h0/* 0*/];
  assign T4 = stmskReg[1'h0/* 0*/:1'h0/* 0*/];
  assign stmsk = T5 ? io_M_ByteEn : 4'b0000/* 0*/;
  assign T5 = io_M_Cmd == 3'b001/* 0*/;
  assign T6 = masterReg_Addr[4'ha/* 10*/:2'h2/* 2*/];
  assign T7 = masterReg_Addr[4'ha/* 10*/:2'h2/* 2*/];
  assign T8 = mem1[T14];
  assign T10 = T11;
  assign T11 = masterReg_Data[4'hf/* 15*/:4'h8/* 8*/];
  assign T12 = stmskReg[1'h1/* 1*/:1'h1/* 1*/];
  assign T13 = masterReg_Addr[4'ha/* 10*/:2'h2/* 2*/];
  assign T14 = masterReg_Addr[4'ha/* 10*/:2'h2/* 2*/];
  assign T15 = mem2[T21];
  assign T17 = T18;
  assign T18 = masterReg_Data[5'h17/* 23*/:5'h10/* 16*/];
  assign T19 = stmskReg[2'h2/* 2*/:2'h2/* 2*/];
  assign T20 = masterReg_Addr[4'ha/* 10*/:2'h2/* 2*/];
  assign T21 = masterReg_Addr[4'ha/* 10*/:2'h2/* 2*/];
  assign T22 = mem3[T28];
  assign T24 = T25;
  assign T25 = masterReg_Data[5'h1f/* 31*/:5'h18/* 24*/];
  assign T26 = stmskReg[2'h3/* 3*/:2'h3/* 3*/];
  assign T27 = masterReg_Addr[4'ha/* 10*/:2'h2/* 2*/];
  assign T28 = masterReg_Addr[4'ha/* 10*/:2'h2/* 2*/];
  assign io_S_Resp = T29;
  assign T29 = {1'h0/* 0*/, T30};
  assign T30 = T31;
  assign T31 = T33 || T32;
  assign T32 = masterReg_Cmd == 3'b010/* 0*/;
  assign T33 = masterReg_Cmd == 3'b001/* 0*/;

  always @(posedge clk) begin
    if (T4)
      mem0[T6] <= T2;
    masterReg_Data <= io_M_Data;
    stmskReg <= stmsk;
    masterReg_Addr <= io_M_Addr;
    if (T12)
      mem1[T13] <= T10;
    if (T19)
      mem2[T20] <= T17;
    if (T26)
      mem3[T27] <= T24;
    masterReg_Cmd <= io_M_Cmd;
  end
endmodule

module OcpCoreBus(
    input [2:0] io_slave_M_Cmd,
    input [31:0] io_slave_M_Addr,
    input [31:0] io_slave_M_Data,
    input [3:0] io_slave_M_ByteEn,
    output[1:0] io_slave_S_Resp,
    output[31:0] io_slave_S_Data,
    output[2:0] io_master_M_Cmd,
    output[31:0] io_master_M_Addr,
    output[31:0] io_master_M_Data,
    output[3:0] io_master_M_ByteEn,
    input [1:0] io_master_S_Resp,
    input [31:0] io_master_S_Data
);


  assign io_master_M_ByteEn = io_slave_M_ByteEn;
  assign io_master_M_Data = io_slave_M_Data;
  assign io_master_M_Addr = io_slave_M_Addr;
  assign io_master_M_Cmd = io_slave_M_Cmd;
  assign io_slave_S_Data = io_master_S_Data;
  assign io_slave_S_Resp = io_master_S_Resp;
endmodule

module OcpIOBus(
    input [2:0] io_slave_M_Cmd,
    input [31:0] io_slave_M_Addr,
    input [31:0] io_slave_M_Data,
    input [3:0] io_slave_M_ByteEn,
    input  io_slave_M_RespAccept,
    output[1:0] io_slave_S_Resp,
    output[31:0] io_slave_S_Data,
    output io_slave_S_CmdAccept,
    output[2:0] io_master_M_Cmd,
    output[31:0] io_master_M_Addr,
    output[31:0] io_master_M_Data,
    output[3:0] io_master_M_ByteEn,
    output io_master_M_RespAccept,
    input [1:0] io_master_S_Resp,
    input [31:0] io_master_S_Data,
    input  io_master_S_CmdAccept
);


  assign io_master_M_RespAccept = io_slave_M_RespAccept;
  assign io_master_M_ByteEn = io_slave_M_ByteEn;
  assign io_master_M_Data = io_slave_M_Data;
  assign io_master_M_Addr = io_slave_M_Addr;
  assign io_master_M_Cmd = io_slave_M_Cmd;
  assign io_slave_S_CmdAccept = io_master_S_CmdAccept;
  assign io_slave_S_Data = io_master_S_Data;
  assign io_slave_S_Resp = io_master_S_Resp;
endmodule

module CpuInfo(input clk,
    input [2:0] io_ocp_M_Cmd,
    input [31:0] io_ocp_M_Addr,
    input [31:0] io_ocp_M_Data,
    input [3:0] io_ocp_M_ByteEn,
    output[1:0] io_ocp_S_Resp,
    output[31:0] io_ocp_S_Data,
    input [31:0] io_cpuInfoPins_id
);

  wire[31:0] data;
  wire[31:0] T0;
  wire[31:0] T1;
  wire[31:0] T2;
  wire T3;
  wire T4;
  wire T5;
  reg[31:0] masterReg_Addr;
  wire T6;
  reg[2:0] masterReg_Cmd;
  wire[31:0] T7;
  wire T8;
  wire T9;
  wire[1:0] resp;
  wire[1:0] T10;
  wire[1:0] T11;
  wire T12;
  wire T13;

  assign io_ocp_S_Data = data;
  assign data = T0;
  assign T0 = T8 ? T7 : T1;
  assign T1 = T3 ? io_cpuInfoPins_id : T2;
  assign T2 = {31'h0/* 0*/, 1'h0/* 0*/};
  assign T3 = T6 && T4;
  assign T4 = T5 == 1'h0/* 0*/;
  assign T5 = masterReg_Addr[2'h2/* 2*/:2'h2/* 2*/];
  assign T6 = masterReg_Cmd == 3'b010/* 0*/;
  assign T7 = {5'h0/* 0*/, 27'h4c4b400/* 80000000*/};
  assign T8 = T6 && T9;
  assign T9 = ! T4;
  assign io_ocp_S_Resp = resp;
  assign resp = T10;
  assign T10 = T6 ? 2'b01/* 0*/ : T11;
  assign T11 = {1'h0/* 0*/, T12};
  assign T12 = T13;
  assign T13 = masterReg_Cmd == 3'b001/* 0*/;

  always @(posedge clk) begin
    masterReg_Addr <= io_ocp_M_Addr;
    masterReg_Cmd <= io_ocp_M_Cmd;
  end
endmodule

module Timer(input clk, input reset,
    input [2:0] io_ocp_M_Cmd,
    input [31:0] io_ocp_M_Addr,
    input [31:0] io_ocp_M_Data,
    input [3:0] io_ocp_M_ByteEn,
    output[1:0] io_ocp_S_Resp,
    output[31:0] io_ocp_S_Data
);

  wire[31:0] data;
  wire[31:0] T0;
  wire[31:0] T1;
  wire[31:0] T2;
  wire[31:0] T3;
  wire[31:0] T4;
  wire[31:0] T5;
  reg[63:0] cycleReg;
  wire[63:0] T6;
  wire[63:0] T7;
  wire T8;
  wire T9;
  wire[1:0] T10;
  reg[31:0] masterReg_Addr;
  wire T11;
  reg[2:0] masterReg_Cmd;
  reg[31:0] cycleHiReg;
  wire[31:0] T12;
  wire T13;
  wire T14;
  wire[1:0] T15;
  wire[31:0] T16;
  reg[63:0] usecReg;
  wire T17;
  wire[6:0] T18;
  reg[0:0] usecSubReg;
  wire T19;
  wire T20;
  wire[63:0] T21;
  wire[63:0] T22;
  wire T23;
  wire T24;
  wire[1:0] T25;
  reg[31:0] usecHiReg;
  wire[31:0] T26;
  wire T27;
  wire T28;
  wire[1:0] T29;
  wire[1:0] resp;
  wire[1:0] T30;
  wire T31;

  assign io_ocp_S_Data = data;
  assign data = T0;
  assign T0 = T27 ? usecHiReg : T1;
  assign T1 = T23 ? T16 : T2;
  assign T2 = T13 ? cycleHiReg : T3;
  assign T3 = T8 ? T5 : T4;
  assign T4 = {31'h0/* 0*/, 1'h0/* 0*/};
  assign T5 = cycleReg[5'h1f/* 31*/:1'h0/* 0*/];
  assign T6 = cycleReg + T7;
  assign T7 = {63'h0/* 0*/, 1'h1/* 1*/};
  assign T8 = T11 && T9;
  assign T9 = T10 == 2'b01/* 0*/;
  assign T10 = masterReg_Addr[2'h3/* 3*/:2'h2/* 2*/];
  assign T11 = masterReg_Cmd == 3'b010/* 0*/;
  assign T12 = cycleReg[6'h3f/* 63*/:6'h20/* 32*/];
  assign T13 = T11 && T14;
  assign T14 = T15 == 2'b00/* 0*/;
  assign T15 = masterReg_Addr[2'h3/* 3*/:2'h2/* 2*/];
  assign T16 = usecReg[5'h1f/* 31*/:1'h0/* 0*/];
  assign T17 = T18 == 7'h50/* 80*/;
  assign T18 = {6'h0/* 0*/, usecSubReg};
  assign T19 = T17 ? 1'h0/* 0*/ : T20;
  assign T20 = usecSubReg + 1'h1/* 1*/;
  assign T21 = usecReg + T22;
  assign T22 = {63'h0/* 0*/, 1'h1/* 1*/};
  assign T23 = T11 && T24;
  assign T24 = T25 == 2'b11/* 0*/;
  assign T25 = masterReg_Addr[2'h3/* 3*/:2'h2/* 2*/];
  assign T26 = usecReg[6'h3f/* 63*/:6'h20/* 32*/];
  assign T27 = T11 && T28;
  assign T28 = T29 == 2'b10/* 0*/;
  assign T29 = masterReg_Addr[2'h3/* 3*/:2'h2/* 2*/];
  assign io_ocp_S_Resp = resp;
  assign resp = T30;
  assign T30 = {1'h0/* 0*/, T31};
  assign T31 = T11;

  always @(posedge clk) begin
    cycleReg <= reset ? 64'h0/* 0*/ : T6;
    masterReg_Addr <= io_ocp_M_Addr;
    masterReg_Cmd <= io_ocp_M_Cmd;
    if(reset) begin
      cycleHiReg <= 32'h0/* 0*/;
    end else if(T8) begin
      cycleHiReg <= T12;
    end
    if(reset) begin
      usecReg <= 64'h0/* 0*/;
    end else if(T17) begin
      usecReg <= T21;
    end
    usecSubReg <= reset ? 1'h0/* 0*/ : T19;
    if(reset) begin
      usecHiReg <= 32'h0/* 0*/;
    end else if(T23) begin
      usecHiReg <= T26;
    end
  end
endmodule

module Uart(input clk, input reset,
    input [2:0] io_ocp_M_Cmd,
    input [31:0] io_ocp_M_Addr,
    input [31:0] io_ocp_M_Data,
    input [3:0] io_ocp_M_ByteEn,
    output[1:0] io_ocp_S_Resp,
    output[31:0] io_ocp_S_Data,
    output io_uartPins_tx,
    input  io_uartPins_rx
);

  reg[0:0] tx_reg;
  wire T0;
  wire T1;
  wire T2;
  wire T3;
  reg[0:0] tx_empty;
  wire T4;
  wire T5;
  wire T6;
  wire T7;
  reg[3:0] tx_counter;
  wire T8;
  wire T9;
  wire T10;
  wire T11;
  reg[0:0] tx_baud_tick;
  wire T12;
  wire T13;
  wire T14;
  reg[9:0] tx_baud_counter;
  wire T15;
  wire[9:0] T16;
  wire[9:0] T17;
  wire[9:0] T18;
  wire[9:0] T19;
  wire T20;
  wire T21;
  reg[0:0] tx_state;
  wire T22;
  wire T23;
  wire T24;
  wire T25;
  wire T26;
  wire[3:0] T27;
  wire[3:0] T28;
  wire[3:0] T29;
  wire[3:0] T30;
  wire[3:0] T31;
  wire[3:0] T32;
  wire T33;
  wire[3:0] T34;
  wire[3:0] T35;
  wire T36;
  wire T37;
  wire T38;
  wire T39;
  wire T40;
  wire T41;
  wire T42;
  reg[9:0] tx_buff;
  wire T43;
  wire T44;
  wire[9:0] T45;
  wire[9:0] T46;
  wire[9:0] T47;
  reg[7:0] tx_data;
  wire[7:0] T48;
  wire[9:0] T49;
  wire[8:0] T50;
  wire[9:0] T51;
  wire[8:0] T52;
  wire[31:0] T53;
  reg[7:0] rdDataReg;
  wire[7:0] T54;
  reg[7:0] rx_data;
  wire T55;
  wire T56;
  reg[0:0] rxd_reg2;
  reg[0:0] rxd_reg1;
  reg[0:0] rxd_reg0;
  wire T57;
  wire T58;
  reg[0:0] rx_baud_tick;
  wire T59;
  wire T60;
  wire T61;
  wire T62;
  reg[9:0] rx_baud_counter;
  wire T63;
  wire T64;
  wire T65;
  wire T66;
  reg[1:0] rx_state;
  wire T67;
  wire T68;
  wire T69;
  wire T70;
  wire T71;
  wire T72;
  wire T73;
  wire T74;
  wire T75;
  wire T76;
  wire T77;
  wire T78;
  wire T79;
  wire T80;
  wire T81;
  wire T82;
  wire T83;
  wire[1:0] T84;
  wire[1:0] T85;
  wire[1:0] T86;
  wire[1:0] T87;
  wire[1:0] T88;
  wire[1:0] T89;
  wire T90;
  reg[2:0] rx_counter;
  wire[2:0] T91;
  wire[2:0] T92;
  wire[2:0] T93;
  wire[2:0] T94;
  wire T95;
  wire T96;
  wire T97;
  reg[0:0] rx_enable;
  wire T98;
  wire T99;
  wire T100;
  wire T101;
  wire[9:0] T102;
  wire[9:0] T103;
  wire[9:0] T104;
  wire[9:0] T105;
  wire[9:0] T106;
  wire[9:0] T107;
  wire T108;
  wire T109;
  reg[7:0] rx_buff;
  wire[7:0] T110;
  wire[6:0] T111;
  wire[7:0] T112;
  reg[0:0] rx_full;
  wire T113;
  wire T114;
  wire T115;
  wire T116;
  wire T117;
  wire[31:0] T118;
  wire T119;
  wire T120;
  reg[1:0] respReg;
  wire[1:0] T121;
  wire[1:0] T122;
  wire T123;

  assign io_uartPins_tx = tx_reg;
  assign T0 = T39 || T1;
  assign T1 = T6 && T2;
  assign T2 = ! T3;
  assign T3 = tx_empty == 1'h0/* 0*/;
  assign T4 = T36 || T5;
  assign T5 = T6 && T3;
  assign T6 = T10 && T7;
  assign T7 = tx_counter == 4'ha/* 10*/;
  assign T8 = T9 || T1;
  assign T9 = T10 || T5;
  assign T10 = T21 && T11;
  assign T11 = tx_baud_tick == 1'h1/* 1*/;
  assign T12 = T14 || T13;
  assign T13 = ! T14;
  assign T14 = tx_baud_counter == 10'h2b6/* 694*/;
  assign T15 = T14 || T13;
  assign T16 = T13 ? T18 : T17;
  assign T17 = {9'h0/* 0*/, 1'h0/* 0*/};
  assign T18 = tx_baud_counter + T19;
  assign T19 = {9'h0/* 0*/, 1'h1/* 1*/};
  assign T20 = T13 ? 1'h0/* 0*/ : 1'h1/* 1*/;
  assign T21 = tx_state == 1'h1/* 1*/;
  assign T22 = T23 || T1;
  assign T23 = T25 && T24;
  assign T24 = tx_empty == 1'h0/* 0*/;
  assign T25 = tx_state == 1'h0/* 0*/;
  assign T26 = T1 ? 1'h0/* 0*/ : 1'h1/* 1*/;
  assign T27 = T1 ? T35 : T28;
  assign T28 = T5 ? T34 : T29;
  assign T29 = T33 ? T32 : T30;
  assign T30 = tx_counter + T31;
  assign T31 = {3'h0/* 0*/, 1'h1/* 1*/};
  assign T32 = {3'h0/* 0*/, 1'h0/* 0*/};
  assign T33 = tx_counter == 4'ha/* 10*/;
  assign T34 = {3'h0/* 0*/, 1'h1/* 1*/};
  assign T35 = {3'h0/* 0*/, 1'h0/* 0*/};
  assign T36 = T37 || T23;
  assign T37 = io_ocp_M_Cmd == 3'b001/* 0*/;
  assign T38 = T5 ? 1'h1/* 1*/ : T23;
  assign T39 = T10 || T5;
  assign T40 = T1 ? 1'h1/* 1*/ : T41;
  assign T41 = T5 ? 1'h0/* 0*/ : T42;
  assign T42 = tx_buff[1'h0/* 0*/:1'h0/* 0*/];
  assign T43 = T44 || T5;
  assign T44 = T23 || T10;
  assign T45 = T5 ? T51 : T46;
  assign T46 = T10 ? T49 : T47;
  assign T47 = {1'h1/* 1*/, tx_data, 1'h0/* 0*/};
  assign T48 = io_ocp_M_Data[3'h7/* 7*/:1'h0/* 0*/];
  assign T49 = {1'h0/* 0*/, T50};
  assign T50 = tx_buff[4'h9/* 9*/:1'h1/* 1*/];
  assign T51 = {1'h0/* 0*/, T52};
  assign T52 = {1'h1/* 1*/, tx_data};
  assign io_ocp_S_Data = T53;
  assign T53 = {24'h0/* 0*/, rdDataReg};
  assign T54 = T119 ? T112 : rx_data;
  assign T55 = T57 && T56;
  assign T56 = rxd_reg2 == 1'h1/* 1*/;
  assign T57 = T109 && T58;
  assign T58 = rx_baud_tick == 1'h1/* 1*/;
  assign T59 = T97 || T60;
  assign T60 = rx_enable && T61;
  assign T61 = ! T62;
  assign T62 = rx_baud_counter == 10'h2b6/* 694*/;
  assign T63 = T96 || T64;
  assign T64 = T66 && T65;
  assign T65 = rxd_reg2 == 1'h0/* 0*/;
  assign T66 = rx_state == 2'h0/* 0*/;
  assign T67 = T70 || T68;
  assign T68 = T57 && T69;
  assign T69 = ! T56;
  assign T70 = T71 || T55;
  assign T71 = T75 || T72;
  assign T72 = T74 && T73;
  assign T73 = rx_baud_tick == 1'h1/* 1*/;
  assign T74 = rx_state == 2'h2/* 2*/;
  assign T75 = T82 || T76;
  assign T76 = T79 && T77;
  assign T77 = ! T78;
  assign T78 = rxd_reg2 == 1'h0/* 0*/;
  assign T79 = T81 && T80;
  assign T80 = rx_baud_tick == 1'h1/* 1*/;
  assign T81 = rx_state == 2'h1/* 1*/;
  assign T82 = T64 || T83;
  assign T83 = T79 && T78;
  assign T84 = T68 ? 2'h0/* 0*/ : T85;
  assign T85 = T55 ? 2'h0/* 0*/ : T86;
  assign T86 = T72 ? T89 : T87;
  assign T87 = T76 ? 2'h0/* 0*/ : T88;
  assign T88 = T83 ? 2'h2/* 2*/ : 2'h1/* 1*/;
  assign T89 = T90 ? 2'h3/* 3*/ : 2'h2/* 2*/;
  assign T90 = rx_counter == 3'h7/* 7*/;
  assign T91 = T95 ? T94 : T92;
  assign T92 = rx_counter + T93;
  assign T93 = {2'h0/* 0*/, 1'h1/* 1*/};
  assign T94 = {2'h0/* 0*/, 1'h0/* 0*/};
  assign T95 = rx_counter == 3'h7/* 7*/;
  assign T96 = T97 || T60;
  assign T97 = rx_enable && T62;
  assign T98 = T99 || T68;
  assign T99 = T64 || T55;
  assign T100 = T68 ? 1'h0/* 0*/ : T101;
  assign T101 = T55 ? 1'h0/* 0*/ : 1'h1/* 1*/;
  assign T102 = T64 ? T107 : T103;
  assign T103 = T60 ? T105 : T104;
  assign T104 = {9'h0/* 0*/, 1'h0/* 0*/};
  assign T105 = rx_baud_counter + T106;
  assign T106 = {9'h0/* 0*/, 1'h1/* 1*/};
  assign T107 = 10'h2b6/* 694*/ / 2'h2/* 2*/;
  assign T108 = T60 ? 1'h0/* 0*/ : 1'h1/* 1*/;
  assign T109 = rx_state == 2'h3/* 3*/;
  assign T110 = {rxd_reg2, T111};
  assign T111 = rx_buff[3'h7/* 7*/:1'h1/* 1*/];
  assign T112 = {6'h0/* 0*/, rx_full, tx_empty};
  assign T113 = T114 || T55;
  assign T114 = io_ocp_M_Cmd == 3'b010/* 0*/;
  assign T115 = T55 ? 1'h1/* 1*/ : T116;
  assign T116 = T117 ? rx_full : 1'h0/* 0*/;
  assign T117 = io_ocp_M_Addr == T118;
  assign T118 = {31'h0/* 0*/, 1'h0/* 0*/};
  assign T119 = T120 == 1'h0/* 0*/;
  assign T120 = io_ocp_M_Addr[2'h2/* 2*/:2'h2/* 2*/];
  assign io_ocp_S_Resp = respReg;
  assign T121 = T114 ? 2'b01/* 0*/ : T122;
  assign T122 = {1'h0/* 0*/, T123};
  assign T123 = T37;

  always @(posedge clk) begin
    if(reset) begin
      tx_reg <= 1'h1/* 1*/;
    end else if(T0) begin
      tx_reg <= T40;
    end
    if(reset) begin
      tx_empty <= 1'h1/* 1*/;
    end else if(T4) begin
      tx_empty <= T38;
    end
    if(reset) begin
      tx_counter <= 4'h0/* 0*/;
    end else if(T8) begin
      tx_counter <= T27;
    end
    if(reset) begin
      tx_baud_tick <= 1'h0/* 0*/;
    end else if(T12) begin
      tx_baud_tick <= T20;
    end
    if(reset) begin
      tx_baud_counter <= 10'h0/* 0*/;
    end else if(T15) begin
      tx_baud_counter <= T16;
    end
    if(reset) begin
      tx_state <= 1'h0/* 0*/;
    end else if(T22) begin
      tx_state <= T26;
    end
    if(reset) begin
      tx_buff <= 10'h0/* 0*/;
    end else if(T43) begin
      tx_buff <= T45;
    end
    if(reset) begin
      tx_data <= 8'h0/* 0*/;
    end else if(T37) begin
      tx_data <= T48;
    end
    rdDataReg <= reset ? 8'h0/* 0*/ : T54;
    if(reset) begin
      rx_data <= 8'h0/* 0*/;
    end else if(T55) begin
      rx_data <= rx_buff;
    end
    rxd_reg2 <= reset ? 1'h1/* 1*/ : rxd_reg1;
    rxd_reg1 <= reset ? 1'h1/* 1*/ : rxd_reg0;
    rxd_reg0 <= reset ? 1'h1/* 1*/ : io_uartPins_rx;
    if(reset) begin
      rx_baud_tick <= 1'h0/* 0*/;
    end else if(T59) begin
      rx_baud_tick <= T108;
    end
    if(reset) begin
      rx_baud_counter <= 10'h0/* 0*/;
    end else if(T63) begin
      rx_baud_counter <= T102;
    end
    if(reset) begin
      rx_state <= 2'h0/* 0*/;
    end else if(T67) begin
      rx_state <= T84;
    end
    if(reset) begin
      rx_counter <= 3'h0/* 0*/;
    end else if(T72) begin
      rx_counter <= T91;
    end
    if(reset) begin
      rx_enable <= 1'h0/* 0*/;
    end else if(T98) begin
      rx_enable <= T100;
    end
    if(reset) begin
      rx_buff <= 8'h0/* 0*/;
    end else if(T72) begin
      rx_buff <= T110;
    end
    if(reset) begin
      rx_full <= 1'h0/* 0*/;
    end else if(T113) begin
      rx_full <= T115;
    end
    respReg <= reset ? 2'b00/* 0*/ : T121;
  end
endmodule

module Leds(input clk, input reset,
    input [2:0] io_ocp_M_Cmd,
    input [31:0] io_ocp_M_Addr,
    input [31:0] io_ocp_M_Data,
    input [3:0] io_ocp_M_ByteEn,
    output[1:0] io_ocp_S_Resp,
    output[31:0] io_ocp_S_Data,
    output[8:0] io_ledsPins_led
);

  reg[8:0] ledReg;
  wire T0;
  wire[8:0] T1;
  wire[31:0] T2;
  reg[1:0] respReg;
  wire[1:0] T3;
  wire[1:0] T4;
  wire T5;
  wire T6;

  assign io_ledsPins_led = ledReg;
  assign T0 = io_ocp_M_Cmd == 3'b001/* 0*/;
  assign T1 = io_ocp_M_Data[4'h8/* 8*/:1'h0/* 0*/];
  assign io_ocp_S_Data = T2;
  assign T2 = {23'h0/* 0*/, ledReg};
  assign io_ocp_S_Resp = respReg;
  assign T3 = T6 ? 2'b01/* 0*/ : T4;
  assign T4 = {1'h0/* 0*/, T5};
  assign T5 = T0;
  assign T6 = io_ocp_M_Cmd == 3'b010/* 0*/;

  always @(posedge clk) begin
    if(reset) begin
      ledReg <= 9'h0/* 0*/;
    end else if(T0) begin
      ledReg <= T1;
    end
    respReg <= reset ? 2'b00/* 0*/ : T3;
  end
endmodule

module InOut(input clk, input reset,
    input [2:0] io_memInOut_M_Cmd,
    input [31:0] io_memInOut_M_Addr,
    input [31:0] io_memInOut_M_Data,
    input [3:0] io_memInOut_M_ByteEn,
    output[1:0] io_memInOut_S_Resp,
    output[31:0] io_memInOut_S_Data,
    output[2:0] io_comConf_M_Cmd,
    output[31:0] io_comConf_M_Addr,
    output[31:0] io_comConf_M_Data,
    output[3:0] io_comConf_M_ByteEn,
    output io_comConf_M_RespAccept,
    input [1:0] io_comConf_S_Resp,
    input [31:0] io_comConf_S_Data,
    input  io_comConf_S_CmdAccept,
    output[2:0] io_comSpm_M_Cmd,
    output[31:0] io_comSpm_M_Addr,
    output[31:0] io_comSpm_M_Data,
    output[3:0] io_comSpm_M_ByteEn,
    input [1:0] comSpmS_Resp,
    input [31:0] comSpmS_Data,
    input [31:0] io_cpuInfoPins_id,
    output io_uartPins_tx,
    input  io_uartPins_rx,
    output[8:0] io_ledsPins_led
);

  wire[2:0] T0;
  wire selDeviceVec_9;
  wire T1;
  wire T2;
  wire[3:0] T3;
  wire selIO;
  wire[3:0] T4;
  wire[2:0] T5;
  wire selDeviceVec_8;
  wire T6;
  wire T7;
  wire[3:0] T8;
  wire[2:0] T9;
  wire selDeviceVec_2;
  wire T10;
  wire T11;
  wire[3:0] T12;
  wire[3:0] T13;
  wire[2:0] T14;
  wire selDeviceVec_0;
  wire T15;
  wire T16;
  wire[3:0] T17;
  wire[3:0] T18;
  reg[3:0] R19;
  wire T20;
  wire T21;
  wire comConfIO_io_slave_S_CmdAccept;
  wire T22;
  reg[2:0] R23;
  wire[2:0] T24;
  wire[2:0] comConf_io_master_M_Cmd;
  wire[3:0] T25;
  wire[3:0] T26;
  wire[3:0] comConf_io_master_M_ByteEn;
  reg[31:0] R27;
  wire[31:0] T28;
  wire[31:0] T29;
  wire[31:0] comConf_io_master_M_Data;
  reg[31:0] R30;
  wire[31:0] T31;
  wire[31:0] T32;
  wire[31:0] comConf_io_master_M_Addr;
  wire[31:0] comConfIO_io_slave_S_Data;
  wire[1:0] comConfIO_io_slave_S_Resp;
  wire[2:0] T33;
  wire selComConf;
  wire T34;
  wire T35;
  wire selNI;
  wire[3:0] T36;
  wire[10:0] T37;
  wire[2:0] T38;
  wire selSpm;
  wire T39;
  wire T40;
  wire T41;
  wire T42;
  wire T43;
  wire[8:0] Leds_io_ledsPins_led;
  wire Uart_io_uartPins_tx;
  wire[2:0] T44;
  wire selComSpm;
  wire T45;
  wire T46;
  wire comConfIO_io_master_M_RespAccept;
  wire[3:0] comConfIO_io_master_M_ByteEn;
  wire[31:0] comConfIO_io_master_M_Data;
  wire[31:0] comConfIO_io_master_M_Addr;
  wire[2:0] comConfIO_io_master_M_Cmd;
  wire[31:0] T47;
  wire[31:0] T48;
  wire[31:0] T49;
  wire[31:0] T50;
  wire[31:0] T51;
  wire[31:0] T52;
  wire[31:0] T53;
  wire[31:0] T54;
  wire[31:0] T55;
  wire[31:0] T56;
  wire[31:0] T57;
  wire[31:0] T58;
  wire[31:0] T59;
  wire[31:0] T60;
  wire[31:0] T61;
  wire[31:0] T62;
  wire[31:0] T63;
  wire[31:0] T64;
  wire[31:0] spm_io_S_Data;
  wire[31:0] comConf_io_slave_S_Data;
  reg[0:0] selComConfReg;
  wire T65;
  reg[0:0] selComSpmReg;
  wire[31:0] deviceSVec_0_Data;
  wire[31:0] CpuInfo_io_ocp_S_Data;
  reg[0:0] selDeviceReg_0;
  wire[31:0] deviceSVec_1_Data;
  wire[31:0] T66;
  wire[31:0] T67;
  reg[0:0] selDeviceReg_1;
  wire selDeviceVec_1;
  wire T68;
  wire T69;
  wire[3:0] T70;
  wire[3:0] T71;
  wire[31:0] deviceSVec_2_Data;
  wire[31:0] Timer_io_ocp_S_Data;
  reg[0:0] selDeviceReg_2;
  wire[31:0] deviceSVec_3_Data;
  wire[31:0] T72;
  wire[31:0] T73;
  reg[0:0] selDeviceReg_3;
  wire selDeviceVec_3;
  wire T74;
  wire T75;
  wire[3:0] T76;
  wire[3:0] T77;
  wire[31:0] deviceSVec_4_Data;
  wire[31:0] T78;
  wire[31:0] T79;
  reg[0:0] selDeviceReg_4;
  wire selDeviceVec_4;
  wire T80;
  wire T81;
  wire[3:0] T82;
  wire[3:0] T83;
  wire[31:0] deviceSVec_5_Data;
  wire[31:0] T84;
  wire[31:0] T85;
  reg[0:0] selDeviceReg_5;
  wire selDeviceVec_5;
  wire T86;
  wire T87;
  wire[3:0] T88;
  wire[3:0] T89;
  wire[31:0] deviceSVec_6_Data;
  wire[31:0] T90;
  wire[31:0] T91;
  reg[0:0] selDeviceReg_6;
  wire selDeviceVec_6;
  wire T92;
  wire T93;
  wire[3:0] T94;
  wire[3:0] T95;
  wire[31:0] deviceSVec_7_Data;
  wire[31:0] T96;
  wire[31:0] T97;
  reg[0:0] selDeviceReg_7;
  wire selDeviceVec_7;
  wire T98;
  wire T99;
  wire[3:0] T100;
  wire[3:0] T101;
  wire[31:0] deviceSVec_8_Data;
  wire[31:0] Uart_io_ocp_S_Data;
  reg[0:0] selDeviceReg_8;
  wire[31:0] deviceSVec_9_Data;
  wire[31:0] Leds_io_ocp_S_Data;
  reg[0:0] selDeviceReg_9;
  wire[31:0] deviceSVec_10_Data;
  wire[31:0] T102;
  wire[31:0] T103;
  reg[0:0] selDeviceReg_10;
  wire selDeviceVec_10;
  wire T104;
  wire T105;
  wire[3:0] T106;
  wire[31:0] deviceSVec_11_Data;
  wire[31:0] T107;
  wire[31:0] T108;
  reg[0:0] selDeviceReg_11;
  wire selDeviceVec_11;
  wire T109;
  wire T110;
  wire[3:0] T111;
  wire[31:0] deviceSVec_12_Data;
  wire[31:0] T112;
  wire[31:0] T113;
  reg[0:0] selDeviceReg_12;
  wire selDeviceVec_12;
  wire T114;
  wire T115;
  wire[3:0] T116;
  wire[31:0] deviceSVec_13_Data;
  wire[31:0] T117;
  wire[31:0] T118;
  reg[0:0] selDeviceReg_13;
  wire selDeviceVec_13;
  wire T119;
  wire T120;
  wire[3:0] T121;
  wire[31:0] deviceSVec_14_Data;
  wire[31:0] T122;
  wire[31:0] T123;
  reg[0:0] selDeviceReg_14;
  wire selDeviceVec_14;
  wire T124;
  wire T125;
  wire[3:0] T126;
  wire[31:0] deviceSVec_15_Data;
  wire[31:0] T127;
  wire[31:0] T128;
  reg[0:0] selDeviceReg_15;
  wire selDeviceVec_15;
  wire T129;
  wire T130;
  wire[3:0] T131;
  wire[1:0] T132;
  wire[1:0] T133;
  wire[1:0] deviceSVec_15_Resp;
  wire[1:0] T134;
  wire[1:0] T135;
  wire[1:0] deviceSVec_14_Resp;
  wire[1:0] T136;
  wire[1:0] T137;
  wire[1:0] deviceSVec_13_Resp;
  wire[1:0] T138;
  wire[1:0] T139;
  wire[1:0] deviceSVec_12_Resp;
  wire[1:0] T140;
  wire[1:0] T141;
  wire[1:0] deviceSVec_11_Resp;
  wire[1:0] T142;
  wire[1:0] T143;
  wire[1:0] deviceSVec_10_Resp;
  wire[1:0] T144;
  wire[1:0] T145;
  wire[1:0] deviceSVec_9_Resp;
  wire[1:0] Leds_io_ocp_S_Resp;
  wire[1:0] T146;
  wire[1:0] deviceSVec_8_Resp;
  wire[1:0] Uart_io_ocp_S_Resp;
  wire[1:0] T147;
  wire[1:0] deviceSVec_7_Resp;
  wire[1:0] T148;
  wire[1:0] T149;
  wire[1:0] deviceSVec_6_Resp;
  wire[1:0] T150;
  wire[1:0] T151;
  wire[1:0] deviceSVec_5_Resp;
  wire[1:0] T152;
  wire[1:0] T153;
  wire[1:0] deviceSVec_4_Resp;
  wire[1:0] T154;
  wire[1:0] T155;
  wire[1:0] deviceSVec_3_Resp;
  wire[1:0] T156;
  wire[1:0] T157;
  wire[1:0] deviceSVec_2_Resp;
  wire[1:0] Timer_io_ocp_S_Resp;
  wire[1:0] T158;
  wire[1:0] deviceSVec_1_Resp;
  wire[1:0] T159;
  wire[1:0] T160;
  wire[1:0] deviceSVec_0_Resp;
  wire[1:0] CpuInfo_io_ocp_S_Resp;
  wire[1:0] T161;
  wire[1:0] T162;
  wire[1:0] comConf_io_slave_S_Resp;
  wire[1:0] T163;
  wire[1:0] spm_io_S_Resp;
  wire[1:0] ispmResp;
  wire T164;
  reg[2:0] ispmCmdReg;
  wire[2:0] T165;
  wire selISpm;
  wire T166;
  wire T167;
  wire T168;
  wire T169;
  wire T170;

  assign T0 = selDeviceVec_9 ? io_memInOut_M_Cmd : 3'b000/* 0*/;
  assign selDeviceVec_9 = T1;
  assign T1 = selIO & T2;
  assign T2 = T3 == 4'h9/* 9*/;
  assign T3 = io_memInOut_M_Addr[4'hb/* 11*/:4'h8/* 8*/];
  assign selIO = T4 == 4'b1111/* 0*/;
  assign T4 = io_memInOut_M_Addr[5'h1f/* 31*/:5'h1c/* 28*/];
  assign T5 = selDeviceVec_8 ? io_memInOut_M_Cmd : 3'b000/* 0*/;
  assign selDeviceVec_8 = T6;
  assign T6 = selIO & T7;
  assign T7 = T8 == 4'h8/* 8*/;
  assign T8 = io_memInOut_M_Addr[4'hb/* 11*/:4'h8/* 8*/];
  assign T9 = selDeviceVec_2 ? io_memInOut_M_Cmd : 3'b000/* 0*/;
  assign selDeviceVec_2 = T10;
  assign T10 = selIO & T11;
  assign T11 = T13 == T12;
  assign T12 = {2'h0/* 0*/, 2'h2/* 2*/};
  assign T13 = io_memInOut_M_Addr[4'hb/* 11*/:4'h8/* 8*/];
  assign T14 = selDeviceVec_0 ? io_memInOut_M_Cmd : 3'b000/* 0*/;
  assign selDeviceVec_0 = T15;
  assign T15 = selIO & T16;
  assign T16 = T18 == T17;
  assign T17 = {3'h0/* 0*/, 1'h0/* 0*/};
  assign T18 = io_memInOut_M_Addr[4'hb/* 11*/:4'h8/* 8*/];
  assign T20 = T22 || T21;
  assign T21 = comConfIO_io_slave_S_CmdAccept == 1'h1/* 1*/;
  assign T22 = R23 == 3'b000/* 0*/;
  assign T24 = 3'b000/* 0*/;
  assign T25 = T26;
  assign T26 = {3'h0/* 0*/, 1'h0/* 0*/};
  assign T28 = T29;
  assign T29 = {31'h0/* 0*/, 1'h0/* 0*/};
  assign T31 = T32;
  assign T32 = {31'h0/* 0*/, 1'h0/* 0*/};
  assign T33 = selComConf ? io_memInOut_M_Cmd : 3'b000/* 0*/;
  assign selComConf = selNI & T34;
  assign T34 = T35 == 1'b0/* 0*/;
  assign T35 = io_memInOut_M_Addr[5'h1b/* 27*/:5'h1b/* 27*/];
  assign selNI = T36 == 4'b1110/* 0*/;
  assign T36 = io_memInOut_M_Addr[5'h1f/* 31*/:5'h1c/* 28*/];
  assign T37 = io_memInOut_M_Addr[4'ha/* 10*/:1'h0/* 0*/];
  assign T38 = selSpm ? io_memInOut_M_Cmd : 3'b000/* 0*/;
  assign selSpm = T41 & T39;
  assign T39 = T40 == 1'h0/* 0*/;
  assign T40 = io_memInOut_M_Addr[5'h10/* 16*/:5'h10/* 16*/];
  assign T41 = T43 & T42;
  assign T42 = ! selNI;
  assign T43 = ! selIO;
  assign io_ledsPins_led = Leds_io_ledsPins_led;
  assign io_uartPins_tx = Uart_io_uartPins_tx;
  assign io_comSpm_M_ByteEn = io_memInOut_M_ByteEn;
  assign io_comSpm_M_Data = io_memInOut_M_Data;
  assign io_comSpm_M_Addr = io_memInOut_M_Addr;
  assign io_comSpm_M_Cmd = T44;
  assign T44 = selComSpm ? io_memInOut_M_Cmd : 3'b000/* 0*/;
  assign selComSpm = selNI & T45;
  assign T45 = T46 == 1'b1/* 0*/;
  assign T46 = io_memInOut_M_Addr[5'h1b/* 27*/:5'h1b/* 27*/];
  assign io_comConf_M_RespAccept = comConfIO_io_master_M_RespAccept;
  assign io_comConf_M_ByteEn = comConfIO_io_master_M_ByteEn;
  assign io_comConf_M_Data = comConfIO_io_master_M_Data;
  assign io_comConf_M_Addr = comConfIO_io_master_M_Addr;
  assign io_comConf_M_Cmd = comConfIO_io_master_M_Cmd;
  assign io_memInOut_S_Data = T47;
  assign T47 = selDeviceReg_15 ? deviceSVec_15_Data : T48;
  assign T48 = selDeviceReg_14 ? deviceSVec_14_Data : T49;
  assign T49 = selDeviceReg_13 ? deviceSVec_13_Data : T50;
  assign T50 = selDeviceReg_12 ? deviceSVec_12_Data : T51;
  assign T51 = selDeviceReg_11 ? deviceSVec_11_Data : T52;
  assign T52 = selDeviceReg_10 ? deviceSVec_10_Data : T53;
  assign T53 = selDeviceReg_9 ? deviceSVec_9_Data : T54;
  assign T54 = selDeviceReg_8 ? deviceSVec_8_Data : T55;
  assign T55 = selDeviceReg_7 ? deviceSVec_7_Data : T56;
  assign T56 = selDeviceReg_6 ? deviceSVec_6_Data : T57;
  assign T57 = selDeviceReg_5 ? deviceSVec_5_Data : T58;
  assign T58 = selDeviceReg_4 ? deviceSVec_4_Data : T59;
  assign T59 = selDeviceReg_3 ? deviceSVec_3_Data : T60;
  assign T60 = selDeviceReg_2 ? deviceSVec_2_Data : T61;
  assign T61 = selDeviceReg_1 ? deviceSVec_1_Data : T62;
  assign T62 = selDeviceReg_0 ? deviceSVec_0_Data : T63;
  assign T63 = selComSpmReg ? comSpmS_Data : T64;
  assign T64 = selComConfReg ? comConf_io_slave_S_Data : spm_io_S_Data;
  assign T65 = io_memInOut_M_Cmd != 3'b000/* 0*/;
  assign deviceSVec_0_Data = CpuInfo_io_ocp_S_Data;
  assign deviceSVec_1_Data = T66;
  assign T66 = T67;
  assign T67 = {31'h0/* 0*/, 1'h0/* 0*/};
  assign selDeviceVec_1 = T68;
  assign T68 = selIO & T69;
  assign T69 = T71 == T70;
  assign T70 = {3'h0/* 0*/, 1'h1/* 1*/};
  assign T71 = io_memInOut_M_Addr[4'hb/* 11*/:4'h8/* 8*/];
  assign deviceSVec_2_Data = Timer_io_ocp_S_Data;
  assign deviceSVec_3_Data = T72;
  assign T72 = T73;
  assign T73 = {31'h0/* 0*/, 1'h0/* 0*/};
  assign selDeviceVec_3 = T74;
  assign T74 = selIO & T75;
  assign T75 = T77 == T76;
  assign T76 = {2'h0/* 0*/, 2'h3/* 3*/};
  assign T77 = io_memInOut_M_Addr[4'hb/* 11*/:4'h8/* 8*/];
  assign deviceSVec_4_Data = T78;
  assign T78 = T79;
  assign T79 = {31'h0/* 0*/, 1'h0/* 0*/};
  assign selDeviceVec_4 = T80;
  assign T80 = selIO & T81;
  assign T81 = T83 == T82;
  assign T82 = {1'h0/* 0*/, 3'h4/* 4*/};
  assign T83 = io_memInOut_M_Addr[4'hb/* 11*/:4'h8/* 8*/];
  assign deviceSVec_5_Data = T84;
  assign T84 = T85;
  assign T85 = {31'h0/* 0*/, 1'h0/* 0*/};
  assign selDeviceVec_5 = T86;
  assign T86 = selIO & T87;
  assign T87 = T89 == T88;
  assign T88 = {1'h0/* 0*/, 3'h5/* 5*/};
  assign T89 = io_memInOut_M_Addr[4'hb/* 11*/:4'h8/* 8*/];
  assign deviceSVec_6_Data = T90;
  assign T90 = T91;
  assign T91 = {31'h0/* 0*/, 1'h0/* 0*/};
  assign selDeviceVec_6 = T92;
  assign T92 = selIO & T93;
  assign T93 = T95 == T94;
  assign T94 = {1'h0/* 0*/, 3'h6/* 6*/};
  assign T95 = io_memInOut_M_Addr[4'hb/* 11*/:4'h8/* 8*/];
  assign deviceSVec_7_Data = T96;
  assign T96 = T97;
  assign T97 = {31'h0/* 0*/, 1'h0/* 0*/};
  assign selDeviceVec_7 = T98;
  assign T98 = selIO & T99;
  assign T99 = T101 == T100;
  assign T100 = {1'h0/* 0*/, 3'h7/* 7*/};
  assign T101 = io_memInOut_M_Addr[4'hb/* 11*/:4'h8/* 8*/];
  assign deviceSVec_8_Data = Uart_io_ocp_S_Data;
  assign deviceSVec_9_Data = Leds_io_ocp_S_Data;
  assign deviceSVec_10_Data = T102;
  assign T102 = T103;
  assign T103 = {31'h0/* 0*/, 1'h0/* 0*/};
  assign selDeviceVec_10 = T104;
  assign T104 = selIO & T105;
  assign T105 = T106 == 4'ha/* 10*/;
  assign T106 = io_memInOut_M_Addr[4'hb/* 11*/:4'h8/* 8*/];
  assign deviceSVec_11_Data = T107;
  assign T107 = T108;
  assign T108 = {31'h0/* 0*/, 1'h0/* 0*/};
  assign selDeviceVec_11 = T109;
  assign T109 = selIO & T110;
  assign T110 = T111 == 4'hb/* 11*/;
  assign T111 = io_memInOut_M_Addr[4'hb/* 11*/:4'h8/* 8*/];
  assign deviceSVec_12_Data = T112;
  assign T112 = T113;
  assign T113 = {31'h0/* 0*/, 1'h0/* 0*/};
  assign selDeviceVec_12 = T114;
  assign T114 = selIO & T115;
  assign T115 = T116 == 4'hc/* 12*/;
  assign T116 = io_memInOut_M_Addr[4'hb/* 11*/:4'h8/* 8*/];
  assign deviceSVec_13_Data = T117;
  assign T117 = T118;
  assign T118 = {31'h0/* 0*/, 1'h0/* 0*/};
  assign selDeviceVec_13 = T119;
  assign T119 = selIO & T120;
  assign T120 = T121 == 4'hd/* 13*/;
  assign T121 = io_memInOut_M_Addr[4'hb/* 11*/:4'h8/* 8*/];
  assign deviceSVec_14_Data = T122;
  assign T122 = T123;
  assign T123 = {31'h0/* 0*/, 1'h0/* 0*/};
  assign selDeviceVec_14 = T124;
  assign T124 = selIO & T125;
  assign T125 = T126 == 4'he/* 14*/;
  assign T126 = io_memInOut_M_Addr[4'hb/* 11*/:4'h8/* 8*/];
  assign deviceSVec_15_Data = T127;
  assign T127 = T128;
  assign T128 = {31'h0/* 0*/, 1'h0/* 0*/};
  assign selDeviceVec_15 = T129;
  assign T129 = selIO & T130;
  assign T130 = T131 == 4'hf/* 15*/;
  assign T131 = io_memInOut_M_Addr[4'hb/* 11*/:4'h8/* 8*/];
  assign io_memInOut_S_Resp = T132;
  assign T132 = T161 | T133;
  assign T133 = T135 | deviceSVec_15_Resp;
  assign deviceSVec_15_Resp = T134;
  assign T134 = 2'b00/* 0*/;
  assign T135 = T137 | deviceSVec_14_Resp;
  assign deviceSVec_14_Resp = T136;
  assign T136 = 2'b00/* 0*/;
  assign T137 = T139 | deviceSVec_13_Resp;
  assign deviceSVec_13_Resp = T138;
  assign T138 = 2'b00/* 0*/;
  assign T139 = T141 | deviceSVec_12_Resp;
  assign deviceSVec_12_Resp = T140;
  assign T140 = 2'b00/* 0*/;
  assign T141 = T143 | deviceSVec_11_Resp;
  assign deviceSVec_11_Resp = T142;
  assign T142 = 2'b00/* 0*/;
  assign T143 = T145 | deviceSVec_10_Resp;
  assign deviceSVec_10_Resp = T144;
  assign T144 = 2'b00/* 0*/;
  assign T145 = T146 | deviceSVec_9_Resp;
  assign deviceSVec_9_Resp = Leds_io_ocp_S_Resp;
  assign T146 = T147 | deviceSVec_8_Resp;
  assign deviceSVec_8_Resp = Uart_io_ocp_S_Resp;
  assign T147 = T149 | deviceSVec_7_Resp;
  assign deviceSVec_7_Resp = T148;
  assign T148 = 2'b00/* 0*/;
  assign T149 = T151 | deviceSVec_6_Resp;
  assign deviceSVec_6_Resp = T150;
  assign T150 = 2'b00/* 0*/;
  assign T151 = T153 | deviceSVec_5_Resp;
  assign deviceSVec_5_Resp = T152;
  assign T152 = 2'b00/* 0*/;
  assign T153 = T155 | deviceSVec_4_Resp;
  assign deviceSVec_4_Resp = T154;
  assign T154 = 2'b00/* 0*/;
  assign T155 = T157 | deviceSVec_3_Resp;
  assign deviceSVec_3_Resp = T156;
  assign T156 = 2'b00/* 0*/;
  assign T157 = T158 | deviceSVec_2_Resp;
  assign deviceSVec_2_Resp = Timer_io_ocp_S_Resp;
  assign T158 = T160 | deviceSVec_1_Resp;
  assign deviceSVec_1_Resp = T159;
  assign T159 = 2'b00/* 0*/;
  assign T160 = 2'b00/* 0*/ | deviceSVec_0_Resp;
  assign deviceSVec_0_Resp = CpuInfo_io_ocp_S_Resp;
  assign T161 = T162 | comSpmS_Resp;
  assign T162 = T163 | comConf_io_slave_S_Resp;
  assign T163 = ispmResp | spm_io_S_Resp;
  assign ispmResp = T164 ? 2'b00/* 0*/ : 2'b01/* 0*/;
  assign T164 = ispmCmdReg == 3'b000/* 0*/;
  assign T165 = selISpm ? io_memInOut_M_Cmd : 3'b000/* 0*/;
  assign selISpm = T168 & T166;
  assign T166 = T167 == 1'h1/* 1*/;
  assign T167 = io_memInOut_M_Addr[5'h10/* 16*/:5'h10/* 16*/];
  assign T168 = T170 & T169;
  assign T169 = ! selNI;
  assign T170 = ! selIO;
  Spm spm(.clk(clk),
       .io_M_Cmd( T38 ),
       .io_M_Addr( T37 ),
       .io_M_Data( io_memInOut_M_Data ),
       .io_M_ByteEn( io_memInOut_M_ByteEn ),
       .io_S_Resp( spm_io_S_Resp ),
       .io_S_Data( spm_io_S_Data )
  );
  OcpCoreBus comConf(
       .io_slave_M_Cmd( T33 ),
       .io_slave_M_Addr( io_memInOut_M_Addr ),
       .io_slave_M_Data( io_memInOut_M_Data ),
       .io_slave_M_ByteEn( io_memInOut_M_ByteEn ),
       .io_slave_S_Resp( comConf_io_slave_S_Resp ),
       .io_slave_S_Data( comConf_io_slave_S_Data ),
       .io_master_M_Cmd( comConf_io_master_M_Cmd ),
       .io_master_M_Addr( comConf_io_master_M_Addr ),
       .io_master_M_Data( comConf_io_master_M_Data ),
       .io_master_M_ByteEn( comConf_io_master_M_ByteEn ),
       .io_master_S_Resp( comConfIO_io_slave_S_Resp ),
       .io_master_S_Data( comConfIO_io_slave_S_Data )
  );
  OcpIOBus comConfIO(
       .io_slave_M_Cmd( R23 ),
       .io_slave_M_Addr( R30 ),
       .io_slave_M_Data( R27 ),
       .io_slave_M_ByteEn( R19 ),
       .io_slave_M_RespAccept( 1'b1/* 0*/ ),
       .io_slave_S_Resp( comConfIO_io_slave_S_Resp ),
       .io_slave_S_Data( comConfIO_io_slave_S_Data ),
       .io_slave_S_CmdAccept( comConfIO_io_slave_S_CmdAccept ),
       .io_master_M_Cmd( comConfIO_io_master_M_Cmd ),
       .io_master_M_Addr( comConfIO_io_master_M_Addr ),
       .io_master_M_Data( comConfIO_io_master_M_Data ),
       .io_master_M_ByteEn( comConfIO_io_master_M_ByteEn ),
       .io_master_M_RespAccept( comConfIO_io_master_M_RespAccept ),
       .io_master_S_Resp( io_comConf_S_Resp ),
       .io_master_S_Data( io_comConf_S_Data ),
       .io_master_S_CmdAccept( io_comConf_S_CmdAccept )
  );
  CpuInfo CpuInfo(.clk(clk),
       .io_ocp_M_Cmd( T14 ),
       .io_ocp_M_Addr( io_memInOut_M_Addr ),
       .io_ocp_M_Data( io_memInOut_M_Data ),
       .io_ocp_M_ByteEn( io_memInOut_M_ByteEn ),
       .io_ocp_S_Resp( CpuInfo_io_ocp_S_Resp ),
       .io_ocp_S_Data( CpuInfo_io_ocp_S_Data ),
       .io_cpuInfoPins_id( io_cpuInfoPins_id )
  );
  Timer Timer(.clk(clk), .reset(reset),
       .io_ocp_M_Cmd( T9 ),
       .io_ocp_M_Addr( io_memInOut_M_Addr ),
       .io_ocp_M_Data( io_memInOut_M_Data ),
       .io_ocp_M_ByteEn( io_memInOut_M_ByteEn ),
       .io_ocp_S_Resp( Timer_io_ocp_S_Resp ),
       .io_ocp_S_Data( Timer_io_ocp_S_Data )
  );
  Uart Uart(.clk(clk), .reset(reset),
       .io_ocp_M_Cmd( T5 ),
       .io_ocp_M_Addr( io_memInOut_M_Addr ),
       .io_ocp_M_Data( io_memInOut_M_Data ),
       .io_ocp_M_ByteEn( io_memInOut_M_ByteEn ),
       .io_ocp_S_Resp( Uart_io_ocp_S_Resp ),
       .io_ocp_S_Data( Uart_io_ocp_S_Data ),
       .io_uartPins_tx( Uart_io_uartPins_tx ),
       .io_uartPins_rx( io_uartPins_rx )
  );
  Leds Leds(.clk(clk), .reset(reset),
       .io_ocp_M_Cmd( T0 ),
       .io_ocp_M_Addr( io_memInOut_M_Addr ),
       .io_ocp_M_Data( io_memInOut_M_Data ),
       .io_ocp_M_ByteEn( io_memInOut_M_ByteEn ),
       .io_ocp_S_Resp( Leds_io_ocp_S_Resp ),
       .io_ocp_S_Data( Leds_io_ocp_S_Data ),
       .io_ledsPins_led( Leds_io_ledsPins_led )
  );

  always @(posedge clk) begin
    if(reset) begin
      R19 <= T25;
    end else if(T20) begin
      R19 <= comConf_io_master_M_ByteEn;
    end
    if(reset) begin
      R23 <= T24;
    end else if(T20) begin
      R23 <= comConf_io_master_M_Cmd;
    end
    if(reset) begin
      R27 <= T28;
    end else if(T20) begin
      R27 <= comConf_io_master_M_Data;
    end
    if(reset) begin
      R30 <= T31;
    end else if(T20) begin
      R30 <= comConf_io_master_M_Addr;
    end
    if(reset) begin
      selComConfReg <= 1'h0/* 0*/;
    end else if(T65) begin
      selComConfReg <= selComConf;
    end
    if(reset) begin
      selComSpmReg <= 1'h0/* 0*/;
    end else if(T65) begin
      selComSpmReg <= selComSpm;
    end
    if(T65) begin
      selDeviceReg_0 <= selDeviceVec_0;
    end
    if(T65) begin
      selDeviceReg_1 <= selDeviceVec_1;
    end
    if(T65) begin
      selDeviceReg_2 <= selDeviceVec_2;
    end
    if(T65) begin
      selDeviceReg_3 <= selDeviceVec_3;
    end
    if(T65) begin
      selDeviceReg_4 <= selDeviceVec_4;
    end
    if(T65) begin
      selDeviceReg_5 <= selDeviceVec_5;
    end
    if(T65) begin
      selDeviceReg_6 <= selDeviceVec_6;
    end
    if(T65) begin
      selDeviceReg_7 <= selDeviceVec_7;
    end
    if(T65) begin
      selDeviceReg_8 <= selDeviceVec_8;
    end
    if(T65) begin
      selDeviceReg_9 <= selDeviceVec_9;
    end
    if(T65) begin
      selDeviceReg_10 <= selDeviceVec_10;
    end
    if(T65) begin
      selDeviceReg_11 <= selDeviceVec_11;
    end
    if(T65) begin
      selDeviceReg_12 <= selDeviceVec_12;
    end
    if(T65) begin
      selDeviceReg_13 <= selDeviceVec_13;
    end
    if(T65) begin
      selDeviceReg_14 <= selDeviceVec_14;
    end
    if(T65) begin
      selDeviceReg_15 <= selDeviceVec_15;
    end
    ispmCmdReg <= T165;
  end
endmodule

module BootMem(input clk, input reset,
    input [2:0] io_memInOut_M_Cmd,
    input [31:0] io_memInOut_M_Addr,
    input [31:0] io_memInOut_M_Data,
    input [3:0] io_memInOut_M_ByteEn,
    input [1:0] io_memInOut_M_AddrSpace,
    output[1:0] io_memInOut_S_Resp,
    output[31:0] io_memInOut_S_Data,
    output[2:0] io_extMem_M_Cmd,
    output[31:0] io_extMem_M_Addr,
    output[31:0] io_extMem_M_Data,
    output[3:0] io_extMem_M_ByteEn,
    output[1:0] io_extMem_M_AddrSpace,
    input [1:0] io_extMem_S_Resp,
    input [31:0] io_extMem_S_Data
);

  wire[10:0] T0;
  wire[2:0] T1;
  wire selSpm;
  wire T2;
  wire T3;
  wire T4;
  wire selExt;
  wire T5;
  wire[2:0] T6;
  wire[31:0] T7;
  wire[31:0] T8;
  wire[31:0] spm_io_S_Data;
  reg[0:0] selSpmReg;
  wire T9;
  wire[31:0] T10;
  reg [31:0] rom [0:0];
  wire T11;
  reg[31:0] romAddr;
  reg[0:0] selRomReg;
  wire selRom;
  wire T12;
  wire T13;
  wire T14;
  wire[1:0] T15;
  wire[1:0] T16;
  wire[1:0] spm_io_S_Resp;
  wire[1:0] romResp;
  wire T17;
  reg[2:0] romCmdReg;
  wire[2:0] T18;

  assign T0 = io_memInOut_M_Addr[4'ha/* 10*/:1'h0/* 0*/];
  assign T1 = selSpm ? io_memInOut_M_Cmd : 3'b000/* 0*/;
  assign selSpm = T4 & T2;
  assign T2 = T3 == 1'h1/* 1*/;
  assign T3 = io_memInOut_M_Addr[5'h10/* 16*/:5'h10/* 16*/];
  assign T4 = ! selExt;
  assign selExt = T5 == 1'b0/* 0*/;
  assign T5 = io_memInOut_M_Addr[5'h1f/* 31*/:5'h1f/* 31*/];
  assign io_extMem_M_AddrSpace = io_memInOut_M_AddrSpace;
  assign io_extMem_M_ByteEn = io_memInOut_M_ByteEn;
  assign io_extMem_M_Data = io_memInOut_M_Data;
  assign io_extMem_M_Addr = io_memInOut_M_Addr;
  assign io_extMem_M_Cmd = T6;
  assign T6 = selExt ? io_memInOut_M_Cmd : 3'b000/* 0*/;
  assign io_memInOut_S_Data = T7;
  assign T7 = selRomReg ? T10 : T8;
  assign T8 = selSpmReg ? spm_io_S_Data : io_extMem_S_Data;
  assign T9 = io_memInOut_M_Cmd != 3'b000/* 0*/;
  assign T10 = rom[T11];
  initial begin
    rom[0] = 32'h0/* 0*/;
  end
  assign T11 = romAddr[2'h2/* 2*/:2'h2/* 2*/];
  assign selRom = T14 & T12;
  assign T12 = T13 == 1'h0/* 0*/;
  assign T13 = io_memInOut_M_Addr[5'h10/* 16*/:5'h10/* 16*/];
  assign T14 = ! selExt;
  assign io_memInOut_S_Resp = T15;
  assign T15 = T16 | io_extMem_S_Resp;
  assign T16 = romResp | spm_io_S_Resp;
  assign romResp = T17 ? 2'b00/* 0*/ : 2'b01/* 0*/;
  assign T17 = romCmdReg == 3'b000/* 0*/;
  assign T18 = selRom ? io_memInOut_M_Cmd : 3'b000/* 0*/;
  Spm spm(.clk(clk),
       .io_M_Cmd( T1 ),
       .io_M_Addr( T0 ),
       .io_M_Data( io_memInOut_M_Data ),
       .io_M_ByteEn( io_memInOut_M_ByteEn ),
       .io_S_Resp( spm_io_S_Resp ),
       .io_S_Data( spm_io_S_Data )
  );

  always @(posedge clk) begin
    if(reset) begin
      selSpmReg <= 1'h0/* 0*/;
    end else if(T9) begin
      selSpmReg <= selSpm;
    end
    romAddr <= io_memInOut_M_Addr;
    if(reset) begin
      selRomReg <= 1'h0/* 0*/;
    end else if(T9) begin
      selRomReg <= selRom;
    end
    romCmdReg <= T18;
  end
endmodule

module OcpBurstBus(
    input [2:0] io_slave_M_Cmd,
    input [31:0] io_slave_M_Addr,
    input [31:0] io_slave_M_Data,
    input  io_slave_M_DataValid,
    input [3:0] io_slave_M_DataByteEn,
    output[1:0] io_slave_S_Resp,
    output[31:0] io_slave_S_Data,
    output io_slave_S_CmdAccept,
    output io_slave_S_DataAccept,
    output[2:0] io_master_M_Cmd,
    output[31:0] io_master_M_Addr,
    output[31:0] io_master_M_Data,
    output io_master_M_DataValid,
    output[3:0] io_master_M_DataByteEn,
    input [1:0] io_master_S_Resp,
    input [31:0] io_master_S_Data,
    input  io_master_S_CmdAccept,
    input  io_master_S_DataAccept
);


  assign io_master_M_DataByteEn = io_slave_M_DataByteEn;
  assign io_master_M_DataValid = io_slave_M_DataValid;
  assign io_master_M_Data = io_slave_M_Data;
  assign io_master_M_Addr = io_slave_M_Addr;
  assign io_master_M_Cmd = io_slave_M_Cmd;
  assign io_slave_S_DataAccept = io_master_S_DataAccept;
  assign io_slave_S_CmdAccept = io_master_S_CmdAccept;
  assign io_slave_S_Data = io_master_S_Data;
  assign io_slave_S_Resp = io_master_S_Resp;
endmodule

module PatmosCore(input clk, input reset,
    output[31:0] io_dummy,
    output[2:0] io_comConf_M_Cmd,
    output[31:0] io_comConf_M_Addr,
    output[31:0] io_comConf_M_Data,
    output[3:0] io_comConf_M_ByteEn,
    output io_comConf_M_RespAccept,
    input [1:0] io_comConf_S_Resp,
    input [31:0] io_comConf_S_Data,
    input  io_comConf_S_CmdAccept,
    output[2:0] io_comSpm_M_Cmd,
    output[31:0] io_comSpm_M_Addr,
    output[31:0] io_comSpm_M_Data,
    output[3:0] io_comSpm_M_ByteEn,
    input [1:0] io_comSpm_S_Resp,
    input [31:0] io_comSpm_S_Data,
    output[2:0] io_memPort_M_Cmd,
    output[31:0] io_memPort_M_Addr,
    output[31:0] io_memPort_M_Data,
    output io_memPort_M_DataValid,
    output[3:0] io_memPort_M_DataByteEn,
    input [1:0] io_memPort_S_Resp,
    input [31:0] io_memPort_S_Data,
    input  io_memPort_S_CmdAccept,
    input  io_memPort_S_DataAccept,
    input [31:0] io_cpuInfoPins_id,
    output io_uartPins_tx,
    input  io_uartPins_rx,
    output[8:0] io_ledsPins_led
);

  wire[3:0] T0;
  wire[3:0] mcache_io_ocp_port_M_DataByteEn;
  wire[3:0] cacheToBurstBus_io_master_M_DataByteEn;
  wire T1;
  wire T2;
  reg[0:0] R3;
  wire T4;
  wire[2:0] cacheToBurstBus_io_master_M_Cmd;
  wire T5;
  wire[2:0] mcache_io_ocp_port_M_Cmd;
  wire T6;
  wire mcache_io_ocp_port_M_DataValid;
  wire cacheToBurstBus_io_master_M_DataValid;
  wire[31:0] T7;
  wire[31:0] mcache_io_ocp_port_M_Data;
  wire[31:0] cacheToBurstBus_io_master_M_Data;
  wire[31:0] T8;
  wire[31:0] mcache_io_ocp_port_M_Addr;
  wire[31:0] cacheToBurstBus_io_master_M_Addr;
  wire[2:0] T9;
  wire burstBus_io_slave_S_DataAccept;
  wire burstBus_io_slave_S_CmdAccept;
  wire[31:0] burstBus_io_slave_S_Data;
  wire[1:0] T10;
  wire[1:0] burstBus_io_slave_S_Resp;
  wire T11;
  wire[3:0] T12;
  wire[3:0] T13;
  reg[3:0] R14;
  wire T15;
  wire T16;
  wire T17;
  wire cacheToBurstBus_io_slave_S_CmdAccept;
  wire T18;
  reg[2:0] R19;
  wire T20;
  wire T21;
  reg[1:0] R22;
  wire T23;
  wire T24;
  wire[2:0] bootMem_io_extMem_M_Cmd;
  wire T25;
  wire T26;
  wire T27;
  wire T28;
  wire T29;
  reg[1:0] R30;
  wire T31;
  wire T32;
  wire T33;
  wire cacheToBurstBus_io_slave_S_DataAccept;
  wire T34;
  wire T35;
  wire[1:0] cacheToBurstBus_io_slave_S_Resp;
  wire T36;
  wire[1:0] T37;
  wire[1:0] T38;
  wire[1:0] T39;
  wire[1:0] T40;
  wire[1:0] T41;
  wire T42;
  wire T43;
  wire T44;
  wire T45;
  wire[1:0] T46;
  wire[1:0] T47;
  wire[1:0] T48;
  wire[1:0] T49;
  wire[2:0] T50;
  wire[2:0] T51;
  wire T52;
  wire[3:0] T53;
  wire[3:0] T54;
  wire[3:0] bootMem_io_extMem_M_ByteEn;
  wire T55;
  wire T56;
  reg[1:0] R57;
  wire T58;
  wire[1:0] T59;
  wire[1:0] T60;
  wire[31:0] bootMem_io_extMem_M_Addr;
  wire[1:0] T61;
  wire[31:0] T62;
  wire[31:0] T63;
  reg[31:0] R64;
  wire[31:0] T65;
  wire[31:0] T66;
  wire[31:0] bootMem_io_extMem_M_Data;
  wire[31:0] T67;
  wire[27:0] T68;
  reg[31:0] R69;
  wire[31:0] T70;
  wire[31:0] T71;
  wire[31:0] T72;
  wire[31:0] T73;
  wire[31:0] cacheToBurstBus_io_slave_S_Data;
  wire[31:0] T74;
  reg[31:0] R75;
  wire T76;
  wire T77;
  wire[31:0] T78;
  wire[31:0] T79;
  wire[1:0] T80;
  wire[1:0] T81;
  reg[1:0] R82;
  wire[1:0] T83;
  wire[1:0] memory_io_globalInOut_M_AddrSpace;
  wire[3:0] memory_io_globalInOut_M_ByteEn;
  wire[31:0] memory_io_globalInOut_M_Data;
  wire[31:0] memory_io_globalInOut_M_Addr;
  wire[2:0] memory_io_globalInOut_M_Cmd;
  wire[3:0] memory_io_localInOut_M_ByteEn;
  wire[31:0] memory_io_localInOut_M_Data;
  wire[31:0] memory_io_localInOut_M_Addr;
  wire[2:0] memory_io_localInOut_M_Cmd;
  wire[29:0] memory_io_memwb_pc;
  wire memory_io_memwb_rd_1_valid;
  wire[31:0] memory_io_memwb_rd_1_data;
  wire[4:0] memory_io_memwb_rd_1_addr;
  wire memory_io_memwb_rd_0_valid;
  wire[31:0] memory_io_memwb_rd_0_data;
  wire[4:0] memory_io_memwb_rd_0_addr;
  wire enable;
  wire mcache_io_ena_out;
  wire memory_io_ena_out;
  wire[31:0] bootMem_io_memInOut_S_Data;
  wire[1:0] bootMem_io_memInOut_S_Resp;
  wire[31:0] iocomp_io_memInOut_S_Data;
  wire[1:0] iocomp_io_memInOut_S_Resp;
  wire[10:0] fetch_io_femem_pc;
  wire[29:0] execute_io_exmem_pc;
  wire[31:0] execute_io_exmem_mem_callRetBase;
  wire[31:0] execute_io_exmem_mem_callRetAddr;
  wire execute_io_exmem_mem_brcf;
  wire execute_io_exmem_mem_ret;
  wire execute_io_exmem_mem_call;
  wire[31:0] execute_io_exmem_mem_data;
  wire[31:0] execute_io_exmem_mem_addr;
  wire[1:0] execute_io_exmem_mem_typ;
  wire execute_io_exmem_mem_zext;
  wire execute_io_exmem_mem_byte;
  wire execute_io_exmem_mem_hword;
  wire execute_io_exmem_mem_store;
  wire execute_io_exmem_mem_load;
  wire execute_io_exmem_rd_1_valid;
  wire[31:0] execute_io_exmem_rd_1_data;
  wire[4:0] execute_io_exmem_rd_1_addr;
  wire execute_io_exmem_rd_0_valid;
  wire[31:0] execute_io_exmem_rd_0_data;
  wire[4:0] execute_io_exmem_rd_0_addr;
  wire writeback_io_memResult_1_valid;
  wire[31:0] writeback_io_memResult_1_data;
  wire[4:0] writeback_io_memResult_1_addr;
  wire writeback_io_memResult_0_valid;
  wire[31:0] writeback_io_memResult_0_data;
  wire[4:0] writeback_io_memResult_0_addr;
  wire memory_io_exResult_1_valid;
  wire[31:0] memory_io_exResult_1_data;
  wire[4:0] memory_io_exResult_1_addr;
  wire memory_io_exResult_0_valid;
  wire[31:0] memory_io_exResult_0_data;
  wire[4:0] memory_io_exResult_0_addr;
  wire decode_io_decex_brcf;
  wire decode_io_decex_ret;
  wire decode_io_decex_call;
  wire[31:0] decode_io_decex_brcfAddr;
  wire[31:0] decode_io_decex_callAddr;
  wire decode_io_decex_wrRd_1;
  wire decode_io_decex_wrRd_0;
  wire decode_io_decex_immOp_1;
  wire decode_io_decex_immOp_0;
  wire[31:0] decode_io_decex_immVal_1;
  wire[31:0] decode_io_decex_immVal_0;
  wire[4:0] decode_io_decex_rdAddr_1;
  wire[4:0] decode_io_decex_rdAddr_0;
  wire[31:0] decode_io_decex_rsData_3;
  wire[31:0] decode_io_decex_rsData_2;
  wire[31:0] decode_io_decex_rsData_1;
  wire[31:0] decode_io_decex_rsData_0;
  wire[4:0] decode_io_decex_rsAddr_3;
  wire[4:0] decode_io_decex_rsAddr_2;
  wire[4:0] decode_io_decex_rsAddr_1;
  wire[4:0] decode_io_decex_rsAddr_0;
  wire[1:0] decode_io_decex_memOp_typ;
  wire decode_io_decex_memOp_zext;
  wire decode_io_decex_memOp_byte;
  wire decode_io_decex_memOp_hword;
  wire decode_io_decex_memOp_store;
  wire decode_io_decex_memOp_load;
  wire[31:0] decode_io_decex_jmpOp_reloc;
  wire[29:0] decode_io_decex_jmpOp_target;
  wire decode_io_decex_jmpOp_branch;
  wire[3:0] decode_io_decex_predOp_1_s2Addr;
  wire[3:0] decode_io_decex_predOp_1_s1Addr;
  wire[2:0] decode_io_decex_predOp_1_dest;
  wire[1:0] decode_io_decex_predOp_1_func;
  wire[3:0] decode_io_decex_predOp_0_s2Addr;
  wire[3:0] decode_io_decex_predOp_0_s1Addr;
  wire[2:0] decode_io_decex_predOp_0_dest;
  wire[1:0] decode_io_decex_predOp_0_func;
  wire decode_io_decex_aluOp_1_isSTC;
  wire decode_io_decex_aluOp_1_isMFS;
  wire decode_io_decex_aluOp_1_isMTS;
  wire decode_io_decex_aluOp_1_isPred;
  wire decode_io_decex_aluOp_1_isCmp;
  wire decode_io_decex_aluOp_1_isMul;
  wire[3:0] decode_io_decex_aluOp_1_func;
  wire decode_io_decex_aluOp_0_isSTC;
  wire decode_io_decex_aluOp_0_isMFS;
  wire decode_io_decex_aluOp_0_isMTS;
  wire decode_io_decex_aluOp_0_isPred;
  wire decode_io_decex_aluOp_0_isCmp;
  wire decode_io_decex_aluOp_0_isMul;
  wire[3:0] decode_io_decex_aluOp_0_func;
  wire[3:0] decode_io_decex_pred_1;
  wire[3:0] decode_io_decex_pred_0;
  wire[29:0] decode_io_decex_pc;
  wire writeback_io_rfWrite_1_valid;
  wire[31:0] writeback_io_rfWrite_1_data;
  wire[4:0] writeback_io_rfWrite_1_addr;
  wire writeback_io_rfWrite_0_valid;
  wire[31:0] writeback_io_rfWrite_0_data;
  wire[4:0] writeback_io_rfWrite_0_addr;
  wire[31:0] execute_io_exdec_sp;
  wire[31:0] fetch_io_fedec_reloc;
  wire[29:0] fetch_io_fedec_pc;
  wire[31:0] fetch_io_fedec_instr_b;
  wire[31:0] fetch_io_fedec_instr_a;
  wire[1:0] mcache_io_mcachefe_mem_sel;
  wire[31:0] mcache_io_mcachefe_reloc;
  wire[11:0] mcache_io_mcachefe_relPc;
  wire[10:0] mcache_io_mcachefe_relBase;
  wire[31:0] mcache_io_mcachefe_instr_b;
  wire[31:0] mcache_io_mcachefe_instr_a;
  wire[31:0] memory_io_memfe_data;
  wire[31:0] memory_io_memfe_addr;
  wire memory_io_memfe_store;
  wire[29:0] memory_io_memfe_callRetBase;
  wire[29:0] memory_io_memfe_callRetPc;
  wire memory_io_memfe_doCallRet;
  wire[29:0] execute_io_exfe_branchPc;
  wire execute_io_exfe_doBranch;
  wire[1:0] T84;
  wire[31:0] execute_io_exmcache_callRetAddr;
  wire[31:0] execute_io_exmcache_callRetBase;
  wire execute_io_exmcache_doCallRet;
  wire[31:0] fetch_io_femcache_callRetBase;
  wire fetch_io_femcache_doCallRet;
  wire fetch_io_femcache_request;
  wire[31:0] fetch_io_femcache_address;
  wire[8:0] iocomp_io_ledsPins_led;
  wire iocomp_io_uartPins_tx;
  wire[3:0] burstBus_io_master_M_DataByteEn;
  wire burstBus_io_master_M_DataValid;
  wire[31:0] burstBus_io_master_M_Data;
  wire[31:0] burstBus_io_master_M_Addr;
  wire[2:0] burstBus_io_master_M_Cmd;
  wire[3:0] iocomp_io_comSpm_M_ByteEn;
  wire[31:0] iocomp_io_comSpm_M_Data;
  wire[31:0] iocomp_io_comSpm_M_Addr;
  wire[2:0] iocomp_io_comSpm_M_Cmd;
  wire iocomp_io_comConf_M_RespAccept;
  wire[3:0] iocomp_io_comConf_M_ByteEn;
  wire[31:0] iocomp_io_comConf_M_Data;
  wire[31:0] iocomp_io_comConf_M_Addr;
  wire[2:0] iocomp_io_comConf_M_Cmd;
  wire[31:0] T85;
  wire[29:0] T86;
  wire[29:0] T87;
  reg[0:0] enableReg;
  reg[29:0] R88;

  assign T0 = T1 ? cacheToBurstBus_io_master_M_DataByteEn : mcache_io_ocp_port_M_DataByteEn;
  assign T1 = T5 ? 1'h0/* 0*/ : T2;
  assign T2 = T4 ? 1'h1/* 1*/ : R3;
  assign T4 = cacheToBurstBus_io_master_M_Cmd != 3'b000/* 0*/;
  assign T5 = mcache_io_ocp_port_M_Cmd != 3'b000/* 0*/;
  assign T6 = T1 ? cacheToBurstBus_io_master_M_DataValid : mcache_io_ocp_port_M_DataValid;
  assign T7 = T1 ? cacheToBurstBus_io_master_M_Data : mcache_io_ocp_port_M_Data;
  assign T8 = T1 ? cacheToBurstBus_io_master_M_Addr : mcache_io_ocp_port_M_Addr;
  assign T9 = cacheToBurstBus_io_master_M_Cmd | mcache_io_ocp_port_M_Cmd;
  assign T10 = T11 ? 2'b00/* 0*/ : burstBus_io_slave_S_Resp;
  assign T11 = ! T1;
  assign T12 = T55 ? R14 : T13;
  assign T13 = {3'h0/* 0*/, 1'h0/* 0*/};
  assign T15 = T52 && T16;
  assign T16 = T18 || T17;
  assign T17 = cacheToBurstBus_io_slave_S_CmdAccept == 1'h1/* 1*/;
  assign T18 = R19 == 3'b000/* 0*/;
  assign T20 = T15 || T21;
  assign T21 = R22 == 2'h3/* 3*/;
  assign T23 = T25 || T24;
  assign T24 = bootMem_io_extMem_M_Cmd == 3'b001/* 0*/;
  assign T25 = T27 || T26;
  assign T26 = bootMem_io_extMem_M_Cmd == 3'b010/* 0*/;
  assign T27 = T42 || T28;
  assign T28 = T21 && T29;
  assign T29 = R30 == 2'h3/* 3*/;
  assign T31 = T34 || T32;
  assign T32 = T21 && T33;
  assign T33 = cacheToBurstBus_io_slave_S_DataAccept == 1'h1/* 1*/;
  assign T34 = T36 && T35;
  assign T35 = cacheToBurstBus_io_slave_S_Resp == 2'b01/* 0*/;
  assign T36 = R22 == 2'h1/* 1*/;
  assign T37 = T32 ? T40 : T38;
  assign T38 = R30 + T39;
  assign T39 = {1'h0/* 0*/, 1'h1/* 1*/};
  assign T40 = R30 + T41;
  assign T41 = {1'h0/* 0*/, 1'h1/* 1*/};
  assign T42 = T44 || T43;
  assign T43 = R22 == 2'h2/* 2*/;
  assign T44 = T34 && T45;
  assign T45 = R30 == 2'h3/* 3*/;
  assign T46 = T24 ? 2'h3/* 3*/ : T47;
  assign T47 = T26 ? 2'h1/* 1*/ : T48;
  assign T48 = T28 ? 2'h0/* 0*/ : T49;
  assign T49 = T43 ? 2'h0/* 0*/ : 2'h2/* 2*/;
  assign T50 = 3'b000/* 0*/;
  assign T51 = T21 ? 3'b000/* 0*/ : bootMem_io_extMem_M_Cmd;
  assign T52 = R22 != 2'h3/* 3*/;
  assign T53 = T54;
  assign T54 = {3'h0/* 0*/, 1'h0/* 0*/};
  assign T55 = T21 && T56;
  assign T56 = R30 == R57;
  assign T58 = T26 || T24;
  assign T59 = T24 ? T61 : T60;
  assign T60 = bootMem_io_extMem_M_Addr[2'h3/* 3*/:2'h2/* 2*/];
  assign T61 = bootMem_io_extMem_M_Addr[2'h3/* 3*/:2'h2/* 2*/];
  assign T62 = T55 ? R64 : T63;
  assign T63 = {31'h0/* 0*/, 1'h0/* 0*/};
  assign T65 = T66;
  assign T66 = {31'h0/* 0*/, 1'h0/* 0*/};
  assign T67 = {T68, 4'h0/* 0*/};
  assign T68 = R69[5'h1f/* 31*/:3'h4/* 4*/];
  assign T70 = T71;
  assign T71 = {31'h0/* 0*/, 1'h0/* 0*/};
  assign T72 = T43 ? R75 : T73;
  assign T73 = T36 ? T74 : cacheToBurstBus_io_slave_S_Data;
  assign T74 = {31'h0/* 0*/, 1'h0/* 0*/};
  assign T76 = T34 && T77;
  assign T77 = R30 == R57;
  assign T78 = T79;
  assign T79 = {31'h0/* 0*/, 1'h0/* 0*/};
  assign T80 = T43 ? R82 : T81;
  assign T81 = T36 ? 2'b00/* 0*/ : cacheToBurstBus_io_slave_S_Resp;
  assign T83 = 2'b00/* 0*/;
  assign enable = memory_io_ena_out & mcache_io_ena_out;
  assign T84 = T1 ? 2'b00/* 0*/ : burstBus_io_slave_S_Resp;
  assign io_ledsPins_led = iocomp_io_ledsPins_led;
  assign io_uartPins_tx = iocomp_io_uartPins_tx;
  assign io_memPort_M_DataByteEn = burstBus_io_master_M_DataByteEn;
  assign io_memPort_M_DataValid = burstBus_io_master_M_DataValid;
  assign io_memPort_M_Data = burstBus_io_master_M_Data;
  assign io_memPort_M_Addr = burstBus_io_master_M_Addr;
  assign io_memPort_M_Cmd = burstBus_io_master_M_Cmd;
  assign io_comSpm_M_ByteEn = iocomp_io_comSpm_M_ByteEn;
  assign io_comSpm_M_Data = iocomp_io_comSpm_M_Data;
  assign io_comSpm_M_Addr = iocomp_io_comSpm_M_Addr;
  assign io_comSpm_M_Cmd = iocomp_io_comSpm_M_Cmd;
  assign io_comConf_M_RespAccept = iocomp_io_comConf_M_RespAccept;
  assign io_comConf_M_ByteEn = iocomp_io_comConf_M_ByteEn;
  assign io_comConf_M_Data = iocomp_io_comConf_M_Data;
  assign io_comConf_M_Addr = iocomp_io_comConf_M_Addr;
  assign io_comConf_M_Cmd = iocomp_io_comConf_M_Cmd;
  assign io_dummy = T85;
  assign T85 = {2'h0/* 0*/, T86};
  assign T86 = R88 | T87;
  assign T87 = {29'h0/* 0*/, enableReg};
  MCache mcache(.clk(clk), .reset(reset),
       .io_ena_out( mcache_io_ena_out ),
       .io_ena_in( memory_io_ena_out ),
       .io_femcache_address( fetch_io_femcache_address ),
       .io_femcache_request( fetch_io_femcache_request ),
       .io_femcache_doCallRet( fetch_io_femcache_doCallRet ),
       .io_femcache_callRetBase( fetch_io_femcache_callRetBase ),
       .io_exmcache_doCallRet( execute_io_exmcache_doCallRet ),
       .io_exmcache_callRetBase( execute_io_exmcache_callRetBase ),
       .io_exmcache_callRetAddr( execute_io_exmcache_callRetAddr ),
       .io_mcachefe_instr_a( mcache_io_mcachefe_instr_a ),
       .io_mcachefe_instr_b( mcache_io_mcachefe_instr_b ),
       .io_mcachefe_relBase( mcache_io_mcachefe_relBase ),
       .io_mcachefe_relPc( mcache_io_mcachefe_relPc ),
       .io_mcachefe_reloc( mcache_io_mcachefe_reloc ),
       .io_mcachefe_mem_sel( mcache_io_mcachefe_mem_sel ),
       .io_ocp_port_M_Cmd( mcache_io_ocp_port_M_Cmd ),
       .io_ocp_port_M_Addr( mcache_io_ocp_port_M_Addr ),
       .io_ocp_port_M_Data( mcache_io_ocp_port_M_Data ),
       .io_ocp_port_M_DataValid( mcache_io_ocp_port_M_DataValid ),
       .io_ocp_port_M_DataByteEn( mcache_io_ocp_port_M_DataByteEn ),
       .io_ocp_port_S_Resp( T84 ),
       .io_ocp_port_S_Data( burstBus_io_slave_S_Data ),
       .io_ocp_port_S_CmdAccept( burstBus_io_slave_S_CmdAccept ),
       .io_ocp_port_S_DataAccept( burstBus_io_slave_S_DataAccept )
  );
  Fetch fetch(.clk(clk), .reset(reset),
       .io_ena( enable ),
       .io_fedec_instr_a( fetch_io_fedec_instr_a ),
       .io_fedec_instr_b( fetch_io_fedec_instr_b ),
       .io_fedec_pc( fetch_io_fedec_pc ),
       .io_fedec_reloc( fetch_io_fedec_reloc ),
       .io_femem_pc( fetch_io_femem_pc ),
       .io_exfe_doBranch( execute_io_exfe_doBranch ),
       .io_exfe_branchPc( execute_io_exfe_branchPc ),
       .io_memfe_doCallRet( memory_io_memfe_doCallRet ),
       .io_memfe_callRetPc( memory_io_memfe_callRetPc ),
       .io_memfe_callRetBase( memory_io_memfe_callRetBase ),
       .io_memfe_store( memory_io_memfe_store ),
       .io_memfe_addr( memory_io_memfe_addr ),
       .io_memfe_data( memory_io_memfe_data ),
       .io_femcache_address( fetch_io_femcache_address ),
       .io_femcache_request( fetch_io_femcache_request ),
       .io_femcache_doCallRet( fetch_io_femcache_doCallRet ),
       .io_femcache_callRetBase( fetch_io_femcache_callRetBase ),
       .io_mcachefe_instr_a( mcache_io_mcachefe_instr_a ),
       .io_mcachefe_instr_b( mcache_io_mcachefe_instr_b ),
       .io_mcachefe_relBase( mcache_io_mcachefe_relBase ),
       .io_mcachefe_relPc( mcache_io_mcachefe_relPc ),
       .io_mcachefe_reloc( mcache_io_mcachefe_reloc ),
       .io_mcachefe_mem_sel( mcache_io_mcachefe_mem_sel )
  );
  Decode decode(.clk(clk), .reset(reset),
       .io_ena( enable ),
       .io_fedec_instr_a( fetch_io_fedec_instr_a ),
       .io_fedec_instr_b( fetch_io_fedec_instr_b ),
       .io_fedec_pc( fetch_io_fedec_pc ),
       .io_fedec_reloc( fetch_io_fedec_reloc ),
       .io_decex_pc( decode_io_decex_pc ),
       .io_decex_pred_0( decode_io_decex_pred_0 ),
       .io_decex_pred_1( decode_io_decex_pred_1 ),
       .io_decex_aluOp_0_func( decode_io_decex_aluOp_0_func ),
       .io_decex_aluOp_0_isMul( decode_io_decex_aluOp_0_isMul ),
       .io_decex_aluOp_0_isCmp( decode_io_decex_aluOp_0_isCmp ),
       .io_decex_aluOp_0_isPred( decode_io_decex_aluOp_0_isPred ),
       .io_decex_aluOp_0_isMTS( decode_io_decex_aluOp_0_isMTS ),
       .io_decex_aluOp_0_isMFS( decode_io_decex_aluOp_0_isMFS ),
       .io_decex_aluOp_0_isSTC( decode_io_decex_aluOp_0_isSTC ),
       .io_decex_aluOp_1_func( decode_io_decex_aluOp_1_func ),
       .io_decex_aluOp_1_isMul( decode_io_decex_aluOp_1_isMul ),
       .io_decex_aluOp_1_isCmp( decode_io_decex_aluOp_1_isCmp ),
       .io_decex_aluOp_1_isPred( decode_io_decex_aluOp_1_isPred ),
       .io_decex_aluOp_1_isMTS( decode_io_decex_aluOp_1_isMTS ),
       .io_decex_aluOp_1_isMFS( decode_io_decex_aluOp_1_isMFS ),
       .io_decex_aluOp_1_isSTC( decode_io_decex_aluOp_1_isSTC ),
       .io_decex_predOp_0_func( decode_io_decex_predOp_0_func ),
       .io_decex_predOp_0_dest( decode_io_decex_predOp_0_dest ),
       .io_decex_predOp_0_s1Addr( decode_io_decex_predOp_0_s1Addr ),
       .io_decex_predOp_0_s2Addr( decode_io_decex_predOp_0_s2Addr ),
       .io_decex_predOp_1_func( decode_io_decex_predOp_1_func ),
       .io_decex_predOp_1_dest( decode_io_decex_predOp_1_dest ),
       .io_decex_predOp_1_s1Addr( decode_io_decex_predOp_1_s1Addr ),
       .io_decex_predOp_1_s2Addr( decode_io_decex_predOp_1_s2Addr ),
       .io_decex_jmpOp_branch( decode_io_decex_jmpOp_branch ),
       .io_decex_jmpOp_target( decode_io_decex_jmpOp_target ),
       .io_decex_jmpOp_reloc( decode_io_decex_jmpOp_reloc ),
       .io_decex_memOp_load( decode_io_decex_memOp_load ),
       .io_decex_memOp_store( decode_io_decex_memOp_store ),
       .io_decex_memOp_hword( decode_io_decex_memOp_hword ),
       .io_decex_memOp_byte( decode_io_decex_memOp_byte ),
       .io_decex_memOp_zext( decode_io_decex_memOp_zext ),
       .io_decex_memOp_typ( decode_io_decex_memOp_typ ),
       .io_decex_rsAddr_0( decode_io_decex_rsAddr_0 ),
       .io_decex_rsAddr_1( decode_io_decex_rsAddr_1 ),
       .io_decex_rsAddr_2( decode_io_decex_rsAddr_2 ),
       .io_decex_rsAddr_3( decode_io_decex_rsAddr_3 ),
       .io_decex_rsData_0( decode_io_decex_rsData_0 ),
       .io_decex_rsData_1( decode_io_decex_rsData_1 ),
       .io_decex_rsData_2( decode_io_decex_rsData_2 ),
       .io_decex_rsData_3( decode_io_decex_rsData_3 ),
       .io_decex_rdAddr_0( decode_io_decex_rdAddr_0 ),
       .io_decex_rdAddr_1( decode_io_decex_rdAddr_1 ),
       .io_decex_immVal_0( decode_io_decex_immVal_0 ),
       .io_decex_immVal_1( decode_io_decex_immVal_1 ),
       .io_decex_immOp_0( decode_io_decex_immOp_0 ),
       .io_decex_immOp_1( decode_io_decex_immOp_1 ),
       .io_decex_wrRd_0( decode_io_decex_wrRd_0 ),
       .io_decex_wrRd_1( decode_io_decex_wrRd_1 ),
       .io_decex_callAddr( decode_io_decex_callAddr ),
       .io_decex_brcfAddr( decode_io_decex_brcfAddr ),
       .io_decex_call( decode_io_decex_call ),
       .io_decex_ret( decode_io_decex_ret ),
       .io_decex_brcf( decode_io_decex_brcf ),
       .io_exdec_sp( execute_io_exdec_sp ),
       .io_rfWrite_0_addr( writeback_io_rfWrite_0_addr ),
       .io_rfWrite_0_data( writeback_io_rfWrite_0_data ),
       .io_rfWrite_0_valid( writeback_io_rfWrite_0_valid ),
       .io_rfWrite_1_addr( writeback_io_rfWrite_1_addr ),
       .io_rfWrite_1_data( writeback_io_rfWrite_1_data ),
       .io_rfWrite_1_valid( writeback_io_rfWrite_1_valid )
  );
  Execute execute(.clk(clk), .reset(reset),
       .io_ena( enable ),
       .io_decex_pc( decode_io_decex_pc ),
       .io_decex_pred_0( decode_io_decex_pred_0 ),
       .io_decex_pred_1( decode_io_decex_pred_1 ),
       .io_decex_aluOp_0_func( decode_io_decex_aluOp_0_func ),
       .io_decex_aluOp_0_isMul( decode_io_decex_aluOp_0_isMul ),
       .io_decex_aluOp_0_isCmp( decode_io_decex_aluOp_0_isCmp ),
       .io_decex_aluOp_0_isPred( decode_io_decex_aluOp_0_isPred ),
       .io_decex_aluOp_0_isMTS( decode_io_decex_aluOp_0_isMTS ),
       .io_decex_aluOp_0_isMFS( decode_io_decex_aluOp_0_isMFS ),
       .io_decex_aluOp_0_isSTC( decode_io_decex_aluOp_0_isSTC ),
       .io_decex_aluOp_1_func( decode_io_decex_aluOp_1_func ),
       .io_decex_aluOp_1_isMul( decode_io_decex_aluOp_1_isMul ),
       .io_decex_aluOp_1_isCmp( decode_io_decex_aluOp_1_isCmp ),
       .io_decex_aluOp_1_isPred( decode_io_decex_aluOp_1_isPred ),
       .io_decex_aluOp_1_isMTS( decode_io_decex_aluOp_1_isMTS ),
       .io_decex_aluOp_1_isMFS( decode_io_decex_aluOp_1_isMFS ),
       .io_decex_aluOp_1_isSTC( decode_io_decex_aluOp_1_isSTC ),
       .io_decex_predOp_0_func( decode_io_decex_predOp_0_func ),
       .io_decex_predOp_0_dest( decode_io_decex_predOp_0_dest ),
       .io_decex_predOp_0_s1Addr( decode_io_decex_predOp_0_s1Addr ),
       .io_decex_predOp_0_s2Addr( decode_io_decex_predOp_0_s2Addr ),
       .io_decex_predOp_1_func( decode_io_decex_predOp_1_func ),
       .io_decex_predOp_1_dest( decode_io_decex_predOp_1_dest ),
       .io_decex_predOp_1_s1Addr( decode_io_decex_predOp_1_s1Addr ),
       .io_decex_predOp_1_s2Addr( decode_io_decex_predOp_1_s2Addr ),
       .io_decex_jmpOp_branch( decode_io_decex_jmpOp_branch ),
       .io_decex_jmpOp_target( decode_io_decex_jmpOp_target ),
       .io_decex_jmpOp_reloc( decode_io_decex_jmpOp_reloc ),
       .io_decex_memOp_load( decode_io_decex_memOp_load ),
       .io_decex_memOp_store( decode_io_decex_memOp_store ),
       .io_decex_memOp_hword( decode_io_decex_memOp_hword ),
       .io_decex_memOp_byte( decode_io_decex_memOp_byte ),
       .io_decex_memOp_zext( decode_io_decex_memOp_zext ),
       .io_decex_memOp_typ( decode_io_decex_memOp_typ ),
       .io_decex_rsAddr_0( decode_io_decex_rsAddr_0 ),
       .io_decex_rsAddr_1( decode_io_decex_rsAddr_1 ),
       .io_decex_rsAddr_2( decode_io_decex_rsAddr_2 ),
       .io_decex_rsAddr_3( decode_io_decex_rsAddr_3 ),
       .io_decex_rsData_0( decode_io_decex_rsData_0 ),
       .io_decex_rsData_1( decode_io_decex_rsData_1 ),
       .io_decex_rsData_2( decode_io_decex_rsData_2 ),
       .io_decex_rsData_3( decode_io_decex_rsData_3 ),
       .io_decex_rdAddr_0( decode_io_decex_rdAddr_0 ),
       .io_decex_rdAddr_1( decode_io_decex_rdAddr_1 ),
       .io_decex_immVal_0( decode_io_decex_immVal_0 ),
       .io_decex_immVal_1( decode_io_decex_immVal_1 ),
       .io_decex_immOp_0( decode_io_decex_immOp_0 ),
       .io_decex_immOp_1( decode_io_decex_immOp_1 ),
       .io_decex_wrRd_0( decode_io_decex_wrRd_0 ),
       .io_decex_wrRd_1( decode_io_decex_wrRd_1 ),
       .io_decex_callAddr( decode_io_decex_callAddr ),
       .io_decex_brcfAddr( decode_io_decex_brcfAddr ),
       .io_decex_call( decode_io_decex_call ),
       .io_decex_ret( decode_io_decex_ret ),
       .io_decex_brcf( decode_io_decex_brcf ),
       .io_exdec_sp( execute_io_exdec_sp ),
       .io_exmem_rd_0_addr( execute_io_exmem_rd_0_addr ),
       .io_exmem_rd_0_data( execute_io_exmem_rd_0_data ),
       .io_exmem_rd_0_valid( execute_io_exmem_rd_0_valid ),
       .io_exmem_rd_1_addr( execute_io_exmem_rd_1_addr ),
       .io_exmem_rd_1_data( execute_io_exmem_rd_1_data ),
       .io_exmem_rd_1_valid( execute_io_exmem_rd_1_valid ),
       .io_exmem_mem_load( execute_io_exmem_mem_load ),
       .io_exmem_mem_store( execute_io_exmem_mem_store ),
       .io_exmem_mem_hword( execute_io_exmem_mem_hword ),
       .io_exmem_mem_byte( execute_io_exmem_mem_byte ),
       .io_exmem_mem_zext( execute_io_exmem_mem_zext ),
       .io_exmem_mem_typ( execute_io_exmem_mem_typ ),
       .io_exmem_mem_addr( execute_io_exmem_mem_addr ),
       .io_exmem_mem_data( execute_io_exmem_mem_data ),
       .io_exmem_mem_call( execute_io_exmem_mem_call ),
       .io_exmem_mem_ret( execute_io_exmem_mem_ret ),
       .io_exmem_mem_brcf( execute_io_exmem_mem_brcf ),
       .io_exmem_mem_callRetAddr( execute_io_exmem_mem_callRetAddr ),
       .io_exmem_mem_callRetBase( execute_io_exmem_mem_callRetBase ),
       .io_exmem_pc( execute_io_exmem_pc ),
       .io_exmcache_doCallRet( execute_io_exmcache_doCallRet ),
       .io_exmcache_callRetBase( execute_io_exmcache_callRetBase ),
       .io_exmcache_callRetAddr( execute_io_exmcache_callRetAddr ),
       .io_exResult_0_addr( memory_io_exResult_0_addr ),
       .io_exResult_0_data( memory_io_exResult_0_data ),
       .io_exResult_0_valid( memory_io_exResult_0_valid ),
       .io_exResult_1_addr( memory_io_exResult_1_addr ),
       .io_exResult_1_data( memory_io_exResult_1_data ),
       .io_exResult_1_valid( memory_io_exResult_1_valid ),
       .io_memResult_0_addr( writeback_io_memResult_0_addr ),
       .io_memResult_0_data( writeback_io_memResult_0_data ),
       .io_memResult_0_valid( writeback_io_memResult_0_valid ),
       .io_memResult_1_addr( writeback_io_memResult_1_addr ),
       .io_memResult_1_data( writeback_io_memResult_1_data ),
       .io_memResult_1_valid( writeback_io_memResult_1_valid ),
       .io_exfe_doBranch( execute_io_exfe_doBranch ),
       .io_exfe_branchPc( execute_io_exfe_branchPc )
  );
  Memory memory(.clk(clk), .reset(reset),
       .io_ena_out( memory_io_ena_out ),
       .io_ena_in( mcache_io_ena_out ),
       .io_exmem_rd_0_addr( execute_io_exmem_rd_0_addr ),
       .io_exmem_rd_0_data( execute_io_exmem_rd_0_data ),
       .io_exmem_rd_0_valid( execute_io_exmem_rd_0_valid ),
       .io_exmem_rd_1_addr( execute_io_exmem_rd_1_addr ),
       .io_exmem_rd_1_data( execute_io_exmem_rd_1_data ),
       .io_exmem_rd_1_valid( execute_io_exmem_rd_1_valid ),
       .io_exmem_mem_load( execute_io_exmem_mem_load ),
       .io_exmem_mem_store( execute_io_exmem_mem_store ),
       .io_exmem_mem_hword( execute_io_exmem_mem_hword ),
       .io_exmem_mem_byte( execute_io_exmem_mem_byte ),
       .io_exmem_mem_zext( execute_io_exmem_mem_zext ),
       .io_exmem_mem_typ( execute_io_exmem_mem_typ ),
       .io_exmem_mem_addr( execute_io_exmem_mem_addr ),
       .io_exmem_mem_data( execute_io_exmem_mem_data ),
       .io_exmem_mem_call( execute_io_exmem_mem_call ),
       .io_exmem_mem_ret( execute_io_exmem_mem_ret ),
       .io_exmem_mem_brcf( execute_io_exmem_mem_brcf ),
       .io_exmem_mem_callRetAddr( execute_io_exmem_mem_callRetAddr ),
       .io_exmem_mem_callRetBase( execute_io_exmem_mem_callRetBase ),
       .io_exmem_pc( execute_io_exmem_pc ),
       .io_memwb_rd_0_addr( memory_io_memwb_rd_0_addr ),
       .io_memwb_rd_0_data( memory_io_memwb_rd_0_data ),
       .io_memwb_rd_0_valid( memory_io_memwb_rd_0_valid ),
       .io_memwb_rd_1_addr( memory_io_memwb_rd_1_addr ),
       .io_memwb_rd_1_data( memory_io_memwb_rd_1_data ),
       .io_memwb_rd_1_valid( memory_io_memwb_rd_1_valid ),
       .io_memwb_pc( memory_io_memwb_pc ),
       .io_memfe_doCallRet( memory_io_memfe_doCallRet ),
       .io_memfe_callRetPc( memory_io_memfe_callRetPc ),
       .io_memfe_callRetBase( memory_io_memfe_callRetBase ),
       .io_memfe_store( memory_io_memfe_store ),
       .io_memfe_addr( memory_io_memfe_addr ),
       .io_memfe_data( memory_io_memfe_data ),
       .io_femem_pc( fetch_io_femem_pc ),
       .io_exResult_0_addr( memory_io_exResult_0_addr ),
       .io_exResult_0_data( memory_io_exResult_0_data ),
       .io_exResult_0_valid( memory_io_exResult_0_valid ),
       .io_exResult_1_addr( memory_io_exResult_1_addr ),
       .io_exResult_1_data( memory_io_exResult_1_data ),
       .io_exResult_1_valid( memory_io_exResult_1_valid ),
       .io_localInOut_M_Cmd( memory_io_localInOut_M_Cmd ),
       .io_localInOut_M_Addr( memory_io_localInOut_M_Addr ),
       .io_localInOut_M_Data( memory_io_localInOut_M_Data ),
       .io_localInOut_M_ByteEn( memory_io_localInOut_M_ByteEn ),
       .io_localInOut_S_Resp( iocomp_io_memInOut_S_Resp ),
       .io_localInOut_S_Data( iocomp_io_memInOut_S_Data ),
       .io_globalInOut_M_Cmd( memory_io_globalInOut_M_Cmd ),
       .io_globalInOut_M_Addr( memory_io_globalInOut_M_Addr ),
       .io_globalInOut_M_Data( memory_io_globalInOut_M_Data ),
       .io_globalInOut_M_ByteEn( memory_io_globalInOut_M_ByteEn ),
       .io_globalInOut_M_AddrSpace( memory_io_globalInOut_M_AddrSpace ),
       .io_globalInOut_S_Resp( bootMem_io_memInOut_S_Resp ),
       .io_globalInOut_S_Data( bootMem_io_memInOut_S_Data )
  );
  WriteBack writeback(
       .io_ena( enable ),
       .io_memwb_rd_0_addr( memory_io_memwb_rd_0_addr ),
       .io_memwb_rd_0_data( memory_io_memwb_rd_0_data ),
       .io_memwb_rd_0_valid( memory_io_memwb_rd_0_valid ),
       .io_memwb_rd_1_addr( memory_io_memwb_rd_1_addr ),
       .io_memwb_rd_1_data( memory_io_memwb_rd_1_data ),
       .io_memwb_rd_1_valid( memory_io_memwb_rd_1_valid ),
       .io_memwb_pc( memory_io_memwb_pc ),
       .io_rfWrite_0_addr( writeback_io_rfWrite_0_addr ),
       .io_rfWrite_0_data( writeback_io_rfWrite_0_data ),
       .io_rfWrite_0_valid( writeback_io_rfWrite_0_valid ),
       .io_rfWrite_1_addr( writeback_io_rfWrite_1_addr ),
       .io_rfWrite_1_data( writeback_io_rfWrite_1_data ),
       .io_rfWrite_1_valid( writeback_io_rfWrite_1_valid ),
       .io_memResult_0_addr( writeback_io_memResult_0_addr ),
       .io_memResult_0_data( writeback_io_memResult_0_data ),
       .io_memResult_0_valid( writeback_io_memResult_0_valid ),
       .io_memResult_1_addr( writeback_io_memResult_1_addr ),
       .io_memResult_1_data( writeback_io_memResult_1_data ),
       .io_memResult_1_valid( writeback_io_memResult_1_valid )
  );
  InOut iocomp(.clk(clk), .reset(reset),
       .io_memInOut_M_Cmd( memory_io_localInOut_M_Cmd ),
       .io_memInOut_M_Addr( memory_io_localInOut_M_Addr ),
       .io_memInOut_M_Data( memory_io_localInOut_M_Data ),
       .io_memInOut_M_ByteEn( memory_io_localInOut_M_ByteEn ),
       .io_memInOut_S_Resp( iocomp_io_memInOut_S_Resp ),
       .io_memInOut_S_Data( iocomp_io_memInOut_S_Data ),
       .io_comConf_M_Cmd( iocomp_io_comConf_M_Cmd ),
       .io_comConf_M_Addr( iocomp_io_comConf_M_Addr ),
       .io_comConf_M_Data( iocomp_io_comConf_M_Data ),
       .io_comConf_M_ByteEn( iocomp_io_comConf_M_ByteEn ),
       .io_comConf_M_RespAccept( iocomp_io_comConf_M_RespAccept ),
       .io_comConf_S_Resp( io_comConf_S_Resp ),
       .io_comConf_S_Data( io_comConf_S_Data ),
       .io_comConf_S_CmdAccept( io_comConf_S_CmdAccept ),
       .io_comSpm_M_Cmd( iocomp_io_comSpm_M_Cmd ),
       .io_comSpm_M_Addr( iocomp_io_comSpm_M_Addr ),
       .io_comSpm_M_Data( iocomp_io_comSpm_M_Data ),
       .io_comSpm_M_ByteEn( iocomp_io_comSpm_M_ByteEn ),
       .comSpmS_Resp( io_comSpm_S_Resp ),
       .comSpmS_Data( io_comSpm_S_Data ),
       .io_cpuInfoPins_id( io_cpuInfoPins_id ),
       .io_uartPins_tx( iocomp_io_uartPins_tx ),
       .io_uartPins_rx( io_uartPins_rx ),
       .io_ledsPins_led( iocomp_io_ledsPins_led )
  );
  BootMem bootMem(.clk(clk), .reset(reset),
       .io_memInOut_M_Cmd( memory_io_globalInOut_M_Cmd ),
       .io_memInOut_M_Addr( memory_io_globalInOut_M_Addr ),
       .io_memInOut_M_Data( memory_io_globalInOut_M_Data ),
       .io_memInOut_M_ByteEn( memory_io_globalInOut_M_ByteEn ),
       .io_memInOut_M_AddrSpace( memory_io_globalInOut_M_AddrSpace ),
       .io_memInOut_S_Resp( bootMem_io_memInOut_S_Resp ),
       .io_memInOut_S_Data( bootMem_io_memInOut_S_Data ),
       .io_extMem_M_Cmd( bootMem_io_extMem_M_Cmd ),
       .io_extMem_M_Addr( bootMem_io_extMem_M_Addr ),
       .io_extMem_M_Data( bootMem_io_extMem_M_Data ),
       .io_extMem_M_ByteEn( bootMem_io_extMem_M_ByteEn ),
       //.io_extMem_M_AddrSpace(  )
       .io_extMem_S_Resp( T80 ),
       .io_extMem_S_Data( T72 )
  );
  OcpBurstBus cacheToBurstBus(
       .io_slave_M_Cmd( R19 ),
       .io_slave_M_Addr( T67 ),
       .io_slave_M_Data( T62 ),
       .io_slave_M_DataValid( T21 ),
       .io_slave_M_DataByteEn( T12 ),
       .io_slave_S_Resp( cacheToBurstBus_io_slave_S_Resp ),
       .io_slave_S_Data( cacheToBurstBus_io_slave_S_Data ),
       .io_slave_S_CmdAccept( cacheToBurstBus_io_slave_S_CmdAccept ),
       .io_slave_S_DataAccept( cacheToBurstBus_io_slave_S_DataAccept ),
       .io_master_M_Cmd( cacheToBurstBus_io_master_M_Cmd ),
       .io_master_M_Addr( cacheToBurstBus_io_master_M_Addr ),
       .io_master_M_Data( cacheToBurstBus_io_master_M_Data ),
       .io_master_M_DataValid( cacheToBurstBus_io_master_M_DataValid ),
       .io_master_M_DataByteEn( cacheToBurstBus_io_master_M_DataByteEn ),
       .io_master_S_Resp( T10 ),
       .io_master_S_Data( burstBus_io_slave_S_Data ),
       .io_master_S_CmdAccept( burstBus_io_slave_S_CmdAccept ),
       .io_master_S_DataAccept( burstBus_io_slave_S_DataAccept )
  );
  OcpBurstBus burstBus(
       .io_slave_M_Cmd( T9 ),
       .io_slave_M_Addr( T8 ),
       .io_slave_M_Data( T7 ),
       .io_slave_M_DataValid( T6 ),
       .io_slave_M_DataByteEn( T0 ),
       .io_slave_S_Resp( burstBus_io_slave_S_Resp ),
       .io_slave_S_Data( burstBus_io_slave_S_Data ),
       .io_slave_S_CmdAccept( burstBus_io_slave_S_CmdAccept ),
       .io_slave_S_DataAccept( burstBus_io_slave_S_DataAccept ),
       .io_master_M_Cmd( burstBus_io_master_M_Cmd ),
       .io_master_M_Addr( burstBus_io_master_M_Addr ),
       .io_master_M_Data( burstBus_io_master_M_Data ),
       .io_master_M_DataValid( burstBus_io_master_M_DataValid ),
       .io_master_M_DataByteEn( burstBus_io_master_M_DataByteEn ),
       .io_master_S_Resp( io_memPort_S_Resp ),
       .io_master_S_Data( io_memPort_S_Data ),
       .io_master_S_CmdAccept( io_memPort_S_CmdAccept ),
       .io_master_S_DataAccept( io_memPort_S_DataAccept )
  );

  always @(posedge clk) begin
    R3 <= reset ? 1'h0/* 0*/ : T1;
    if(reset) begin
      R14 <= T53;
    end else if(T15) begin
      R14 <= bootMem_io_extMem_M_ByteEn;
    end
    if(reset) begin
      R19 <= T50;
    end else if(T20) begin
      R19 <= T51;
    end
    if(reset) begin
      R22 <= 2'h0/* 0*/;
    end else if(T23) begin
      R22 <= T46;
    end
    if(reset) begin
      R30 <= 2'h0/* 0*/;
    end else if(T31) begin
      R30 <= T37;
    end
    if(reset) begin
      R57 <= 2'h0/* 0*/;
    end else if(T58) begin
      R57 <= T59;
    end
    if(reset) begin
      R64 <= T65;
    end else if(T15) begin
      R64 <= bootMem_io_extMem_M_Data;
    end
    if(reset) begin
      R69 <= T70;
    end else if(T15) begin
      R69 <= bootMem_io_extMem_M_Addr;
    end
    if(reset) begin
      R75 <= T78;
    end else if(T76) begin
      R75 <= cacheToBurstBus_io_slave_S_Data;
    end
    if(reset) begin
      R82 <= T83;
    end else if(T76) begin
      R82 <= cacheToBurstBus_io_slave_S_Resp;
    end
    enableReg <= enable;
    R88 <= memory_io_memwb_pc;
  end
endmodule

module Patmos(input clk, input reset,
    output[31:0] io_dummy,
    output[2:0] io_comConf_M_Cmd,
    output[31:0] io_comConf_M_Addr,
    output[31:0] io_comConf_M_Data,
    output[3:0] io_comConf_M_ByteEn,
    output io_comConf_M_RespAccept,
    input [1:0] io_comConf_S_Resp,
    input [31:0] io_comConf_S_Data,
    input  io_comConf_S_CmdAccept,
    output[2:0] io_comSpm_M_Cmd,
    output[31:0] io_comSpm_M_Addr,
    output[31:0] io_comSpm_M_Data,
    output[3:0] io_comSpm_M_ByteEn,
    input [1:0] io_comSpm_S_Resp,
    input [31:0] io_comSpm_S_Data,
    output[2:0] io_mem_interface_M_Cmd,
    output[31:0] io_mem_interface_M_Addr,
    output[31:0] io_mem_interface_M_Data,
    output io_mem_interface_M_DataValid,
    output[3:0] io_mem_interface_M_DataByteEn,
    input [1:0] io_mem_interface_S_Resp,
    input [31:0] io_mem_interface_S_Data,
    input  io_mem_interface_S_CmdAccept,
    input  io_mem_interface_S_DataAccept,
    input [31:0] io_cpuInfoPins_id,
    output io_uartPins_tx,
    input  io_uartPins_rx,
    output[8:0] io_ledsPins_led
);

  wire[8:0] core_io_ledsPins_led;
  wire core_io_uartPins_tx;
  wire[3:0] core_io_memPort_M_DataByteEn;
  wire core_io_memPort_M_DataValid;
  wire[31:0] core_io_memPort_M_Data;
  wire[31:0] core_io_memPort_M_Addr;
  wire[2:0] core_io_memPort_M_Cmd;
  wire[3:0] core_io_comSpm_M_ByteEn;
  wire[31:0] core_io_comSpm_M_Data;
  wire[31:0] core_io_comSpm_M_Addr;
  wire[2:0] core_io_comSpm_M_Cmd;
  wire core_io_comConf_M_RespAccept;
  wire[3:0] core_io_comConf_M_ByteEn;
  wire[31:0] core_io_comConf_M_Data;
  wire[31:0] core_io_comConf_M_Addr;
  wire[2:0] core_io_comConf_M_Cmd;
  wire[31:0] core_io_dummy;

  assign io_ledsPins_led = core_io_ledsPins_led;
  assign io_uartPins_tx = core_io_uartPins_tx;
  assign io_mem_interface_M_DataByteEn = core_io_memPort_M_DataByteEn;
  assign io_mem_interface_M_DataValid = core_io_memPort_M_DataValid;
  assign io_mem_interface_M_Data = core_io_memPort_M_Data;
  assign io_mem_interface_M_Addr = core_io_memPort_M_Addr;
  assign io_mem_interface_M_Cmd = core_io_memPort_M_Cmd;
  assign io_comSpm_M_ByteEn = core_io_comSpm_M_ByteEn;
  assign io_comSpm_M_Data = core_io_comSpm_M_Data;
  assign io_comSpm_M_Addr = core_io_comSpm_M_Addr;
  assign io_comSpm_M_Cmd = core_io_comSpm_M_Cmd;
  assign io_comConf_M_RespAccept = core_io_comConf_M_RespAccept;
  assign io_comConf_M_ByteEn = core_io_comConf_M_ByteEn;
  assign io_comConf_M_Data = core_io_comConf_M_Data;
  assign io_comConf_M_Addr = core_io_comConf_M_Addr;
  assign io_comConf_M_Cmd = core_io_comConf_M_Cmd;
  assign io_dummy = core_io_dummy;
  PatmosCore core(.clk(clk), .reset(reset),
       .io_dummy( core_io_dummy ),
       .io_comConf_M_Cmd( core_io_comConf_M_Cmd ),
       .io_comConf_M_Addr( core_io_comConf_M_Addr ),
       .io_comConf_M_Data( core_io_comConf_M_Data ),
       .io_comConf_M_ByteEn( core_io_comConf_M_ByteEn ),
       .io_comConf_M_RespAccept( core_io_comConf_M_RespAccept ),
       .io_comConf_S_Resp( io_comConf_S_Resp ),
       .io_comConf_S_Data( io_comConf_S_Data ),
       .io_comConf_S_CmdAccept( io_comConf_S_CmdAccept ),
       .io_comSpm_M_Cmd( core_io_comSpm_M_Cmd ),
       .io_comSpm_M_Addr( core_io_comSpm_M_Addr ),
       .io_comSpm_M_Data( core_io_comSpm_M_Data ),
       .io_comSpm_M_ByteEn( core_io_comSpm_M_ByteEn ),
       .io_comSpm_S_Resp( io_comSpm_S_Resp ),
       .io_comSpm_S_Data( io_comSpm_S_Data ),
       .io_memPort_M_Cmd( core_io_memPort_M_Cmd ),
       .io_memPort_M_Addr( core_io_memPort_M_Addr ),
       .io_memPort_M_Data( core_io_memPort_M_Data ),
       .io_memPort_M_DataValid( core_io_memPort_M_DataValid ),
       .io_memPort_M_DataByteEn( core_io_memPort_M_DataByteEn ),
       .io_memPort_S_Resp( io_mem_interface_S_Resp ),
       .io_memPort_S_Data( io_mem_interface_S_Data ),
       .io_memPort_S_CmdAccept( io_mem_interface_S_CmdAccept ),
       .io_memPort_S_DataAccept( io_mem_interface_S_DataAccept ),
       .io_cpuInfoPins_id( io_cpuInfoPins_id ),
       .io_uartPins_tx( core_io_uartPins_tx ),
       .io_uartPins_rx( io_uartPins_rx ),
       .io_ledsPins_led( core_io_ledsPins_led )
  );
endmodule

