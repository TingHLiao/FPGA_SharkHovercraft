module UART_rx (clk, Rst_n, RxData, RxDone, Rx, tick, NBits);
input clk, Rst_n, Rx, tick;	
input [3:0]NBits;

output RxDone;
output reg [7:0]RxData;

parameter  IDLE = 1'b0, READ = 1'b1; 	//2 states
reg  State, Next;
reg  start_bit = 1'b1, next_start;		//notify start bit detected
reg  RxDone, next_done;	
reg [4:0]bit, next_bit;					//count read bit
reg [3:0]count, next_count;				//count tick
reg [7:0]read_data, next_data;

always @ (State or Rx or RxDone) begin
    case(State)	
	IDLE:	if(!Rx)	Next = READ;	 		//Rx low (Start bit detected)
			else			Next = IDLE;
	READ:	if(RxDone)		Next = IDLE; 	//RxDone, back to IDLE
			else			Next = READ;
	default 		Next = IDLE;
    endcase
end

always @(posedge clk) begin
	//initialize
	if(Rst_n) begin
		State <= IDLE;
		start_bit <= 1;
		count <= 0;
		bit <= 0;
		RxDone <= 0;
		read_data <= 0;
	end else begin
		State <= Next;
		start_bit <= next_start;
		count <= next_count;
		bit <= next_bit;
		RxDone <= next_done;
		read_data <= next_data;
	end
end

always @ (*) begin
	case(State)
		READ: begin
			if(tick) next_count = count + 1;
			else next_count = count;
			next_start = start_bit;
			next_bit = bit;
			next_done = 0;
			next_data = read_data;

			//middle of start
			if ((count == 4'b1000) && start_bit)begin	
				next_start = 1'b0;
				next_count = 4'b0000;
			end

			//read at middle of transition
			//8 loops for 8 bits
			if ((count == 4'b1111) && (bit < NBits) && tick) begin
				next_count = 4'b0000;
				next_bit = bit+1;
				next_data = {Rx,read_data[7:1]};
			end

			//finish reading & detect the stop bit(high)
			if ((count == 4'b1111) && (bit == NBits) && (Rx)) begin
				next_count = 4'b0000;
				next_bit = 5'b00000;
				next_done = 1'b1;
				next_start = 1'b1;
			end
			default: begin
				next_count = count;
				next_start = start_bit;
				next_bit = bit;
				next_done = RxDone;
				next_data = read_data;
			end
		end
	endcase
end

//give value to RxData while done reading
always @ (posedge clk) begin
	if (RxDone) begin
		RxData[7:0] <= read_data[7:0];	
	end else begin
		RxData[7:0] <= 8'd0;	
	end
end

endmodule

