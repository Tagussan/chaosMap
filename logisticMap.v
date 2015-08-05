module logisticModule(CLK, RST, red, green, blue, row, col, mu, maxrepeat);
   input CLK, RST;
   input [8:0] maxrepeat;
   output red, green, blue;
   input [9:0] row, col;
   input [17:0] mu;
   wire [16:0] A_result, B_result, C_result, D_result;
   wire [9:0] A_row, B_row, C_row, D_row;
   wire [2:0] colorbits;
   logisticCycle A_cycle(.CLK(CLK), .RST(RST), .dzero(17'b0_1000_0010_0100_0000), .times(maxrepeat), .mu(mu), .result(A_result));
   logisticCycle B_cycle(.CLK(CLK), .RST(RST), .dzero(17'b0_1000_0010_0100_0001), .times(maxrepeat), .mu(mu), .result(B_result));
   logisticCycle C_cycle(.CLK(CLK), .RST(RST), .dzero(17'b0_1000_0010_0100_0010), .times(maxrepeat), .mu(mu), .result(C_result));
   logisticCycle D_cycle(.CLK(CLK), .RST(RST), .dzero(17'b0_1000_0010_0100_0011), .times(maxrepeat), .mu(mu), .result(D_result));
   assign A_row = A_result >> 8;
   assign B_row = B_result >> 8;
   assign C_row = C_result >> 8;
   assign D_row = D_result >> 8;
   function [2:0] colorselect;
      input [9:0] row,col;
      if(0 < col && col <= 10 && A_row <= row && row <= A_row + 5)
         colorselect = 3'b001;
      else if (10 < col && col <= 20 && B_row <= row && row <= B_row + 5)
         colorselect = 3'b011;
      else if (20 < col && col <= 30 && C_row <= row && row <= C_row + 5)
         colorselect = 3'b100;
      else if (40 < col && col <= 50 && D_row <= row && row <= D_row + 5)
         colorselect = 3'b010;
      else
         colorselect = 3'b111;
   endfunction
   assign colorbits = colorselect(row, col);
   assign {red,green,blue} = colorbits;
endmodule

module logisticCycle(CLK, RST, done, dzero, times, mu, result);
//Dset to set initial data
//dzero is initial data
//done to show completed mapping for "times"
//times to map times
//repeating and stop sanitary
   input CLK, RST;
   input [16:0] dzero;
   input [8:0] times;
   input [17:0] mu;
   wire [16:0] funcIn, funcOut;
   output [16:0] result;
   output done;
   reg [8:0] ind; //ind as how many times mapped
   reg done;
   reg [16:0] result;
   always @(posedge CLK) begin
      if(RST == 0 || ind == 0) begin
         done <= 'b0;
         result <= dzero;
         ind <= 1;
      end else begin
         if(ind == times) begin
            done <= 1;
         end else begin
            result <= funcOut;
            ind <= ind + 1;
         end
      end
   end
   logisticFunc logisticFunc(.x(result), .mu(mu), .y(funcOut));
endmodule

module logisticFunc(x,mu,y);
   input [16:0] x;
   input [17:0] mu;
   output [16:0] y;
   wire [33:0] term;
   wire [34:0] enlarge;
   assign term = x * (17'h1_0000_0000_0000_0000 - x);
   assign enlarge = mu * term[33:16];
   assign y = enlarge[34:18];
endmodule
