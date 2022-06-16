library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
entity TLC is
	Port (
		Trafficlights:out STD_LOGIC_Vector (5 downto 0);
		Clck : in STD_LOGIC;
		Reset : in STD_LOGIC);
		
end TLC;


architecture Behavioral of TLC is

	type state_type is (st0_R1_G2, st1_R1_A1_A2, st2_G1_R2, st3_A1_R2_A2);
	signal state: state_type;
	signal count : std_logic_vector (3 downto 0);
	constant sec10 : std_logic_vector (3 downto 0) := "1010";
	constant sec2 : std_logic_vector (3 downto 0) := "0010";
	constant sec16: std_logic_vector (3 downto 0) := "1111";

begin
	
	process (Clck,Reset)
		begin
			if Reset='1' then
				state <= st0_R1_G2; --reset to initial state
				count <= X"0"; -- reset counter
			elsif Clck' event and Clck = '1' then
				case (state) is
					
					when st0_R1_G2 =>
						if count < sec10 then
							state <= st0_R1_G2;
							count <= count + 1;
						else
							state <= st1_R1_A1_A2;
							count <= X"0";
						end if;
						
						
					when st1_R1_A1_A2 =>
						if count < sec2 then
							state <= st1_R1_A1_A2;
							count <= count + 1;
						else
							state <= st2_G1_R2;
							count <= X"0";
						end if;
					
					when st2_G1_R2 =>
						if count < sec10 then
							state <= st2_G1_R2;
							count <= count + 1;
						else
							state <= st3_A1_R2_A2;
							count <= X"0";
						end if;
					
					when st3_A1_R2_A2 =>
						if count < sec2 then
							state <= st3_A1_R2_A2;
							count <= count + 1;
						else
							state <=st0_R1_G2;
							count <= X"0";
						end if;
					
					when others =>
						state <= st0_R1_G2;
				end case;
				
			end if;
	end process;


	OUTPUT_DECODE: process (state)
		begin
			case state is
				when (st0_R1_G2) => 
					Trafficlights <= "100001"; --Traffic Red 1, Pedestrian Green 1
				when st1_R1_A1_A2 =>
					Trafficlights <= "110010";
				when st2_G1_R2 =>
					Trafficlights <= "001100";
				when st3_A1_R2_A2 =>
					Trafficlights <= "010110";
				when others =>
					Trafficlights <= "100001";
			end case;
		end process;			
end Behavioral;


