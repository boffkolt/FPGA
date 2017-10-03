library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

use ieee.numeric_std.all;



entity vga_25mhz is
generic(


VIS_AREA_HOR 	: integer	:=	800	;
FR_PCH_HOR		: integer	:=56;
SYNC_HOR			: integer	:=120;
BK_PCH_HOR		: integer	:=64	;
WHOLE_HOR		:	integer	:=1040;
	
VIS_AREA_VER 	: integer	:=	600	;
FR_PCH_VER		: integer	:=37;
SYNC_VER			: integer	:=6;
BK_PCH_VER		: integer	:=23	;
WHOLE_VER		:	integer	:=666

);

port(clk : in std_logic;

vga_g, vga_r, vga_b, hsync, vsync : out std_logic);

end vga_25mhz;
architecture synt of vga_25mhz is

constant HSYNC_BEGIN :	integer	:= VIS_AREA_HOR + FR_PCH_HOR - 1;
constant HSYNC_END :	integer	:= WHOLE_HOR - BK_PCH_HOR - 1;
constant VSYNC_BEGIN :	integer	:= VIS_AREA_VER + FR_PCH_VER - 1;
constant VSYNC_END :	integer	:= WHOLE_VER - BK_PCH_VER - 1;

signal videoon, videov, videoh : std_logic;
signal hcount, vcount : integer :=0;
signal h_en	:std_logic:='0';
signal v_en	:std_logic:='0';



begin


	counter: process (clk)
	begin
	if (clk'event and clk='1')then 
						
			if (hcount > WHOLE_HOR-1) then 
				hcount <= 0;
				if(vcount > WHOLE_VER-1) then
					vcount <= 0;
				else
					vcount <= vcount + 1;
				end if;
			else 
				hcount <= hcount + 1;
			end if;
	end if;
	end process;
	
	
	sync: process (clk)
	begin
 if (clk'event and clk='1')then
    if ((hcount >= HSYNC_BEGIN) and (hcount <= HSYNC_END)) then
        hsync <= '0';
    else
        hsync <= '1';
		end if;
    if ((vcount >= VSYNC_BEGIN) and (vcount <= VSYNC_END)) then
        vsync <= '0';
    else 
        vsync <= '1';
	end if;
end if;	
	end process;
 
	
	
	


	
		ena_img: process (clk)
	begin
	if (clk'event and clk='1') then 
	
    if(vcount < VIS_AREA_VER) then
        v_en <= '1';
    else
        v_en <= '0';
	end if;
    if(hcount < VIS_AREA_HOR) then
        h_en <= '1';
    else
        h_en <= '0';
		end if;
	end if;
	end process;
	
	img: process (clk)
	begin
	if (clk'event and clk='1') then 
	
   if((v_en = '1') and (h_en = '1'))  then
	
        if(vcount < 200)   then    
			vga_r <= '1';
			vga_g <= '1';
			vga_b <= '1';
		end if;
        if(vcount >= 200 and vcount < 400) then
	    			vga_r <= '0';
			vga_g <= '0';
			vga_b <= '1';
			end if;				
        if(vcount >= 400 and vcount < 600) then
	            
        	vga_r <= '1';
			vga_g <= '0';
			vga_b <= '0';	
			
			end if;	
    else  

	vga_r <= '0';
			vga_g <= '0';
			vga_b <= '0';	
			
		end if;
	 
	 
	 
	 
	 
	end if;
	end process;
--	
	
--rom : entity work.rom
--	generic map (11,1)
--	port map (adr,	clk,	vga_g	);


end synt;






