-- Copyright 2014 University of York
-- All rights reserved.
-- 
-- This file is part of the Bluetree memory tree.
-- 
-- Redistribution and use in source and binary forms, with or without
-- modification, are permitted provided that the following conditions are met:
-- 
--   1. Redistributions of source code must retain the above copyright notice,
--      this list of conditions and the following disclaimer.
--   2. Redistributions in binary form must reproduce the above copyright
--      notice, this list of conditions and the following disclaimer in the
--      documentation and/or other materials provided with the distribution.
-- 
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDER ‘‘AS IS’’ AND ANY EXPRESS
-- OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
-- OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN
-- NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY
-- DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
-- (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
-- LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
-- ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
-- (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
-- THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
-- 
-- The views and conclusions contained in the software and documentation are
-- those of the authors and should not be interpreted as representing official
-- policies, either expressed or implied, of the copyright holder.


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
