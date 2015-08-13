totalNum = 800
print "wire [16:0] "
0.upto(totalNum) do |i|
    print "logistic_result#{i}, " if i != totalNum
    print "logistic_result#{i};\n" if i == totalNum
end
print "wire[9:0] "
0.upto(totalNum) do |i|
    print "logistic_row#{i}, " if i != totalNum
    print "logistic_row#{i};\n" if i == totalNum
end
0.upto(totalNum) do |i|
    dzero = 0b01000001001000000 + i
    puts "logisticCycle cycle_#{i}(.CLK(CLK), .RST(RST), .dzero(17'b#{dzero.to_s(2)}), .times(maxrepeat), .mu(mu), .result(logistic_result#{i});"
end
0.upto(totalNum) do |i|
    puts "assign logistic_row#{i} = logistic_result#{i} >> 8;"
end

