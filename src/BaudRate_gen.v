/*baud rate = 9600. The clock of FPGA is 100MHz. 
we want the "TICKS" to ahev 16 times the frequency of the UART signal,
so we need a frequency 16 times the 9600Hz.
That the pulse = 100M/9600/16 = 650,
So set baud rate to 650 in bluetooth.
*/
module BaudRate_gen(Clk, Rst_n, Tick, BaudRate);
    input Clk, Rst_n;
    input [15:0]BaudRate;
    output Tick ; // 650 pulses generte a tick pulse
    reg [15:0]count ; //count pulse

    always @(posedge Clk)
        if (Rst_n) count <= 16'b1;
        else if (Tick) count <= 16'b1;
            else count <= count + 1'b1;
    assign Tick = (count == BaudRate);
endmodule

