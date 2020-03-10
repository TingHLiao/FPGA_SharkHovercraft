# Clock signal
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports clk]

#7 segment display
set_property IOSTANDARD LVCMOS33 [get_ports {seg[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[2]}]
set_property PACKAGE_PIN V8 [get_ports {seg[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[3]}]
set_property PACKAGE_PIN U8 [get_ports {seg[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[4]}]
set_property PACKAGE_PIN W6 [get_ports {seg[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[5]}]
set_property PACKAGE_PIN W7 [get_ports {seg[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[6]}]

#AN
set_property PACKAGE_PIN U2 [get_ports {AN[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {AN[0]}]
set_property PACKAGE_PIN U4 [get_ports {AN[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {AN[1]}]
set_property PACKAGE_PIN V4 [get_ports {AN[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {AN[2]}]
set_property PACKAGE_PIN W4 [get_ports {AN[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {AN[3]}]

set_property PACKAGE_PIN B16 [get_ports {Rx}]
set_property IOSTANDARD LVCMOS33 [get_ports {Rx}]
set_property PACKAGE_PIN B15 [get_ports {Tx}]
set_property IOSTANDARD LVCMOS33 [get_ports {Tx}]
set_property PACKAGE_PIN P18 [get_ports {dir}]
set_property IOSTANDARD LVCMOS33 [get_ports {dir}]
set_property PACKAGE_PIN R18 [get_ports {push}]
set_property IOSTANDARD LVCMOS33 [get_ports {push}]
set_property PACKAGE_PIN C16 [get_ports {start}]
set_property IOSTANDARD LVCMOS33 [get_ports {start}]
set_property PACKAGE_PIN G3 [get_ports {led}]
set_property IOSTANDARD LVCMOS33 [get_ports {led}]


#Buttons
set_property PACKAGE_PIN T18 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports rst]

set_property PACKAGE_PIN U5 [get_ports {seg[2]}]
set_property PACKAGE_PIN V5 [get_ports {seg[1]}]
set_property PACKAGE_PIN U7 [get_ports {seg[0]}]
