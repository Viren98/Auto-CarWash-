LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity autocarwash is

    port (clk : in std_logic;
        st,tcr,tcd : in std_logic;
		  water,brush,soap : out std_logic);
end entity autocarwash;

architecture arct of autocarwash is

component counter5bit is
	port ( clk , rst : in std_logic ;
	q: out std_logic_vector (4 downto 0) );
end component ;

signal res_time, t10, t20, t30 : std_logic ;
signal q_out : std_logic_vector (4 downto 0);

type state_type is (token, start, rs1, rs2, rs3, ds1, ds2, ds3, ds4, ds5, ds6);

signal ps,ns : state_type := token ;


begin 

coun : counter5bit port map ( clk , res_time , q_out );
t10 <= q_out (3) and q_out (1);
t20 <= q_out (4) and q_out (2);
t30 <= q_out (4) and q_out (3) and q_out (2) and q_out (1);

process ( clk )
begin
	if (clk'event and clk='1') then
			ps <= ns ;
	end if ;
end process ;

process(ps, t10, t20, t30, st, tcr, tcd)
	begin
	
	case (ps) is 
	
	when token =>
		brush <= '0';
		water <= '0';
		soap <= '0';
		if(tcd = '1' or tcr = '1') then
		ns <= start;
		else 
		ns <= token;end if;
	
	when start =>
		brush <= '0';
		water <= '0';
		soap <= '0';
		if(st = '1' and tcr = '1') then
		ns <= rs1;
		elsif(st = '1' and tcd = '1') then
		ns <= ds1;
		else
		ns <= start;end if;
	
	when rs1 =>
		brush <= '0';
		water <= '1';
		soap <= '0';
		if(t10 = '1') then
		ns <= rs2;
		else 
		ns <= rs1;end if;
		
	when rs2 =>
		brush <= '1';
		water <= '1';
		soap <= '0';
		if(t20 = '1') then
		ns <= rs3;
		else 
		ns <= rs2;end if;
		
	when rs3 =>
		brush <= '1';
		water <= '0';
		soap <= '0';
		if(t10 = '1') then
		ns <= token;
		else 
		ns <= rs3;end if;
		
	when ds1 =>
		brush <= '0';
		water <= '1';
		soap <= '0';
		if(t10 = '1') then
		ns <= ds2;
		else 
		ns <= ds1;end if;
		
	when ds2 =>
		brush <= '0';
		water <= '0';
		soap <= '1';
		if(t10 = '1') then
		ns <= ds3;
		else 
		ns <= ds2;end if;
		
	when ds3 =>
		brush <= '1';
		water <= '0';
		soap <= '1';
		if(t10 = '1') then
		ns <= ds4;
		else 
		ns <= ds3;end if;
		
	when ds4 =>
		brush <= '1';
		water <= '0';
		soap <= '0';
		if(t20 = '1') then
		ns <= ds5;
		else 
		ns <= ds4;end if;
		
	when ds5 =>
		brush <= '1';
		water <= '1';
		soap <= '0';
		if(t30 = '1') then
		ns <= ds6;
		else 
		ns <= ds5;end if;
		
	when ds6 =>
		brush <= '1';
		water <= '0';
		soap <= '0';
		if(t10 = '1') then
		ns <= token;
		else 
		ns <= ds6;end if;
		
end case;
end process;

res_time <= '1' when (( ps = rs1) and (t10 = '1')) or
							((ps = rs2) and (t20 = '1')) or
							((ps = rs3) and (t10 = '1')) or
--							((ps = start) and (st = '1') and ((tcr = '1') or (tcd = '1'))) or
							((ps = ds1) and (t10 = '1')) or
							((ps = ds2) and (t10 = '1')) or
							((ps = ds3) and (t10 = '1')) or
							((ps = ds4) and (t20 = '1')) or
							((ps = ds5) and (t30 = '1')) or
							((ps = ds6) and (t10 = '1')) 
							else '0';
end arct;