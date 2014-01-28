module MCacheCtrl(input clk, input reset,
    input  io_ena_in,
    output io_fetch_ena,
    output io_mcache_ctrlrepl_wEna,
    output[31:0] io_mcache_ctrlrepl_wData,
    output[31:0] io_mcache_ctrlrepl_wAddr,
    output io_mcache_ctrlrepl_wTag,
    output[9:0] io_mcache_ctrlrepl_addrEven,
    output[9:0] io_mcache_ctrlrepl_addrOdd,
    output io_mcache_ctrlrepl_instrStall,
    input  io_mcache_replctrl_hit,
    input [31:0] io_femcache_addrEven,
    input [31:0] io_femcache_addrOdd,
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
  wire[31:0] ocpAddr;
  wire[31:0] T3;
  wire[31:0] T4;
  wire[31:0] T5;
  wire[31:0] T6;
  wire[31:0] T7;
  wire[31:0] T8;
  wire[29:0] T9;
  wire[31:0] msizeAddr;
  wire[31:0] T10;
  reg[31:0] callRetBaseReg;
  wire T11;
  wire T12;
  wire T13;
  wire T14;
  reg[2:0] mcacheState;
  wire T15;
  wire T16;
  wire T17;
  wire T18;
  wire T19;
  wire T20;
  reg[9:0] transferSizeReg;
  wire T21;
  wire T22;
  wire[1:0] T23;
  reg[1:0] burstCntReg;
  wire T24;
  wire T25;
  wire T26;
  wire T27;
  wire T28;
  wire[9:0] T29;
  wire[9:0] T30;
  reg[9:0] fetchCntReg;
  wire T31;
  wire T32;
  wire T33;
  reg[1:0] ocpSlaveReg_Resp;
  wire T34;
  wire T35;
  wire[9:0] T36;
  wire[9:0] T37;
  wire[9:0] T38;
  wire[9:0] T39;
  wire T40;
  wire T41;
  wire T42;
  wire T43;
  wire T44;
  wire T45;
  wire T46;
  wire T47;
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
  wire[1:0] T58;
  wire[9:0] T59;
  wire[10:0] T60;
  reg[31:0] ocpSlaveReg_Data;
  wire T61;
  wire T62;
  wire T63;
  wire T64;
  wire T65;
  wire T66;
  wire T67;
  wire T68;
  wire T69;
  wire T70;
  wire[2:0] T71;
  wire[2:0] T72;
  wire[2:0] T73;
  wire[2:0] T74;
  wire[2:0] T75;
  wire[31:0] T76;
  wire[29:0] T77;
  wire[31:0] T78;
  wire[31:0] T79;
  wire[31:0] T80;
  wire[31:0] T81;
  wire[2:0] ocpCmd;
  wire[2:0] T82;
  wire[2:0] T83;
  wire[2:0] T84;
  wire[2:0] T85;
  wire T86;
  wire[9:0] T87;
  wire[31:0] addrOdd;
  wire[31:0] T88;
  wire[31:0] T89;
  reg[31:0] addrOddReg;
  wire T90;
  wire[9:0] T91;
  wire[31:0] addrEven;
  wire[31:0] T92;
  wire[31:0] T93;
  reg[31:0] addrEvenReg;
  wire wTag;
  wire[31:0] wAddr;
  wire[31:0] T94;
  wire[31:0] T95;
  wire[31:0] T96;
  wire[31:0] T97;
  wire[31:0] wData;
  wire[31:0] T98;
  wire[31:0] T99;
  wire[10:0] T100;
  wire[10:0] T101;
  wire[10:0] T102;
  wire[10:0] T103;
  wire T104;
  wire wEna;
  wire fetchEna;
  wire T105;
  wire T106;
  wire T107;

  assign io_ocp_port_M_DataByteEn = 4'b1111/* 0*/;
  assign io_ocp_port_M_DataValid = 1'h0/* 0*/;
  assign io_ocp_port_M_Data = T0;
  assign T0 = {31'h0/* 0*/, 1'h0/* 0*/};
  assign io_ocp_port_M_Addr = T1;
  assign T1 = T2[5'h1f/* 31*/:1'h0/* 0*/];
  assign T2 = {ocpAddr, 2'b00/* 0*/};
  assign ocpAddr = T3;
  assign T3 = T25 ? T78 : T4;
  assign T4 = T42 ? callRetBaseReg : T5;
  assign T5 = T65 ? T76 : T6;
  assign T6 = T11 ? T8 : T7;
  assign T7 = {31'h0/* 0*/, 1'h0/* 0*/};
  assign T8 = {T9, 2'b00/* 0*/};
  assign T9 = msizeAddr[5'h1f/* 31*/:2'h2/* 2*/];
  assign msizeAddr = callRetBaseReg - T10;
  assign T10 = {31'h0/* 0*/, 1'h1/* 1*/};
  assign T11 = T14 && T12;
  assign T12 = ! T13;
  assign T13 = io_mcache_replctrl_hit == 1'h1/* 1*/;
  assign T14 = mcacheState == 3'h0/* 0*/;
  assign T15 = T17 || T16;
  assign T16 = mcacheState == 3'h4/* 4*/;
  assign T17 = T61 || T18;
  assign T18 = T35 && T19;
  assign T19 = ! T20;
  assign T20 = fetchCntReg < transferSizeReg;
  assign T21 = T45 && T22;
  assign T22 = burstCntReg == T23;
  assign T23 = msizeAddr[1'h1/* 1*/:1'h0/* 0*/];
  assign T24 = T40 || T25;
  assign T25 = T27 && T26;
  assign T26 = burstCntReg >= 2'h3/* 3*/;
  assign T27 = T32 && T28;
  assign T28 = fetchCntReg < T29;
  assign T29 = transferSizeReg - T30;
  assign T30 = {9'h0/* 0*/, 1'h1/* 1*/};
  assign T31 = T21 || T32;
  assign T32 = T34 && T33;
  assign T33 = ocpSlaveReg_Resp == 2'b01/* 0*/;
  assign T34 = T35 && T20;
  assign T35 = mcacheState == 3'h3/* 3*/;
  assign T36 = T32 ? T38 : T37;
  assign T37 = {9'h0/* 0*/, 1'h0/* 0*/};
  assign T38 = fetchCntReg + T39;
  assign T39 = {9'h0/* 0*/, 1'h1/* 1*/};
  assign T40 = T41 || T32;
  assign T41 = T44 || T42;
  assign T42 = T21 && T43;
  assign T43 = burstCntReg >= 2'h3/* 3*/;
  assign T44 = T11 || T45;
  assign T45 = T47 && T46;
  assign T46 = ocpSlaveReg_Resp == 2'b01/* 0*/;
  assign T47 = mcacheState == 3'h1/* 1*/;
  assign T48 = T25 ? T58 : T49;
  assign T49 = T32 ? T56 : T50;
  assign T50 = T42 ? T55 : T51;
  assign T51 = T45 ? T53 : T52;
  assign T52 = {1'h0/* 0*/, 1'h0/* 0*/};
  assign T53 = burstCntReg + T54;
  assign T54 = {1'h0/* 0*/, 1'h1/* 1*/};
  assign T55 = {1'h0/* 0*/, 1'h0/* 0*/};
  assign T56 = burstCntReg + T57;
  assign T57 = {1'h0/* 0*/, 1'h1/* 1*/};
  assign T58 = {1'h0/* 0*/, 1'h0/* 0*/};
  assign T59 = T60[4'h9/* 9*/:1'h0/* 0*/];
  assign T60 = ocpSlaveReg_Data[4'hc/* 12*/:2'h2/* 2*/];
  assign T61 = T62 || T21;
  assign T62 = T66 || T63;
  assign T63 = T65 && T64;
  assign T64 = io_ocp_port_S_CmdAccept == 1'h1/* 1*/;
  assign T65 = mcacheState == 3'h2/* 2*/;
  assign T66 = T70 || T67;
  assign T67 = T11 && T68;
  assign T68 = ! T69;
  assign T69 = io_ocp_port_S_CmdAccept == 1'h1/* 1*/;
  assign T70 = T11 && T69;
  assign T71 = T16 ? 3'h0/* 0*/ : T72;
  assign T72 = T18 ? 3'h4/* 4*/ : T73;
  assign T73 = T21 ? 3'h3/* 3*/ : T74;
  assign T74 = T63 ? 3'h1/* 1*/ : T75;
  assign T75 = T67 ? 3'h2/* 2*/ : 3'h1/* 1*/;
  assign T76 = {T77, 2'b00/* 0*/};
  assign T77 = msizeAddr[5'h1f/* 31*/:2'h2/* 2*/];
  assign T78 = T80 + T79;
  assign T79 = {31'h0/* 0*/, 1'h1/* 1*/};
  assign T80 = callRetBaseReg + T81;
  assign T81 = {22'h0/* 0*/, fetchCntReg};
  assign io_ocp_port_M_Cmd = ocpCmd;
  assign ocpCmd = T82;
  assign T82 = T25 ? 3'b010/* 0*/ : T83;
  assign T83 = T42 ? 3'b010/* 0*/ : T84;
  assign T84 = T65 ? 3'b010/* 0*/ : T85;
  assign T85 = T11 ? 3'b010/* 0*/ : 3'b000/* 0*/;
  assign io_mcache_ctrlrepl_instrStall = T86;
  assign T86 = mcacheState != 3'h0/* 0*/;
  assign io_mcache_ctrlrepl_addrOdd = T87;
  assign T87 = addrOdd[4'h9/* 9*/:1'h0/* 0*/];
  assign addrOdd = T88;
  assign T88 = T16 ? io_femcache_addrOdd : T89;
  assign T89 = T90 ? io_femcache_addrOdd : addrOddReg;
  assign T90 = T14 && T13;
  assign io_mcache_ctrlrepl_addrEven = T91;
  assign T91 = addrEven[4'h9/* 9*/:1'h0/* 0*/];
  assign addrEven = T92;
  assign T92 = T16 ? io_femcache_addrEven : T93;
  assign T93 = T90 ? io_femcache_addrEven : addrEvenReg;
  assign io_mcache_ctrlrepl_wTag = wTag;
  assign wTag = T21;
  assign io_mcache_ctrlrepl_wAddr = wAddr;
  assign wAddr = T94;
  assign T94 = T34 ? T97 : T95;
  assign T95 = T21 ? callRetBaseReg : T96;
  assign T96 = {31'h0/* 0*/, 1'h0/* 0*/};
  assign T97 = {22'h0/* 0*/, fetchCntReg};
  assign io_mcache_ctrlrepl_wData = wData;
  assign wData = T98;
  assign T98 = T32 ? ocpSlaveReg_Data : T99;
  assign T99 = {21'h0/* 0*/, T100};
  assign T100 = T21 ? T102 : T101;
  assign T101 = {10'h0/* 0*/, 1'h0/* 0*/};
  assign T102 = T60 + T103;
  assign T103 = {10'h0/* 0*/, T104};
  assign T104 = T60[1'h0/* 0*/:1'h0/* 0*/];
  assign io_mcache_ctrlrepl_wEna = wEna;
  assign wEna = T32;
  assign io_fetch_ena = fetchEna;
  assign fetchEna = T105;
  assign T105 = T35 ? 1'h0/* 0*/ : T106;
  assign T106 = T47 ? 1'h0/* 0*/ : T107;
  assign T107 = T65 ? 1'h0/* 0*/ : 1'h1/* 1*/;

  always @(posedge clk) begin
    if(reset) begin
      callRetBaseReg <= 32'h0/* 0*/;
    end else if(io_exmcache_doCallRet) begin
      callRetBaseReg <= io_exmcache_callRetBase;
    end
    if(reset) begin
      mcacheState <= 3'h0/* 0*/;
    end else if(T15) begin
      mcacheState <= T71;
    end
    if(reset) begin
      transferSizeReg <= 10'h0/* 0*/;
    end else if(T21) begin
      transferSizeReg <= T59;
    end
    if(reset) begin
      burstCntReg <= 2'h0/* 0*/;
    end else if(T24) begin
      burstCntReg <= T48;
    end
    if(reset) begin
      fetchCntReg <= 10'h0/* 0*/;
    end else if(T31) begin
      fetchCntReg <= T36;
    end
    ocpSlaveReg_Resp <= io_ocp_port_S_Resp;
    ocpSlaveReg_Data <= io_ocp_port_S_Data;
    if(reset) begin
      addrOddReg <= 1'h0/* 0*/;
    end else if(io_exmcache_doCallRet) begin
      addrOddReg <= io_femcache_addrOdd;
    end
    if(reset) begin
      addrEvenReg <= 1'h0/* 0*/;
    end else if(io_exmcache_doCallRet) begin
      addrEvenReg <= io_femcache_addrEven;
    end
  end
endmodule

module MCacheReplFifo(input clk, input reset,
    input  io_ena_in,
    output io_hitEna,
    input  io_exmcache_doCallRet,
    input [31:0] io_exmcache_callRetBase,
    input [31:0] io_exmcache_callRetAddr,
    output[31:0] io_mcachefe_instrEven,
    output[31:0] io_mcachefe_instrOdd,
    output[10:0] io_mcachefe_relBase,
    output[11:0] io_mcachefe_relPc,
    output[31:0] io_mcachefe_reloc,
    output[1:0] io_mcachefe_memSel,
    input  io_mcache_ctrlrepl_wEna,
    input [31:0] io_mcache_ctrlrepl_wData,
    input [31:0] io_mcache_ctrlrepl_wAddr,
    input  io_mcache_ctrlrepl_wTag,
    input [9:0] io_mcache_ctrlrepl_addrEven,
    input [9:0] io_mcache_ctrlrepl_addrOdd,
    input  io_mcache_ctrlrepl_instrStall,
    output io_mcache_replctrl_hit,
    output io_mcachemem_in_wEven,
    output io_mcachemem_in_wOdd,
    output[31:0] io_mcachemem_in_wData,
    output[8:0] io_mcachemem_in_wAddr,
    output[8:0] io_mcachemem_in_addrEven,
    output[8:0] io_mcachemem_in_addrOdd,
    input [31:0] instrEven,
    input [31:0] instrOdd
);

  wire[8:0] addrOdd;
  wire[8:0] addrEven;
  wire[8:0] wAddr;
  wire[31:0] T0;
  wire[31:0] T1;
  reg[9:0] wrPosReg;
  reg[9:0] posReg;
  wire T2;
  wire T3;
  wire hit;
  wire T4;
  wire T5;
  wire T6;
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
  reg[0:0] mcacheValidVec_0;
  wire T21;
  wire T22;
  wire T23;
  wire[15:0] T24;
  wire[30:0] T25;
  wire[3:0] T26;
  reg[3:0] nextTagReg;
  wire T27;
  wire signed  T28;
  wire[11:0] T29;
  reg signed [11:0] freeSpaceReg;
  wire T30;
  wire[11:0] T31;
  wire signed [11:0] T32;
  wire signed [11:0] T33;
  wire[11:0] T34;
  wire[10:0] T35;
  wire[10:0] T36;
  wire[10:0] T37;
  wire[10:0] T38;
  reg[10:0] mcacheSizeVec_0;
  wire T39;
  wire T40;
  wire T41;
  wire[15:0] T42;
  wire[30:0] T43;
  wire[3:0] T44;
  wire T45;
  wire T46;
  wire[15:0] T47;
  wire[30:0] T48;
  wire[3:0] T49;
  reg[3:0] nextIndexReg;
  wire[3:0] T50;
  wire[3:0] T51;
  wire[3:0] T52;
  wire[3:0] T53;
  wire T54;
  wire[10:0] T55;
  wire[10:0] T56;
  wire[10:0] T57;
  reg[10:0] mcacheSizeVec_1;
  wire T58;
  wire T59;
  wire T60;
  wire T61;
  wire T62;
  wire[10:0] T63;
  wire[10:0] T64;
  wire T65;
  wire[10:0] T66;
  reg[10:0] mcacheSizeVec_2;
  wire T67;
  wire T68;
  wire T69;
  wire T70;
  wire T71;
  wire[10:0] T72;
  wire[10:0] T73;
  reg[10:0] mcacheSizeVec_3;
  wire T74;
  wire T75;
  wire T76;
  wire T77;
  wire T78;
  wire[10:0] T79;
  wire[10:0] T80;
  wire T81;
  wire T82;
  wire[10:0] T83;
  wire[10:0] T84;
  reg[10:0] mcacheSizeVec_4;
  wire T85;
  wire T86;
  wire T87;
  wire T88;
  wire T89;
  wire[10:0] T90;
  wire[10:0] T91;
  reg[10:0] mcacheSizeVec_5;
  wire T92;
  wire T93;
  wire T94;
  wire T95;
  wire T96;
  wire[10:0] T97;
  wire[10:0] T98;
  wire T99;
  wire[10:0] T100;
  reg[10:0] mcacheSizeVec_6;
  wire T101;
  wire T102;
  wire T103;
  wire T104;
  wire T105;
  wire[10:0] T106;
  wire[10:0] T107;
  reg[10:0] mcacheSizeVec_7;
  wire T108;
  wire T109;
  wire T110;
  wire T111;
  wire T112;
  wire[10:0] T113;
  wire[10:0] T114;
  wire T115;
  wire T116;
  wire T117;
  wire[10:0] T118;
  wire[10:0] T119;
  wire[10:0] T120;
  reg[10:0] mcacheSizeVec_8;
  wire T121;
  wire T122;
  wire T123;
  wire T124;
  wire T125;
  wire[10:0] T126;
  wire[10:0] T127;
  reg[10:0] mcacheSizeVec_9;
  wire T128;
  wire T129;
  wire T130;
  wire T131;
  wire T132;
  wire[10:0] T133;
  wire[10:0] T134;
  wire T135;
  wire[10:0] T136;
  reg[10:0] mcacheSizeVec_10;
  wire T137;
  wire T138;
  wire T139;
  wire T140;
  wire T141;
  wire[10:0] T142;
  wire[10:0] T143;
  reg[10:0] mcacheSizeVec_11;
  wire T144;
  wire T145;
  wire T146;
  wire T147;
  wire T148;
  wire[10:0] T149;
  wire[10:0] T150;
  wire T151;
  wire T152;
  wire[10:0] T153;
  wire[10:0] T154;
  reg[10:0] mcacheSizeVec_12;
  wire T155;
  wire T156;
  wire T157;
  wire T158;
  wire T159;
  wire[10:0] T160;
  wire[10:0] T161;
  reg[10:0] mcacheSizeVec_13;
  wire T162;
  wire T163;
  wire T164;
  wire T165;
  wire T166;
  wire[10:0] T167;
  wire[10:0] T168;
  wire T169;
  wire[10:0] T170;
  reg[10:0] mcacheSizeVec_14;
  wire T171;
  wire T172;
  wire T173;
  wire T174;
  wire T175;
  wire[10:0] T176;
  wire[10:0] T177;
  reg[10:0] mcacheSizeVec_15;
  wire T178;
  wire T179;
  wire T180;
  wire T181;
  wire T182;
  wire[10:0] T183;
  wire[10:0] T184;
  wire T185;
  wire T186;
  wire T187;
  wire T188;
  wire signed [11:0] T189;
  wire signed [11:0] T190;
  wire[11:0] T191;
  wire[10:0] T192;
  wire signed [11:0] T193;
  wire signed [11:0] T194;
  wire[11:0] T195;
  wire[10:0] T196;
  wire[10:0] T197;
  wire[10:0] T198;
  wire[10:0] T199;
  wire T200;
  wire[10:0] T201;
  wire T202;
  wire T203;
  wire[10:0] T204;
  wire[10:0] T205;
  wire T206;
  wire[10:0] T207;
  wire T208;
  wire T209;
  wire T210;
  wire[10:0] T211;
  wire[10:0] T212;
  wire[10:0] T213;
  wire T214;
  wire[10:0] T215;
  wire T216;
  wire T217;
  wire[10:0] T218;
  wire[10:0] T219;
  wire T220;
  wire[10:0] T221;
  wire T222;
  wire T223;
  wire T224;
  wire T225;
  wire T226;
  wire T227;
  wire[3:0] T228;
  wire[3:0] T229;
  wire[3:0] T230;
  wire[3:0] T231;
  wire[3:0] T232;
  wire T233;
  wire T234;
  wire T235;
  wire[15:0] T236;
  wire[30:0] T237;
  wire[3:0] T238;
  wire T239;
  wire T240;
  reg[31:0] mcacheAddrVec_0;
  wire T241;
  wire T242;
  wire[15:0] T243;
  wire[30:0] T244;
  wire[3:0] T245;
  wire T246;
  wire T247;
  wire[16:0] T248;
  wire[16:0] T249;
  wire T250;
  wire T251;
  wire T252;
  reg[0:0] mcacheValidVec_1;
  wire T253;
  wire T254;
  wire T255;
  wire T256;
  wire T257;
  wire T258;
  wire T259;
  reg[31:0] mcacheAddrVec_1;
  wire T260;
  wire T261;
  wire T262;
  wire T263;
  reg[0:0] mcacheValidVec_2;
  wire T264;
  wire T265;
  wire T266;
  wire T267;
  wire T268;
  wire T269;
  wire T270;
  reg[31:0] mcacheAddrVec_2;
  wire T271;
  wire T272;
  wire T273;
  wire T274;
  reg[0:0] mcacheValidVec_3;
  wire T275;
  wire T276;
  wire T277;
  wire T278;
  wire T279;
  wire T280;
  wire T281;
  reg[31:0] mcacheAddrVec_3;
  wire T282;
  wire T283;
  wire T284;
  wire T285;
  reg[0:0] mcacheValidVec_4;
  wire T286;
  wire T287;
  wire T288;
  wire T289;
  wire T290;
  wire T291;
  wire T292;
  reg[31:0] mcacheAddrVec_4;
  wire T293;
  wire T294;
  wire T295;
  wire T296;
  reg[0:0] mcacheValidVec_5;
  wire T297;
  wire T298;
  wire T299;
  wire T300;
  wire T301;
  wire T302;
  wire T303;
  reg[31:0] mcacheAddrVec_5;
  wire T304;
  wire T305;
  wire T306;
  wire T307;
  reg[0:0] mcacheValidVec_6;
  wire T308;
  wire T309;
  wire T310;
  wire T311;
  wire T312;
  wire T313;
  wire T314;
  reg[31:0] mcacheAddrVec_6;
  wire T315;
  wire T316;
  wire T317;
  wire T318;
  reg[0:0] mcacheValidVec_7;
  wire T319;
  wire T320;
  wire T321;
  wire T322;
  wire T323;
  wire T324;
  wire T325;
  reg[31:0] mcacheAddrVec_7;
  wire T326;
  wire T327;
  wire T328;
  wire T329;
  reg[0:0] mcacheValidVec_8;
  wire T330;
  wire T331;
  wire T332;
  wire T333;
  wire T334;
  wire T335;
  wire T336;
  reg[31:0] mcacheAddrVec_8;
  wire T337;
  wire T338;
  wire T339;
  wire T340;
  reg[0:0] mcacheValidVec_9;
  wire T341;
  wire T342;
  wire T343;
  wire T344;
  wire T345;
  wire T346;
  wire T347;
  reg[31:0] mcacheAddrVec_9;
  wire T348;
  wire T349;
  wire T350;
  wire T351;
  reg[0:0] mcacheValidVec_10;
  wire T352;
  wire T353;
  wire T354;
  wire T355;
  wire T356;
  wire T357;
  wire T358;
  reg[31:0] mcacheAddrVec_10;
  wire T359;
  wire T360;
  wire T361;
  wire T362;
  reg[0:0] mcacheValidVec_11;
  wire T363;
  wire T364;
  wire T365;
  wire T366;
  wire T367;
  wire T368;
  wire T369;
  reg[31:0] mcacheAddrVec_11;
  wire T370;
  wire T371;
  wire T372;
  wire T373;
  reg[0:0] mcacheValidVec_12;
  wire T374;
  wire T375;
  wire T376;
  wire T377;
  wire T378;
  wire T379;
  wire T380;
  reg[31:0] mcacheAddrVec_12;
  wire T381;
  wire T382;
  wire T383;
  wire T384;
  reg[0:0] mcacheValidVec_13;
  wire T385;
  wire T386;
  wire T387;
  wire T388;
  wire T389;
  wire T390;
  wire T391;
  reg[31:0] mcacheAddrVec_13;
  wire T392;
  wire T393;
  wire T394;
  wire T395;
  reg[0:0] mcacheValidVec_14;
  wire T396;
  wire T397;
  wire T398;
  wire T399;
  wire T400;
  wire T401;
  wire T402;
  reg[31:0] mcacheAddrVec_14;
  wire T403;
  wire T404;
  wire T405;
  wire T406;
  reg[0:0] mcacheValidVec_15;
  wire T407;
  wire T408;
  wire T409;
  wire T410;
  wire T411;
  wire T412;
  wire T413;
  reg[31:0] mcacheAddrVec_15;
  wire T414;
  wire T415;
  wire[9:0] T416;
  reg[9:0] nextPosReg;
  wire[9:0] T417;
  wire[9:0] T418;
  wire[9:0] T419;
  wire[9:0] mergePosVec_15;
  wire[9:0] T420;
  wire[9:0] T421;
  reg[9:0] mcachePosVec_15;
  wire T422;
  wire T423;
  wire[15:0] T424;
  wire[30:0] T425;
  wire[3:0] T426;
  wire[9:0] T427;
  wire[9:0] mergePosVec_14;
  wire[9:0] T428;
  wire[9:0] T429;
  reg[9:0] mcachePosVec_14;
  wire T430;
  wire T431;
  wire[9:0] T432;
  wire[9:0] mergePosVec_13;
  wire[9:0] T433;
  wire[9:0] T434;
  reg[9:0] mcachePosVec_13;
  wire T435;
  wire T436;
  wire[9:0] T437;
  wire[9:0] mergePosVec_12;
  wire[9:0] T438;
  wire[9:0] T439;
  reg[9:0] mcachePosVec_12;
  wire T440;
  wire T441;
  wire[9:0] T442;
  wire[9:0] mergePosVec_11;
  wire[9:0] T443;
  wire[9:0] T444;
  reg[9:0] mcachePosVec_11;
  wire T445;
  wire T446;
  wire[9:0] T447;
  wire[9:0] mergePosVec_10;
  wire[9:0] T448;
  wire[9:0] T449;
  reg[9:0] mcachePosVec_10;
  wire T450;
  wire T451;
  wire[9:0] T452;
  wire[9:0] mergePosVec_9;
  wire[9:0] T453;
  wire[9:0] T454;
  reg[9:0] mcachePosVec_9;
  wire T455;
  wire T456;
  wire[9:0] T457;
  wire[9:0] mergePosVec_8;
  wire[9:0] T458;
  wire[9:0] T459;
  reg[9:0] mcachePosVec_8;
  wire T460;
  wire T461;
  wire[9:0] T462;
  wire[9:0] mergePosVec_7;
  wire[9:0] T463;
  wire[9:0] T464;
  reg[9:0] mcachePosVec_7;
  wire T465;
  wire T466;
  wire[9:0] T467;
  wire[9:0] mergePosVec_6;
  wire[9:0] T468;
  wire[9:0] T469;
  reg[9:0] mcachePosVec_6;
  wire T470;
  wire T471;
  wire[9:0] T472;
  wire[9:0] mergePosVec_5;
  wire[9:0] T473;
  wire[9:0] T474;
  reg[9:0] mcachePosVec_5;
  wire T475;
  wire T476;
  wire[9:0] T477;
  wire[9:0] mergePosVec_4;
  wire[9:0] T478;
  wire[9:0] T479;
  reg[9:0] mcachePosVec_4;
  wire T480;
  wire T481;
  wire[9:0] T482;
  wire[9:0] mergePosVec_3;
  wire[9:0] T483;
  wire[9:0] T484;
  reg[9:0] mcachePosVec_3;
  wire T485;
  wire T486;
  wire[9:0] T487;
  wire[9:0] mergePosVec_2;
  wire[9:0] T488;
  wire[9:0] T489;
  reg[9:0] mcachePosVec_2;
  wire T490;
  wire T491;
  wire[9:0] T492;
  wire[9:0] mergePosVec_1;
  wire[9:0] T493;
  wire[9:0] T494;
  reg[9:0] mcachePosVec_1;
  wire T495;
  wire T496;
  wire[9:0] T497;
  wire[9:0] mergePosVec_0;
  wire[9:0] T498;
  wire[9:0] T499;
  reg[9:0] mcachePosVec_0;
  wire T500;
  wire T501;
  wire[9:0] T502;
  wire T503;
  wire wParity;
  wire T504;
  reg[0:0] hitReg;
  wire T505;
  wire T506;
  wire T507;
  wire T508;
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
  wire[1:0] T538;
  reg[0:0] selMCacheReg;
  wire T539;
  wire[16:0] T540;
  wire[16:0] T541;
  reg[0:0] selIspmReg;
  wire T542;
  wire[17:0] T543;
  wire[17:0] T544;
  wire[31:0] reloc;
  wire[31:0] T545;
  wire[14:0] T546;
  wire[14:0] T547;
  wire[31:0] T548;
  wire[31:0] T549;
  wire[9:0] T550;
  reg[31:0] callRetBaseReg;
  wire[11:0] T551;
  wire[31:0] relPc;
  wire[31:0] T552;
  wire[13:0] relBase;
  wire[13:0] T553;
  wire[13:0] T554;
  wire[9:0] T555;
  reg[31:0] callAddrReg;
  wire[10:0] T556;
  wire[31:0] T557;
  reg[31:0] instrOddReg;
  wire T558;
  wire[31:0] T559;
  reg[31:0] instrEvenReg;

  assign io_mcachemem_in_addrOdd = addrOdd;
  assign addrOdd = io_mcache_ctrlrepl_addrOdd[4'h9/* 9*/:1'h1/* 1*/];
  assign io_mcachemem_in_addrEven = addrEven;
  assign addrEven = io_mcache_ctrlrepl_addrEven[4'h9/* 9*/:1'h1/* 1*/];
  assign io_mcachemem_in_wAddr = wAddr;
  assign wAddr = T0[4'h9/* 9*/:1'h1/* 1*/];
  assign T0 = T1 + io_mcache_ctrlrepl_wAddr;
  assign T1 = {22'h0/* 0*/, wrPosReg};
  assign T2 = T246 || T3;
  assign T3 = T246 && hit;
  assign hit = T4;
  assign T4 = T405 ? 1'h1/* 1*/ : T5;
  assign T5 = T394 ? 1'h1/* 1*/ : T6;
  assign T6 = T383 ? 1'h1/* 1*/ : T7;
  assign T7 = T372 ? 1'h1/* 1*/ : T8;
  assign T8 = T361 ? 1'h1/* 1*/ : T9;
  assign T9 = T350 ? 1'h1/* 1*/ : T10;
  assign T10 = T339 ? 1'h1/* 1*/ : T11;
  assign T11 = T328 ? 1'h1/* 1*/ : T12;
  assign T12 = T317 ? 1'h1/* 1*/ : T13;
  assign T13 = T306 ? 1'h1/* 1*/ : T14;
  assign T14 = T295 ? 1'h1/* 1*/ : T15;
  assign T15 = T284 ? 1'h1/* 1*/ : T16;
  assign T16 = T273 ? 1'h1/* 1*/ : T17;
  assign T17 = T262 ? 1'h1/* 1*/ : T18;
  assign T18 = T251 ? 1'h1/* 1*/ : T19;
  assign T19 = T246 && T20;
  assign T20 = T240 && mcacheValidVec_0;
  assign T21 = T234 || T22;
  assign T22 = T28 && T23;
  assign T23 = T24[1'h0/* 0*/:1'h0/* 0*/];
  assign T24 = T25[4'hf/* 15*/:1'h0/* 0*/];
  assign T25 = 16'h1/* 1*/ << T26;
  assign T26 = nextTagReg;
  assign T27 = T226 || T28;
  assign T28 = $signed(freeSpaceReg) < $signed(T29);
  assign T29 = {11'h0/* 0*/, 1'h0/* 0*/};
  assign T30 = io_mcache_ctrlrepl_wTag || T28;
  assign T31 = T28 ? T193 : T32;
  assign T32 = $signed(T189) + $signed(T33);
  assign T33 = T34;
  assign T34 = {1'h0/* 0*/, T35};
  assign T35 = T188 ? T118 : T36;
  assign T36 = T117 ? T83 : T37;
  assign T37 = T82 ? T66 : T38;
  assign T38 = T65 ? mcacheSizeVec_1 : mcacheSizeVec_0;
  assign T39 = T45 || T40;
  assign T40 = T28 && T41;
  assign T41 = T42[1'h0/* 0*/:1'h0/* 0*/];
  assign T42 = T43[4'hf/* 15*/:1'h0/* 0*/];
  assign T43 = 16'h1/* 1*/ << T44;
  assign T44 = nextTagReg;
  assign T45 = io_mcache_ctrlrepl_wTag && T46;
  assign T46 = T47[1'h0/* 0*/:1'h0/* 0*/];
  assign T47 = T48[4'hf/* 15*/:1'h0/* 0*/];
  assign T48 = 16'h1/* 1*/ << T49;
  assign T49 = nextIndexReg;
  assign T50 = T54 ? T53 : T51;
  assign T51 = nextIndexReg + T52;
  assign T52 = {3'h0/* 0*/, 1'h1/* 1*/};
  assign T53 = {3'h0/* 0*/, 1'h0/* 0*/};
  assign T54 = nextIndexReg == 4'hf/* 15*/;
  assign T55 = T40 ? T57 : T56;
  assign T56 = io_mcache_ctrlrepl_wData[4'ha/* 10*/:1'h0/* 0*/];
  assign T57 = {10'h0/* 0*/, 1'h0/* 0*/};
  assign T58 = T61 || T59;
  assign T59 = T28 && T60;
  assign T60 = T42[1'h1/* 1*/:1'h1/* 1*/];
  assign T61 = io_mcache_ctrlrepl_wTag && T62;
  assign T62 = T47[1'h1/* 1*/:1'h1/* 1*/];
  assign T63 = T59 ? T64 : T56;
  assign T64 = {10'h0/* 0*/, 1'h0/* 0*/};
  assign T65 = T49[1'h0/* 0*/:1'h0/* 0*/];
  assign T66 = T81 ? mcacheSizeVec_3 : mcacheSizeVec_2;
  assign T67 = T70 || T68;
  assign T68 = T28 && T69;
  assign T69 = T42[2'h2/* 2*/:2'h2/* 2*/];
  assign T70 = io_mcache_ctrlrepl_wTag && T71;
  assign T71 = T47[2'h2/* 2*/:2'h2/* 2*/];
  assign T72 = T68 ? T73 : T56;
  assign T73 = {10'h0/* 0*/, 1'h0/* 0*/};
  assign T74 = T77 || T75;
  assign T75 = T28 && T76;
  assign T76 = T42[2'h3/* 3*/:2'h3/* 3*/];
  assign T77 = io_mcache_ctrlrepl_wTag && T78;
  assign T78 = T47[2'h3/* 3*/:2'h3/* 3*/];
  assign T79 = T75 ? T80 : T56;
  assign T80 = {10'h0/* 0*/, 1'h0/* 0*/};
  assign T81 = T49[1'h0/* 0*/:1'h0/* 0*/];
  assign T82 = T49[1'h1/* 1*/:1'h1/* 1*/];
  assign T83 = T116 ? T100 : T84;
  assign T84 = T99 ? mcacheSizeVec_5 : mcacheSizeVec_4;
  assign T85 = T88 || T86;
  assign T86 = T28 && T87;
  assign T87 = T42[3'h4/* 4*/:3'h4/* 4*/];
  assign T88 = io_mcache_ctrlrepl_wTag && T89;
  assign T89 = T47[3'h4/* 4*/:3'h4/* 4*/];
  assign T90 = T86 ? T91 : T56;
  assign T91 = {10'h0/* 0*/, 1'h0/* 0*/};
  assign T92 = T95 || T93;
  assign T93 = T28 && T94;
  assign T94 = T42[3'h5/* 5*/:3'h5/* 5*/];
  assign T95 = io_mcache_ctrlrepl_wTag && T96;
  assign T96 = T47[3'h5/* 5*/:3'h5/* 5*/];
  assign T97 = T93 ? T98 : T56;
  assign T98 = {10'h0/* 0*/, 1'h0/* 0*/};
  assign T99 = T49[1'h0/* 0*/:1'h0/* 0*/];
  assign T100 = T115 ? mcacheSizeVec_7 : mcacheSizeVec_6;
  assign T101 = T104 || T102;
  assign T102 = T28 && T103;
  assign T103 = T42[3'h6/* 6*/:3'h6/* 6*/];
  assign T104 = io_mcache_ctrlrepl_wTag && T105;
  assign T105 = T47[3'h6/* 6*/:3'h6/* 6*/];
  assign T106 = T102 ? T107 : T56;
  assign T107 = {10'h0/* 0*/, 1'h0/* 0*/};
  assign T108 = T111 || T109;
  assign T109 = T28 && T110;
  assign T110 = T42[3'h7/* 7*/:3'h7/* 7*/];
  assign T111 = io_mcache_ctrlrepl_wTag && T112;
  assign T112 = T47[3'h7/* 7*/:3'h7/* 7*/];
  assign T113 = T109 ? T114 : T56;
  assign T114 = {10'h0/* 0*/, 1'h0/* 0*/};
  assign T115 = T49[1'h0/* 0*/:1'h0/* 0*/];
  assign T116 = T49[1'h1/* 1*/:1'h1/* 1*/];
  assign T117 = T49[2'h2/* 2*/:2'h2/* 2*/];
  assign T118 = T187 ? T153 : T119;
  assign T119 = T152 ? T136 : T120;
  assign T120 = T135 ? mcacheSizeVec_9 : mcacheSizeVec_8;
  assign T121 = T124 || T122;
  assign T122 = T28 && T123;
  assign T123 = T42[4'h8/* 8*/:4'h8/* 8*/];
  assign T124 = io_mcache_ctrlrepl_wTag && T125;
  assign T125 = T47[4'h8/* 8*/:4'h8/* 8*/];
  assign T126 = T122 ? T127 : T56;
  assign T127 = {10'h0/* 0*/, 1'h0/* 0*/};
  assign T128 = T131 || T129;
  assign T129 = T28 && T130;
  assign T130 = T42[4'h9/* 9*/:4'h9/* 9*/];
  assign T131 = io_mcache_ctrlrepl_wTag && T132;
  assign T132 = T47[4'h9/* 9*/:4'h9/* 9*/];
  assign T133 = T129 ? T134 : T56;
  assign T134 = {10'h0/* 0*/, 1'h0/* 0*/};
  assign T135 = T49[1'h0/* 0*/:1'h0/* 0*/];
  assign T136 = T151 ? mcacheSizeVec_11 : mcacheSizeVec_10;
  assign T137 = T140 || T138;
  assign T138 = T28 && T139;
  assign T139 = T42[4'ha/* 10*/:4'ha/* 10*/];
  assign T140 = io_mcache_ctrlrepl_wTag && T141;
  assign T141 = T47[4'ha/* 10*/:4'ha/* 10*/];
  assign T142 = T138 ? T143 : T56;
  assign T143 = {10'h0/* 0*/, 1'h0/* 0*/};
  assign T144 = T147 || T145;
  assign T145 = T28 && T146;
  assign T146 = T42[4'hb/* 11*/:4'hb/* 11*/];
  assign T147 = io_mcache_ctrlrepl_wTag && T148;
  assign T148 = T47[4'hb/* 11*/:4'hb/* 11*/];
  assign T149 = T145 ? T150 : T56;
  assign T150 = {10'h0/* 0*/, 1'h0/* 0*/};
  assign T151 = T49[1'h0/* 0*/:1'h0/* 0*/];
  assign T152 = T49[1'h1/* 1*/:1'h1/* 1*/];
  assign T153 = T186 ? T170 : T154;
  assign T154 = T169 ? mcacheSizeVec_13 : mcacheSizeVec_12;
  assign T155 = T158 || T156;
  assign T156 = T28 && T157;
  assign T157 = T42[4'hc/* 12*/:4'hc/* 12*/];
  assign T158 = io_mcache_ctrlrepl_wTag && T159;
  assign T159 = T47[4'hc/* 12*/:4'hc/* 12*/];
  assign T160 = T156 ? T161 : T56;
  assign T161 = {10'h0/* 0*/, 1'h0/* 0*/};
  assign T162 = T165 || T163;
  assign T163 = T28 && T164;
  assign T164 = T42[4'hd/* 13*/:4'hd/* 13*/];
  assign T165 = io_mcache_ctrlrepl_wTag && T166;
  assign T166 = T47[4'hd/* 13*/:4'hd/* 13*/];
  assign T167 = T163 ? T168 : T56;
  assign T168 = {10'h0/* 0*/, 1'h0/* 0*/};
  assign T169 = T49[1'h0/* 0*/:1'h0/* 0*/];
  assign T170 = T185 ? mcacheSizeVec_15 : mcacheSizeVec_14;
  assign T171 = T174 || T172;
  assign T172 = T28 && T173;
  assign T173 = T42[4'he/* 14*/:4'he/* 14*/];
  assign T174 = io_mcache_ctrlrepl_wTag && T175;
  assign T175 = T47[4'he/* 14*/:4'he/* 14*/];
  assign T176 = T172 ? T177 : T56;
  assign T177 = {10'h0/* 0*/, 1'h0/* 0*/};
  assign T178 = T181 || T179;
  assign T179 = T28 && T180;
  assign T180 = T42[4'hf/* 15*/:4'hf/* 15*/];
  assign T181 = io_mcache_ctrlrepl_wTag && T182;
  assign T182 = T47[4'hf/* 15*/:4'hf/* 15*/];
  assign T183 = T179 ? T184 : T56;
  assign T184 = {10'h0/* 0*/, 1'h0/* 0*/};
  assign T185 = T49[1'h0/* 0*/:1'h0/* 0*/];
  assign T186 = T49[1'h1/* 1*/:1'h1/* 1*/];
  assign T187 = T49[2'h2/* 2*/:2'h2/* 2*/];
  assign T188 = T49[2'h3/* 3*/:2'h3/* 3*/];
  assign T189 = $signed(freeSpaceReg) - $signed(T190);
  assign T190 = T191;
  assign T191 = {1'h0/* 0*/, T192};
  assign T192 = io_mcache_ctrlrepl_wData[4'ha/* 10*/:1'h0/* 0*/];
  assign T193 = $signed(freeSpaceReg) + $signed(T194);
  assign T194 = T195;
  assign T195 = {1'h0/* 0*/, T196};
  assign T196 = T225 ? T211 : T197;
  assign T197 = T210 ? T204 : T198;
  assign T198 = T203 ? T201 : T199;
  assign T199 = T200 ? mcacheSizeVec_1 : mcacheSizeVec_0;
  assign T200 = T44[1'h0/* 0*/:1'h0/* 0*/];
  assign T201 = T202 ? mcacheSizeVec_3 : mcacheSizeVec_2;
  assign T202 = T44[1'h0/* 0*/:1'h0/* 0*/];
  assign T203 = T44[1'h1/* 1*/:1'h1/* 1*/];
  assign T204 = T209 ? T207 : T205;
  assign T205 = T206 ? mcacheSizeVec_5 : mcacheSizeVec_4;
  assign T206 = T44[1'h0/* 0*/:1'h0/* 0*/];
  assign T207 = T208 ? mcacheSizeVec_7 : mcacheSizeVec_6;
  assign T208 = T44[1'h0/* 0*/:1'h0/* 0*/];
  assign T209 = T44[1'h1/* 1*/:1'h1/* 1*/];
  assign T210 = T44[2'h2/* 2*/:2'h2/* 2*/];
  assign T211 = T224 ? T218 : T212;
  assign T212 = T217 ? T215 : T213;
  assign T213 = T214 ? mcacheSizeVec_9 : mcacheSizeVec_8;
  assign T214 = T44[1'h0/* 0*/:1'h0/* 0*/];
  assign T215 = T216 ? mcacheSizeVec_11 : mcacheSizeVec_10;
  assign T216 = T44[1'h0/* 0*/:1'h0/* 0*/];
  assign T217 = T44[1'h1/* 1*/:1'h1/* 1*/];
  assign T218 = T223 ? T221 : T219;
  assign T219 = T220 ? mcacheSizeVec_13 : mcacheSizeVec_12;
  assign T220 = T44[1'h0/* 0*/:1'h0/* 0*/];
  assign T221 = T222 ? mcacheSizeVec_15 : mcacheSizeVec_14;
  assign T222 = T44[1'h0/* 0*/:1'h0/* 0*/];
  assign T223 = T44[1'h1/* 1*/:1'h1/* 1*/];
  assign T224 = T44[2'h2/* 2*/:2'h2/* 2*/];
  assign T225 = T44[2'h3/* 3*/:2'h3/* 3*/];
  assign T226 = io_mcache_ctrlrepl_wTag && T227;
  assign T227 = nextTagReg == nextIndexReg;
  assign T228 = T28 ? T229 : T50;
  assign T229 = T233 ? T232 : T230;
  assign T230 = nextTagReg + T231;
  assign T231 = {3'h0/* 0*/, 1'h1/* 1*/};
  assign T232 = {3'h0/* 0*/, 1'h0/* 0*/};
  assign T233 = nextTagReg == 4'hf/* 15*/;
  assign T234 = io_mcache_ctrlrepl_wTag && T235;
  assign T235 = T236[1'h0/* 0*/:1'h0/* 0*/];
  assign T236 = T237[4'hf/* 15*/:1'h0/* 0*/];
  assign T237 = 16'h1/* 1*/ << T238;
  assign T238 = nextIndexReg;
  assign T239 = T22 ? 1'h0/* 0*/ : 1'h1/* 1*/;
  assign T240 = io_exmcache_callRetBase == mcacheAddrVec_0;
  assign T241 = io_mcache_ctrlrepl_wTag && T242;
  assign T242 = T243[1'h0/* 0*/:1'h0/* 0*/];
  assign T243 = T244[4'hf/* 15*/:1'h0/* 0*/];
  assign T244 = 16'h1/* 1*/ << T245;
  assign T245 = nextIndexReg;
  assign T246 = T250 && T247;
  assign T247 = T249 >= T248;
  assign T248 = {16'h0/* 0*/, 1'h1/* 1*/};
  assign T249 = io_exmcache_callRetBase[5'h1f/* 31*/:4'hf/* 15*/];
  assign T250 = io_exmcache_doCallRet && io_ena_in;
  assign T251 = T246 && T252;
  assign T252 = T259 && mcacheValidVec_1;
  assign T253 = T256 || T254;
  assign T254 = T28 && T255;
  assign T255 = T24[1'h1/* 1*/:1'h1/* 1*/];
  assign T256 = io_mcache_ctrlrepl_wTag && T257;
  assign T257 = T236[1'h1/* 1*/:1'h1/* 1*/];
  assign T258 = T254 ? 1'h0/* 0*/ : 1'h1/* 1*/;
  assign T259 = io_exmcache_callRetBase == mcacheAddrVec_1;
  assign T260 = io_mcache_ctrlrepl_wTag && T261;
  assign T261 = T243[1'h1/* 1*/:1'h1/* 1*/];
  assign T262 = T246 && T263;
  assign T263 = T270 && mcacheValidVec_2;
  assign T264 = T267 || T265;
  assign T265 = T28 && T266;
  assign T266 = T24[2'h2/* 2*/:2'h2/* 2*/];
  assign T267 = io_mcache_ctrlrepl_wTag && T268;
  assign T268 = T236[2'h2/* 2*/:2'h2/* 2*/];
  assign T269 = T265 ? 1'h0/* 0*/ : 1'h1/* 1*/;
  assign T270 = io_exmcache_callRetBase == mcacheAddrVec_2;
  assign T271 = io_mcache_ctrlrepl_wTag && T272;
  assign T272 = T243[2'h2/* 2*/:2'h2/* 2*/];
  assign T273 = T246 && T274;
  assign T274 = T281 && mcacheValidVec_3;
  assign T275 = T278 || T276;
  assign T276 = T28 && T277;
  assign T277 = T24[2'h3/* 3*/:2'h3/* 3*/];
  assign T278 = io_mcache_ctrlrepl_wTag && T279;
  assign T279 = T236[2'h3/* 3*/:2'h3/* 3*/];
  assign T280 = T276 ? 1'h0/* 0*/ : 1'h1/* 1*/;
  assign T281 = io_exmcache_callRetBase == mcacheAddrVec_3;
  assign T282 = io_mcache_ctrlrepl_wTag && T283;
  assign T283 = T243[2'h3/* 3*/:2'h3/* 3*/];
  assign T284 = T246 && T285;
  assign T285 = T292 && mcacheValidVec_4;
  assign T286 = T289 || T287;
  assign T287 = T28 && T288;
  assign T288 = T24[3'h4/* 4*/:3'h4/* 4*/];
  assign T289 = io_mcache_ctrlrepl_wTag && T290;
  assign T290 = T236[3'h4/* 4*/:3'h4/* 4*/];
  assign T291 = T287 ? 1'h0/* 0*/ : 1'h1/* 1*/;
  assign T292 = io_exmcache_callRetBase == mcacheAddrVec_4;
  assign T293 = io_mcache_ctrlrepl_wTag && T294;
  assign T294 = T243[3'h4/* 4*/:3'h4/* 4*/];
  assign T295 = T246 && T296;
  assign T296 = T303 && mcacheValidVec_5;
  assign T297 = T300 || T298;
  assign T298 = T28 && T299;
  assign T299 = T24[3'h5/* 5*/:3'h5/* 5*/];
  assign T300 = io_mcache_ctrlrepl_wTag && T301;
  assign T301 = T236[3'h5/* 5*/:3'h5/* 5*/];
  assign T302 = T298 ? 1'h0/* 0*/ : 1'h1/* 1*/;
  assign T303 = io_exmcache_callRetBase == mcacheAddrVec_5;
  assign T304 = io_mcache_ctrlrepl_wTag && T305;
  assign T305 = T243[3'h5/* 5*/:3'h5/* 5*/];
  assign T306 = T246 && T307;
  assign T307 = T314 && mcacheValidVec_6;
  assign T308 = T311 || T309;
  assign T309 = T28 && T310;
  assign T310 = T24[3'h6/* 6*/:3'h6/* 6*/];
  assign T311 = io_mcache_ctrlrepl_wTag && T312;
  assign T312 = T236[3'h6/* 6*/:3'h6/* 6*/];
  assign T313 = T309 ? 1'h0/* 0*/ : 1'h1/* 1*/;
  assign T314 = io_exmcache_callRetBase == mcacheAddrVec_6;
  assign T315 = io_mcache_ctrlrepl_wTag && T316;
  assign T316 = T243[3'h6/* 6*/:3'h6/* 6*/];
  assign T317 = T246 && T318;
  assign T318 = T325 && mcacheValidVec_7;
  assign T319 = T322 || T320;
  assign T320 = T28 && T321;
  assign T321 = T24[3'h7/* 7*/:3'h7/* 7*/];
  assign T322 = io_mcache_ctrlrepl_wTag && T323;
  assign T323 = T236[3'h7/* 7*/:3'h7/* 7*/];
  assign T324 = T320 ? 1'h0/* 0*/ : 1'h1/* 1*/;
  assign T325 = io_exmcache_callRetBase == mcacheAddrVec_7;
  assign T326 = io_mcache_ctrlrepl_wTag && T327;
  assign T327 = T243[3'h7/* 7*/:3'h7/* 7*/];
  assign T328 = T246 && T329;
  assign T329 = T336 && mcacheValidVec_8;
  assign T330 = T333 || T331;
  assign T331 = T28 && T332;
  assign T332 = T24[4'h8/* 8*/:4'h8/* 8*/];
  assign T333 = io_mcache_ctrlrepl_wTag && T334;
  assign T334 = T236[4'h8/* 8*/:4'h8/* 8*/];
  assign T335 = T331 ? 1'h0/* 0*/ : 1'h1/* 1*/;
  assign T336 = io_exmcache_callRetBase == mcacheAddrVec_8;
  assign T337 = io_mcache_ctrlrepl_wTag && T338;
  assign T338 = T243[4'h8/* 8*/:4'h8/* 8*/];
  assign T339 = T246 && T340;
  assign T340 = T347 && mcacheValidVec_9;
  assign T341 = T344 || T342;
  assign T342 = T28 && T343;
  assign T343 = T24[4'h9/* 9*/:4'h9/* 9*/];
  assign T344 = io_mcache_ctrlrepl_wTag && T345;
  assign T345 = T236[4'h9/* 9*/:4'h9/* 9*/];
  assign T346 = T342 ? 1'h0/* 0*/ : 1'h1/* 1*/;
  assign T347 = io_exmcache_callRetBase == mcacheAddrVec_9;
  assign T348 = io_mcache_ctrlrepl_wTag && T349;
  assign T349 = T243[4'h9/* 9*/:4'h9/* 9*/];
  assign T350 = T246 && T351;
  assign T351 = T358 && mcacheValidVec_10;
  assign T352 = T355 || T353;
  assign T353 = T28 && T354;
  assign T354 = T24[4'ha/* 10*/:4'ha/* 10*/];
  assign T355 = io_mcache_ctrlrepl_wTag && T356;
  assign T356 = T236[4'ha/* 10*/:4'ha/* 10*/];
  assign T357 = T353 ? 1'h0/* 0*/ : 1'h1/* 1*/;
  assign T358 = io_exmcache_callRetBase == mcacheAddrVec_10;
  assign T359 = io_mcache_ctrlrepl_wTag && T360;
  assign T360 = T243[4'ha/* 10*/:4'ha/* 10*/];
  assign T361 = T246 && T362;
  assign T362 = T369 && mcacheValidVec_11;
  assign T363 = T366 || T364;
  assign T364 = T28 && T365;
  assign T365 = T24[4'hb/* 11*/:4'hb/* 11*/];
  assign T366 = io_mcache_ctrlrepl_wTag && T367;
  assign T367 = T236[4'hb/* 11*/:4'hb/* 11*/];
  assign T368 = T364 ? 1'h0/* 0*/ : 1'h1/* 1*/;
  assign T369 = io_exmcache_callRetBase == mcacheAddrVec_11;
  assign T370 = io_mcache_ctrlrepl_wTag && T371;
  assign T371 = T243[4'hb/* 11*/:4'hb/* 11*/];
  assign T372 = T246 && T373;
  assign T373 = T380 && mcacheValidVec_12;
  assign T374 = T377 || T375;
  assign T375 = T28 && T376;
  assign T376 = T24[4'hc/* 12*/:4'hc/* 12*/];
  assign T377 = io_mcache_ctrlrepl_wTag && T378;
  assign T378 = T236[4'hc/* 12*/:4'hc/* 12*/];
  assign T379 = T375 ? 1'h0/* 0*/ : 1'h1/* 1*/;
  assign T380 = io_exmcache_callRetBase == mcacheAddrVec_12;
  assign T381 = io_mcache_ctrlrepl_wTag && T382;
  assign T382 = T243[4'hc/* 12*/:4'hc/* 12*/];
  assign T383 = T246 && T384;
  assign T384 = T391 && mcacheValidVec_13;
  assign T385 = T388 || T386;
  assign T386 = T28 && T387;
  assign T387 = T24[4'hd/* 13*/:4'hd/* 13*/];
  assign T388 = io_mcache_ctrlrepl_wTag && T389;
  assign T389 = T236[4'hd/* 13*/:4'hd/* 13*/];
  assign T390 = T386 ? 1'h0/* 0*/ : 1'h1/* 1*/;
  assign T391 = io_exmcache_callRetBase == mcacheAddrVec_13;
  assign T392 = io_mcache_ctrlrepl_wTag && T393;
  assign T393 = T243[4'hd/* 13*/:4'hd/* 13*/];
  assign T394 = T246 && T395;
  assign T395 = T402 && mcacheValidVec_14;
  assign T396 = T399 || T397;
  assign T397 = T28 && T398;
  assign T398 = T24[4'he/* 14*/:4'he/* 14*/];
  assign T399 = io_mcache_ctrlrepl_wTag && T400;
  assign T400 = T236[4'he/* 14*/:4'he/* 14*/];
  assign T401 = T397 ? 1'h0/* 0*/ : 1'h1/* 1*/;
  assign T402 = io_exmcache_callRetBase == mcacheAddrVec_14;
  assign T403 = io_mcache_ctrlrepl_wTag && T404;
  assign T404 = T243[4'he/* 14*/:4'he/* 14*/];
  assign T405 = T246 && T406;
  assign T406 = T413 && mcacheValidVec_15;
  assign T407 = T410 || T408;
  assign T408 = T28 && T409;
  assign T409 = T24[4'hf/* 15*/:4'hf/* 15*/];
  assign T410 = io_mcache_ctrlrepl_wTag && T411;
  assign T411 = T236[4'hf/* 15*/:4'hf/* 15*/];
  assign T412 = T408 ? 1'h0/* 0*/ : 1'h1/* 1*/;
  assign T413 = io_exmcache_callRetBase == mcacheAddrVec_15;
  assign T414 = io_mcache_ctrlrepl_wTag && T415;
  assign T415 = T243[4'hf/* 15*/:4'hf/* 15*/];
  assign T416 = T3 ? T419 : nextPosReg;
  assign T417 = nextPosReg + T418;
  assign T418 = io_mcache_ctrlrepl_wData[4'h9/* 9*/:1'h0/* 0*/];
  assign T419 = T427 | mergePosVec_15;
  assign mergePosVec_15 = T420;
  assign T420 = T405 ? mcachePosVec_15 : T421;
  assign T421 = {9'h0/* 0*/, 1'h0/* 0*/};
  assign T422 = io_mcache_ctrlrepl_wTag && T423;
  assign T423 = T424[4'hf/* 15*/:4'hf/* 15*/];
  assign T424 = T425[4'hf/* 15*/:1'h0/* 0*/];
  assign T425 = 16'h1/* 1*/ << T426;
  assign T426 = nextIndexReg;
  assign T427 = T432 | mergePosVec_14;
  assign mergePosVec_14 = T428;
  assign T428 = T394 ? mcachePosVec_14 : T429;
  assign T429 = {9'h0/* 0*/, 1'h0/* 0*/};
  assign T430 = io_mcache_ctrlrepl_wTag && T431;
  assign T431 = T424[4'he/* 14*/:4'he/* 14*/];
  assign T432 = T437 | mergePosVec_13;
  assign mergePosVec_13 = T433;
  assign T433 = T383 ? mcachePosVec_13 : T434;
  assign T434 = {9'h0/* 0*/, 1'h0/* 0*/};
  assign T435 = io_mcache_ctrlrepl_wTag && T436;
  assign T436 = T424[4'hd/* 13*/:4'hd/* 13*/];
  assign T437 = T442 | mergePosVec_12;
  assign mergePosVec_12 = T438;
  assign T438 = T372 ? mcachePosVec_12 : T439;
  assign T439 = {9'h0/* 0*/, 1'h0/* 0*/};
  assign T440 = io_mcache_ctrlrepl_wTag && T441;
  assign T441 = T424[4'hc/* 12*/:4'hc/* 12*/];
  assign T442 = T447 | mergePosVec_11;
  assign mergePosVec_11 = T443;
  assign T443 = T361 ? mcachePosVec_11 : T444;
  assign T444 = {9'h0/* 0*/, 1'h0/* 0*/};
  assign T445 = io_mcache_ctrlrepl_wTag && T446;
  assign T446 = T424[4'hb/* 11*/:4'hb/* 11*/];
  assign T447 = T452 | mergePosVec_10;
  assign mergePosVec_10 = T448;
  assign T448 = T350 ? mcachePosVec_10 : T449;
  assign T449 = {9'h0/* 0*/, 1'h0/* 0*/};
  assign T450 = io_mcache_ctrlrepl_wTag && T451;
  assign T451 = T424[4'ha/* 10*/:4'ha/* 10*/];
  assign T452 = T457 | mergePosVec_9;
  assign mergePosVec_9 = T453;
  assign T453 = T339 ? mcachePosVec_9 : T454;
  assign T454 = {9'h0/* 0*/, 1'h0/* 0*/};
  assign T455 = io_mcache_ctrlrepl_wTag && T456;
  assign T456 = T424[4'h9/* 9*/:4'h9/* 9*/];
  assign T457 = T462 | mergePosVec_8;
  assign mergePosVec_8 = T458;
  assign T458 = T328 ? mcachePosVec_8 : T459;
  assign T459 = {9'h0/* 0*/, 1'h0/* 0*/};
  assign T460 = io_mcache_ctrlrepl_wTag && T461;
  assign T461 = T424[4'h8/* 8*/:4'h8/* 8*/];
  assign T462 = T467 | mergePosVec_7;
  assign mergePosVec_7 = T463;
  assign T463 = T317 ? mcachePosVec_7 : T464;
  assign T464 = {9'h0/* 0*/, 1'h0/* 0*/};
  assign T465 = io_mcache_ctrlrepl_wTag && T466;
  assign T466 = T424[3'h7/* 7*/:3'h7/* 7*/];
  assign T467 = T472 | mergePosVec_6;
  assign mergePosVec_6 = T468;
  assign T468 = T306 ? mcachePosVec_6 : T469;
  assign T469 = {9'h0/* 0*/, 1'h0/* 0*/};
  assign T470 = io_mcache_ctrlrepl_wTag && T471;
  assign T471 = T424[3'h6/* 6*/:3'h6/* 6*/];
  assign T472 = T477 | mergePosVec_5;
  assign mergePosVec_5 = T473;
  assign T473 = T295 ? mcachePosVec_5 : T474;
  assign T474 = {9'h0/* 0*/, 1'h0/* 0*/};
  assign T475 = io_mcache_ctrlrepl_wTag && T476;
  assign T476 = T424[3'h5/* 5*/:3'h5/* 5*/];
  assign T477 = T482 | mergePosVec_4;
  assign mergePosVec_4 = T478;
  assign T478 = T284 ? mcachePosVec_4 : T479;
  assign T479 = {9'h0/* 0*/, 1'h0/* 0*/};
  assign T480 = io_mcache_ctrlrepl_wTag && T481;
  assign T481 = T424[3'h4/* 4*/:3'h4/* 4*/];
  assign T482 = T487 | mergePosVec_3;
  assign mergePosVec_3 = T483;
  assign T483 = T273 ? mcachePosVec_3 : T484;
  assign T484 = {9'h0/* 0*/, 1'h0/* 0*/};
  assign T485 = io_mcache_ctrlrepl_wTag && T486;
  assign T486 = T424[2'h3/* 3*/:2'h3/* 3*/];
  assign T487 = T492 | mergePosVec_2;
  assign mergePosVec_2 = T488;
  assign T488 = T262 ? mcachePosVec_2 : T489;
  assign T489 = {9'h0/* 0*/, 1'h0/* 0*/};
  assign T490 = io_mcache_ctrlrepl_wTag && T491;
  assign T491 = T424[2'h2/* 2*/:2'h2/* 2*/];
  assign T492 = T497 | mergePosVec_1;
  assign mergePosVec_1 = T493;
  assign T493 = T251 ? mcachePosVec_1 : T494;
  assign T494 = {9'h0/* 0*/, 1'h0/* 0*/};
  assign T495 = io_mcache_ctrlrepl_wTag && T496;
  assign T496 = T424[1'h1/* 1*/:1'h1/* 1*/];
  assign T497 = T502 | mergePosVec_0;
  assign mergePosVec_0 = T498;
  assign T498 = T19 ? mcachePosVec_0 : T499;
  assign T499 = {9'h0/* 0*/, 1'h0/* 0*/};
  assign T500 = io_mcache_ctrlrepl_wTag && T501;
  assign T501 = T424[1'h0/* 0*/:1'h0/* 0*/];
  assign T502 = {9'h0/* 0*/, 1'h0/* 0*/};
  assign io_mcachemem_in_wData = io_mcache_ctrlrepl_wData;
  assign io_mcachemem_in_wOdd = T503;
  assign T503 = wParity ? io_mcache_ctrlrepl_wEna : 1'h0/* 0*/;
  assign wParity = io_mcache_ctrlrepl_wAddr[1'h0/* 0*/:1'h0/* 0*/];
  assign io_mcachemem_in_wEven = T504;
  assign T504 = wParity ? 1'h0/* 0*/ : io_mcache_ctrlrepl_wEna;
  assign io_mcache_replctrl_hit = hitReg;
  assign T505 = T506 || io_mcache_ctrlrepl_wTag;
  assign T506 = T507 || T405;
  assign T507 = T508 || T394;
  assign T508 = T509 || T383;
  assign T509 = T510 || T372;
  assign T510 = T511 || T361;
  assign T511 = T512 || T350;
  assign T512 = T513 || T339;
  assign T513 = T514 || T328;
  assign T514 = T515 || T317;
  assign T515 = T516 || T306;
  assign T516 = T517 || T295;
  assign T517 = T518 || T284;
  assign T518 = T519 || T273;
  assign T519 = T520 || T262;
  assign T520 = T521 || T251;
  assign T521 = T246 || T19;
  assign T522 = io_mcache_ctrlrepl_wTag ? 1'h1/* 1*/ : T523;
  assign T523 = T405 ? 1'h1/* 1*/ : T524;
  assign T524 = T394 ? 1'h1/* 1*/ : T525;
  assign T525 = T383 ? 1'h1/* 1*/ : T526;
  assign T526 = T372 ? 1'h1/* 1*/ : T527;
  assign T527 = T361 ? 1'h1/* 1*/ : T528;
  assign T528 = T350 ? 1'h1/* 1*/ : T529;
  assign T529 = T339 ? 1'h1/* 1*/ : T530;
  assign T530 = T328 ? 1'h1/* 1*/ : T531;
  assign T531 = T317 ? 1'h1/* 1*/ : T532;
  assign T532 = T306 ? 1'h1/* 1*/ : T533;
  assign T533 = T295 ? 1'h1/* 1*/ : T534;
  assign T534 = T284 ? 1'h1/* 1*/ : T535;
  assign T535 = T273 ? 1'h1/* 1*/ : T536;
  assign T536 = T262 ? 1'h1/* 1*/ : T537;
  assign T537 = T251 ? 1'h1/* 1*/ : T19;
  assign io_mcachefe_memSel = T538;
  assign T538 = {selIspmReg, selMCacheReg};
  assign T539 = T541 >= T540;
  assign T540 = {16'h0/* 0*/, 1'h1/* 1*/};
  assign T541 = io_exmcache_callRetBase[5'h1f/* 31*/:4'hf/* 15*/];
  assign T542 = T544 == T543;
  assign T543 = {17'h0/* 0*/, 1'h1/* 1*/};
  assign T544 = io_exmcache_callRetBase[5'h1f/* 31*/:4'he/* 14*/];
  assign io_mcachefe_reloc = reloc;
  assign reloc = selMCacheReg ? T548 : T545;
  assign T545 = {17'h0/* 0*/, T546};
  assign T546 = selIspmReg ? 15'h4000/* 16384*/ : T547;
  assign T547 = {14'h0/* 0*/, 1'h0/* 0*/};
  assign T548 = callRetBaseReg - T549;
  assign T549 = {22'h0/* 0*/, T550};
  assign T550 = posReg;
  assign io_mcachefe_relPc = T551;
  assign T551 = relPc[4'hb/* 11*/:1'h0/* 0*/];
  assign relPc = callAddrReg + T552;
  assign T552 = {18'h0/* 0*/, relBase};
  assign relBase = selMCacheReg ? T554 : T553;
  assign T553 = callRetBaseReg[4'hd/* 13*/:1'h0/* 0*/];
  assign T554 = {4'h0/* 0*/, T555};
  assign T555 = posReg;
  assign io_mcachefe_relBase = T556;
  assign T556 = relBase[4'ha/* 10*/:1'h0/* 0*/];
  assign io_mcachefe_instrOdd = T557;
  assign T557 = io_mcache_ctrlrepl_instrStall ? instrOddReg : instrOdd;
  assign T558 = ! io_mcache_ctrlrepl_instrStall;
  assign io_mcachefe_instrEven = T559;
  assign T559 = io_mcache_ctrlrepl_instrStall ? instrEvenReg : instrEven;
  assign io_hitEna = hitReg;

  always @(posedge clk) begin
    if(reset) begin
      wrPosReg <= 10'h0/* 0*/;
    end else if(io_mcache_ctrlrepl_wTag) begin
      wrPosReg <= posReg;
    end
    if(reset) begin
      posReg <= 10'h0/* 0*/;
    end else if(T2) begin
      posReg <= T416;
    end
    if(reset) begin
      mcacheValidVec_0 <= 1'h0/* 0*/;
    end else if(T21) begin
      mcacheValidVec_0 <= T239;
    end
    if(reset) begin
      nextTagReg <= 4'h0/* 0*/;
    end else if(T27) begin
      nextTagReg <= T228;
    end
    if(reset) begin
      freeSpaceReg <= 12'h400/* 1024*/;
    end else if(T30) begin
      freeSpaceReg <= T31;
    end
    if(reset) begin
      mcacheSizeVec_0 <= 11'h0/* 0*/;
    end else if(T39) begin
      mcacheSizeVec_0 <= T55;
    end
    if(reset) begin
      nextIndexReg <= 4'h0/* 0*/;
    end else if(io_mcache_ctrlrepl_wTag) begin
      nextIndexReg <= T50;
    end
    if(reset) begin
      mcacheSizeVec_1 <= 11'h0/* 0*/;
    end else if(T58) begin
      mcacheSizeVec_1 <= T63;
    end
    if(reset) begin
      mcacheSizeVec_2 <= 11'h0/* 0*/;
    end else if(T67) begin
      mcacheSizeVec_2 <= T72;
    end
    if(reset) begin
      mcacheSizeVec_3 <= 11'h0/* 0*/;
    end else if(T74) begin
      mcacheSizeVec_3 <= T79;
    end
    if(reset) begin
      mcacheSizeVec_4 <= 11'h0/* 0*/;
    end else if(T85) begin
      mcacheSizeVec_4 <= T90;
    end
    if(reset) begin
      mcacheSizeVec_5 <= 11'h0/* 0*/;
    end else if(T92) begin
      mcacheSizeVec_5 <= T97;
    end
    if(reset) begin
      mcacheSizeVec_6 <= 11'h0/* 0*/;
    end else if(T101) begin
      mcacheSizeVec_6 <= T106;
    end
    if(reset) begin
      mcacheSizeVec_7 <= 11'h0/* 0*/;
    end else if(T108) begin
      mcacheSizeVec_7 <= T113;
    end
    if(reset) begin
      mcacheSizeVec_8 <= 11'h0/* 0*/;
    end else if(T121) begin
      mcacheSizeVec_8 <= T126;
    end
    if(reset) begin
      mcacheSizeVec_9 <= 11'h0/* 0*/;
    end else if(T128) begin
      mcacheSizeVec_9 <= T133;
    end
    if(reset) begin
      mcacheSizeVec_10 <= 11'h0/* 0*/;
    end else if(T137) begin
      mcacheSizeVec_10 <= T142;
    end
    if(reset) begin
      mcacheSizeVec_11 <= 11'h0/* 0*/;
    end else if(T144) begin
      mcacheSizeVec_11 <= T149;
    end
    if(reset) begin
      mcacheSizeVec_12 <= 11'h0/* 0*/;
    end else if(T155) begin
      mcacheSizeVec_12 <= T160;
    end
    if(reset) begin
      mcacheSizeVec_13 <= 11'h0/* 0*/;
    end else if(T162) begin
      mcacheSizeVec_13 <= T167;
    end
    if(reset) begin
      mcacheSizeVec_14 <= 11'h0/* 0*/;
    end else if(T171) begin
      mcacheSizeVec_14 <= T176;
    end
    if(reset) begin
      mcacheSizeVec_15 <= 11'h0/* 0*/;
    end else if(T178) begin
      mcacheSizeVec_15 <= T183;
    end
    if(reset) begin
      mcacheAddrVec_0 <= 32'h0/* 0*/;
    end else if(T241) begin
      mcacheAddrVec_0 <= io_mcache_ctrlrepl_wAddr;
    end
    if(reset) begin
      mcacheValidVec_1 <= 1'h0/* 0*/;
    end else if(T253) begin
      mcacheValidVec_1 <= T258;
    end
    if(reset) begin
      mcacheAddrVec_1 <= 32'h0/* 0*/;
    end else if(T260) begin
      mcacheAddrVec_1 <= io_mcache_ctrlrepl_wAddr;
    end
    if(reset) begin
      mcacheValidVec_2 <= 1'h0/* 0*/;
    end else if(T264) begin
      mcacheValidVec_2 <= T269;
    end
    if(reset) begin
      mcacheAddrVec_2 <= 32'h0/* 0*/;
    end else if(T271) begin
      mcacheAddrVec_2 <= io_mcache_ctrlrepl_wAddr;
    end
    if(reset) begin
      mcacheValidVec_3 <= 1'h0/* 0*/;
    end else if(T275) begin
      mcacheValidVec_3 <= T280;
    end
    if(reset) begin
      mcacheAddrVec_3 <= 32'h0/* 0*/;
    end else if(T282) begin
      mcacheAddrVec_3 <= io_mcache_ctrlrepl_wAddr;
    end
    if(reset) begin
      mcacheValidVec_4 <= 1'h0/* 0*/;
    end else if(T286) begin
      mcacheValidVec_4 <= T291;
    end
    if(reset) begin
      mcacheAddrVec_4 <= 32'h0/* 0*/;
    end else if(T293) begin
      mcacheAddrVec_4 <= io_mcache_ctrlrepl_wAddr;
    end
    if(reset) begin
      mcacheValidVec_5 <= 1'h0/* 0*/;
    end else if(T297) begin
      mcacheValidVec_5 <= T302;
    end
    if(reset) begin
      mcacheAddrVec_5 <= 32'h0/* 0*/;
    end else if(T304) begin
      mcacheAddrVec_5 <= io_mcache_ctrlrepl_wAddr;
    end
    if(reset) begin
      mcacheValidVec_6 <= 1'h0/* 0*/;
    end else if(T308) begin
      mcacheValidVec_6 <= T313;
    end
    if(reset) begin
      mcacheAddrVec_6 <= 32'h0/* 0*/;
    end else if(T315) begin
      mcacheAddrVec_6 <= io_mcache_ctrlrepl_wAddr;
    end
    if(reset) begin
      mcacheValidVec_7 <= 1'h0/* 0*/;
    end else if(T319) begin
      mcacheValidVec_7 <= T324;
    end
    if(reset) begin
      mcacheAddrVec_7 <= 32'h0/* 0*/;
    end else if(T326) begin
      mcacheAddrVec_7 <= io_mcache_ctrlrepl_wAddr;
    end
    if(reset) begin
      mcacheValidVec_8 <= 1'h0/* 0*/;
    end else if(T330) begin
      mcacheValidVec_8 <= T335;
    end
    if(reset) begin
      mcacheAddrVec_8 <= 32'h0/* 0*/;
    end else if(T337) begin
      mcacheAddrVec_8 <= io_mcache_ctrlrepl_wAddr;
    end
    if(reset) begin
      mcacheValidVec_9 <= 1'h0/* 0*/;
    end else if(T341) begin
      mcacheValidVec_9 <= T346;
    end
    if(reset) begin
      mcacheAddrVec_9 <= 32'h0/* 0*/;
    end else if(T348) begin
      mcacheAddrVec_9 <= io_mcache_ctrlrepl_wAddr;
    end
    if(reset) begin
      mcacheValidVec_10 <= 1'h0/* 0*/;
    end else if(T352) begin
      mcacheValidVec_10 <= T357;
    end
    if(reset) begin
      mcacheAddrVec_10 <= 32'h0/* 0*/;
    end else if(T359) begin
      mcacheAddrVec_10 <= io_mcache_ctrlrepl_wAddr;
    end
    if(reset) begin
      mcacheValidVec_11 <= 1'h0/* 0*/;
    end else if(T363) begin
      mcacheValidVec_11 <= T368;
    end
    if(reset) begin
      mcacheAddrVec_11 <= 32'h0/* 0*/;
    end else if(T370) begin
      mcacheAddrVec_11 <= io_mcache_ctrlrepl_wAddr;
    end
    if(reset) begin
      mcacheValidVec_12 <= 1'h0/* 0*/;
    end else if(T374) begin
      mcacheValidVec_12 <= T379;
    end
    if(reset) begin
      mcacheAddrVec_12 <= 32'h0/* 0*/;
    end else if(T381) begin
      mcacheAddrVec_12 <= io_mcache_ctrlrepl_wAddr;
    end
    if(reset) begin
      mcacheValidVec_13 <= 1'h0/* 0*/;
    end else if(T385) begin
      mcacheValidVec_13 <= T390;
    end
    if(reset) begin
      mcacheAddrVec_13 <= 32'h0/* 0*/;
    end else if(T392) begin
      mcacheAddrVec_13 <= io_mcache_ctrlrepl_wAddr;
    end
    if(reset) begin
      mcacheValidVec_14 <= 1'h0/* 0*/;
    end else if(T396) begin
      mcacheValidVec_14 <= T401;
    end
    if(reset) begin
      mcacheAddrVec_14 <= 32'h0/* 0*/;
    end else if(T403) begin
      mcacheAddrVec_14 <= io_mcache_ctrlrepl_wAddr;
    end
    if(reset) begin
      mcacheValidVec_15 <= 1'h0/* 0*/;
    end else if(T407) begin
      mcacheValidVec_15 <= T412;
    end
    if(reset) begin
      mcacheAddrVec_15 <= 32'h0/* 0*/;
    end else if(T414) begin
      mcacheAddrVec_15 <= io_mcache_ctrlrepl_wAddr;
    end
    if(reset) begin
      nextPosReg <= 10'h0/* 0*/;
    end else if(io_mcache_ctrlrepl_wTag) begin
      nextPosReg <= T417;
    end
    if(reset) begin
      mcachePosVec_15 <= 10'h0/* 0*/;
    end else if(T422) begin
      mcachePosVec_15 <= nextPosReg;
    end
    if(reset) begin
      mcachePosVec_14 <= 10'h0/* 0*/;
    end else if(T430) begin
      mcachePosVec_14 <= nextPosReg;
    end
    if(reset) begin
      mcachePosVec_13 <= 10'h0/* 0*/;
    end else if(T435) begin
      mcachePosVec_13 <= nextPosReg;
    end
    if(reset) begin
      mcachePosVec_12 <= 10'h0/* 0*/;
    end else if(T440) begin
      mcachePosVec_12 <= nextPosReg;
    end
    if(reset) begin
      mcachePosVec_11 <= 10'h0/* 0*/;
    end else if(T445) begin
      mcachePosVec_11 <= nextPosReg;
    end
    if(reset) begin
      mcachePosVec_10 <= 10'h0/* 0*/;
    end else if(T450) begin
      mcachePosVec_10 <= nextPosReg;
    end
    if(reset) begin
      mcachePosVec_9 <= 10'h0/* 0*/;
    end else if(T455) begin
      mcachePosVec_9 <= nextPosReg;
    end
    if(reset) begin
      mcachePosVec_8 <= 10'h0/* 0*/;
    end else if(T460) begin
      mcachePosVec_8 <= nextPosReg;
    end
    if(reset) begin
      mcachePosVec_7 <= 10'h0/* 0*/;
    end else if(T465) begin
      mcachePosVec_7 <= nextPosReg;
    end
    if(reset) begin
      mcachePosVec_6 <= 10'h0/* 0*/;
    end else if(T470) begin
      mcachePosVec_6 <= nextPosReg;
    end
    if(reset) begin
      mcachePosVec_5 <= 10'h0/* 0*/;
    end else if(T475) begin
      mcachePosVec_5 <= nextPosReg;
    end
    if(reset) begin
      mcachePosVec_4 <= 10'h0/* 0*/;
    end else if(T480) begin
      mcachePosVec_4 <= nextPosReg;
    end
    if(reset) begin
      mcachePosVec_3 <= 10'h0/* 0*/;
    end else if(T485) begin
      mcachePosVec_3 <= nextPosReg;
    end
    if(reset) begin
      mcachePosVec_2 <= 10'h0/* 0*/;
    end else if(T490) begin
      mcachePosVec_2 <= nextPosReg;
    end
    if(reset) begin
      mcachePosVec_1 <= 10'h0/* 0*/;
    end else if(T495) begin
      mcachePosVec_1 <= nextPosReg;
    end
    if(reset) begin
      mcachePosVec_0 <= 10'h0/* 0*/;
    end else if(T500) begin
      mcachePosVec_0 <= nextPosReg;
    end
    if(reset) begin
      hitReg <= 1'h1/* 1*/;
    end else if(T505) begin
      hitReg <= T522;
    end
    if(reset) begin
      selMCacheReg <= 1'h0/* 0*/;
    end else if(T250) begin
      selMCacheReg <= T539;
    end
    if(reset) begin
      selIspmReg <= 1'h0/* 0*/;
    end else if(T250) begin
      selIspmReg <= T542;
    end
    if(reset) begin
      callRetBaseReg <= 32'h1/* 1*/;
    end else if(T250) begin
      callRetBaseReg <= io_exmcache_callRetBase;
    end
    if(reset) begin
      callAddrReg <= 32'h1/* 1*/;
    end else if(T250) begin
      callAddrReg <= io_exmcache_callRetAddr;
    end
    if(reset) begin
      instrOddReg <= 32'h0/* 0*/;
    end else if(T558) begin
      instrOddReg <= io_mcachefe_instrOdd;
    end
    if(reset) begin
      instrEvenReg <= 32'h0/* 0*/;
    end else if(T558) begin
      instrEvenReg <= io_mcachefe_instrEven;
    end
  end
endmodule

module MemBlock_0(input clk,
    input [8:0] io_rdAddr,
    output[31:0] io_rdData,
    input [8:0] io_wrAddr,
    input  io_wrEna,
    input [31:0] io_wrData
);

  wire[31:0] T0;
  reg [31:0] mem [511:0];
  wire[31:0] T1;
  wire[31:0] T2;
  wire T3;
  reg[8:0] R4;

  assign io_rdData = T0;
  assign T0 = mem[R4];
  assign T2 = io_wrData;
  assign T3 = io_wrEna == 1'h1/* 1*/;

  always @(posedge clk) begin
    if (T3)
      mem[io_wrAddr] <= T2;
    R4 <= io_rdAddr;
  end
endmodule

module MCacheMem(input clk,
    input  io_mcachemem_in_wEven,
    input  io_mcachemem_in_wOdd,
    input [31:0] io_mcachemem_in_wData,
    input [8:0] io_mcachemem_in_wAddr,
    input [8:0] io_mcachemem_in_addrEven,
    input [8:0] io_mcachemem_in_addrOdd,
    output[31:0] io_mcachemem_out_instrEven,
    output[31:0] io_mcachemem_out_instrOdd
);

  wire[31:0] mcacheOdd_io_rdData;
  wire[31:0] mcacheEven_io_rdData;

  assign io_mcachemem_out_instrOdd = mcacheOdd_io_rdData;
  assign io_mcachemem_out_instrEven = mcacheEven_io_rdData;
  MemBlock_0 mcacheEven(.clk(clk),
       .io_rdAddr( io_mcachemem_in_addrEven ),
       .io_rdData( mcacheEven_io_rdData ),
       .io_wrAddr( io_mcachemem_in_wAddr ),
       .io_wrEna( io_mcachemem_in_wEven ),
       .io_wrData( io_mcachemem_in_wData )
  );
  MemBlock_0 mcacheOdd(.clk(clk),
       .io_rdAddr( io_mcachemem_in_addrOdd ),
       .io_rdData( mcacheOdd_io_rdData ),
       .io_wrAddr( io_mcachemem_in_wAddr ),
       .io_wrEna( io_mcachemem_in_wOdd ),
       .io_wrData( io_mcachemem_in_wData )
  );
endmodule

module MCache(input clk, input reset,
    output io_ena_out,
    input  io_ena_in,
    input [31:0] io_femcache_addrEven,
    input [31:0] io_femcache_addrOdd,
    input  io_exmcache_doCallRet,
    input [31:0] io_exmcache_callRetBase,
    input [31:0] io_exmcache_callRetAddr,
    output[31:0] io_mcachefe_instrEven,
    output[31:0] io_mcachefe_instrOdd,
    output[10:0] io_mcachefe_relBase,
    output[11:0] io_mcachefe_relPc,
    output[31:0] io_mcachefe_reloc,
    output[1:0] io_mcachefe_memSel,
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

  wire[8:0] mcacherepl_io_mcachemem_in_addrOdd;
  wire[8:0] mcacherepl_io_mcachemem_in_addrEven;
  wire[8:0] mcacherepl_io_mcachemem_in_wAddr;
  wire[31:0] mcacherepl_io_mcachemem_in_wData;
  wire mcacherepl_io_mcachemem_in_wOdd;
  wire mcacherepl_io_mcachemem_in_wEven;
  wire[31:0] mcachemem_io_mcachemem_out_instrOdd;
  wire[31:0] mcachemem_io_mcachemem_out_instrEven;
  wire mcachectrl_io_mcache_ctrlrepl_instrStall;
  wire[9:0] mcachectrl_io_mcache_ctrlrepl_addrOdd;
  wire[9:0] mcachectrl_io_mcache_ctrlrepl_addrEven;
  wire mcachectrl_io_mcache_ctrlrepl_wTag;
  wire[31:0] mcachectrl_io_mcache_ctrlrepl_wAddr;
  wire[31:0] mcachectrl_io_mcache_ctrlrepl_wData;
  wire mcachectrl_io_mcache_ctrlrepl_wEna;
  wire mcacherepl_io_mcache_replctrl_hit;
  wire[3:0] mcachectrl_io_ocp_port_M_DataByteEn;
  wire mcachectrl_io_ocp_port_M_DataValid;
  wire[31:0] mcachectrl_io_ocp_port_M_Data;
  wire[31:0] mcachectrl_io_ocp_port_M_Addr;
  wire[2:0] mcachectrl_io_ocp_port_M_Cmd;
  wire[1:0] mcacherepl_io_mcachefe_memSel;
  wire[31:0] mcacherepl_io_mcachefe_reloc;
  wire[11:0] mcacherepl_io_mcachefe_relPc;
  wire[10:0] mcacherepl_io_mcachefe_relBase;
  wire[31:0] mcacherepl_io_mcachefe_instrOdd;
  wire[31:0] mcacherepl_io_mcachefe_instrEven;
  wire T0;
  wire mcacherepl_io_hitEna;
  wire mcachectrl_io_fetch_ena;

  assign io_ocp_port_M_DataByteEn = mcachectrl_io_ocp_port_M_DataByteEn;
  assign io_ocp_port_M_DataValid = mcachectrl_io_ocp_port_M_DataValid;
  assign io_ocp_port_M_Data = mcachectrl_io_ocp_port_M_Data;
  assign io_ocp_port_M_Addr = mcachectrl_io_ocp_port_M_Addr;
  assign io_ocp_port_M_Cmd = mcachectrl_io_ocp_port_M_Cmd;
  assign io_mcachefe_memSel = mcacherepl_io_mcachefe_memSel;
  assign io_mcachefe_reloc = mcacherepl_io_mcachefe_reloc;
  assign io_mcachefe_relPc = mcacherepl_io_mcachefe_relPc;
  assign io_mcachefe_relBase = mcacherepl_io_mcachefe_relBase;
  assign io_mcachefe_instrOdd = mcacherepl_io_mcachefe_instrOdd;
  assign io_mcachefe_instrEven = mcacherepl_io_mcachefe_instrEven;
  assign io_ena_out = T0;
  assign T0 = mcachectrl_io_fetch_ena & mcacherepl_io_hitEna;
  MCacheCtrl mcachectrl(.clk(clk), .reset(reset),
       .io_ena_in( io_ena_in ),
       .io_fetch_ena( mcachectrl_io_fetch_ena ),
       .io_mcache_ctrlrepl_wEna( mcachectrl_io_mcache_ctrlrepl_wEna ),
       .io_mcache_ctrlrepl_wData( mcachectrl_io_mcache_ctrlrepl_wData ),
       .io_mcache_ctrlrepl_wAddr( mcachectrl_io_mcache_ctrlrepl_wAddr ),
       .io_mcache_ctrlrepl_wTag( mcachectrl_io_mcache_ctrlrepl_wTag ),
       .io_mcache_ctrlrepl_addrEven( mcachectrl_io_mcache_ctrlrepl_addrEven ),
       .io_mcache_ctrlrepl_addrOdd( mcachectrl_io_mcache_ctrlrepl_addrOdd ),
       .io_mcache_ctrlrepl_instrStall( mcachectrl_io_mcache_ctrlrepl_instrStall ),
       .io_mcache_replctrl_hit( mcacherepl_io_mcache_replctrl_hit ),
       .io_femcache_addrEven( io_femcache_addrEven ),
       .io_femcache_addrOdd( io_femcache_addrOdd ),
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
       .io_hitEna( mcacherepl_io_hitEna ),
       .io_exmcache_doCallRet( io_exmcache_doCallRet ),
       .io_exmcache_callRetBase( io_exmcache_callRetBase ),
       .io_exmcache_callRetAddr( io_exmcache_callRetAddr ),
       .io_mcachefe_instrEven( mcacherepl_io_mcachefe_instrEven ),
       .io_mcachefe_instrOdd( mcacherepl_io_mcachefe_instrOdd ),
       .io_mcachefe_relBase( mcacherepl_io_mcachefe_relBase ),
       .io_mcachefe_relPc( mcacherepl_io_mcachefe_relPc ),
       .io_mcachefe_reloc( mcacherepl_io_mcachefe_reloc ),
       .io_mcachefe_memSel( mcacherepl_io_mcachefe_memSel ),
       .io_mcache_ctrlrepl_wEna( mcachectrl_io_mcache_ctrlrepl_wEna ),
       .io_mcache_ctrlrepl_wData( mcachectrl_io_mcache_ctrlrepl_wData ),
       .io_mcache_ctrlrepl_wAddr( mcachectrl_io_mcache_ctrlrepl_wAddr ),
       .io_mcache_ctrlrepl_wTag( mcachectrl_io_mcache_ctrlrepl_wTag ),
       .io_mcache_ctrlrepl_addrEven( mcachectrl_io_mcache_ctrlrepl_addrEven ),
       .io_mcache_ctrlrepl_addrOdd( mcachectrl_io_mcache_ctrlrepl_addrOdd ),
       .io_mcache_ctrlrepl_instrStall( mcachectrl_io_mcache_ctrlrepl_instrStall ),
       .io_mcache_replctrl_hit( mcacherepl_io_mcache_replctrl_hit ),
       .io_mcachemem_in_wEven( mcacherepl_io_mcachemem_in_wEven ),
       .io_mcachemem_in_wOdd( mcacherepl_io_mcachemem_in_wOdd ),
       .io_mcachemem_in_wData( mcacherepl_io_mcachemem_in_wData ),
       .io_mcachemem_in_wAddr( mcacherepl_io_mcachemem_in_wAddr ),
       .io_mcachemem_in_addrEven( mcacherepl_io_mcachemem_in_addrEven ),
       .io_mcachemem_in_addrOdd( mcacherepl_io_mcachemem_in_addrOdd ),
       .instrEven( mcachemem_io_mcachemem_out_instrEven ),
       .instrOdd( mcachemem_io_mcachemem_out_instrOdd )
  );
  MCacheMem mcachemem(.clk(clk),
       .io_mcachemem_in_wEven( mcacherepl_io_mcachemem_in_wEven ),
       .io_mcachemem_in_wOdd( mcacherepl_io_mcachemem_in_wOdd ),
       .io_mcachemem_in_wData( mcacherepl_io_mcachemem_in_wData ),
       .io_mcachemem_in_wAddr( mcacherepl_io_mcachemem_in_wAddr ),
       .io_mcachemem_in_addrEven( mcacherepl_io_mcachemem_in_addrEven ),
       .io_mcachemem_in_addrOdd( mcacherepl_io_mcachemem_in_addrOdd ),
       .io_mcachemem_out_instrEven( mcachemem_io_mcachemem_out_instrEven ),
       .io_mcachemem_out_instrOdd( mcachemem_io_mcachemem_out_instrOdd )
  );
endmodule

module MemBlock_1(input clk,
    input [9:0] io_rdAddr,
    output[31:0] io_rdData,
    input [9:0] io_wrAddr,
    input  io_wrEna,
    input [31:0] io_wrData
);

  wire[31:0] T0;
  reg [31:0] mem [1023:0];
  wire[31:0] T1;
  wire[31:0] T2;
  wire T3;
  reg[9:0] R4;

  assign io_rdData = T0;
  assign T0 = mem[R4];
  assign T2 = io_wrData;
  assign T3 = io_wrEna == 1'h1/* 1*/;

  always @(posedge clk) begin
    if (T3)
      mem[io_wrAddr] <= T2;
    R4 <= io_rdAddr;
  end
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
    output[31:0] io_femcache_addrEven,
    output[31:0] io_femcache_addrOdd,
    input [31:0] io_mcachefe_instrEven,
    input [31:0] io_mcachefe_instrOdd,
    input [10:0] io_mcachefe_relBase,
    input [11:0] io_mcachefe_relPc,
    input [31:0] io_mcachefe_reloc,
    input [1:0] io_mcachefe_memSel
);

  wire wrOdd;
  wire T0;
  wire T1;
  wire selWrite;
  wire T2;
  wire[15:0] T3;
  wire[15:0] T4;
  wire[9:0] T5;
  wire[9:0] T6;
  wire[29:0] addrOdd;
  wire[29:0] T7;
  reg[29:0] addrOddReg;
  wire[29:0] T8;
  wire[29:0] T9;
  wire[28:0] T10;
  wire[29:0] pc_next;
  wire[29:0] T11;
  wire[29:0] pc_cont;
  wire[29:0] T12;
  wire[29:0] T13;
  reg[29:0] pcReg;
  wire T14;
  wire T15;
  wire[29:0] T16;
  wire[29:0] T17;
  wire b_valid;
  wire T18;
  wire[31:0] instr_a;
  wire[31:0] T19;
  wire[31:0] instr_a_rom;
  reg[31:0] data_odd;
  wire[31:0] T20;
  reg [31:0] romOdd [48:0];
  wire[5:0] T21;
  reg[31:0] data_even;
  wire[31:0] T22;
  reg [31:0] romEven [48:0];
  wire[5:0] T23;
  wire[29:0] addrEven;
  wire[29:0] T24;
  reg[29:0] addrEvenReg;
  wire[29:0] T25;
  wire[29:0] T26;
  wire[28:0] T27;
  wire[29:0] pc_inc;
  wire[29:0] pc_next2;
  wire[29:0] T28;
  wire[29:0] pc_cont2;
  wire[29:0] T29;
  wire[29:0] T30;
  wire[29:0] T31;
  wire[29:0] T32;
  wire[29:0] T33;
  wire[29:0] T34;
  wire[29:0] T35;
  wire[11:0] T36;
  wire[11:0] T37;
  wire[11:0] T38;
  wire T39;
  wire T40;
  wire T41;
  wire[31:0] instr_a_cache;
  wire T42;
  wire T43;
  reg[0:0] selMCache;
  wire T44;
  wire[31:0] instr_a_ispm;
  wire[31:0] memOdd_io_rdData;
  wire[31:0] memEven_io_rdData;
  wire T45;
  wire T46;
  reg[0:0] selIspm;
  wire T47;
  wire[29:0] T48;
  wire[11:0] T49;
  wire wrEven;
  wire T50;
  wire T51;
  wire[9:0] T52;
  wire[9:0] T53;
  wire[31:0] T54;
  wire[31:0] T55;
  wire[10:0] T56;
  wire[29:0] T57;
  wire[29:0] T58;
  wire[29:0] T59;
  wire[29:0] relPc;
  wire[29:0] T60;
  reg[10:0] relBaseReg;
  wire T61;
  wire[29:0] T62;
  wire[29:0] T63;
  reg[31:0] relocReg;
  wire[31:0] instr_b;
  wire[31:0] T64;
  wire[31:0] instr_b_rom;
  wire T65;
  wire T66;
  wire[31:0] instr_b_cache;
  wire T67;
  wire T68;
  wire[31:0] instr_b_ispm;
  wire T69;
  wire T70;

  assign wrOdd = selWrite & T0;
  assign T0 = T1 == 1'h1/* 1*/;
  assign T1 = io_memfe_addr[2'h2/* 2*/:2'h2/* 2*/];
  assign selWrite = io_memfe_store & T2;
  assign T2 = T4 == T3;
  assign T3 = {15'h0/* 0*/, 1'h1/* 1*/};
  assign T4 = io_memfe_addr[5'h1f/* 31*/:5'h10/* 16*/];
  assign T5 = io_memfe_addr[4'h9/* 9*/:1'h0/* 0*/];
  assign T6 = addrOdd[4'ha/* 10*/:1'h1/* 1*/];
  assign addrOdd = T7;
  assign T7 = T14 ? T8 : addrOddReg;
  assign T8 = T9;
  assign T9 = {T10, 1'h1/* 1*/};
  assign T10 = pc_next[5'h1d/* 29*/:1'h1/* 1*/];
  assign pc_next = io_memfe_doCallRet ? T48 : T11;
  assign T11 = io_exfe_doBranch ? io_exfe_branchPc : pc_cont;
  assign pc_cont = b_valid ? T16 : T12;
  assign T12 = pcReg + T13;
  assign T13 = {29'h0/* 0*/, 1'h1/* 1*/};
  assign T14 = io_ena && T15;
  assign T15 = ! reset;
  assign T16 = pcReg + T17;
  assign T17 = {28'h0/* 0*/, 2'h2/* 2*/};
  assign b_valid = T18 == 1'h1/* 1*/;
  assign T18 = instr_a[5'h1f/* 31*/:5'h1f/* 31*/];
  assign instr_a = selIspm ? instr_a_ispm : T19;
  assign T19 = selMCache ? instr_a_cache : instr_a_rom;
  assign instr_a_rom = T40 ? data_even : data_odd;
  assign T20 = romOdd[T21];
  initial begin
    romOdd[0] = 32'h3c0004/* 3932164*/;
    romOdd[1] = 32'hcc601c/* 13393948*/;
    romOdd[2] = 32'h2005a/* 131162*/;
    romOdd[3] = 32'h6000057/* 100663383*/;
    romOdd[4] = 32'h0/* 0*/;
    romOdd[5] = 32'h2c26081/* 46293121*/;
    romOdd[6] = 32'h0/* 0*/;
    romOdd[7] = 32'h40008/* 262152*/;
    romOdd[8] = 32'h2c26181/* 46293377*/;
    romOdd[9] = 32'h0/* 0*/;
    romOdd[10] = 32'h2c62180/* 46539136*/;
    romOdd[11] = 32'h63001/* 405505*/;
    romOdd[12] = 32'h6000057/* 100663383*/;
    romOdd[13] = 32'h0/* 0*/;
    romOdd[14] = 32'h42004/* 270340*/;
    romOdd[15] = 32'h2c26181/* 46293377*/;
    romOdd[16] = 32'h0/* 0*/;
    romOdd[17] = 32'h2c62180/* 46539136*/;
    romOdd[18] = 32'h63001/* 405505*/;
    romOdd[19] = 32'h6000057/* 100663383*/;
    romOdd[20] = 32'h0/* 0*/;
    romOdd[21] = 32'h42004/* 270340*/;
    romOdd[22] = 32'h2c26181/* 46293377*/;
    romOdd[23] = 32'h0/* 0*/;
    romOdd[24] = 32'h40008/* 262152*/;
    romOdd[25] = 32'h0/* 0*/;
    romOdd[26] = 32'h0/* 0*/;
    romOdd[27] = 32'h42004/* 270340*/;
    romOdd[28] = 32'h6000057/* 100663383*/;
    romOdd[29] = 32'h0/* 0*/;
    romOdd[30] = 32'h42004/* 270340*/;
    romOdd[31] = 32'h6000057/* 100663383*/;
    romOdd[32] = 32'h0/* 0*/;
    romOdd[33] = 32'h42004/* 270340*/;
    romOdd[34] = 32'h6000057/* 100663383*/;
    romOdd[35] = 32'h0/* 0*/;
    romOdd[36] = 32'h42004/* 270340*/;
    romOdd[37] = 32'h6000057/* 100663383*/;
    romOdd[38] = 32'h0/* 0*/;
    romOdd[39] = 32'h400000/* 4194304*/;
    romOdd[40] = 32'h0/* 0*/;
    romOdd[41] = 32'h0/* 0*/;
    romOdd[42] = 32'h0/* 0*/;
    romOdd[43] = 32'h1e0fa0/* 1970080*/;
    romOdd[44] = 32'h202f831/* 33749041*/;
    romOdd[45] = 32'h210001/* 2162689*/;
    romOdd[46] = 32'h781ef80/* 125955968*/;
    romOdd[47] = 32'h0/* 0*/;
    romOdd[48] = 1'h0/* 0*/;
  end
  assign T21 = addrOdd[3'h6/* 6*/:1'h1/* 1*/];
  assign T22 = romEven[T23];
  initial begin
    romEven[0] = 32'h138/* 312*/;
    romEven[1] = 32'hc000f/* 786447*/;
    romEven[2] = 32'hc6800/* 813056*/;
    romEven[3] = 32'h2c26081/* 46293121*/;
    romEven[4] = 32'h0/* 0*/;
    romEven[5] = 32'h20059/* 131161*/;
    romEven[6] = 32'h6000057/* 100663383*/;
    romEven[7] = 32'h0/* 0*/;
    romEven[8] = 32'h60043/* 393283*/;
    romEven[9] = 32'h6000057/* 100663383*/;
    romEven[10] = 32'h0/* 0*/;
    romEven[11] = 32'h42004/* 270340*/;
    romEven[12] = 32'h2c26181/* 46293377*/;
    romEven[13] = 32'h0/* 0*/;
    romEven[14] = 32'h2c62180/* 46539136*/;
    romEven[15] = 32'h63001/* 405505*/;
    romEven[16] = 32'h6000057/* 100663383*/;
    romEven[17] = 32'h0/* 0*/;
    romEven[18] = 32'h42004/* 270340*/;
    romEven[19] = 32'h2c26181/* 46293377*/;
    romEven[20] = 32'h0/* 0*/;
    romEven[21] = 32'h2c62180/* 46539136*/;
    romEven[22] = 32'h63001/* 405505*/;
    romEven[23] = 32'h6000057/* 100663383*/;
    romEven[24] = 32'h0/* 0*/;
    romEven[25] = 32'h0/* 0*/;
    romEven[26] = 32'h0/* 0*/;
    romEven[27] = 32'h2862180/* 42344832*/;
    romEven[28] = 32'h2c26181/* 46293377*/;
    romEven[29] = 32'h0/* 0*/;
    romEven[30] = 32'h2862180/* 42344832*/;
    romEven[31] = 32'h2c26181/* 46293377*/;
    romEven[32] = 32'h0/* 0*/;
    romEven[33] = 32'h2862180/* 42344832*/;
    romEven[34] = 32'h2c26181/* 46293377*/;
    romEven[35] = 32'h0/* 0*/;
    romEven[36] = 32'h2862180/* 42344832*/;
    romEven[37] = 32'h2c26181/* 46293377*/;
    romEven[38] = 32'h0/* 0*/;
    romEven[39] = 32'h7800000/* 125829120*/;
    romEven[40] = 32'h0/* 0*/;
    romEven[41] = 32'h0/* 0*/;
    romEven[42] = 32'h0/* 0*/;
    romEven[43] = 32'h2c/* 44*/;
    romEven[44] = 32'h200000/* 2097152*/;
    romEven[45] = 32'he7fffff/* 243269631*/;
    romEven[46] = 32'h0/* 0*/;
    romEven[47] = 32'h0/* 0*/;
    romEven[48] = 32'h0/* 0*/;
  end
  assign T23 = addrEven[3'h6/* 6*/:1'h1/* 1*/];
  assign addrEven = T24;
  assign T24 = T14 ? T25 : addrEvenReg;
  assign T25 = T26;
  assign T26 = {T27, 1'h0/* 0*/};
  assign T27 = pc_inc[5'h1d/* 29*/:1'h1/* 1*/];
  assign pc_inc = T39 ? pc_next2 : pc_next;
  assign pc_next2 = io_memfe_doCallRet ? T35 : T28;
  assign T28 = io_exfe_doBranch ? T33 : pc_cont2;
  assign pc_cont2 = b_valid ? T31 : T29;
  assign T29 = pcReg + T30;
  assign T30 = {28'h0/* 0*/, 2'h3/* 3*/};
  assign T31 = pcReg + T32;
  assign T32 = {27'h0/* 0*/, 3'h4/* 4*/};
  assign T33 = io_exfe_branchPc + T34;
  assign T34 = {28'h0/* 0*/, 2'h2/* 2*/};
  assign T35 = {18'h0/* 0*/, T36};
  assign T36 = T38 + T37;
  assign T37 = {10'h0/* 0*/, 2'h2/* 2*/};
  assign T38 = io_mcachefe_relPc;
  assign T39 = pc_next[1'h0/* 0*/:1'h0/* 0*/];
  assign T40 = T41 == 1'h0/* 0*/;
  assign T41 = pcReg[1'h0/* 0*/:1'h0/* 0*/];
  assign instr_a_cache = T42 ? io_mcachefe_instrEven : io_mcachefe_instrOdd;
  assign T42 = T43 == 1'h0/* 0*/;
  assign T43 = pcReg[1'h0/* 0*/:1'h0/* 0*/];
  assign T44 = io_mcachefe_memSel[1'h0/* 0*/:1'h0/* 0*/];
  assign instr_a_ispm = T45 ? memEven_io_rdData : memOdd_io_rdData;
  assign T45 = T46 == 1'h0/* 0*/;
  assign T46 = pcReg[1'h0/* 0*/:1'h0/* 0*/];
  assign T47 = io_mcachefe_memSel[1'h1/* 1*/:1'h1/* 1*/];
  assign T48 = {18'h0/* 0*/, T49};
  assign T49 = io_mcachefe_relPc;
  assign wrEven = selWrite & T50;
  assign T50 = T51 == 1'h0/* 0*/;
  assign T51 = io_memfe_addr[2'h2/* 2*/:2'h2/* 2*/];
  assign T52 = io_memfe_addr[4'h9/* 9*/:1'h0/* 0*/];
  assign T53 = addrEven[4'ha/* 10*/:1'h1/* 1*/];
  assign io_femcache_addrOdd = T54;
  assign T54 = {2'h0/* 0*/, addrOdd};
  assign io_femcache_addrEven = T55;
  assign T55 = {2'h0/* 0*/, addrEven};
  assign io_femem_pc = T56;
  assign T56 = T57[4'ha/* 10*/:1'h0/* 0*/];
  assign T57 = b_valid ? T62 : T58;
  assign T58 = relPc + T59;
  assign T59 = {29'h0/* 0*/, 1'h1/* 1*/};
  assign relPc = pcReg - T60;
  assign T60 = {19'h0/* 0*/, relBaseReg};
  assign T61 = io_memfe_doCallRet && io_ena;
  assign T62 = relPc + T63;
  assign T63 = {28'h0/* 0*/, 2'h2/* 2*/};
  assign io_fedec_reloc = relocReg;
  assign io_fedec_pc = pcReg;
  assign io_fedec_instr_b = instr_b;
  assign instr_b = selIspm ? instr_b_ispm : T64;
  assign T64 = selMCache ? instr_b_cache : instr_b_rom;
  assign instr_b_rom = T65 ? data_odd : data_even;
  assign T65 = T66 == 1'h0/* 0*/;
  assign T66 = pcReg[1'h0/* 0*/:1'h0/* 0*/];
  assign instr_b_cache = T67 ? io_mcachefe_instrOdd : io_mcachefe_instrEven;
  assign T67 = T68 == 1'h0/* 0*/;
  assign T68 = pcReg[1'h0/* 0*/:1'h0/* 0*/];
  assign instr_b_ispm = T69 ? memOdd_io_rdData : memEven_io_rdData;
  assign T69 = T70 == 1'h0/* 0*/;
  assign T70 = pcReg[1'h0/* 0*/:1'h0/* 0*/];
  assign io_fedec_instr_a = instr_a;
  MemBlock_1 memEven(.clk(clk),
       .io_rdAddr( T53 ),
       .io_rdData( memEven_io_rdData ),
       .io_wrAddr( T52 ),
       .io_wrEna( wrEven ),
       .io_wrData( io_memfe_data )
  );
  MemBlock_1 memOdd(.clk(clk),
       .io_rdAddr( T6 ),
       .io_rdData( memOdd_io_rdData ),
       .io_wrAddr( T5 ),
       .io_wrEna( wrOdd ),
       .io_wrData( io_memfe_data )
  );

  always @(posedge clk) begin
    addrOddReg <= reset ? 30'h1/* 1*/ : addrOdd;
    if(reset) begin
      pcReg <= 30'h1/* 1*/;
    end else if(T14) begin
      pcReg <= pc_next;
    end
    data_odd <= T20;
    data_even <= T22;
    addrEvenReg <= reset ? 30'h2/* 2*/ : addrEven;
    selMCache <= T44;
    selIspm <= T47;
    if(reset) begin
      relBaseReg <= 11'h1/* 1*/;
    end else if(T61) begin
      relBaseReg <= io_mcachefe_relBase;
    end
    if(reset) begin
      relocReg <= 32'h0/* 0*/;
    end else if(T61) begin
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
  wire[31:0] T585;
  wire[63:0] T586;
  wire[31:0] T587;
  wire[15:0] T588;
  wire[15:0] T589;
  wire[15:0] T590;
  wire[15:0] T591;
  wire T592;
  wire T593;
  wire[31:0] T594;
  wire[15:0] T595;
  wire[15:0] T596;
  reg[0:0] signLHReg;
  wire T597;
  wire[63:0] T598;
  wire[63:0] T599;
  reg[31:0] mulHLReg;
  wire[31:0] T600;
  wire[63:0] T601;
  wire[31:0] T602;
  wire[15:0] T603;
  wire[31:0] T604;
  wire[15:0] T605;
  wire[15:0] T606;
  wire[15:0] T607;
  wire[15:0] T608;
  wire T609;
  wire[15:0] T610;
  reg[0:0] signHLReg;
  wire T611;
  wire[63:0] T612;
  reg[31:0] mulLLReg;
  wire[31:0] T613;
  wire[63:0] T614;
  reg[31:0] mulHHReg;
  wire[31:0] T615;
  wire[63:0] T616;
  wire[31:0] T617;
  wire[31:0] T618;
  wire T619;
  reg[31:0] mulHiReg;
  wire T620;
  wire T621;
  wire T622;
  wire T623;
  wire T624;
  wire T625;
  wire[31:0] T626;
  wire[31:0] T627;
  wire[31:0] T628;
  wire[31:0] T629;
  wire[31:0] T630;
  wire T631;
  reg[31:0] stackTopReg;
  wire T632;
  wire T633;
  wire T634;
  wire T635;
  wire T636;
  wire T637;
  reg[0:0] exReg_aluOp_1_isSTC;
  wire T638;
  wire T639;
  wire T640;
  wire T641;
  wire T642;
  wire T643;
  wire T644;
  reg[0:0] exReg_aluOp_0_isSTC;
  wire T645;
  wire[31:0] T646;
  wire[31:0] T647;
  wire[31:0] T648;
  wire[31:0] T649;
  wire[31:0] T650;
  wire[31:0] T651;
  wire[31:0] T652;
  wire T653;
  reg[31:0] stackSpillReg;
  wire T654;
  wire T655;
  wire T656;
  wire T657;
  wire T658;
  wire[31:0] T659;
  wire[31:0] T660;
  wire[31:0] T661;
  wire T662;
  reg[0:0] exReg_aluOp_1_isMFS;
  wire T663;
  wire T664;
  reg[4:0] exReg_rdAddr_1;
  wire[4:0] T665;
  wire[4:0] T666;
  wire T667;
  reg[0:0] exReg_wrRd_0;
  wire T668;
  wire[31:0] T669;
  wire[31:0] T670;
  wire[31:0] T671;
  wire[62:0] T672;
  wire[62:0] T673;
  wire[62:0] T674;
  wire[62:0] T675;
  wire[62:0] T676;
  wire[62:0] T677;
  wire[62:0] T678;
  wire[62:0] T679;
  wire[62:0] T680;
  wire[34:0] T681;
  wire[34:0] T682;
  wire[34:0] T683;
  wire[34:0] T684;
  wire[34:0] T685;
  wire[34:0] T686;
  wire[1:0] T687;
  wire[1:0] T688;
  wire T689;
  wire T690;
  wire T691;
  wire[34:0] T692;
  wire[31:0] T693;
  wire T694;
  wire[34:0] T695;
  wire[31:0] T696;
  wire[31:0] T697;
  wire T698;
  wire[62:0] T699;
  wire[62:0] T700;
  wire[4:0] T701;
  wire[4:0] T702;
  wire T703;
  wire[62:0] T704;
  wire[31:0] T705;
  wire[31:0] T706;
  wire T707;
  wire[62:0] T708;
  wire[31:0] T709;
  wire signed [31:0] T710;
  wire signed [31:0] T711;
  wire T712;
  wire[62:0] T713;
  wire[31:0] T714;
  wire[31:0] T715;
  wire T716;
  wire[62:0] T717;
  wire[31:0] T718;
  wire[31:0] T719;
  wire T720;
  wire[62:0] T721;
  wire[31:0] T722;
  wire[31:0] T723;
  wire[31:0] T724;
  wire T725;
  wire[62:0] T726;
  wire T727;
  wire[62:0] T728;
  wire T729;
  wire[31:0] T730;
  wire[31:0] T731;
  wire[31:0] T732;
  wire[31:0] T733;
  wire[31:0] T734;
  wire[31:0] T735;
  wire[31:0] T736;
  wire[31:0] T737;
  wire[7:0] T738;
  wire T739;
  wire T740;
  wire T741;
  wire T742;
  wire T743;
  wire T744;
  wire T745;
  wire T746;
  wire T747;
  wire T748;
  wire T749;
  wire T750;
  wire T751;
  reg[0:0] exReg_aluOp_0_isMFS;
  wire T752;
  reg[4:0] exReg_rdAddr_0;
  wire[4:0] T753;
  wire[4:0] T754;
  wire[31:0] T755;
  wire[31:0] T756;
  wire[31:0] T757;
  wire[31:0] T758;
  wire[31:0] T759;
  wire[31:0] T760;
  wire T761;
  wire T762;
  wire T763;
  wire[31:0] T764;
  wire[31:0] T765;
  wire T766;
  wire T767;
  wire T768;

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
  assign T553 = T662 ? stackSpillReg : T554;
  assign T554 = T653 ? stackTopReg : T555;
  assign T555 = T631 ? mulHiReg : T556;
  assign T556 = T619 ? mulLoReg : T557;
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
  assign T580 = T571 ? T618 : T581;
  assign T581 = T574 ? T617 : T582;
  assign T582 = T583[5'h1f/* 31*/:1'h0/* 0*/];
  assign T583 = T598 + T584;
  assign T584 = {T596, mulLHReg, 16'h0/* 0*/};
  assign T585 = T586[5'h1f/* 31*/:1'h0/* 0*/];
  assign T586 = T594 * T587;
  assign T587 = {T589, T588};
  assign T588 = op_1[5'h1f/* 31*/:5'h10/* 16*/];
  assign T589 = T593 ? T591 : T590;
  assign T590 = {15'h0/* 0*/, 1'h0/* 0*/};
  assign T591 = {5'h10/* 16*/{T592}};
  assign T592 = op_1[5'h1f/* 31*/:5'h1f/* 31*/];
  assign T593 = exReg_aluOp_0_func == 4'b0000/* 0*/;
  assign T594 = {16'h0/* 0*/, T595};
  assign T595 = op_0[4'hf/* 15*/:1'h0/* 0*/];
  assign T596 = {5'h10/* 16*/{signLHReg}};
  assign T597 = T587[5'h10/* 16*/:5'h10/* 16*/];
  assign T598 = T612 + T599;
  assign T599 = {T610, mulHLReg, 16'h0/* 0*/};
  assign T600 = T601[5'h1f/* 31*/:1'h0/* 0*/];
  assign T601 = T604 * T602;
  assign T602 = {16'h0/* 0*/, T603};
  assign T603 = op_1[4'hf/* 15*/:1'h0/* 0*/];
  assign T604 = {T606, T605};
  assign T605 = op_0[5'h1f/* 31*/:5'h10/* 16*/];
  assign T606 = T593 ? T608 : T607;
  assign T607 = {15'h0/* 0*/, 1'h0/* 0*/};
  assign T608 = {5'h10/* 16*/{T609}};
  assign T609 = op_0[5'h1f/* 31*/:5'h1f/* 31*/];
  assign T610 = {5'h10/* 16*/{signHLReg}};
  assign T611 = T604[5'h10/* 16*/:5'h10/* 16*/];
  assign T612 = {mulHHReg, mulLLReg};
  assign T613 = T614[5'h1f/* 31*/:1'h0/* 0*/];
  assign T614 = T594 * T602;
  assign T615 = T616[5'h1f/* 31*/:1'h0/* 0*/];
  assign T616 = T604 * T587;
  assign T617 = op_0;
  assign T618 = op_2;
  assign T619 = exReg_aluOp_1_func == 4'b0010/* 0*/;
  assign T620 = T623 || T621;
  assign T621 = T75 && T622;
  assign T622 = exReg_aluOp_1_func == 4'b0011/* 0*/;
  assign T623 = T576 || T624;
  assign T624 = T105 && T625;
  assign T625 = exReg_aluOp_0_func == 4'b0011/* 0*/;
  assign T626 = T621 ? T630 : T627;
  assign T627 = T624 ? T629 : T628;
  assign T628 = T583[6'h3f/* 63*/:6'h20/* 32*/];
  assign T629 = op_0;
  assign T630 = op_2;
  assign T631 = exReg_aluOp_1_func == 4'b0011/* 0*/;
  assign T632 = T635 || T633;
  assign T633 = T75 && T634;
  assign T634 = exReg_aluOp_1_func == 4'b0110/* 0*/;
  assign T635 = T640 || T636;
  assign T636 = T637 && io_ena;
  assign T637 = exReg_aluOp_1_isSTC && doExecute_1;
  assign T638 = T639;
  assign T639 = 1'h0/* 0*/;
  assign T640 = T643 || T641;
  assign T641 = T105 && T642;
  assign T642 = exReg_aluOp_0_func == 4'b0110/* 0*/;
  assign T643 = T644 && io_ena;
  assign T644 = exReg_aluOp_0_isSTC && doExecute_0;
  assign T645 = T639;
  assign T646 = T633 ? T652 : T647;
  assign T647 = T636 ? T651 : T648;
  assign T648 = T641 ? T650 : T649;
  assign T649 = op_1;
  assign T650 = op_0;
  assign T651 = op_3;
  assign T652 = op_2;
  assign T653 = exReg_aluOp_1_func == 4'b0110/* 0*/;
  assign T654 = T657 || T655;
  assign T655 = T75 && T656;
  assign T656 = exReg_aluOp_1_func == 4'b0101/* 0*/;
  assign T657 = T105 && T658;
  assign T658 = exReg_aluOp_0_func == 4'b0101/* 0*/;
  assign T659 = T655 ? T661 : T660;
  assign T660 = op_0;
  assign T661 = op_2;
  assign T662 = exReg_aluOp_1_func == 4'b0101/* 0*/;
  assign T663 = T664;
  assign T664 = 1'h0/* 0*/;
  assign io_exmem_rd_1_addr = exReg_rdAddr_1;
  assign T665 = T666;
  assign T666 = {4'h0/* 0*/, 1'h0/* 0*/};
  assign io_exmem_rd_0_valid = T667;
  assign T667 = exReg_wrRd_0 && doExecute_0;
  assign T668 = 1'h0/* 0*/;
  assign io_exmem_rd_0_data = T669;
  assign T669 = exReg_aluOp_0_isMFS ? T730 : T670;
  assign T670 = T671;
  assign T671 = T672[5'h1f/* 31*/:1'h0/* 0*/];
  assign T672 = T729 ? T728 : T673;
  assign T673 = T727 ? T726 : T674;
  assign T674 = T725 ? T721 : T675;
  assign T675 = T720 ? T717 : T676;
  assign T676 = T716 ? T713 : T677;
  assign T677 = T712 ? T708 : T678;
  assign T678 = T707 ? T704 : T679;
  assign T679 = T703 ? T699 : T680;
  assign T680 = {28'h0/* 0*/, T681};
  assign T681 = T698 ? T695 : T682;
  assign T682 = T694 ? T692 : T683;
  assign T683 = T691 ? T684 : T684;
  assign T684 = T686 + T685;
  assign T685 = {3'h0/* 0*/, op_1};
  assign T686 = op_0 << T687;
  assign T687 = T690 ? 2'h2/* 2*/ : T688;
  assign T688 = {1'h0/* 0*/, T689};
  assign T689 = exReg_aluOp_0_func == 4'b1100/* 0*/;
  assign T690 = exReg_aluOp_0_func == 4'b1101/* 0*/;
  assign T691 = exReg_aluOp_0_func == 4'b0000/* 0*/;
  assign T692 = {3'h0/* 0*/, T693};
  assign T693 = op_0 - op_1;
  assign T694 = exReg_aluOp_0_func == 4'b0001/* 0*/;
  assign T695 = {3'h0/* 0*/, T696};
  assign T696 = T697;
  assign T697 = op_0 ^ op_1;
  assign T698 = exReg_aluOp_0_func == 4'b0010/* 0*/;
  assign T699 = T700;
  assign T700 = op_0 << T701;
  assign T701 = T702;
  assign T702 = op_1[3'h4/* 4*/:1'h0/* 0*/];
  assign T703 = exReg_aluOp_0_func == 4'b0011/* 0*/;
  assign T704 = {31'h0/* 0*/, T705};
  assign T705 = T706;
  assign T706 = op_0 >> T701;
  assign T707 = exReg_aluOp_0_func == 4'b0100/* 0*/;
  assign T708 = {31'h0/* 0*/, T709};
  assign T709 = T710;
  assign T710 = $signed(T711) >>> T701;
  assign T711 = op_0;
  assign T712 = exReg_aluOp_0_func == 4'b0101/* 0*/;
  assign T713 = {31'h0/* 0*/, T714};
  assign T714 = T715;
  assign T715 = op_0 | op_1;
  assign T716 = exReg_aluOp_0_func == 4'b0110/* 0*/;
  assign T717 = {31'h0/* 0*/, T718};
  assign T718 = T719;
  assign T719 = op_0 & op_1;
  assign T720 = exReg_aluOp_0_func == 4'b0111/* 0*/;
  assign T721 = {31'h0/* 0*/, T722};
  assign T722 = T723;
  assign T723 = ~ T724;
  assign T724 = op_0 | op_1;
  assign T725 = exReg_aluOp_0_func == 4'b1011/* 0*/;
  assign T726 = {28'h0/* 0*/, T684};
  assign T727 = exReg_aluOp_0_func == 4'b1100/* 0*/;
  assign T728 = {28'h0/* 0*/, T684};
  assign T729 = exReg_aluOp_0_func == 4'b1101/* 0*/;
  assign T730 = T731;
  assign T731 = T751 ? stackSpillReg : T732;
  assign T732 = T750 ? stackTopReg : T733;
  assign T733 = T749 ? mulHiReg : T734;
  assign T734 = T748 ? mulLoReg : T735;
  assign T735 = T747 ? T736 : 32'h0/* 0*/;
  assign T736 = T737;
  assign T737 = {24'h0/* 0*/, T738};
  assign T738 = {T746, T745, T744, T743, T742, T741, T740, T739};
  assign T739 = predReg_0;
  assign T740 = predReg_1;
  assign T741 = predReg_2;
  assign T742 = predReg_3;
  assign T743 = predReg_4;
  assign T744 = predReg_5;
  assign T745 = predReg_6;
  assign T746 = predReg_7;
  assign T747 = exReg_aluOp_0_func == 4'b0000/* 0*/;
  assign T748 = exReg_aluOp_0_func == 4'b0010/* 0*/;
  assign T749 = exReg_aluOp_0_func == 4'b0011/* 0*/;
  assign T750 = exReg_aluOp_0_func == 4'b0110/* 0*/;
  assign T751 = exReg_aluOp_0_func == 4'b0101/* 0*/;
  assign T752 = T664;
  assign io_exmem_rd_0_addr = exReg_rdAddr_0;
  assign T753 = T754;
  assign T754 = {4'h0/* 0*/, 1'h0/* 0*/};
  assign io_exdec_sp = T755;
  assign T755 = T766 ? T765 : T756;
  assign T756 = T637 ? T764 : T757;
  assign T757 = T761 ? T760 : T758;
  assign T758 = T644 ? T759 : stackTopReg;
  assign T759 = op_1;
  assign T760 = op_0;
  assign T761 = T763 && T762;
  assign T762 = exReg_aluOp_0_func == 4'b0110/* 0*/;
  assign T763 = exReg_aluOp_0_isMTS && doExecute_0;
  assign T764 = op_3;
  assign T765 = op_2;
  assign T766 = T768 && T767;
  assign T767 = exReg_aluOp_1_func == 4'b0110/* 0*/;
  assign T768 = exReg_aluOp_1_isMTS && doExecute_1;

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
    end else if(io_ena) begin
      mulLHReg <= T585;
    end
    if(reset) begin
      signLHReg <= 1'h0/* 0*/;
    end else if(io_ena) begin
      signLHReg <= T597;
    end
    if(reset) begin
      mulHLReg <= 32'h0/* 0*/;
    end else if(io_ena) begin
      mulHLReg <= T600;
    end
    if(reset) begin
      signHLReg <= 1'h0/* 0*/;
    end else if(io_ena) begin
      signHLReg <= T611;
    end
    if(reset) begin
      mulLLReg <= 32'h0/* 0*/;
    end else if(io_ena) begin
      mulLLReg <= T613;
    end
    if(reset) begin
      mulHHReg <= 32'h0/* 0*/;
    end else if(io_ena) begin
      mulHHReg <= T615;
    end
    if(reset) begin
      mulHiReg <= 32'h0/* 0*/;
    end else if(T620) begin
      mulHiReg <= T626;
    end
    if(reset) begin
      stackTopReg <= 32'h0/* 0*/;
    end else if(T632) begin
      stackTopReg <= T646;
    end
    if(reset) begin
      exReg_aluOp_1_isSTC <= T638;
    end else if(io_ena) begin
      exReg_aluOp_1_isSTC <= io_decex_aluOp_1_isSTC;
    end
    if(reset) begin
      exReg_aluOp_0_isSTC <= T645;
    end else if(io_ena) begin
      exReg_aluOp_0_isSTC <= io_decex_aluOp_0_isSTC;
    end
    if(reset) begin
      stackSpillReg <= 32'h0/* 0*/;
    end else if(T654) begin
      stackSpillReg <= T659;
    end
    if(reset) begin
      exReg_aluOp_1_isMFS <= T663;
    end else if(io_ena) begin
      exReg_aluOp_1_isMFS <= io_decex_aluOp_1_isMFS;
    end
    if(reset) begin
      exReg_rdAddr_1 <= T665;
    end else if(io_ena) begin
      exReg_rdAddr_1 <= io_decex_rdAddr_1;
    end
    if(reset) begin
      exReg_wrRd_0 <= T668;
    end else if(io_ena) begin
      exReg_wrRd_0 <= io_decex_wrRd_0;
    end
    if(reset) begin
      exReg_aluOp_0_isMFS <= T752;
    end else if(io_ena) begin
      exReg_aluOp_0_isMFS <= io_decex_aluOp_0_isMFS;
    end
    if(reset) begin
      exReg_rdAddr_0 <= T753;
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

  reg[29:0] memReg_pc;
  wire T0;
  wire enable;
  wire T1;
  wire T2;
  wire T3;
  reg[0:0] mayStallReg;
  wire T4;
  wire[29:0] T5;
  wire[29:0] T6;
  wire[1:0] T7;
  wire[1:0] T8;
  wire T9;
  wire T10;
  wire[3:0] byteEn;
  wire[3:0] T11;
  wire[3:0] T12;
  wire[3:0] T13;
  wire[3:0] T14;
  wire[3:0] T15;
  wire[3:0] T16;
  wire T17;
  wire T18;
  wire T19;
  wire T20;
  wire T21;
  wire T22;
  wire T23;
  wire[1:0] T24;
  wire T25;
  wire T26;
  wire T27;
  wire T28;
  wire T29;
  wire T30;
  wire[31:0] T31;
  wire[7:0] wrData_0;
  wire[7:0] T32;
  wire[7:0] T33;
  wire[7:0] T34;
  wire[7:0] T35;
  wire[7:0] T36;
  wire[7:0] wrData_1;
  wire[7:0] T37;
  wire[7:0] T38;
  wire[7:0] T39;
  wire[7:0] T40;
  wire[7:0] T41;
  wire[7:0] wrData_2;
  wire[7:0] T42;
  wire[7:0] T43;
  wire[7:0] T44;
  wire[7:0] T45;
  wire[7:0] T46;
  wire[7:0] wrData_3;
  wire[7:0] T47;
  wire[7:0] T48;
  wire[7:0] T49;
  wire[7:0] T50;
  wire[7:0] T51;
  wire[31:0] T52;
  wire[29:0] T53;
  wire[2:0] T54;
  wire[2:0] cmd;
  wire[2:0] T55;
  wire[2:0] T56;
  wire T57;
  wire T58;
  wire T59;
  wire[31:0] T60;
  wire[31:0] T61;
  wire[29:0] T62;
  wire[2:0] T63;
  wire T64;
  wire[31:0] T65;
  wire T66;
  wire[29:0] T67;
  reg[31:0] memReg_mem_callRetBase;
  wire[31:0] T68;
  wire[31:0] T69;
  wire[31:0] T70;
  wire[29:0] T71;
  reg[31:0] memReg_mem_callRetAddr;
  wire[31:0] T72;
  wire[31:0] T73;
  wire[31:0] T74;
  wire T75;
  reg[0:0] memReg_mem_brcf;
  wire T76;
  wire T77;
  wire T78;
  reg[0:0] memReg_mem_ret;
  wire T79;
  wire T80;
  reg[0:0] memReg_mem_call;
  wire T81;
  wire T82;
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

  assign io_memwb_pc = memReg_pc;
  assign T0 = enable && io_ena_in;
  assign enable = mayStallReg ? T1 : 1'h1/* 1*/;
  assign T1 = T3 || T2;
  assign T2 = io_globalInOut_S_Resp == 2'b01/* 0*/;
  assign T3 = io_localInOut_S_Resp == 2'b01/* 0*/;
  assign T4 = io_exmem_mem_load || io_exmem_mem_store;
  assign T5 = T6;
  assign T6 = {29'h0/* 0*/, 1'h0/* 0*/};
  assign io_globalInOut_M_AddrSpace = T7;
  assign T7 = T10 ? 2'b00/* 0*/ : T8;
  assign T8 = T9 ? 2'b10/* 0*/ : 2'b11/* 0*/;
  assign T9 = io_exmem_mem_typ == 2'b10/* 0*/;
  assign T10 = io_exmem_mem_typ == 2'b00/* 0*/;
  assign io_globalInOut_M_ByteEn = byteEn;
  assign byteEn = T11;
  assign T11 = T29 ? 4'b0001/* 0*/ : T12;
  assign T12 = T27 ? 4'b0010/* 0*/ : T13;
  assign T13 = T25 ? 4'b0100/* 0*/ : T14;
  assign T14 = T22 ? 4'b1000/* 0*/ : T15;
  assign T15 = T20 ? 4'b0011/* 0*/ : T16;
  assign T16 = T17 ? 4'b1100/* 0*/ : 4'b1111/* 0*/;
  assign T17 = io_exmem_mem_hword && T18;
  assign T18 = T19 == 1'b0/* 0*/;
  assign T19 = io_exmem_mem_addr[1'h1/* 1*/:1'h1/* 1*/];
  assign T20 = io_exmem_mem_hword && T21;
  assign T21 = T19 == 1'b1/* 0*/;
  assign T22 = io_exmem_mem_byte && T23;
  assign T23 = T24 == 2'b00/* 0*/;
  assign T24 = io_exmem_mem_addr[1'h1/* 1*/:1'h0/* 0*/];
  assign T25 = io_exmem_mem_byte && T26;
  assign T26 = T24 == 2'b01/* 0*/;
  assign T27 = io_exmem_mem_byte && T28;
  assign T28 = T24 == 2'b10/* 0*/;
  assign T29 = io_exmem_mem_byte && T30;
  assign T30 = T24 == 2'b11/* 0*/;
  assign io_globalInOut_M_Data = T31;
  assign T31 = {wrData_3, wrData_2, wrData_1, wrData_0};
  assign wrData_0 = T32;
  assign T32 = T29 ? T36 : T33;
  assign T33 = T20 ? T35 : T34;
  assign T34 = io_exmem_mem_data[3'h7/* 7*/:1'h0/* 0*/];
  assign T35 = io_exmem_mem_data[3'h7/* 7*/:1'h0/* 0*/];
  assign T36 = io_exmem_mem_data[3'h7/* 7*/:1'h0/* 0*/];
  assign wrData_1 = T37;
  assign T37 = T27 ? T41 : T38;
  assign T38 = T20 ? T40 : T39;
  assign T39 = io_exmem_mem_data[4'hf/* 15*/:4'h8/* 8*/];
  assign T40 = io_exmem_mem_data[4'hf/* 15*/:4'h8/* 8*/];
  assign T41 = io_exmem_mem_data[3'h7/* 7*/:1'h0/* 0*/];
  assign wrData_2 = T42;
  assign T42 = T25 ? T46 : T43;
  assign T43 = T17 ? T45 : T44;
  assign T44 = io_exmem_mem_data[5'h17/* 23*/:5'h10/* 16*/];
  assign T45 = io_exmem_mem_data[3'h7/* 7*/:1'h0/* 0*/];
  assign T46 = io_exmem_mem_data[3'h7/* 7*/:1'h0/* 0*/];
  assign wrData_3 = T47;
  assign T47 = T22 ? T51 : T48;
  assign T48 = T17 ? T50 : T49;
  assign T49 = io_exmem_mem_data[5'h1f/* 31*/:5'h18/* 24*/];
  assign T50 = io_exmem_mem_data[4'hf/* 15*/:4'h8/* 8*/];
  assign T51 = io_exmem_mem_data[3'h7/* 7*/:1'h0/* 0*/];
  assign io_globalInOut_M_Addr = T52;
  assign T52 = {T53, 2'b00/* 0*/};
  assign T53 = io_exmem_mem_addr[5'h1f/* 31*/:2'h2/* 2*/];
  assign io_globalInOut_M_Cmd = T54;
  assign T54 = T59 ? cmd : 3'b000/* 0*/;
  assign cmd = T58 ? T55 : 3'b000/* 0*/;
  assign T55 = io_exmem_mem_load ? 3'b010/* 0*/ : T56;
  assign T56 = {2'h0/* 0*/, T57};
  assign T57 = io_exmem_mem_store;
  assign T58 = enable && io_ena_in;
  assign T59 = io_exmem_mem_typ != 2'b01/* 0*/;
  assign io_localInOut_M_ByteEn = byteEn;
  assign io_localInOut_M_Data = T60;
  assign T60 = {wrData_3, wrData_2, wrData_1, wrData_0};
  assign io_localInOut_M_Addr = T61;
  assign T61 = {T62, 2'b00/* 0*/};
  assign T62 = io_exmem_mem_addr[5'h1f/* 31*/:2'h2/* 2*/];
  assign io_localInOut_M_Cmd = T63;
  assign T63 = T64 ? cmd : 3'b000/* 0*/;
  assign T64 = io_exmem_mem_typ == 2'b01/* 0*/;
  assign io_exResult_1_valid = io_exmem_rd_1_valid;
  assign io_exResult_1_data = io_exmem_rd_1_data;
  assign io_exResult_1_addr = io_exmem_rd_1_addr;
  assign io_exResult_0_valid = io_exmem_rd_0_valid;
  assign io_exResult_0_data = io_exmem_rd_0_data;
  assign io_exResult_0_addr = io_exmem_rd_0_addr;
  assign io_memfe_data = T65;
  assign T65 = {wrData_3, wrData_2, wrData_1, wrData_0};
  assign io_memfe_addr = io_exmem_mem_addr;
  assign io_memfe_store = T66;
  assign T66 = io_localInOut_M_Cmd == 3'b001/* 0*/;
  assign io_memfe_callRetBase = T67;
  assign T67 = memReg_mem_callRetBase[5'h1f/* 31*/:2'h2/* 2*/];
  assign T68 = T69;
  assign T69 = T70;
  assign T70 = {31'h0/* 0*/, 1'h0/* 0*/};
  assign io_memfe_callRetPc = T71;
  assign T71 = memReg_mem_callRetAddr[5'h1f/* 31*/:2'h2/* 2*/];
  assign T72 = T73;
  assign T73 = T74;
  assign T74 = {31'h0/* 0*/, 1'h0/* 0*/};
  assign io_memfe_doCallRet = T75;
  assign T75 = T78 || memReg_mem_brcf;
  assign T76 = T77;
  assign T77 = 1'h0/* 0*/;
  assign T78 = memReg_mem_call || memReg_mem_ret;
  assign T79 = T80;
  assign T80 = 1'h0/* 0*/;
  assign T81 = T82;
  assign T82 = 1'h0/* 0*/;
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
      memReg_pc <= T5;
    end else if(T0) begin
      memReg_pc <= io_exmem_pc;
    end
    if(reset) begin
      mayStallReg <= 1'h0/* 0*/;
    end else if(T0) begin
      mayStallReg <= T4;
    end
    if(reset) begin
      memReg_mem_callRetBase <= T68;
    end else if(T0) begin
      memReg_mem_callRetBase <= io_exmem_mem_callRetBase;
    end
    if(reset) begin
      memReg_mem_callRetAddr <= T72;
    end else if(T0) begin
      memReg_mem_callRetAddr <= io_exmem_mem_callRetAddr;
    end
    if(reset) begin
      memReg_mem_brcf <= T76;
    end else if(T0) begin
      memReg_mem_brcf <= io_exmem_mem_brcf;
    end
    if(reset) begin
      memReg_mem_ret <= T79;
    end else if(T0) begin
      memReg_mem_ret <= io_exmem_mem_ret;
    end
    if(reset) begin
      memReg_mem_call <= T81;
    end else if(T0) begin
      memReg_mem_call <= io_exmem_mem_call;
    end
    if(reset) begin
      memReg_rd_1_valid <= T83;
    end else if(T0) begin
      memReg_rd_1_valid <= io_exmem_rd_1_valid;
    end
    if(reset) begin
      memReg_rd_1_data <= T85;
    end else if(T0) begin
      memReg_rd_1_data <= io_exmem_rd_1_data;
    end
    if(reset) begin
      memReg_rd_1_addr <= T88;
    end else if(T0) begin
      memReg_rd_1_addr <= io_exmem_rd_1_addr;
    end
    if(reset) begin
      memReg_rd_0_valid <= T91;
    end else if(T0) begin
      memReg_rd_0_valid <= io_exmem_rd_0_valid;
    end
    if(reset) begin
      memReg_rd_0_data <= T94;
    end else if(T0) begin
      memReg_rd_0_data <= io_exmem_rd_0_data;
    end
    if(reset) begin
      memReg_mem_typ <= T105;
    end else if(T0) begin
      memReg_mem_typ <= io_exmem_mem_typ;
    end
    if(reset) begin
      memReg_mem_addr <= T117;
    end else if(T0) begin
      memReg_mem_addr <= io_exmem_mem_addr;
    end
    if(reset) begin
      memReg_mem_byte <= T125;
    end else if(T0) begin
      memReg_mem_byte <= io_exmem_mem_byte;
    end
    if(reset) begin
      memReg_mem_zext <= T129;
    end else if(T0) begin
      memReg_mem_zext <= io_exmem_mem_zext;
    end
    if(reset) begin
      memReg_mem_hword <= T141;
    end else if(T0) begin
      memReg_mem_hword <= io_exmem_mem_hword;
    end
    if(reset) begin
      memReg_mem_load <= T145;
    end else if(T0) begin
      memReg_mem_load <= io_exmem_mem_load;
    end
    if(reset) begin
      memReg_rd_0_addr <= T147;
    end else if(T0) begin
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

module MemBlock_2(input clk,
    input [8:0] io_rdAddr,
    output[7:0] io_rdData,
    input [8:0] io_wrAddr,
    input  io_wrEna,
    input [7:0] io_wrData
);

  wire[7:0] T0;
  reg [7:0] mem [511:0];
  wire[8:0] T1;
  wire[7:0] T2;
  wire T3;
  reg[8:0] R4;

  assign io_rdData = T0;
  assign T0 = mem[R4];
  assign T2 = io_wrData;
  assign T3 = io_wrEna == 1'h1/* 1*/;

  always @(posedge clk) begin
    if (T3)
      mem[io_wrAddr] <= T2;
    R4 <= io_rdAddr;
  end
endmodule

module Spm(input clk,
    input [2:0] io_M_Cmd,
    input [10:0] io_M_Addr,
    input [31:0] io_M_Data,
    input [3:0] io_M_ByteEn,
    output[1:0] io_S_Resp,
    output[31:0] io_S_Data
);

  wire[7:0] T0;
  wire T1;
  wire[3:0] stmsk;
  wire T2;
  wire[8:0] T3;
  wire[8:0] T4;
  wire[7:0] T5;
  wire T6;
  wire[8:0] T7;
  wire[8:0] T8;
  wire[7:0] T9;
  wire T10;
  wire[8:0] T11;
  wire[8:0] T12;
  wire[7:0] T13;
  wire T14;
  wire[8:0] T15;
  wire[8:0] T16;
  wire[31:0] rdData;
  wire[23:0] T17;
  wire[15:0] T18;
  wire[7:0] MemBlock_0_io_rdData;
  wire[7:0] MemBlock_1_io_rdData;
  wire[7:0] MemBlock_2_io_rdData;
  wire[7:0] MemBlock_3_io_rdData;
  wire[1:0] T19;
  wire T20;
  wire T21;
  wire T22;
  reg[2:0] cmdReg;
  wire T23;

  assign T0 = io_M_Data[5'h1f/* 31*/:5'h18/* 24*/];
  assign T1 = stmsk[2'h3/* 3*/:2'h3/* 3*/];
  assign stmsk = T2 ? io_M_ByteEn : 4'b0000/* 0*/;
  assign T2 = io_M_Cmd == 3'b001/* 0*/;
  assign T3 = io_M_Addr[4'ha/* 10*/:2'h2/* 2*/];
  assign T4 = io_M_Addr[4'ha/* 10*/:2'h2/* 2*/];
  assign T5 = io_M_Data[5'h17/* 23*/:5'h10/* 16*/];
  assign T6 = stmsk[2'h2/* 2*/:2'h2/* 2*/];
  assign T7 = io_M_Addr[4'ha/* 10*/:2'h2/* 2*/];
  assign T8 = io_M_Addr[4'ha/* 10*/:2'h2/* 2*/];
  assign T9 = io_M_Data[4'hf/* 15*/:4'h8/* 8*/];
  assign T10 = stmsk[1'h1/* 1*/:1'h1/* 1*/];
  assign T11 = io_M_Addr[4'ha/* 10*/:2'h2/* 2*/];
  assign T12 = io_M_Addr[4'ha/* 10*/:2'h2/* 2*/];
  assign T13 = io_M_Data[3'h7/* 7*/:1'h0/* 0*/];
  assign T14 = stmsk[1'h0/* 0*/:1'h0/* 0*/];
  assign T15 = io_M_Addr[4'ha/* 10*/:2'h2/* 2*/];
  assign T16 = io_M_Addr[4'ha/* 10*/:2'h2/* 2*/];
  assign io_S_Data = rdData;
  assign rdData = {MemBlock_3_io_rdData, T17};
  assign T17 = {MemBlock_2_io_rdData, T18};
  assign T18 = {MemBlock_1_io_rdData, MemBlock_0_io_rdData};
  assign io_S_Resp = T19;
  assign T19 = {1'h0/* 0*/, T20};
  assign T20 = T21;
  assign T21 = T23 || T22;
  assign T22 = cmdReg == 3'b010/* 0*/;
  assign T23 = cmdReg == 3'b001/* 0*/;
  MemBlock_2 MemBlock_0(.clk(clk),
       .io_rdAddr( T16 ),
       .io_rdData( MemBlock_0_io_rdData ),
       .io_wrAddr( T15 ),
       .io_wrEna( T14 ),
       .io_wrData( T13 )
  );
  MemBlock_2 MemBlock_1(.clk(clk),
       .io_rdAddr( T12 ),
       .io_rdData( MemBlock_1_io_rdData ),
       .io_wrAddr( T11 ),
       .io_wrEna( T10 ),
       .io_wrData( T9 )
  );
  MemBlock_2 MemBlock_2(.clk(clk),
       .io_rdAddr( T8 ),
       .io_rdData( MemBlock_2_io_rdData ),
       .io_wrAddr( T7 ),
       .io_wrEna( T6 ),
       .io_wrData( T5 )
  );
  MemBlock_2 MemBlock_3(.clk(clk),
       .io_rdAddr( T4 ),
       .io_rdData( MemBlock_3_io_rdData ),
       .io_wrAddr( T3 ),
       .io_wrEna( T1 ),
       .io_wrData( T0 )
  );

  always @(posedge clk) begin
    cmdReg <= io_M_Cmd;
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
  assign T7 = {5'h0/* 0*/, 27'h5f5e100/* 100000000*/};
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
  assign T17 = T18 == 7'h64/* 100*/;
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
  assign T14 = tx_baud_counter == 10'h364/* 868*/;
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
  assign T62 = rx_baud_counter == 10'h364/* 868*/;
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
  assign T107 = 10'h364/* 868*/ / 2'h2/* 2*/;
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

  reg[0:0] enableReg;
  wire enable;
  wire mcache_io_ena_out;
  wire memory_io_ena_out;
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
  wire[1:0] mcache_io_mcachefe_memSel;
  wire[31:0] mcache_io_mcachefe_reloc;
  wire[11:0] mcache_io_mcachefe_relPc;
  wire[10:0] mcache_io_mcachefe_relBase;
  wire[31:0] mcache_io_mcachefe_instrOdd;
  wire[31:0] mcache_io_mcachefe_instrEven;
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
  wire[31:0] fetch_io_femcache_addrOdd;
  wire[31:0] fetch_io_femcache_addrEven;
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

  assign enable = memory_io_ena_out & mcache_io_ena_out;
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
  MCache mcache(.clk(clk), .reset(reset),
       .io_ena_out( mcache_io_ena_out ),
       .io_ena_in( memory_io_ena_out ),
       .io_femcache_addrEven( fetch_io_femcache_addrEven ),
       .io_femcache_addrOdd( fetch_io_femcache_addrOdd ),
       .io_exmcache_doCallRet( execute_io_exmcache_doCallRet ),
       .io_exmcache_callRetBase( execute_io_exmcache_callRetBase ),
       .io_exmcache_callRetAddr( execute_io_exmcache_callRetAddr ),
       .io_mcachefe_instrEven( mcache_io_mcachefe_instrEven ),
       .io_mcachefe_instrOdd( mcache_io_mcachefe_instrOdd ),
       .io_mcachefe_relBase( mcache_io_mcachefe_relBase ),
       .io_mcachefe_relPc( mcache_io_mcachefe_relPc ),
       .io_mcachefe_reloc( mcache_io_mcachefe_reloc ),
       .io_mcachefe_memSel( mcache_io_mcachefe_memSel ),
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
       .io_femcache_addrEven( fetch_io_femcache_addrEven ),
       .io_femcache_addrOdd( fetch_io_femcache_addrOdd ),
       .io_mcachefe_instrEven( mcache_io_mcachefe_instrEven ),
       .io_mcachefe_instrOdd( mcache_io_mcachefe_instrOdd ),
       .io_mcachefe_relBase( mcache_io_mcachefe_relBase ),
       .io_mcachefe_relPc( mcache_io_mcachefe_relPc ),
       .io_mcachefe_reloc( mcache_io_mcachefe_reloc ),
       .io_mcachefe_memSel( mcache_io_mcachefe_memSel )
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
    enableReg <= enable;
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
  end
endmodule

module MemBridge(
    input [2:0] io_ocp_M_Cmd,
    input [31:0] io_ocp_M_Addr,
    input [31:0] io_ocp_M_Data,
    input  io_ocp_M_DataValid,
    input [3:0] io_ocp_M_DataByteEn,
    output[1:0] io_ocp_S_Resp,
    output[31:0] io_ocp_S_Data,
    output io_ocp_S_CmdAccept,
    output io_ocp_S_DataAccept,
    output[2:0] io_memBridgePins_M_Cmd,
    output[31:0] io_memBridgePins_M_Addr,
    output[31:0] io_memBridgePins_M_Data,
    output io_memBridgePins_M_DataValid,
    output[3:0] io_memBridgePins_M_DataByteEn,
    input [1:0] io_memBridgePins_S_Resp,
    input [31:0] io_memBridgePins_S_Data,
    input  io_memBridgePins_S_CmdAccept,
    input  io_memBridgePins_S_DataAccept
);


  assign io_memBridgePins_M_DataByteEn = io_ocp_M_DataByteEn;
  assign io_memBridgePins_M_DataValid = io_ocp_M_DataValid;
  assign io_memBridgePins_M_Data = io_ocp_M_Data;
  assign io_memBridgePins_M_Addr = io_ocp_M_Addr;
  assign io_memBridgePins_M_Cmd = io_ocp_M_Cmd;
  assign io_ocp_S_DataAccept = io_memBridgePins_S_DataAccept;
  assign io_ocp_S_CmdAccept = io_memBridgePins_S_CmdAccept;
  assign io_ocp_S_Data = io_memBridgePins_S_Data;
  assign io_ocp_S_Resp = io_memBridgePins_S_Resp;
endmodule

module Patmos(input clk, input reset,
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
    output[2:0] io_memBridgePins_M_Cmd,
    output[31:0] io_memBridgePins_M_Addr,
    output[31:0] io_memBridgePins_M_Data,
    output io_memBridgePins_M_DataValid,
    output[3:0] io_memBridgePins_M_DataByteEn,
    input [1:0] io_memBridgePins_S_Resp,
    input [31:0] io_memBridgePins_S_Data,
    input  io_memBridgePins_S_CmdAccept,
    input  io_memBridgePins_S_DataAccept,
    input [31:0] io_cpuInfoPins_id,
    output io_uartPins_tx,
    input  io_uartPins_rx,
    output[8:0] io_ledsPins_led
);

  wire[3:0] core_io_memPort_M_DataByteEn;
  wire core_io_memPort_M_DataValid;
  wire[31:0] core_io_memPort_M_Data;
  wire[31:0] core_io_memPort_M_Addr;
  wire[2:0] core_io_memPort_M_Cmd;
  wire sramCtrl_io_ocp_S_DataAccept;
  wire sramCtrl_io_ocp_S_CmdAccept;
  wire[31:0] sramCtrl_io_ocp_S_Data;
  wire[1:0] sramCtrl_io_ocp_S_Resp;
  wire[8:0] core_io_ledsPins_led;
  wire core_io_uartPins_tx;
  wire[3:0] sramCtrl_io_memBridgePins_M_DataByteEn;
  wire sramCtrl_io_memBridgePins_M_DataValid;
  wire[31:0] sramCtrl_io_memBridgePins_M_Data;
  wire[31:0] sramCtrl_io_memBridgePins_M_Addr;
  wire[2:0] sramCtrl_io_memBridgePins_M_Cmd;
  wire[3:0] core_io_comSpm_M_ByteEn;
  wire[31:0] core_io_comSpm_M_Data;
  wire[31:0] core_io_comSpm_M_Addr;
  wire[2:0] core_io_comSpm_M_Cmd;
  wire core_io_comConf_M_RespAccept;
  wire[3:0] core_io_comConf_M_ByteEn;
  wire[31:0] core_io_comConf_M_Data;
  wire[31:0] core_io_comConf_M_Addr;
  wire[2:0] core_io_comConf_M_Cmd;

  assign io_ledsPins_led = core_io_ledsPins_led;
  assign io_uartPins_tx = core_io_uartPins_tx;
  assign io_memBridgePins_M_DataByteEn = sramCtrl_io_memBridgePins_M_DataByteEn;
  assign io_memBridgePins_M_DataValid = sramCtrl_io_memBridgePins_M_DataValid;
  assign io_memBridgePins_M_Data = sramCtrl_io_memBridgePins_M_Data;
  assign io_memBridgePins_M_Addr = sramCtrl_io_memBridgePins_M_Addr;
  assign io_memBridgePins_M_Cmd = sramCtrl_io_memBridgePins_M_Cmd;
  assign io_comSpm_M_ByteEn = core_io_comSpm_M_ByteEn;
  assign io_comSpm_M_Data = core_io_comSpm_M_Data;
  assign io_comSpm_M_Addr = core_io_comSpm_M_Addr;
  assign io_comSpm_M_Cmd = core_io_comSpm_M_Cmd;
  assign io_comConf_M_RespAccept = core_io_comConf_M_RespAccept;
  assign io_comConf_M_ByteEn = core_io_comConf_M_ByteEn;
  assign io_comConf_M_Data = core_io_comConf_M_Data;
  assign io_comConf_M_Addr = core_io_comConf_M_Addr;
  assign io_comConf_M_Cmd = core_io_comConf_M_Cmd;
  PatmosCore core(.clk(clk), .reset(reset),
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
       .io_memPort_S_Resp( sramCtrl_io_ocp_S_Resp ),
       .io_memPort_S_Data( sramCtrl_io_ocp_S_Data ),
       .io_memPort_S_CmdAccept( sramCtrl_io_ocp_S_CmdAccept ),
       .io_memPort_S_DataAccept( sramCtrl_io_ocp_S_DataAccept ),
       .io_cpuInfoPins_id( io_cpuInfoPins_id ),
       .io_uartPins_tx( core_io_uartPins_tx ),
       .io_uartPins_rx( io_uartPins_rx ),
       .io_ledsPins_led( core_io_ledsPins_led )
  );
  MemBridge sramCtrl(
       .io_ocp_M_Cmd( core_io_memPort_M_Cmd ),
       .io_ocp_M_Addr( core_io_memPort_M_Addr ),
       .io_ocp_M_Data( core_io_memPort_M_Data ),
       .io_ocp_M_DataValid( core_io_memPort_M_DataValid ),
       .io_ocp_M_DataByteEn( core_io_memPort_M_DataByteEn ),
       .io_ocp_S_Resp( sramCtrl_io_ocp_S_Resp ),
       .io_ocp_S_Data( sramCtrl_io_ocp_S_Data ),
       .io_ocp_S_CmdAccept( sramCtrl_io_ocp_S_CmdAccept ),
       .io_ocp_S_DataAccept( sramCtrl_io_ocp_S_DataAccept ),
       .io_memBridgePins_M_Cmd( sramCtrl_io_memBridgePins_M_Cmd ),
       .io_memBridgePins_M_Addr( sramCtrl_io_memBridgePins_M_Addr ),
       .io_memBridgePins_M_Data( sramCtrl_io_memBridgePins_M_Data ),
       .io_memBridgePins_M_DataValid( sramCtrl_io_memBridgePins_M_DataValid ),
       .io_memBridgePins_M_DataByteEn( sramCtrl_io_memBridgePins_M_DataByteEn ),
       .io_memBridgePins_S_Resp( io_memBridgePins_S_Resp ),
       .io_memBridgePins_S_Data( io_memBridgePins_S_Data ),
       .io_memBridgePins_S_CmdAccept( io_memBridgePins_S_CmdAccept ),
       .io_memBridgePins_S_DataAccept( io_memBridgePins_S_DataAccept )
  );
endmodule

