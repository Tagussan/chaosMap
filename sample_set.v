module sample_set(CLK, RST, sample_num, mu, calc_clock);
   input [5:0] sample_num;
   input CLK, RST;
   output [17:0] mu;
   output calc_clock;
   wire CLK_SLOW, CLK_VERY_SLOW;
   divider_very_slow divider_very_slow(.clk(CLK), .rst(RST), .clkout(CLK_VERY_SLOW));
   divider_slow divider_slow(.clk(CLK), .rst(RST), .clkout(CLK_SLOW));
   function [17:0] select_mu;
      input [5:0] sample_num;
      case (sample_num)
         0:     select_mu = 18'b00_1100_1100_1100_1100;
         1:     select_mu = 18'b01_0011_0011_0011_0011;
         2:     select_mu = 18'b11_0001_1001_1001_1001;
         3:     select_mu = 18'b11_0111_0011_0011_0011;
         4:     select_mu = 18'b11_1000_1100_1100_1101;
         5:     select_mu = 18'b11_1001_0000_1010_0100;
         6:     select_mu = 18'b11_1001_0000_1110_0101;
         7:     select_mu = 18'b11_1001_0001_0010_0111;
         8:     select_mu = 18'b11_1001_0001_1110_1100;
         9:     select_mu = 18'b11_1001_0100_0111_1011;
         10:    select_mu = 18'b11_1111_1111_1111_1111;
         default: select_mu = 0;
      endcase
   endfunction
   function select_CLK;
      input [5:0] sample_num;
      case (sample_num)
         0:     select_CLK = CLK_SLOW;
         1:     select_CLK = CLK_SLOW;
         2:     select_CLK = CLK_SLOW;
         default:  select_CLK = CLK_SLOW;
      endcase
   endfunction
   assign mu = select_mu(sample_num);
   assign calc_clock = select_CLK(sample_num);
endmodule
