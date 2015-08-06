module myMult18(CLK, RST, calc_start, done, dataa, datab, result);
   input CLK, RST, calc_start;
   input [17:0] dataa;
   input [17:0] datab;
   output [35:0] result;
   output done;
   reg [5:0] index;
   reg [35:0] temp, result;
   reg [1:0] progress;
   reg done;
   always @(posedge CLK) begin
      if(RST == 0) begin
         index <= 0;
         result <= 0;
         temp <= 0;
         done <= 0;
      end else begin 
         if(calc_start == 0) begin
            
         end else begin
            if(index > 17) begin
               result <= temp;
               done <= 1;
            end else if(datab[index] == 1) begin
               temp <= temp + (dataa << index);
               index <= index + 1;
            end else begin
               index <= index + 1;
            end
         end
      end
   end
endmodule

