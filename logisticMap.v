module logisticModule(CLK,CLK_calc, RST, red, green, blue, row, col, mu, maxrepeat);
   input CLK, CLK_calc, RST;
   input [8:0] maxrepeat;
   output red, green, blue;
   input [9:0] row, col;
   input [17:0] mu;
   wire [16:0] A_result, B_result, C_result, D_result, E_result, F_result, G_result;
   wire [33:0] B_result_dbg;
   wire [34:0] B_result_dbgdbg;
   wire [34:0] A_result_dbgdbg;
   wire [9:0] A_row, B_row, C_row, D_row, E_row, F_row, G_row;
   wire [2:0] colorbits;
   logisticCycleTiny A_cycle(.CLK(CLK), .CLK_calc(CLK_calc), .RST(RST), .dzero(17'b0_1000_0010_0100_0000), .times(maxrepeat), .mu(mu), .result(A_result));
   //myMult18 myMult18(.CLK(CLK_calc), .RST(RST), .calc_start(RST), .dataa(B_result_dbg[33:16]), .datab(mu), .result(A_result_dbgdbg));
   //assign A_result = A_result_dbgdbg[34:18];
   //logisticFuncTiny A_Tiny(.CLK(CLK_calc), .calc_start(RST), .x(17'b0_1000_0010_0100_0001), .mu(mu), .y(B_result));
   logisticCycle B_cycle(.CLK(CLK), .RST(RST), .dzero(17'b0_1000_0010_0100_0001), .times(maxrepeat), .mu(mu), .result(B_result));
   
   //assign B_result_dbg = (17'b0_1000_0010_0100_0001 * (17'h1_0000_0000_0000_0000 - 17'b0_1000_0010_0100_0001));
   //assign B_result_dbgdbg = mu * B_result_dbg[33:16];
   //assign B_result = B_result_dbgdbg[34:18];
   
   logisticCycle C_cycle(.CLK(CLK), .RST(RST), .dzero(17'b0_1000_0010_0100_0010), .times(maxrepeat), .mu(mu), .result(C_result));
   logisticCycle D_cycle(.CLK(CLK), .RST(RST), .dzero(17'b0_1000_0010_0100_0011), .times(maxrepeat), .mu(mu), .result(D_result));
   logisticCycle E_cycle(.CLK(CLK), .RST(RST), .dzero(17'b0_1000_0010_0100_0100), .times(maxrepeat), .mu(mu), .result(E_result));
   logisticCycle F_cycle(.CLK(CLK), .RST(RST), .dzero(17'b0_1000_0010_0100_0101), .times(maxrepeat), .mu(mu), .result(F_result));
   logisticCycle G_cycle(.CLK(CLK), .RST(RST), .dzero(17'b0_1000_0010_0100_0110), .times(maxrepeat), .mu(mu), .result(G_result));
   assign A_row = A_result >> 8;
   assign B_row = B_result >> 8;
   assign C_row = C_result >> 8;
   assign D_row = D_result >> 8;
   assign E_row = E_result >> 8;
   assign F_row = F_result >> 8;
   assign G_row = G_result >> 8;
   function [2:0] colorselect;
      input [9:0] row,col;
      if(0 < col && col <= 20 && A_row <= row && row <= A_row + 5)
         colorselect = 3'b001;
      else if (20 < col && col <= 40 && B_row <= row && row <= B_row + 5)
         colorselect = 3'b011;
      else if (40 < col && col <= 60 && C_row <= row && row <= C_row + 5)
         colorselect = 3'b100;
      else if (60 < col && col <= 80 && D_row <= row && row <= D_row + 5)
         colorselect = 3'b010;
      else if (80 < col && col <= 100 && E_row <= row && row <= E_row + 5)
         colorselect = 3'b101;
      else if (100 < col && col <= 120 && F_row <= row && row <= F_row + 5)
            colorselect = 3'b110;
      else if (120 < col && col <= 140 && G_row <= row && row <= G_row + 5)
         colorselect = 3'b000;
      else
         colorselect = 3'b111;
   endfunction
   assign colorbits = colorselect(row, col);
   assign {red,green,blue} = colorbits;
endmodule

module logisticCycle(CLK, RST, dzero, mu, result);
//Dset to set initial data
//dzero is initial data
//done to show completed mapping for "times"
//times to map times
//repeating and stop sanitary
   input CLK, RST;
   input [16:0] dzero;
   input [17:0] mu;
   wire [16:0] funcIn, funcOut;
   output [16:0] result;
   reg [16:0] result;
   always @(posedge CLK) begin
      if(RST == 0) begin
         result <= dzero;
      end else begin
          result <= funcOut;
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
   assign term = x * (17'b1_0000_0000_0000_0000 - x);
   assign enlarge = mu * term[33:16];
   assign y = enlarge[32:16];
endmodule

module logisticCycleTiny(CLK, CLK_calc,RST, dzero, mu, result);
//Dset to set initial data
//dzero is initial data
//repeating and stop sanitary
//CLK is slower than CLK_calc
   input CLK, RST, CLK_calc;
   input [16:0] dzero;
   input [17:0] mu;
   wire [16:0] funcIn, funcOut;
   output [16:0] result;
   reg [16:0] result;
   reg [16:0] temp;
   wire calc_done_wire;
   reg calc_start;
   reg [3:0] progress;
   always @(posedge CLK) begin
      if(RST == 0) begin
         temp <= dzero;
         progress <= 0;
         calc_start <= 0;
      end else begin
          if(progress == 0 && calc_done_wire == 0) begin
              calc_start <= 1;
              progress <= 1;
          end else if(progress == 1 && calc_done_wire == 1) begin
              result <= funcOut;
              progress <= 2;
          end else if(progress == 2) begin
              calc_start <= 0;
              progress <= 3;
          end else if(progress == 3 && calc_done_wire == 0) begin
              temp <= result;
              progress <= 0;
          end
      end
   end
   logisticFuncTiny logisticFuncTiny(.x(temp), .mu(mu), .y(funcOut), .CLK(CLK_calc), .calc_start(calc_start), .done(calc_done_wire));
endmodule

module logisticFuncTiny(x,mu,y,CLK,calc_start,done);
   input [16:0] x;
   input [17:0] mu;
   output [16:0] y;
   reg [17:0] dataa,datab;
   reg [16:0] y;
   input CLK;
   input calc_start;
   output done;
   reg done;
   reg [33:0] term;
   reg [34:0] enlarge;
   reg [3:0] progress;
   wire submult_done;
   wire [35:0] submult_result;
   reg submult_start;
   myMult18 myMult18(.CLK(CLK), .dataa(dataa), .datab(datab), .result(submult_result), .done(submult_done), .calc_start(submult_start));
   always @(posedge CLK) begin
      if(calc_start == 0) begin
         progress <= 0;
         submult_start <= 0;
         term <= 0;
         enlarge <= 0;
         dataa <= 0;
         datab <= 0;
         done <= 0;
         y <= 0;
      end else begin
         if(progress == 0 && submult_done == 0) begin
            dataa <= x;
            datab <= (17'b1_0000_0000_0000_0000 - x);
            progress <= 1;
            submult_start <= 0;
            done <= 0;
         end else if(progress == 1) begin
            submult_start <= 1;
            progress <= 2;
            done <= 0;
         end else if(progress == 2 && submult_done == 1) begin
            term <= submult_result[33:0];
            progress <= 3;
            done <= 0;
         end else if(progress == 3) begin
            dataa <= mu;
            datab <= term[33:16];
            progress <= 4;
            submult_start <= 0;
            done <= 0;
         end else if(progress == 4 && submult_done == 0) begin
            submult_start <= 1;
            progress <= 5;
         end else if(progress == 5 && submult_done == 1) begin
            enlarge <= submult_result[34:0];
            progress <= 6;
         end else if(progress == 6) begin
            y <= enlarge[32:16];
            progress <= 7;
         end else if(progress == 7) begin
            done <= 1;
         end else begin
         end
      end
   end
endmodule
