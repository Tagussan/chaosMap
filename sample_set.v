module sample_set(CLK, RST, sample_num, mu, maxrepeat, calc_clock);
   input [5:0] sample_num;
   input CLK, RST;
   output [17:0] mu;
   output [8:0] maxrepeat;
   output calc_clock;
   wire CLK_SLOW, CLK_VERY_SLOW;
   divider_very_slow divider_very_slow(.clk(CLK), .rst(RST), .clkout(CLK_VERY_SLOW));
   divider_slow divider_slow(.clk(CLK), .rst(RST), .clkout(CLK_SLOW));
   function [17:0] select_mu;
      input [5:0] sample_num;
      case (sample_num)
         0:     select_mu = 18'b10_1101_1011_1101_1111;
         1:     select_mu = 18'b11_1101_1011_1101_1111;
         2:     select_mu = 18'b11_1101_1011_1100_1111;
         default: select_mu = 0;
      endcase
   endfunction
   function [8:0] select_maxrepeat;
      input [5:0] sample_num;
      case (sample_num)
         0:     select_maxrepeat = 500;
         1:     select_maxrepeat = 256;
         2:     select_maxrepeat = 256;
         default: select_maxrepeat = 0;
      endcase
   endfunction
   function select_CLK;
      input [5:0] sample_num;
      case (sample_num)
         0:     select_CLK = CLK_SLOW;
         1:     select_CLK = CLK_SLOW;
         2:     select_CLK = CLK_VERY_SLOW;
         default:  select_CLK = CLK_SLOW;
      endcase
   endfunction
   assign mu = select_mu(sample_num);
   assign maxrepeat = select_maxrepeat(sample_num);
   assign calc_clock = select_CLK(sample_num);
endmodule
