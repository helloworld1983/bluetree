----------------------------------------------------------------------------------
-- Company:  University of York
-- Engineer: Jamie Garside

-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
-- This is an example of how to instantiate the Verilog form of Bluetree
-- from the Toplevel file. This will instantiate a single Patmos, and
-- connect it to an external BlockRAM AXI memory instantiated from Coregen.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
    Port ( clk : in  STD_LOGIC;
           reset_n : in  STD_LOGIC);
end top;

architecture toplevel of top is
	component mkToplevel port (
		  CLK_mem_clock : in std_logic;
		  RST_N_mem_resetn : in std_logic;
		  CLK : in std_logic;
		  RST_N : in std_logic;
		  axi_read_ARID : out std_logic_vector(3 downto 0);
		  axi_read_ARADDR : out std_logic_vector(31 downto 0);
		  axi_read_ARLEN : out std_logic_vector(3 downto 0);
		  axi_read_ARSIZE : out std_logic_vector(2 downto 0);
		  axi_read_ARBURST : out std_logic_vector(1 downto 0);
		  axi_read_ARLOCK : out std_logic_vector(1 downto 0);
		  axi_read_ARCACHE : out std_logic_vector(3 downto 0);
		  axi_read_ARPROT : out std_logic_vector(2 downto 0);
		  axi_read_ARVALID : out std_logic;
		  axi_read_ARREADY : in std_logic;
		  axi_read_RREADY : out std_logic;
		  axi_read_RID : in std_logic_vector(3 downto 0);
		  axi_read_RDATA : in std_logic_vector(127 downto 0);
		  axi_read_RRESP : in std_logic_vector(1 downto 0);
		  axi_read_RLAST : in std_logic;
		  axi_read_RVALID : in std_logic;
		  axi_write_AWID : out std_logic_vector(3 downto 0);
		  axi_write_AWADDR : out std_logic_vector(31 downto 0);
		  axi_write_AWLEN : out std_logic_vector(3 downto 0);
		  axi_write_AWSIZE : out std_logic_vector(2 downto 0);
		  axi_write_AWBURST : out std_logic_vector(1 downto 0);
		  axi_write_AWLOCK : out std_logic_vector(1 downto 0);
		  axi_write_AWCACHE : out std_logic_vector(3 downto 0);
		  axi_write_AWPROT : out std_logic_vector(2 downto 0);
		  axi_write_AWVALID : out std_logic;
		  axi_write_AWREADY : in std_logic;
		  axi_write_WID : out std_logic_vector(3 downto 0);
		  axi_write_WDATA : out std_logic_vector(127 downto 0);
		  axi_write_WSTRB : out std_logic_vector(15 downto 0);
		  axi_write_WLAST : out std_logic;
		  axi_write_WVALID : out std_logic;
		  axi_write_WREADY : in std_logic;
		  axi_write_BREADY : out std_logic;
		  axi_write_BID : in std_logic_vector(3 downto 0);
		  axi_write_BRESP : in std_logic_vector(1 downto 0);
		  axi_write_BVALID : in std_logic;
		  
		  procs_0_put_MCmd_x : in std_logic_vector(2 downto 0);
		  procs_0_put_MAddr_x : in std_logic_vector(31 downto 0);
		  procs_0_put_MData_x : in std_logic_vector(31 downto 0);
		  EN_procs_0_put_MDataValid : in std_logic;
		  procs_0_put_MBE_x : in std_logic_vector(3 downto 0);
		  procs_0_get_SResp : out std_logic_vector(1 downto 0);
		  procs_0_get_SData : out std_logic_vector(31 downto 0);
		  procs_0_get_SCmdAccept : out std_logic;
		  procs_0_get_SDataAccept : out std_logic;
		  
		  procs_1_put_MCmd_x : in std_logic_vector(2 downto 0);
		  procs_1_put_MAddr_x : in std_logic_vector(31 downto 0);
		  procs_1_put_MData_x : in std_logic_vector(31 downto 0);
		  EN_procs_1_put_MDataValid : in std_logic;
		  procs_1_put_MBE_x : in std_logic_vector(3 downto 0);
		  procs_1_get_SResp : out std_logic_vector(1 downto 0);
		  procs_1_get_SData : out std_logic_vector(31 downto 0);
		  procs_1_get_SCmdAccept : out std_logic;
		  procs_1_get_SDataAccept : out std_logic;
		  
		  procs_2_put_MCmd_x : in std_logic_vector(2 downto 0);
		  procs_2_put_MAddr_x : in std_logic_vector(31 downto 0);
		  procs_2_put_MData_x : in std_logic_vector(31 downto 0);
		  EN_procs_2_put_MDataValid : in std_logic;
		  procs_2_put_MBE_x : in std_logic_vector(3 downto 0);
		  procs_2_get_SResp : out std_logic_vector(1 downto 0);
		  procs_2_get_SData : out std_logic_vector(31 downto 0);
		  procs_2_get_SCmdAccept : out std_logic;
		  procs_2_get_SDataAccept : out std_logic;
		  
		  procs_3_put_MCmd_x : in std_logic_vector(2 downto 0);
		  procs_3_put_MAddr_x : in std_logic_vector(31 downto 0);
		  procs_3_put_MData_x : in std_logic_vector(31 downto 0);
		  EN_procs_3_put_MDataValid : in std_logic;
		  procs_3_put_MBE_x : in std_logic_vector(3 downto 0);
		  procs_3_get_SResp : out std_logic_vector(1 downto 0);
		  procs_3_get_SData : out std_logic_vector(31 downto 0);
		  procs_3_get_SCmdAccept : out std_logic;
		  procs_3_get_SDataAccept : out std_logic;
		  
		  procs_4_put_MCmd_x : in std_logic_vector(2 downto 0);
		  procs_4_put_MAddr_x : in std_logic_vector(31 downto 0);
		  procs_4_put_MData_x : in std_logic_vector(31 downto 0);
		  EN_procs_4_put_MDataValid : in std_logic;
		  procs_4_put_MBE_x : in std_logic_vector(3 downto 0);
		  procs_4_get_SResp : out std_logic_vector(1 downto 0);
		  procs_4_get_SData : out std_logic_vector(31 downto 0);
		  procs_4_get_SCmdAccept : out std_logic;
		  procs_4_get_SDataAccept : out std_logic;
		  
		  procs_5_put_MCmd_x : in std_logic_vector(2 downto 0);
		  procs_5_put_MAddr_x : in std_logic_vector(31 downto 0);
		  procs_5_put_MData_x : in std_logic_vector(31 downto 0);
		  EN_procs_5_put_MDataValid : in std_logic;
		  procs_5_put_MBE_x : in std_logic_vector(3 downto 0);
		  procs_5_get_SResp : out std_logic_vector(1 downto 0);
		  procs_5_get_SData : out std_logic_vector(31 downto 0);
		  procs_5_get_SCmdAccept : out std_logic;
		  procs_5_get_SDataAccept : out std_logic;
		  
		  procs_6_put_MCmd_x : in std_logic_vector(2 downto 0);
		  procs_6_put_MAddr_x : in std_logic_vector(31 downto 0);
		  procs_6_put_MData_x : in std_logic_vector(31 downto 0);
		  EN_procs_6_put_MDataValid : in std_logic;
		  procs_6_put_MBE_x : in std_logic_vector(3 downto 0);
		  procs_6_get_SResp : out std_logic_vector(1 downto 0);
		  procs_6_get_SData : out std_logic_vector(31 downto 0);
		  procs_6_get_SCmdAccept : out std_logic;
		  procs_6_get_SDataAccept : out std_logic;
		  
		  procs_7_put_MCmd_x : in std_logic_vector(2 downto 0);
		  procs_7_put_MAddr_x : in std_logic_vector(31 downto 0);
		  procs_7_put_MData_x : in std_logic_vector(31 downto 0);
		  EN_procs_7_put_MDataValid : in std_logic;
		  procs_7_put_MBE_x : in std_logic_vector(3 downto 0);
		  procs_7_get_SResp : out std_logic_vector(1 downto 0);
		  procs_7_get_SData : out std_logic_vector(31 downto 0);
		  procs_7_get_SCmdAccept : out std_logic;
		  procs_7_get_SDataAccept : out std_logic;
		  
		  procs_8_put_MCmd_x : in std_logic_vector(2 downto 0);
		  procs_8_put_MAddr_x : in std_logic_vector(31 downto 0);
		  procs_8_put_MData_x : in std_logic_vector(31 downto 0);
		  EN_procs_8_put_MDataValid : in std_logic;
		  procs_8_put_MBE_x : in std_logic_vector(3 downto 0);
		  procs_8_get_SResp : out std_logic_vector(1 downto 0);
		  procs_8_get_SData : out std_logic_vector(31 downto 0);
		  procs_8_get_SCmdAccept : out std_logic;
		  procs_8_get_SDataAccept : out std_logic;
		  
		  procs_9_put_MCmd_x : in std_logic_vector(2 downto 0);
		  procs_9_put_MAddr_x : in std_logic_vector(31 downto 0);
		  procs_9_put_MData_x : in std_logic_vector(31 downto 0);
		  EN_procs_9_put_MDataValid : in std_logic;
		  procs_9_put_MBE_x : in std_logic_vector(3 downto 0);
		  procs_9_get_SResp : out std_logic_vector(1 downto 0);
		  procs_9_get_SData : out std_logic_vector(31 downto 0);
		  procs_9_get_SCmdAccept : out std_logic;
		  procs_9_get_SDataAccept : out std_logic;
		  
		  procs_10_put_MCmd_x : in std_logic_vector(2 downto 0);
		  procs_10_put_MAddr_x : in std_logic_vector(31 downto 0);
		  procs_10_put_MData_x : in std_logic_vector(31 downto 0);
		  EN_procs_10_put_MDataValid : in std_logic;
		  procs_10_put_MBE_x : in std_logic_vector(3 downto 0);
		  procs_10_get_SResp : out std_logic_vector(1 downto 0);
		  procs_10_get_SData : out std_logic_vector(31 downto 0);
		  procs_10_get_SCmdAccept : out std_logic;
		  procs_10_get_SDataAccept : out std_logic;

		  procs_11_put_MCmd_x : in std_logic_vector(2 downto 0);
		  procs_11_put_MAddr_x : in std_logic_vector(31 downto 0);
		  procs_11_put_MData_x : in std_logic_vector(31 downto 0);
		  EN_procs_11_put_MDataValid : in std_logic;
		  procs_11_put_MBE_x : in std_logic_vector(3 downto 0);
		  procs_11_get_SResp : out std_logic_vector(1 downto 0);
		  procs_11_get_SData : out std_logic_vector(31 downto 0);
		  procs_11_get_SCmdAccept : out std_logic;
		  procs_11_get_SDataAccept : out std_logic;
		  
		  procs_12_put_MCmd_x : in std_logic_vector(2 downto 0);
		  procs_12_put_MAddr_x : in std_logic_vector(31 downto 0);
		  procs_12_put_MData_x : in std_logic_vector(31 downto 0);
		  EN_procs_12_put_MDataValid : in std_logic;
		  procs_12_put_MBE_x : in std_logic_vector(3 downto 0);
		  procs_12_get_SResp : out std_logic_vector(1 downto 0);
		  procs_12_get_SData : out std_logic_vector(31 downto 0);
		  procs_12_get_SCmdAccept : out std_logic;
		  procs_12_get_SDataAccept : out std_logic;
		  
		  procs_13_put_MCmd_x : in std_logic_vector(2 downto 0);
		  procs_13_put_MAddr_x : in std_logic_vector(31 downto 0);
		  procs_13_put_MData_x : in std_logic_vector(31 downto 0);
		  EN_procs_13_put_MDataValid : in std_logic;
		  procs_13_put_MBE_x : in std_logic_vector(3 downto 0);
		  procs_13_get_SResp : out std_logic_vector(1 downto 0);
		  procs_13_get_SData : out std_logic_vector(31 downto 0);
		  procs_13_get_SCmdAccept : out std_logic;
		  procs_13_get_SDataAccept : out std_logic;
		  
		  procs_14_put_MCmd_x : in std_logic_vector(2 downto 0);
		  procs_14_put_MAddr_x : in std_logic_vector(31 downto 0);
		  procs_14_put_MData_x : in std_logic_vector(31 downto 0);
		  EN_procs_14_put_MDataValid : in std_logic;
		  procs_14_put_MBE_x : in std_logic_vector(3 downto 0);
		  procs_14_get_SResp : out std_logic_vector(1 downto 0);
		  procs_14_get_SData : out std_logic_vector(31 downto 0);
		  procs_14_get_SCmdAccept : out std_logic;
		  procs_14_get_SDataAccept : out std_logic;
		  
		  procs_15_put_MCmd_x : in std_logic_vector(2 downto 0);
		  procs_15_put_MAddr_x : in std_logic_vector(31 downto 0);
		  procs_15_put_MData_x : in std_logic_vector(31 downto 0);
		  EN_procs_15_put_MDataValid : in std_logic;
		  procs_15_put_MBE_x : in std_logic_vector(3 downto 0);
		  procs_15_get_SResp : out std_logic_vector(1 downto 0);
		  procs_15_get_SData : out std_logic_vector(31 downto 0);
		  procs_15_get_SCmdAccept : out std_logic;
		  procs_15_get_SDataAccept : out std_logic
		  );
        end component;
	
	COMPONENT bram
	  PORT (
		 s_aclk : IN STD_LOGIC;
		 s_aresetn : IN STD_LOGIC;
		 s_axi_awid : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 s_axi_awaddr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 s_axi_awlen : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 s_axi_awsize : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		 s_axi_awburst : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 s_axi_awvalid : IN STD_LOGIC;
		 s_axi_awready : OUT STD_LOGIC;
		 s_axi_wdata : IN STD_LOGIC_VECTOR(127 DOWNTO 0);
		 s_axi_wstrb : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 s_axi_wlast : IN STD_LOGIC;
		 s_axi_wvalid : IN STD_LOGIC;
		 s_axi_wready : OUT STD_LOGIC;
		 s_axi_bid : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 s_axi_bresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		 s_axi_bvalid : OUT STD_LOGIC;
		 s_axi_bready : IN STD_LOGIC;
		 s_axi_arid : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 s_axi_araddr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 s_axi_arlen : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 s_axi_arsize : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		 s_axi_arburst : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 s_axi_arvalid : IN STD_LOGIC;
		 s_axi_arready : OUT STD_LOGIC;
		 s_axi_rid : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 s_axi_rdata : OUT STD_LOGIC_VECTOR(127 DOWNTO 0);
		 s_axi_rresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		 s_axi_rlast : OUT STD_LOGIC;
		 s_axi_rvalid : OUT STD_LOGIC;
		 s_axi_rready : IN STD_LOGIC
	  );
	END COMPONENT;
		  
	component Patmos port (
		clk : in std_logic; 
		reset : in std_logic;
      io_comConf_M_Cmd : out std_logic_vector(2 downto 0);
      io_comConf_M_Addr : out std_logic_vector(31 downto 0);
      io_comConf_M_Data : out std_logic_vector(31 downto 0);
      io_comConf_M_ByteEn : out std_logic_vector(3 downto 0);
      io_comConf_M_RespAccept : out std_logic;
      io_comConf_S_Resp : in std_logic_vector(1 downto 0);
      io_comConf_S_Data : in std_logic_vector(31 downto 0);
      io_comConf_S_CmdAccept : in std_logic;
      io_comSpm_M_Cmd : out std_logic_vector(2 downto 0);
      io_comSpm_M_Addr : out std_logic_vector(31 downto 0);
      io_comSpm_M_Data : out std_logic_vector(31 downto 0);
      io_comSpm_M_ByteEn : out std_logic_vector(3 downto 0);
      io_comSpm_S_Resp : in std_logic_vector(1 downto 0);
      io_comSpm_S_Data : in std_logic_vector(31 downto 0);
      io_memBridgePins_M_Cmd : out std_logic_vector(2 downto 0);
      io_memBridgePins_M_Addr : out std_logic_vector(31 downto 0);
      io_memBridgePins_M_Data : out std_logic_vector(31 downto 0);
      io_memBridgePins_M_DataValid : out std_logic;
      io_memBridgePins_M_DataByteEn : out std_logic_vector(3 downto 0);
      io_memBridgePins_S_Resp : in std_logic_vector(1 downto 0);
      io_memBridgePins_S_Data : in std_logic_vector(31 downto 0);
      io_memBridgePins_S_CmdAccept : in std_logic;
      io_memBridgePins_S_DataAccept : in std_logic;
      io_cpuInfoPins_id : in std_logic_vector(31 downto 0);
      io_uartPins_tx : out std_logic;
      io_uartPins_rx : in std_logic;
      io_ledsPins_led : out std_logic_vector(8 downto 0)
    );
	 end component;
	 
	 signal reset : std_logic;

        -- Patmos signals
        signal pat_mcmd  : std_logic_vector(2 downto 0);
        signal pat_maddr : std_logic_vector(31 downto 0);
        signal pat_mdata : std_logic_vector(31 downto 0);
        signal pat_mdatavalid : std_logic;
        signal pat_mbe : std_logic_vector(3 downto 0);
        signal pat_sresp : std_logic_vector(1 downto 0);
        signal pat_sdata : std_logic_vector(31 downto 0);
        signal pat_scmdaccept : std_logic;
        signal pat_sdataaccept : std_logic;
		  
		  -- AXI signals
		  signal s_aclk :  STD_LOGIC;
		 signal s_aresetn :  STD_LOGIC;
		 signal s_axi_awid : STD_LOGIC_VECTOR(3 DOWNTO 0);
		 signal s_axi_awaddr :  STD_LOGIC_VECTOR(31 DOWNTO 0);
		 signal s_axi_awlen :  STD_LOGIC_VECTOR(7 DOWNTO 0);
		 signal s_axi_awsize :  STD_LOGIC_VECTOR(2 DOWNTO 0);
		 signal s_axi_awburst :  STD_LOGIC_VECTOR(1 DOWNTO 0);
		 signal s_axi_awvalid :  STD_LOGIC;
		 signal s_axi_awready :  STD_LOGIC;
		 signal s_axi_wdata : STD_LOGIC_VECTOR(127 DOWNTO 0);
		 signal s_axi_wstrb :  STD_LOGIC_VECTOR(15 DOWNTO 0);
		 signal s_axi_wlast : STD_LOGIC;
		 signal s_axi_wvalid :  STD_LOGIC;
		 signal s_axi_wready :  STD_LOGIC;
		 signal s_axi_bid : STD_LOGIC_VECTOR(3 DOWNTO 0);
		 signal s_axi_bresp :  STD_LOGIC_VECTOR(1 DOWNTO 0);
		 signal s_axi_bvalid :  STD_LOGIC;
		 signal s_axi_bready :  STD_LOGIC;
		 signal s_axi_arid :  STD_LOGIC_VECTOR(3 DOWNTO 0);
		 signal s_axi_araddr : STD_LOGIC_VECTOR(31 DOWNTO 0);
		 signal s_axi_arlen :  STD_LOGIC_VECTOR(7 DOWNTO 0);
		 signal s_axi_arsize : STD_LOGIC_VECTOR(2 DOWNTO 0);
		 signal s_axi_arburst :  STD_LOGIC_VECTOR(1 DOWNTO 0);
		 signal s_axi_arvalid :  STD_LOGIC;
		 signal s_axi_arready : STD_LOGIC;
		 signal s_axi_rid : STD_LOGIC_VECTOR(3 DOWNTO 0);
		 signal s_axi_rdata : STD_LOGIC_VECTOR(127 DOWNTO 0);
		 signal s_axi_rresp : STD_LOGIC_VECTOR(1 DOWNTO 0);
		 signal s_axi_rlast : STD_LOGIC;
		 signal s_axi_rvalid : STD_LOGIC;
		 signal s_axi_rready : STD_LOGIC;
		 
		 signal s_axi_dummy1 : std_logic_vector(31 downto 12);
		 signal s_axi_dummy2 : std_logic_vector(31 downto 12);
