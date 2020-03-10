module Shark(
    input clk,
    input rst,
    input Rx,
    output [6:0]seg,
    output [3:0]AN,
    output start,
    output push,
    output dir,
    output led
);

    wire [7:0]RxData, next_num;
    reg [7:0]num;
    wire Rst_n, rst_pb;
    wire [9:0]direction, motor, start_duty;

    debounce a3(rst_pb, rst, clk);
    onepulse a8(rst_pb, clk, Rst_n);
    
    bluetooth t0( clk, Rst_n, Rx, RxData);
    show b1(clk, rst, num, AN, seg);
    control c(clk, num, Rst_n, motor, direction, start_duty, led);
    servo   s0(clk, Rst_n, direction, dir);
    motor   m0(clk, Rst_n, motor, push);
    motor   m1(clk, Rst_n, start_duty, start);

    always@(posedge clk) begin
        if(Rst_n) begin
            num <= 8'd0;
        end else begin
            num <= next_num;
        end
    end
    assign next_num = (RxData != 0)? RxData : num;
endmodule

module motor (
    input clk,
    input reset,
    input [9:0]duty,
	output pmod_1 //PWM
);
        
    PWM_gen pwm_0 ( 
        .clk(clk), 
        .reset(reset), 
        .freq(32'd500),
        .duty(duty), 
        .PWM(pmod_1)
    );

endmodule

module servo (
    input clk,
    input reset,
    input [9:0]duty,
	output pmod_1 //PWM
);
        
    PWM_gen pwm_0 ( 
        .clk(clk), 
        .reset(reset), 
        .freq(32'd50),
        .duty(duty), 
        .PWM(pmod_1)
    );

endmodule

//generte PWM by input frequency & duty
module PWM_gen (
    input wire clk,
    input wire reset,
	input [31:0] freq,
    input [9:0] duty,
    output reg PWM
);
    wire [31:0] count_max = 100_000_000 / freq;
    wire [31:0] count_duty = count_max * duty / 1024;
    reg [31:0] count;
        
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            count <= 0;
            PWM <= 0;
        end else if (count < count_max) begin
            count <= count + 1;
            if(count < count_duty)
                PWM <= 1;
            else
                PWM <= 0;
        end else begin
            count <= 0;
            PWM <= 0;
        end
    end
endmodule

//just for checking
module show(clk, rst_n, num, AN, seg);
    input clk, rst_n;
    input [7:0]num;
    output reg[3:0]AN;
    output reg[6:0]seg;
    wire [7:0]num1, num2, num3;
    reg [1:0]cnt;
    wire dclk;

    clk_div #(13) t(clk, rst_n, dclk);
    display_num d0(num/100, num3);
    display_num d1((num/10)%10, num2);
    display_num d2(num%10, num1);

    always@(posedge dclk) begin
        if(cnt == 2'b10)
            cnt <= 2'b00;
        else
            cnt <= cnt + 1'b1;
    end
    always @(*) begin
        case(cnt)
        2'b00: begin
            AN = 4'b1110;
            seg = num1;
            end
        2'b01: begin
            AN = 4'b1101;
            seg = num2;
            end
        2'b10: begin
            AN = 4'b1011;
            seg = num3;
        end
        default:begin
        end
        endcase
    end
endmodule

module display_num(num, seg);
    input [3:0]num;
    output reg[6:0]seg;

    always@(*) begin
        case(num)
            4'b0000: seg = 7'b0000001; 
            4'b0001: seg = 7'b1001111;
            4'b0010: seg = 7'b0010010;
            4'b0011: seg = 7'b0000110;
            4'b0100: seg = 7'b1001100; 
            4'b0101: seg = 7'b0100100;
            4'b0110: seg = 7'b0100000; 
            4'b0111: seg = 7'b0001111;
            4'b1000: seg = 7'b0000000;
            4'b1001: seg = 7'b0000100;
            default: seg = 7'b0000001;
        endcase
    end
endmodule

module debounce (pb_debounced, pb, clk);
    output pb_debounced; 
    input pb;
    input clk;
    reg [4:0] DFF;
    
    always @(posedge clk) begin
        DFF[4:1] <= DFF[3:0];
        DFF[0] <= pb; 
    end
    assign pb_debounced = (&(DFF)); 
endmodule

module onepulse (PB_debounced, clk, PB_one_pulse);
    input PB_debounced;
    input clk;
    output reg PB_one_pulse;
    reg PB_debounced_delay;

    always @(posedge clk) begin
        PB_one_pulse <= PB_debounced & (! PB_debounced_delay);
        PB_debounced_delay <= PB_debounced;
    end 
endmodule

module clk_div #(parameter n=25)(clk, rst_n, dclk);
    input clk, rst_n;
    output dclk;

    reg [n-1:0]num;
    wire [n-1:0]next_num;

    always@(posedge clk) begin
        num <= next_num;
    end
    assign next_num = num + 1'b1;
    assign dclk = num[n-1];
endmodule