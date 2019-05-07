--------------------------------------------------------------------------------
--
--	MAX1000 Workshop
--   
--	FileName:		nios2e_zephyr.vhd
--	Description:	Toplevel of MAX1000 Workshop Design
--
--	HDL CODE IS PROVIDED "AS IS."  ARROW EXPRESSLY DISCLAIMS ANY
--	WARRANTY OF ANY KIND, WHETHER EXPRESS OR IMPLIED, INCLUDING BUT NOT
--	LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
--	PARTICULAR PURPOSE, OR NON-INFRINGEMENT. IN NO EVENT SHALL ARROW
--	BE LIABLE FOR ANY INCIDENTAL, SPECIAL, INDIRECT OR CONSEQUENTIAL
--	DAMAGES, LOST PROFITS OR LOST DATA, HARM TO YOUR EQUIPMENT, COST OF
--	PROCUREMENT OF SUBSTITUTE GOODS, TECHNOLOGY OR SERVICES, ANY CLAIMS
--	BY THIRD PARTIES (INCLUDING BUT NOT LIMITED TO ANY DEFENSE THEREOF),
--	ANY CLAIMS FOR INDEMNITY OR CONTRIBUTION, OR OTHER SIMILAR COSTS.
--
--	Version History
--		Version 1.0 18.02.2019 Matthias Glattfelder
--
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity nios2e_zephyr is
	port (
		clk12m			: in  std_logic;								-- system clock 12MHz
		reset_button	: in  std_logic;								-- asynchronous reset, low active
		led				: out std_logic_vector(7 downto 0);		        -- LEDs, high active
		sw				: in  std_logic;								-- user button, low active, shout be schmitt trigger input
		-- serial UART
        rxd_in          : in  std_logic;
        txd_out         : out std_logic;
        rts_out         : out std_logic;
        cts_in          : in  std_logic;
        dtr_out         : out std_logic;
        dsr_in          : in  std_logic
	);
end nios2e_zephyr;

architecture behavioral of nios2e_zephyr is

	component pll
		port
		(
			areset	: in std_logic;
			inclk0	: in std_logic;
			c0		: out std_logic;
			locked	: out std_logic 
		);
	end component;

	component nios2e is
	port (
		clk_clk                          : in  std_logic;
		pio_0_external_connection_export : out std_logic_vector(7 downto 0);
		pio_1_external_connection_export : in  std_logic;
		reset_reset_n                    : in  std_logic;
		uart_0_external_connection_rxd   : in  std_logic;
		uart_0_external_connection_txd   : out std_logic
	);
	end component nios2e;
	
	signal	clk_50MHz	: std_logic;
	signal	pll_locked	: std_logic;
	signal	reset_nios	: std_logic;
	
begin


   rts_out                         <= '1';
   dtr_out                         <= '1';

	reset_nios	                    <= reset_button and pll_locked;
	
	pll_inst : pll
		port map (
			areset	 => '0',
			inclk0	 => clk12m,
			c0       => clk_50MHz,
			locked	 => pll_locked
		);

	nios2e_inst : nios2e
		port map (
				clk_clk                          => clk_50MHz,
				pio_0_external_connection_export => led,
				pio_1_external_connection_export => sw,
				reset_reset_n                    => reset_nios,
				uart_0_external_connection_rxd   => rxd_in,
				uart_0_external_connection_txd   => txd_out
		);

end behavioral; 