begin
  -- Only instantiate one Patmos for now. I'm not typing all of that out...
  pat0 : Patmos port map (
    clk                           => clk,
    reset                         => reset,
    io_comConf_M_Cmd              => open,
    io_comConf_M_Addr             => open,
    io_comConf_M_Data             => open,
    io_comConf_M_ByteEn           => open,
    io_comConf_M_RespAccept       => open,
    io_comConf_S_Resp             => "00",
    io_comConf_S_Data             => X"00000000",
    io_comConf_S_CmdAccept        => '0',
    io_comSpm_M_Cmd               => open,
    io_comSpm_M_Addr              => open,
    io_comSpm_M_Data              => open,
    io_comSpm_M_ByteEn            => open,
    io_comSpm_S_Resp              => "00",
    io_comSpm_S_Data              => X"00000000",
    io_memBridgePins_M_Cmd        => pat_mcmd,
    io_memBridgePins_M_Addr       => pat_maddr,
    io_memBridgePins_M_Data       => pat_mdata,
    io_memBridgePins_M_DataValid  => pat_mdatavalid,
    io_memBridgePins_M_DataByteEn => pat_mbe,
    io_memBridgePins_S_Resp       => pat_sresp,
    io_memBridgePins_S_Data       => pat_sdata,
    io_memBridgePins_S_CmdAccept  => pat_scmdaccept,
    io_memBridgePins_S_DataAccept => pat_sdataaccept,
    io_cpuInfoPins_id             => X"00000001",
    io_uartPins_tx                => open,
    io_uartPins_rx                => '0',
    io_ledsPins_led               => open);
  
  bram_inst : bram
  PORT MAP (
    s_aclk => clk,
    s_aresetn => reset_n,
    s_axi_awid => s_axi_awid,
    s_axi_awaddr => s_axi_awaddr,
    s_axi_awlen => s_axi_awlen,
    s_axi_awsize => s_axi_awsize,
    s_axi_awburst => s_axi_awburst,
    s_axi_awvalid => s_axi_awvalid,
    s_axi_awready => s_axi_awready,
    s_axi_wdata => s_axi_wdata,
    s_axi_wstrb => s_axi_wstrb,
    s_axi_wlast => s_axi_wlast,
    s_axi_wvalid => s_axi_wvalid,
    s_axi_wready => s_axi_wready,
    s_axi_bid => s_axi_bid,
    s_axi_bresp => s_axi_bresp,
    s_axi_bvalid => s_axi_bvalid,
    s_axi_bready => s_axi_bready,
    s_axi_arid => s_axi_arid,
    s_axi_araddr => s_axi_araddr,
    s_axi_arlen => s_axi_arlen,
    s_axi_arsize => s_axi_arsize,
    s_axi_arburst => s_axi_arburst,
    s_axi_arvalid => s_axi_arvalid,
    s_axi_arready => s_axi_arready,
    s_axi_rid => s_axi_rid,
    s_axi_rdata => s_axi_rdata,
    s_axi_rresp => s_axi_rresp,
    s_axi_rlast => s_axi_rlast,
    s_axi_rvalid => s_axi_rvalid,
    s_axi_rready => s_axi_rready);

  tlInst : mkToplevel port map (
    CLK_mem_clock     => clk,
    RST_N_mem_resetn  => reset_n,
    CLK               => clk,
    RST_N             => reset_n,
    axi_read_ARID     => s_axi_arid,
    axi_read_ARADDR(11 downto 0)   => s_axi_araddr(11 downto 0),
	 axi_read_ARADDR(31 downto 12)  => s_axi_dummy1,
    axi_read_ARLEN    => s_axi_arlen(3 downto 0),  -- A bit of a hack. It should work...
    axi_read_ARSIZE   => s_axi_arsize,
    axi_read_ARBURST  => s_axi_arburst,
    axi_read_ARLOCK   => open,
    axi_read_ARCACHE  => open,
    axi_read_ARPROT   => open,
    axi_read_ARVALID  => s_axi_arvalid,
    axi_read_ARREADY  => s_axi_arready,
    axi_read_RREADY   => s_axi_rready,
    axi_read_RID      => s_axi_rid,
    axi_read_RDATA    => s_axi_rdata,
    axi_read_RRESP    => s_axi_rresp,
    axi_read_RLAST    => s_axi_rlast,
    axi_read_RVALID   => s_axi_rvalid,
    axi_write_AWID    => s_axi_awid,
    axi_write_AWADDR(11 downto 0)   => s_axi_awaddr(11 downto 0),
	 axi_write_AWADDR(31 downto 12) => s_axi_dummy2,
    axi_write_AWLEN   => s_axi_awlen(3 downto 0),
    axi_write_AWSIZE  => s_axi_awsize,
    axi_write_AWBURST => s_axi_awburst,
    axi_write_AWLOCK  => open,
    axi_write_AWCACHE => open,
    axi_write_AWPROT  => open,
    axi_write_AWVALID => s_axi_awvalid,
    axi_write_AWREADY => s_axi_awready,
    axi_write_WID     => open,
    axi_write_WDATA   => s_axi_wdata,
    axi_write_WSTRB   => s_axi_wstrb,
    axi_write_WLAST   => s_axi_wlast,
    axi_write_WVALID  => s_axi_wvalid,
    axi_write_WREADY  => s_axi_wready,
    axi_write_BREADY  => s_axi_bready,
    axi_write_BID     => s_axi_bid,
    axi_write_BRESP   => s_axi_bresp,
    axi_write_BVALID  => s_axi_bvalid,

    procs_0_put_MCmd_x => pat_mcmd,
    procs_0_put_MAddr_x => pat_maddr,
    procs_0_put_MData_x => pat_mdata,
    EN_procs_0_put_MDataValid => pat_mdatavalid,
    procs_0_put_MBE_x => pat_mbe,
    procs_0_get_SResp => pat_sresp,
    procs_0_get_SData => pat_sdata,
    procs_0_get_SCmdAccept => pat_scmdaccept,
    procs_0_get_SDataAccept => pat_sdataaccept,

    procs_1_put_MCmd_x => "000", 
    procs_1_put_MAddr_x => X"00000000",
    procs_1_put_MData_x => X"00000000",
    EN_procs_1_put_MDataValid => '0',
    procs_1_put_MBE_x => "0000",
    procs_1_get_SResp => open,
    procs_1_get_SData => open,
    procs_1_get_SCmdAccept => open,
    procs_1_get_SDataAccept => open,

    procs_2_put_MCmd_x => "000",     
    procs_2_put_MAddr_x => X"00000000",
    procs_2_put_MData_x => X"00000000",
    EN_procs_2_put_MDataValid => '0',
    procs_2_put_MBE_x => "0000",
    procs_2_get_SResp => open,
    procs_2_get_SData => open,
    procs_2_get_SCmdAccept => open,
    procs_2_get_SDataAccept => open,

    procs_3_put_MCmd_x => "000", 
    procs_3_put_MAddr_x => X"00000000",
    procs_3_put_MData_x => X"00000000",
    EN_procs_3_put_MDataValid => '0',
    procs_3_put_MBE_x => "0000",
    procs_3_get_SResp => open,
    procs_3_get_SData => open,
    procs_3_get_SCmdAccept => open,
    procs_3_get_SDataAccept => open,

    procs_4_put_MCmd_x => "000", 
    procs_4_put_MAddr_x => X"00000000",
    procs_4_put_MData_x => X"00000000",
    EN_procs_4_put_MDataValid => '0',
    procs_4_put_MBE_x => "0000",
    procs_4_get_SResp => open,
    procs_4_get_SData => open,
    procs_4_get_SCmdAccept => open,
    procs_4_get_SDataAccept => open,

    procs_5_put_MCmd_x => "000", 
    procs_5_put_MAddr_x => X"00000000",
    procs_5_put_MData_x => X"00000000",
    EN_procs_5_put_MDataValid => '0',
    procs_5_put_MBE_x => "0000",
    procs_5_get_SResp => open,
    procs_5_get_SData => open,
    procs_5_get_SCmdAccept => open,
    procs_5_get_SDataAccept => open,

    procs_6_put_MCmd_x => "000", 
    procs_6_put_MAddr_x => X"00000000",
    procs_6_put_MData_x => X"00000000",
    EN_procs_6_put_MDataValid => '0',
    procs_6_put_MBE_x => "0000",
    procs_6_get_SResp => open,
    procs_6_get_SData => open,
    procs_6_get_SCmdAccept => open,
    procs_6_get_SDataAccept => open,

    procs_7_put_MCmd_x => "000", 
    procs_7_put_MAddr_x => X"00000000",
    procs_7_put_MData_x => X"00000000",
    EN_procs_7_put_MDataValid => '0',
    procs_7_put_MBE_x => "0000",
    procs_7_get_SResp => open,
    procs_7_get_SData => open,
    procs_7_get_SCmdAccept => open,
    procs_7_get_SDataAccept => open,

    procs_8_put_MCmd_x => "000", 
    procs_8_put_MAddr_x => X"00000000",
    procs_8_put_MData_x => X"00000000",
    EN_procs_8_put_MDataValid => '0',
    procs_8_put_MBE_x => "0000",
    procs_8_get_SResp => open,
    procs_8_get_SData => open,
    procs_8_get_SCmdAccept => open,
    procs_8_get_SDataAccept => open,

    procs_9_put_MCmd_x => "000", 
    procs_9_put_MAddr_x => X"00000000",
    procs_9_put_MData_x => X"00000000",
    EN_procs_9_put_MDataValid => '0',
    procs_9_put_MBE_x => "0000",
    procs_9_get_SResp => open,
    procs_9_get_SData => open,
    procs_9_get_SCmdAccept => open,
    procs_9_get_SDataAccept => open,

    procs_10_put_MCmd_x => "000", 
    procs_10_put_MAddr_x => X"00000000",
    procs_10_put_MData_x => X"00000000",
    EN_procs_10_put_MDataValid => '0',
    procs_10_put_MBE_x => "0000",
    procs_10_get_SResp => open,
    procs_10_get_SData => open,
    procs_10_get_SCmdAccept => open,
    procs_10_get_SDataAccept => open,

    procs_11_put_MCmd_x => "000", 
    procs_11_put_MAddr_x => X"00000000",
    procs_11_put_MData_x => X"00000000",
    EN_procs_11_put_MDataValid => '0',
    procs_11_put_MBE_x => "0000",
    procs_11_get_SResp => open,
    procs_11_get_SData => open,
    procs_11_get_SCmdAccept => open,
    procs_11_get_SDataAccept => open,

    procs_12_put_MCmd_x => "000", 
    procs_12_put_MAddr_x => X"00000000",
    procs_12_put_MData_x => X"00000000",
    EN_procs_12_put_MDataValid => '0',
    procs_12_put_MBE_x => "0000",
    procs_12_get_SResp => open,
    procs_12_get_SData => open,
    procs_12_get_SCmdAccept => open,
    procs_12_get_SDataAccept => open,

    procs_13_put_MCmd_x => "000", 
    procs_13_put_MAddr_x => X"00000000",
    procs_13_put_MData_x => X"00000000",
    EN_procs_13_put_MDataValid => '0',
    procs_13_put_MBE_x => "0000",
    procs_13_get_SResp => open,
    procs_13_get_SData => open,
    procs_13_get_SCmdAccept => open,
    procs_13_get_SDataAccept => open,

    procs_14_put_MCmd_x => "000", 
    procs_14_put_MAddr_x => X"00000000",
    procs_14_put_MData_x => X"00000000",
    EN_procs_14_put_MDataValid => '0',
    procs_14_put_MBE_x => "0000",
    procs_14_get_SResp => open,
    procs_14_get_SData => open,
    procs_14_get_SCmdAccept => open,
    procs_14_get_SDataAccept => open,

    procs_15_put_MCmd_x => "000", 
    procs_15_put_MAddr_x => X"00000000",
    procs_15_put_MData_x => X"00000000",
    EN_procs_15_put_MDataValid => '0',
    procs_15_put_MBE_x => "0000",
    procs_15_get_SResp => open,
    procs_15_get_SData => open,
    procs_15_get_SCmdAccept => open,
    procs_15_get_SDataAccept => open
    
    );
  
  reset <= not reset_n;
  s_axi_araddr(31 downto 12) <= "00000000000000000000";
  s_axi_awaddr(31 downto 12) <= "00000000000000000000";
  s_axi_arlen(7 downto 4) <= "0000";
  s_axi_awlen(7 downto 4) <= "0000";
end toplevel;

