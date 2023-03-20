onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+Fifo_In8x1024_Out8x1024 -L xil_defaultlib -L xpm -L fifo_generator_v13_2_2 -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.Fifo_In8x1024_Out8x1024 xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {Fifo_In8x1024_Out8x1024.udo}

run -all

endsim

quit -force
