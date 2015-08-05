module chaosMap(keyin, red, green, blue, hsync, vsync, CLK, RST);
	input CLK, RST;
	input [17:0] keyin;
	output red, green, blue, hsync, vsync;
	wire r, g, b, vnotactive;
	wire [9:0] row, col;
	
	mainvga vga(.red(red),.green(green),.blue(blue),.hsync(hsync),.vsync(vsync),.rin(r),.gin(g),.bin(b),.row(row),.col(col),.vnotactive(vnotactive),.CLK(CLK),.RST(RST));
	display display(.red(r),.green(g),.blue(b),.row(row),.col(col),.vnotactive(vnotactive),.key_c(keyin[9:5]),.key_d(keyin[4:0]) ,.CLK(CLK),.RST(RST));
	chattering_remover cr(.key_in(keyin),.clk(CLK),.rst(RST));
endmodule
