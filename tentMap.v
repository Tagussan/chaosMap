module tentCycle(CLK, Dset, done, dzero, times, mu, result);
//Dset to set initial data
//dzero is initial data
//done to show completed mapping for "times"
//times to map times
//repeating and stop sanitary
   input CLK;
   input Dset; 
   input [15:0] dzero;
   input [15:0] times;
   input [15:0] mu;
   wire [15:0] funcIn, funcOut;
   output [15:0] result;
   output done;
   reg [7:0] ind; //ind as how many times mapped
   reg done;
   reg [15:0] result;
   always @(posedge CLK or posedge Dset) begin
      if(Dset) begin
         ind <= 0;
         done <= 'b0;
         result <= dzero;
      end else begin
         if(ind == times) begin
            done <= 1;
         end else begin
            result <= funcOut;
            ind <= ind + 1;
         end
      end
   end
   tentFunc tentFunc(.x(result), .mu(mu), .y(funcOut));
endmodule

module tentFunc(x,mu,y);
   input [15:0] x;
   input [15:0] mu;
   output [15:0] y;
   wire [15:0] dat1, dat2;
   wire [31:0] result;
   assign dat1 = mu;
   assign dat2 = x;
   //ip_mult ip_mult(.dataa(dat1), .datab(dat2), .result(result));
   assign result = (dat2 < (1 << 15)) ? (dat1 * dat2) : (dat1 * ('hffff - dat2));
   assign y = result[15:0];
endmodule
