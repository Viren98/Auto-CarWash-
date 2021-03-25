library ieee ;
use ieee . std_logic_1164 . all ;
use ieee . numeric_std . all ;
entity counter5bit is
	port ( clk , rst : in std_logic ;
			q: out std_logic_vector (4 downto 0));
end counter5bit;

architecture abc OF counter5bit is
signal cnt : unsigned (4 downto 0) := "00000";
begin
	process (clk)
		begin
			if (clk'event and clk = '1') then
				if (rst='1') then
					cnt <= "00000";
				else
					cnt <= cnt + "1";
				end if ;
			end if ;
		end process ;
q <= std_logic_vector ( cnt );
end abc ;