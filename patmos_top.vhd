--
-- Copyright: 2013, Technical University of Denmark, DTU Compute
-- Author: Martin Schoeberl (martin@jopdesign.com)
-- License: Simplified BSD License
--
-- Modified heavily at York by Jamie Garside (jg@cs.york.ac.uk)

-- VHDL top level for Patmos in Chisel, to connect to Blue*

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity patmos_top is
	port(
          clk : in  std_logic;
          rst_n : in  std_logic;
          hold : in std_logic;
          led : out std_logic_vector(8 downto 0);
          txd : out std_logic;
          rxd : in  std_logic;
	 
          io_comSpm_M_Cmd         : out std_logic_vector(2 downto 0);
          io_comSpm_M_Addr        : out std_logic_vector(31 downto 0);
          io_comSpm_M_Data        : out std_logic_vector(31 downto 0);
          io_comSpm_M_ByteEn      : out std_logic_vector(3 downto 0);
          io_comSpm_S_Resp        : in std_logic_vector(1 downto 0);
          io_comSpm_S_Data        : in std_logic_vector(31 downto 0);

          io_mem_interface_M_Cmd : out std_logic_vector(2 downto 0);
          io_mem_interface_M_Addr : out std_logic_vector(31 downto 0);
          io_mem_interface_M_Data : out std_logic_vector(31 downto 0);
          io_mem_interface_M_DataValid : out std_logic;
          io_mem_interface_M_DataByteEn : out std_logic_vector(3 downto 0);
          io_mem_interface_S_Resp : in std_logic_vector(1 downto 0);
          io_mem_interface_S_Data : in std_logic_vector(31 downto 0);
          io_mem_interface_S_CmdAccept : in std_logic;
          io_mem_interface_S_DataAccept : in std_logic
	);
end entity patmos_top;

architecture rtl of patmos_top is
	component Patmos is
		port(
			clk             : in  std_logic;
			reset           : in  std_logic;
                        io_cpuInfoPins_id : in std_logic_vector(31 downto 0);
                        
			io_comConf_M_Cmd        : out std_logic_vector(2 downto 0);
			io_comConf_M_Addr       : out std_logic_vector(31 downto 0);
			io_comConf_M_Data       : out std_logic_vector(31 downto 0);
			io_comConf_M_ByteEn     : out std_logic_vector(3 downto 0);
			io_comConf_M_RespAccept : out std_logic;
			io_comConf_S_Resp       : in std_logic_vector(1 downto 0);
			io_comConf_S_Data       : in std_logic_vector(31 downto 0);
			io_comConf_S_CmdAccept  : in std_logic;

			io_comSpm_M_Cmd         : out std_logic_vector(2 downto 0);
			io_comSpm_M_Addr        : out std_logic_vector(31 downto 0);
			io_comSpm_M_Data        : out std_logic_vector(31 downto 0);
			io_comSpm_M_ByteEn      : out std_logic_vector(3 downto 0);
			io_comSpm_S_Resp        : in std_logic_vector(1 downto 0);
			io_comSpm_S_Data        : in std_logic_vector(31 downto 0);

			io_ledsPins_led         : out std_logic_vector(8 downto 0);
			io_uartPins_tx  : out std_logic;
			io_uartPins_rx  : in  std_logic;

			io_memBridgePins_M_Cmd : out std_logic_vector(2 downto 0);
			io_memBridgePins_M_Addr : out std_logic_vector(31 downto 0);
			io_memBridgePins_M_Data : out std_logic_vector(31 downto 0);
			io_memBridgePins_M_DataValid : out std_logic;
			io_memBridgePins_M_DataByteEn : out std_logic_vector(3 downto 0);
			io_memBridgePins_S_Resp : in std_logic_vector(1 downto 0);
			io_memBridgePins_S_Data : in std_logic_vector(31 downto 0);
			io_memBridgePins_S_CmdAccept : in std_logic;
			io_memBridgePins_S_DataAccept : in std_logic
		);
	end component;

	-- DE2-70: 50 MHz clock => 80 MHz
	-- BeMicro: 16 MHz clock => 25.6 MHz
	constant pll_mult : natural := 8;
	constant pll_div  : natural := 5;

	signal clk_int : std_logic;

	-- for generation of internal reset
	signal int_res            : std_logic;
	signal res_reg1, res_reg2 : std_logic;
	signal res_cnt            : unsigned(2 downto 0) := "000"; -- for the simulation

	attribute altera_attribute : string;
	attribute altera_attribute of res_cnt : signal is "POWER_UP_LEVEL=LOW";

begin
--	process(clk_int)
--	begin
--		if rising_edge(clk_int) then
--			if (res_cnt /= "111") then
--				res_cnt <= res_cnt + 1;
--			end if;
--			res_reg1 <= not res_cnt(0) or not res_cnt(1) or not res_cnt(2);
--			res_reg2 <= res_reg1;
--			int_res  <= res_reg2;
--		end if;
--	end process;

        int_res <= (not rst_n or hold);
	clk_int <= clk;

comp : Patmos port map (
  clk                     => clk_int,
  reset                   => int_res,
  io_cpuInfoPins_id       => X"00000000",
  io_comConf_M_Cmd        => open,
  io_comConf_M_Addr       => open,
  io_comConf_M_Data       => open,
  io_comConf_M_ByteEn     => open,
  io_comConf_M_RespAccept => open,
  io_comConf_S_Resp       => "00",
  io_comConf_S_Data       => X"00000000",
  io_comConf_S_CmdAccept  => '0',
  io_comSpm_M_Cmd         => io_comSpm_M_Cmd,
  io_comSpm_M_Addr        => io_comSpm_M_Addr,
  io_comSpm_M_Data        => io_comSpm_M_Data,
  io_comSpm_M_ByteEn      => io_comSpm_M_ByteEn,
  io_comSpm_S_Resp        => io_comSpm_S_Resp,
  io_comSpm_S_Data        => io_comSpm_S_Data,
  io_ledsPins_led         => led,
  io_uartPins_tx          => txd,
  io_uartPins_rx          => rxd,
  io_memBridgePins_M_Cmd  => io_mem_interface_M_Cmd,
  io_memBridgePins_M_Addr => io_mem_interface_M_Addr,
  io_memBridgePins_M_Data => io_mem_interface_M_Data,
  io_memBridgePins_M_DataValid => io_mem_interface_M_DataValid,
  io_memBridgePins_M_DataByteEn => io_mem_interface_M_DataByteEn,
  io_memBridgePins_S_Resp => io_mem_interface_S_Resp,
  io_memBridgePins_S_Data => io_mem_interface_S_Data,
  io_memBridgePins_S_CmdAccept => io_mem_interface_S_CmdAccept,
  io_memBridgePins_S_DataAccept => io_mem_interface_S_DataAccept
);
        
end architecture rtl;
