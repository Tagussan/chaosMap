module display(row, col, red, green, blue, color, up, down, left, right, vnotactive, CLK, RST);
input [9:0] row, col;
input CLK, RST, color, up, down, left, right, vnotactive;
output red, green, blue;
wire CLK_VERY_SLOW, CLK_SLOW;
wire red_bar, green_bar, blue_bar;
wire [17:0] mu;
wire [8:0] maxrepeat;
wire calc_clock;
reg red, green, blue;
reg calc_enable, disp_enable;
reg [9:0] originX, originY;
reg [1:0] key_state;
reg [16:0] result;
reg [4:0] startup_delay;
always @(posedge CLK or negedge RST) begin
   if(!RST) begin
      red <= 1'b1;
      green <= 1'b1;
      blue <= 1'b1;
   end else if(disp_enable == 1)begin
      red <= red_bar;
      green <= green_bar;
      blue <= blue_bar;
   end else begin
   end
end

logisticModule logisticModule(.CLK(calc_clock & calc_enable), .RST(RST), .red(red_bar), .green(green_bar), .blue(blue_bar), .row(row), .col(col), .mu(mu), .maxrepeat(maxrepeat));

sample_set sample_set(.CLK(CLK), .RST(RST), .sample_num(1), .mu(mu), .maxrepeat(maxrepeat), .calc_clock(calc_clock));

divider_slow divider_slow(.clk(CLK), .rst(RST), .clkout(CLK_SLOW));
divider_very_slow divider_very_slow(.clk(CLK), .rst(RST), .clkout(CLK_VERY_SLOW));

always @(posedge CLK_VERY_SLOW or negedge RST) begin
   if(!RST) begin
      startup_delay <= 0;
      calc_enable <= 0;
      disp_enable <= 0;
   end else if(startup_delay == 5'b00110) begin
      disp_enable <= 1;
      startup_delay <= startup_delay + 1;
   end else if(startup_delay == 5'b01111) begin
      calc_enable <= 1;
   end else begin
      startup_delay <= startup_delay + 1;
   end
end



always @(posedge CLK or negedge RST) begin
   if(!RST) begin
      originX <= 10'd300;
      originY <= 10'd200;
      key_state <= 2'd0;
   end
   else begin
      case(key_state)
         2'd0: begin
            if(vnotactive) key_state <= 2'd1;
         end
      2'd1: begin
         if(!up) originY <= originY - 10'd2;
         else if(!down) originY <= originY + 10'd2;
         if(!left) originX <= originX - 10'd2;
         else if(!right) originX <= originX + 10'd2;
         if(!up|!down|!left|!right) key_state <= 2'd2;
         else if(!vnotactive) key_state <= 2'd0;
      end
      2'd2: begin
         if(!vnotactive) key_state <= 2'd0;
      end
      2'd3: begin
      end
      endcase
   end
end
endmodule
