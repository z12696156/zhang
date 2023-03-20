onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib Square_Root_opt

do {wave.do}

view wave
view structure
view signals

do {Square_Root.udo}

run -all

quit -force
