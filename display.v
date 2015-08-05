module display(row, col, red, green, blue, key_c, key_d, vnotactive, CLK, RST);
input [9:0] row, col;
input CLK, RST, vnotactive;
input [4:0] key_c, key_d;
output red, green, blue;
wire CLK_VERY_SLOW, CLK_SLOW;
wire red_bar, green_bar, blue_bar;
wire [17:0] mu;
wire [8:0] maxrepeat;
wire calc_clock;
reg red, green, blue;
reg calc_enable, disp_enable;
reg logistic_RST;
reg [4:0] sample_num;
reg [16:0] result;
reg [1:0] key_state;
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

logisticModule logisticModule(.CLK(calc_clock & calc_enable), .RST(logistic_RST), .red(red_bar), .green(green_bar), .blue(blue_bar), .row(row), .col(col), .mu(mu), .maxrepeat(maxrepeat));

sample_set sample_set(.CLK(CLK), .RST(RST), .sample_num(sample_num), .mu(mu), .maxrepeat(maxrepeat), .calc_clock(calc_clock));

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
      key_state <= 'd0;
   end
   else begin
      case(key_state)
         2'd0: begin
            if(vnotactive) 
               key_state <= 2'd1;
         end
         2'd1: begin
            if(!key_d[0]) begin
               sample_num <= 0;
               logistic_RST <= 0;
            end else if(!key_d[1]) begin 
               sample_num <= 1;
               logistic_RST <= 0;
            end else if(!key_d[2]) begin
               sample_num <= 2;
               logistic_RST <= 0;
            end else if(!key_d[3]) begin
               sample_num <= 3;
               logistic_RST <= 0;
            end else begin
               logistic_RST <= 1;
            end
            if(!key_d[0] || !key_d[1] || !key_d[2] || !key_d[3]) begin
               key_state <= 2'd2;
            end else if(!vnotactive) 
               key_state <= 2'd0;
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
