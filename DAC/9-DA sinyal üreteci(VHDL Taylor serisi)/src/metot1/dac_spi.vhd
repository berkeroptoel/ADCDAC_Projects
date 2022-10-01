

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY dac_spi IS
  GENERIC(
    clock_div : integer := 1;
    slaves  : INTEGER := 1;  
    d_width : INTEGER := 16); 
  PORT(
  
    wave1  : in STD_LOGIC_VECTOR(7 DOWNTO 0);  
    wave2  : in STD_LOGIC_VECTOR(7 DOWNTO 0);
    wave3  : in STD_LOGIC_VECTOR(7 DOWNTO 0);
    wave4  : in STD_LOGIC_VECTOR(7 DOWNTO 0);
    channel  : in std_logic_vector(1 downto 0);
    clock      : IN  STD_LOGIC;                             --system clock 
    reset_n    : IN  STD_LOGIC;                             --asynchronous reset
    enable     : IN  STD_LOGIC;                             --initiate transaction
    cpol       : IN  STD_LOGIC:='0';                             --spi clock polarity
    cpha       : IN  STD_LOGIC:='0';                             --spi clock phase
    cont       : IN  STD_LOGIC:='0';                             --continuous mode command
    clk_div    : IN  INTEGER;                               --system clock cycles per 1/2 period of sclk
    addr       : IN  INTEGER:=0;                            --address of slave
    tx_data    : IN  STD_LOGIC_VECTOR(d_width-1 DOWNTO 0);  --data to transmit
    miso       : IN  STD_LOGIC;                             --master in, slave out
    sclk    : BUFFER STD_LOGIC;                             --spi clock
    ss_n    : BUFFER STD_LOGIC_VECTOR(slaves-1 DOWNTO 0);   --slave select
    mosi    : OUT    STD_LOGIC;                             --master out, slave in
    busy    : OUT    STD_LOGIC;                             --busy / data ready signal
	done_dac: OUT    STD_LOGIC := '0';
	load    : out    std_LOGIC;
	fs      : out    std_LOGIC ;
    rx_data : OUT    STD_LOGIC_VECTOR(d_width-1 DOWNTO 0);
    pdown : out std_logic := '1'
    
    ); 
END dac_spi;

ARCHITECTURE logic OF dac_spi IS
  TYPE machine IS(ready, interexe, execute, delay);          --state machine data type
  SIGNAL state       : machine;                              --current state
  SIGNAL slave       : INTEGER;                              --slave selected for current transaction
  SIGNAL clk_ratio   : INTEGER;                              --current clk_div
  SIGNAL count       : INTEGER;                              --counter to trigger sclk from system clock
  SIGNAL clk_toggles : INTEGER RANGE 0 TO d_width*2 + 1;     --count spi clock toggles
  SIGNAL assert_data : STD_LOGIC;                            --'1' is tx sclk toggle, '0' is rx sclk toggle
  SIGNAL continue    : STD_LOGIC;                            --flag to continue transaction
  SIGNAL rx_buffer   : STD_LOGIC_VECTOR(d_width-1 DOWNTO 0); --receive data buffer
  SIGNAL tx_buffer   : STD_LOGIC_VECTOR(d_width-1 DOWNTO 0); --transmit data buffer
  SIGNAL last_bit_rx : INTEGER RANGE 0 TO d_width*2;         --last rx data bit location
  signal c : integer := 0 ;
  constant d : integer := 1 ;
  signal dac_word : std_logic_vector(15 downto 0):= "0000000000000000"; 
  
