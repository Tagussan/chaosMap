module myMult18(CLK, calc_start, done, dataa, datab, result);
   //seems sanitary
   input CLK, calc_start;
   input [17:0] dataa;
   input [17:0] datab;
   output [35:0] result;
   output done;
   reg [5:0] index;
   reg [35:0] temp, result;
   reg [35:0] temp2, temp3;
   reg done;
   always @(posedge CLK) begin
       if(calc_start == 0) begin
           done <= 0;
           temp <= 0;
           temp2 <= dataa;
           temp3 <= datab;
           index <= 0;
           result <= 0;
       end else begin
           if(index == 18) begin
               result <= temp;
               done <= 1;
           end else if(index <= 17 && temp3[index] == 1) begin
               temp <= temp + temp2;
               temp2 <= temp2 << 1;
               index <= index + 1;
           end else if(index <= 17) begin
               temp2 <= temp2 << 1;
               index <= index + 1;
           end else begin

           end
       end
   end
endmodule

