onbreak {quit -f}
onerror {quit -f}

vsim -voptargs="+acc" -t 1ps -L xil_defaultlib -L xpm -L fifo_generator_v13_2_2 -L unisims_ver -L unimacro_ver -L secureip -lib xil_defaultlib xil_defaultlib.Fifo_In8x1024_Out8x1024 xil_defaultlib.glbl

do {wave.do}

view wave
view structure
view signals

do {Fifo_In8x1024_Out8x1024.udo}

run -all

quit -force
