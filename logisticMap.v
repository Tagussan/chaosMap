module logisticCycle(CLK, Dset, done, dzero, times, mu, result);
//Dset to set initial data
//dzero is initial data
//done to show completed mapping for "times"
//times to map times
//repeating and stop sanitary
   input CLK;
   input Dset; 
   input [16:0] dzero;
   input [16:0] times;
   input [17:0] mu;
   wire [16:0] funcIn, funcOut;
   output [16:0] result;
   output done;
   reg [7:0] ind; //ind as how many times mapped
   reg done;
   reg [16:0] result;
   always @(posedge CLK) begin
      if(ind == 0) begin
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
