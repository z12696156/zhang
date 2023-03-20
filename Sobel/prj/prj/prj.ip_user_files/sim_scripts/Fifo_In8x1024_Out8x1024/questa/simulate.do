onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib Fifo_In8x1024_Out8x1024_opt

do {wave.do}

view wave
view structure
view signals

do {Fifo_In8x1024_Out8x1024.udo}

run -all

quit -force
