module display(row, col, red, green, blue, color, up, down, left, right, vnotactive, CLK, RST);
input [9:0] row, col;
input CLK, RST, color, up, down, left, right, vnotactive;
output red, green, blue;
wire CLK_SLOW;
wire [16:0] logistic_result;
wire red_bar, green_bar, blue_bar;
reg red, green, blue;
reg calc_enable, disp_enable;
reg [9:0] originX, originY;
reg [1:0] key_state;
reg [16:0] result;
reg [4:0] startup_delay;
divider divider(.clk(CLK), .rst(RST), .clkout(CLK_SLOW));
//logisticCycle logisticCycle(.CLK(CLK_SLOW), .Dset(!RST), .dzero(17'b0_1000_0010_0100_0000), .times(16'd1024), .mu(18'b11_1111_1011_1101_1111), .result(logistic_result));
//logisticFunc(.x(16'b0111_1111_1111_1111), .mu(18'b01_1111_1111_1111_1111), .y(logistic_result));
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

logisticModule logisticModule(.CLK(CLK_SLOW & calc_enable), .RST(calc_enable), .red(red_bar), .green(green_bar), .blue(blue_bar), .row(row), .col(col), .mu(18'b11_1111_1011_1101_1111));

always @(posedge CLK_SLOW or negedge RST) begin
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
