module vga_tst(clk, v_sync, h_sync, vga_r, vga_g, vga_b);
 
input clk;
 
reg [11:0]h_cnt;
output reg h_sync;
 
reg [10:0]v_cnt;
output reg v_sync;
 
reg h_en;
reg v_en;
 
output reg vga_r;
output reg vga_g;
output reg vga_b;
 
//блок синхронизации
always @ (posedge clk) begin
 
    if ((h_cnt > 855) && (h_cnt < 976))
        h_sync <= 0;
    else
        h_sync <= 1;
 
    if ((v_cnt > 637) && (v_cnt < 643))
        v_sync <= 0;
    else 
        v_sync <= 1;
 
end
 
//Увеличение счетчиков по горизонтали и вертикали 
always @ (posedge clk) begin
    if(h_cnt > 1039) begin
        h_cnt <= 0;  
        if(v_cnt > 665) 
	    v_cnt <= 0;
	else
	    v_cnt <= v_cnt + 1'b1;
    end
    else
        h_cnt <= h_cnt + 1'b1;
end
 
//Разрешаем/запрещаем отрисовку вне видимой зоны 
always @ (posedge clk) begin	
    if(v_cnt < 599)
        v_en <= 1'b1;
    else
        v_en <= 1'b0;
    if(h_cnt < 799)
        h_en <= 1'b1;
    else
        h_en <= 1'b0;
end
 
//отрисовка линий
always @ (posedge clk) begin			
        vga_r <= 1;
		vga_g <= 1;
        vga_b <= 1;
   
	 
end
 
 
endmodule