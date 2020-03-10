module bluetooth(Clk, Rst_n, Rx, RxData);
	input           Clk, Rst_n;
	input           Rx;
	output [7:0]    RxData; 

	wire          	RxDone;
	wire            tick; 	// Baud rate
	wire [3:0]      NBits;
	wire [15:0]    	BaudRate;

	//explain at BaudRate_gen
	assign 		BaudRate = 16'd650;
	assign 		NBits = 4'b1000;

	//read data
	UART_rx rx(
			.clk(Clk),
			.Rst_n(Rst_n),
			.RxData(RxData),
			.RxDone(RxDone),
			.Rx(Rx),
			.tick(tick),
			.NBits(NBits)
		);

	//generte tick & give to UART_rx
	BaudRate_gen gen(
			.Clk(Clk),
			.Rst_n(Rst_n),
			.Tick(tick),
			.BaudRate(BaudRate)
		);
endmodule
