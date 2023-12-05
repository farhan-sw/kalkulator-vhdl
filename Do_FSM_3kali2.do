add wave sim:/fsm_multi/*
force -freeze sim:/fsm_multi/Mode 000 0 
force -freeze sim:/fsm_multi/StatusAdder 00 0
force -freeze sim:/fsm_multi/QMSB 0 0
force -freeze sim:/fsm_multi/PMSB 0 0
force -freeze sim:/fsm_multi/Qprev 0 0
force -freeze sim:/fsm_multi/QLSB 0 0
force -freeze sim:/fsm_multi/Rst 0 0
force -freeze sim:/fsm_multi/clk 1 0 , 0 {5 ps} -r 10
run 10
force -freeze sim:/fsm_multi/Mode 011 0
run 80
force -freeze sim:/fsm_multi/QLSB 1 0
run 80
force -freeze sim:/fsm_multi/StatusAdder 11 0
run 50
force -freeze sim:/fsm_multi/StatusAdder 00 0
run 80
force -freeze sim:/fsm_multi/QLSB 0 0
force -freeze sim:/fsm_multi/Qprev 1 0
run 30
force -freeze sim:/fsm_multi/StatusAdder 00 0
run 40
force -freeze sim:/fsm_multi/StatusAdder 11 0
run 20
force -freeze sim:/fsm_multi/StatusAdder 00 0
run 30
force -freeze sim:/fsm_multi/Qprev 0 0
force -freeze sim:/fsm_multi/QLSB 0 0
run 100



