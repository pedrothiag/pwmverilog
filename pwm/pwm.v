/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* pwm (top-level)
* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
module pwm(clk, rst, enable, cycle_on, period, pre, pwmout);
	input clk, rst, enable;
	input [7:0] cycle_on, period;
	input [1:0] pre;
	output pwmout;
	
	wire clkw;

	prescaler	u0	(clk, rst, pre, clkw);
	basic_pwm	u1 (clkw, rst, enable, cycle_on, period, pwmout);
	
endmodule 
 
/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 * prescaler
 * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
module prescaler(clk, rst, presel, clkout);
	input clk, rst;
	input [1:0] presel;
	output reg clkout;

	wire clk4w, clk16w, clk32w;
	
	clockdivider	u0	(clk, rst, clk4w, clk16w, clk32w);
	
	always @* begin
		case(presel)
			2'b00	  :  clkout = clk;
			2'b01   :  clkout = clk4w;
			2'b10   :  clkout = clk16w;
			2'b11   :  clkout = clk32w;
			default :  clkout = clk;
		endcase
	end
endmodule
 
/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 * clockdivider
 * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
module clockdivider(clk, rst, clk4, clk16, clk32);
	input clk, rst;
	output reg clk4, clk16, clk32;
	
	reg [3:0] counter4, counter16, counter32;
	
	always @(posedge clk, negedge rst) begin
		if(~rst) begin
			clk4 <= 1'b0;
			clk16 <= 1'b0;
			clk32 <= 1'b0;
			counter4 <= 4'b0;
			counter16 <= 4'b0;
			counter32 <= 4'b0;
		end
		
		else begin
			counter4 <= counter4 + 4'b1;
			if(counter4 == 4'd1) begin
				counter4 <= 4'd0;
				clk4 <= ~clk4;
			end
			counter16 <= counter16 + 4'b1;
			if(counter16 == 4'd7) begin
				counter16 <= 4'd0;
				clk16 <= ~clk16;
			end
			counter32 <= counter32 + 4'b1;
			if(counter32 == 4'd15) begin
				counter32 <= 4'd0;
				clk32 <= ~clk32;
			end
		end
	end
endmodule 
 
/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 * basic_pwm
 * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
module basic_pwm(clk, rst, enable, cycle_on, period, pwmout);
	input clk, rst, enable;
	input [7:0] cycle_on, period;
	output reg pwmout;
	
	reg [7:0] counter;

	wire [7:0] cycleoff;
	assign cycleoff = period - cycle_on - 1;
	
	always @(posedge clk, negedge rst) begin
		if(~rst) begin
			pwmout <= 1'b0;
			counter <= 8'd0;
		end
		
		else if(enable) begin
			counter <= counter + 8'd1;

			if(cycle_on >= period) pwmout <= 1'b1;
			
			else if(counter == cycleoff) pwmout <= 1'b1;
			
			else if(counter == period) begin
				pwmout <= 1'b0;
				counter <= 8'd0;
			end
		end
		
		else begin
			counter <= 8'd0;
			pwmout <= 1'b0;
		end
	end
endmodule 