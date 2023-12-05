add wave sim:/multiplication/*
force -freeze sim:/multiplication/P 10#3 0
force -freeze sim:/multiplication/Q 10#2 0
force -freeze sim:/multiplication/Mode 000 0
force -freeze sim:/multiplication/Rst 0 0
force -freeze sim:/multiplication/Clk 1 0, 0 {5 ps} -r 10
run
force -freeze sim:/multiplication/Mode 011 0
run 6500