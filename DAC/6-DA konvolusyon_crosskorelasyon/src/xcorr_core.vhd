library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;



entity xcorr_core is
    Port ( clk              : in std_logic;
           reset            : in std_logic;
           enable           : in std_logic;
           done_xcorr       : out std_logic;
		   --done_step		: out std_logic;
           sum_out          : out std_logic_vector(15 downto 0)
  
   );
end xcorr_core;

architecture Behavioral of xcorr_core is

	signal a : integer := 0;
	signal b : integer := 0;
	signal c : integer := 0;
	signal d : integer := 0;
	signal i : integer := 1;
	signal j : integer := 1;
	signal k : integer := 0;
	signal m : integer := 0;
	signal n : integer := 0;
	signal t : integer := 0;
	signal q : integer := 0;
	signal z : integer := 0;
	signal length : integer := 0;
    signal sum_xcorr: integer range 0 to 65536 := 0;

	type states is (PRE_CALC, FLIPLR, PLACE_DATA, PLACE_KERNEL, PREP_2D_CALC, PRODUCT1_CALC, PRODUCT);
	signal xcorr_state : states := PRE_CALC;

	type array_type1 is array(20 downto 0,20 downto 0) of signed(7 downto 0);
	signal X_arr : array_type1;

	type array_type2 is array(8 downto 0) of signed(7 downto 0);
	signal Y_arr : array_type2;

	type array_type3 is array(20 downto 0) of signed(7 downto 0);
	signal H_arr : array_type3;

	type t_coef is array (natural range <>) of signed(7 downto 0);
    constant data_x : t_coef(0 to 12) :=
    (
    to_signed(2#00000000#, 8), to_signed(2#00000000#, 8), to_signed(2#00000000#, 8), to_signed(2#00000010#, 8),
    to_signed(2#00000010#, 8), to_signed(2#00000010#, 8), to_signed(2#00000010#, 8), to_signed(2#00000010#, 8),
    to_signed(2#00000010#, 8), to_signed(2#00000010#, 8), to_signed(2#00000000#, 8), to_signed(2#00000000#, 8),
    to_signed(2#00000000#, 8)
    );
    
    type t_data is array (natural range <>) of signed(7 downto 0);
    constant data_y : t_data(0 to 8) :=
    (
    to_signed(2#00000000#, 8), to_signed(2#00000001#, 8), to_signed(2#00000010#, 8), to_signed(2#00000100#, 8), 
    to_signed(2#00000110#, 8), to_signed(2#00001001#, 8), to_signed(2#00001101#, 8), to_signed(2#00010010#, 8),
    to_signed(2#00011001#, 8)
    );
begin

	process(clk,reset)

	begin
		if reset = '0' then
			a <= 0; b <= 0;
			i <= 1; j <= 1;
			k <= 0; m <= 0;
			n <= 0; t <= 0;
			q <= 0; z <= 0;
			length <= 0;
			xcorr_state <= PRE_CALC;

		elsif clk'event and clk = '1' then
            
			case xcorr_state is
			when PRE_CALC =>
				done_xcorr <= '0';
				if(enable = '1') then
					sum_xcorr <= 0;
					m <= data_x'length;
		            n <= data_y'length;
					xcorr_state <= FLIPLR;
				else 
					xcorr_state <= PRE_CALC;
				
				end if;

			when FLIPLR =>
			    length <= m+n-1;
				if(t<n) then
					Y_arr(t) <= data_y(t);
					t <= t+1;
					xcorr_state <= FLIPLR;
				else
					t <= 0;
					xcorr_state <= PLACE_DATA;
				end if;
							
				
			when PLACE_DATA =>
                if(z=0) then
                    if(c<n) then
                        X_arr(c,20-z) <= "00000000";
                        c <= c+1;
                        xcorr_state <= PLACE_DATA;
                    else
                        if(c<length) then
                            X_arr(c,20-z) <= data_x(q);
                            c <= c+1;
                            q <= q+1;
                            xcorr_state <= PLACE_DATA;
                        else
                            c <= 0;
                            q <= 0;
                            z <= z+1;
                            xcorr_state <= PLACE_DATA;
                        end if;
                    end if;
                    
                else
                    if(z<length) then
                        if(c<length) then
                            X_arr(c,20-z) <= "00000000";
                            c <= c+1;
                            xcorr_state <= PLACE_DATA;
                        else
                            c <= 0;
                            z <= z+1;
                            xcorr_state <= PLACE_DATA;
                        end if;
                    else 
                        z <= 0;
                        c <= 0;
                        xcorr_state <= PLACE_KERNEL;
                    end if;
                end if;	
                    
			when PLACE_KERNEL =>
				if(d<m-1) then
					H_arr(d) <= "00000000";
					d <= d+1;
					xcorr_state <= PLACE_KERNEL;
				else
					if(d<length-1 or d=length-1) then
						H_arr(d) <= Y_arr(k);
						d <= d+1;
						k <= k+1;
						xcorr_state <= PLACE_KERNEL;
					else 
						d <= 0;
						k <= 0; 
						xcorr_state <= PREP_2D_CALC;
					end if;
				end if;

			when PREP_2D_CALC =>
				if(i<length-1 or i=length-1) then
					if(j<length-1 or j=length-1) then
						X_arr(20-j,20-i) <= X_arr(21-j,21-i);
						j <= j+1;
						xcorr_state <= PREP_2D_CALC;
					else
						j <= 1;
						i <= i+1;
						xcorr_state <= PREP_2D_CALC;
					end if;
				else
					i <= 1;
					j <= 1;
					xcorr_state <= PRODUCT1_CALC;
				end if;
				
			when PRODUCT1_CALC =>
				if(a<length) then
					if(b=length) then
                        b <= 0;
                        xcorr_state <= PRODUCT;
                    else
                        sum_xcorr <= sum_xcorr + to_integer(X_arr(20-a,20-b) * H_arr(20-b));
                        b <= b+1;
                        xcorr_state <= PRODUCT1_CALC;
                    end if;
                else
                    a <= 0;
                    xcorr_state <= PRE_CALC;
				end if;

			when PRODUCT =>
                sum_out <= std_logic_vector(to_signed(sum_xcorr,16));
				--done_step <= '1';
                sum_xcorr <= 0;
                a <= a+1;
                xcorr_state <= PRODUCT1_CALC;
			
		
			end case;

		end if;

	end process;

end Behavioral;
