
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

-- Libraries.

entity lprs1_homework2 is
	port(
		i_clk    :  in std_logic;
		i_rst    :  in std_logic;
		i_run    :  in std_logic;
		i_pause  :  in std_logic;
		o_digit0 : out std_logic_vector(3 downto 0);
		o_digit1 : out std_logic_vector(3 downto 0);
		o_digit2 : out std_logic_vector(3 downto 0);
		o_digit3 : out std_logic_vector(3 downto 0)
	);
end entity;


architecture arch of lprs1_homework2 is
	-- Signals.
		signal s_en_1us, s_en0, s_en1, s_tc_1us, s_tc0 : std_logic;
		signal s_cnt_1us: std_logic_vector(4 downto 0);   -- potrebno je 5 bita da se predstavi broj 19
																		  
		signal s_cnt0, s_cnt1: std_logic_vector(3 downto 0);  -- brojaci cifri
	
begin
	-- Body.
	
	
	-- kontrola dozvole rada
	
	process(i_clk, i_rst) begin
		if(i_rst = '1') then
			s_en_1us <= '0';
			
		elsif(i_clk'event and i_clk = '1') then
		
			if(i_run = '1') then
				s_en_1us <= '1';
				elsif (i_run = '0') then
					if(i_pause = '1') then
						s_en_1us <= '0';
					else
						s_en_1us <= s_en_1us;
					end if;
			end if;
			
		end if;
	end process;
	
	
	-- brojac jedne mikro-sekunde
	
	process(i_clk, i_rst) begin
		if(i_rst = '1') then
			s_cnt_1us <= "00000";
		elsif (i_clk'event and i_clk = '1') then
		
			if(s_en_1us = '1') then			-- ispitujemo kontrolni signal
				if(s_cnt_1us = 19) then
					s_cnt_1us <= "00000";	-- ako je u s_cnt_1us broj 19 onda je prosla 1us
				else
					s_cnt_1us <= s_cnt_1us + 1;
				end if;
			else 
				s_cnt_1us <= s_cnt_1us;
			end if;
			
		end if;
	end process;
	
	s_tc_1us <= '1' when s_cnt_1us = 19 else '0';		-- prosledjujemo '1' ako je prosla 1us
	
	
	-- brojac nulte cifre
	
	s_en0 <= s_tc_1us and s_en_1us;	
	
	process(i_clk, i_rst) begin
		if(i_rst = '1') then
			s_cnt0 <= "0000";
		elsif (i_clk'event and i_clk = '1') then
		
			if(s_en0 = '1') then
				if( s_cnt0 = 8) then
					s_cnt0 <= "0000";
				else
					s_cnt0 <= s_cnt0 + 1;
				end if;
			else
				s_cnt0 <= s_cnt0;
			end if;
		
		end if;
	end process;
	
	s_tc0 <= '1' when s_cnt0 = 8 else '0';
	
	
	
	-- brojac prve cifre
	
	s_en1 <= s_tc0 and s_en0;
	
	
	process(i_clk, i_rst) begin
		if(i_rst = '1') then
			s_cnt1 <= "0000";
		elsif (i_clk'event and i_clk = '1') then
		
			if(s_en1 = '1') then
			
				if( s_cnt1 = 5) then
					s_cnt1 <= "0000";
				else
					s_cnt1 <= s_cnt1 + 1;
				end if;
			else
				s_cnt1 <= s_cnt1;
			end if;
			
		end if;
	end process;
	
	
	
	
	
	-- izlazi
	
	o_digit0 <= s_cnt0;
	o_digit1 <= s_cnt1;
	o_digit2 <= "0101";
	o_digit3 <= "1101";
	
	
end architecture;