BEGIN
  PROCESS(clock, reset_n)
  BEGIN

    IF(reset_n = '0') THEN        --reset system
      done_dac <= '0';
	  busy <= '1';                --set busy signal
      ss_n <= (OTHERS => '1');    --deassert all slave select lines
      mosi <= 'Z';                --set master out to high impedance
      rx_data <= (OTHERS => '0'); --clear receive data port
      state <= ready;             --go to ready state when reset is exited

    ELSIF(clock'EVENT AND clock = '1') THEN
      CASE state IS               --state machine

        WHEN ready =>
        
		  
		  dac_word(15 downto 14) <= "11";
		  --dac_word(13) <= '1';
		  
		  case channel is
            when "00" =>   dac_word(11 downto 4)  <= wave1 ;
            when "01" =>   dac_word(11 downto 4)  <= wave2 ;
            when "10" =>   dac_word(11 downto 4)  <= wave3 ;
            when "11" =>   dac_word(11 downto 4)  <= wave4 ;
            when others => dac_word(11 downto 4)  <= X"00" ;
         end case;
         
			  done_dac <= '0';								
              fs <= '1' ;
              busy <= '0';             --clock out not busy signal
              ss_n <= (OTHERS => '1'); --set all slave select outputs high
              mosi <= 'Z';             --set mosi output high impedance
              continue <= '0';         --clear continue flag

              --user input to initiate transaction
              IF(enable = '1') THEN       
                busy <= '1';             --set busy signal
                IF(addr < slaves) THEN   --check for valid slave address
                  slave <= addr;         --clock in current slave selection if valid
                ELSE
                  slave <= 0;            --set to first slave if not valid
                END IF;
                IF(clock_div = 0) THEN     --check for valid spi speed
                  clk_ratio <= 1;        --set to maximum speed if zero
                  count <= 1;            --initiate system-to-spi clock counter
                ELSE
                  clk_ratio <= clock_div;  --set to input selection if valid
                  count <= clock_div;      --initiate system-to-spi clock counter
                END IF;
                sclk <= cpol;            --set spi clock polarity
                assert_data <= NOT cpha; --set spi clock phase
                tx_buffer <= dac_word;    --clock in data for transmit into buffer
                clk_toggles <= 0;        --initiate clock toggle counter
                last_bit_rx <= d_width*2 + conv_integer(cpha) - 1; --set last rx data bit
                state <= interexe ;
              ELSE
                state <= ready;          --remain in ready state
              END IF;

        WHEN interexe =>  
             
         ss_n(slave) <= '1' ;
         if (c=d) then 
         c<= 1 ;
         ss_n(slave)<= '0' ;
         state <= execute ;
         else 
         c<= c + 1;
         state <= interexe ;
         end if ;
			 
			 
        WHEN execute =>
	 
          busy <= '1';        --set busy signal
          fs <= '0';          --set proper slave select output
          
          --system clock to sclk ratio is met
          IF(count = clk_ratio) THEN        
            count <= 1;                     --reset system-to-spi clock counter
            assert_data <= NOT assert_data; --switch transmit/receive indicator
            IF(clk_toggles = d_width*2 + 1) THEN
              clk_toggles <= 0;               --reset spi clock toggles counter
            ELSE
              clk_toggles <= clk_toggles + 1; --increment spi clock toggles counter
            END IF;
            
            --spi clock toggle needed
            IF(clk_toggles <= d_width*2 AND ss_n(slave) = '0') THEN 
              sclk <= NOT sclk; --toggle spi clock
            END IF;
            
            --receive spi clock toggle
            IF(assert_data = '0' AND clk_toggles < last_bit_rx + 1 AND ss_n(slave) = '0') THEN 
              rx_buffer <= rx_buffer(d_width-2 DOWNTO 0) & miso; --shift in received bit
            END IF;
            
            --transmit spi clock toggle
            IF(assert_data = '1' AND clk_toggles < last_bit_rx) THEN 
              mosi <= tx_buffer(d_width-1);                     --clock out data bit
              tx_buffer <= tx_buffer(d_width-2 DOWNTO 0) & '0'; --shift data transmit buffer
            END IF;
            
            --last data receive, but continue
            IF(clk_toggles = last_bit_rx AND cont = '1') THEN 
              tx_buffer <= dac_word;                       --reload transmit buffer
              clk_toggles <= last_bit_rx - d_width*2 + 1; --reset spi clock toggle counter
              continue <= '1';                            --set continue flag
            END IF;
            
            --normal end of transaction, but continue
            IF(continue = '1') THEN  
              continue <= '0';      --clear continue flag
              busy <= '0';          --clock out signal that first receive data is ready
              rx_data <= rx_buffer; --clock out received data to output port    
            END IF;
            
            --end of transaction
            IF((clk_toggles = d_width*2 + 1) AND cont = '0') THEN   
				  fs 		<= '1' ;
				  count	<= 0;
              busy 	<= '0';             	--clock out not busy signal
              ss_n 	<= (OTHERS => '1'); 	--set all slave selects high
              mosi 	<= 'Z';             	--set mosi output high impedance
              rx_data<= rx_buffer;    		--clock out received data to output port
              state 	<= delay;          	--return to ready state
            ELSE                       	--not end of transaction
              state 	<= execute;        	--remain in execute state
            END IF;
          
          ELSE        --system clock to sclk ratio not met
            count <= count + 1; --increment counter
            state <= execute;   --remain in execute state
          END IF;
          
		when delay =>
			if(count < 1) then
				count <= count + 1;
			else
				done_dac <= '1';
				state	<= ready;
			end if;

      END CASE;
    END IF;
  END PROCESS; 
  
  load <= '0' ;
  
END logic;
