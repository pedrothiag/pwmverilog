`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   23:11:39 04/03/2021
// Design Name:   pwm
// Module Name:   C:/Users/souza/Desktop/pwm/pwm/pwm_tb.v
// Project Name:  pwm
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: pwm
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module pwm_tb;

	// Inputs
	reg clk;
	reg rst;
	reg enable;
	reg [7:0] cycle_on;
	reg [7:0] period;
	reg [1:0] pre;

	// Outputs
	wire pwmout;

	// Instantiate the Unit Under Test (UUT)
	pwm uut (
		.clk(clk), 
		.rst(rst), 
		.enable(enable), 
		.cycle_on(cycle_on), 
		.period(period), 
		.pre(pre), 
		.pwmout(pwmout)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		enable = 1;
		cycle_on = 150;
		period = 200;
		pre = 2'b00;
		
		#10
		rst = 1;

		#200000
		$stop;

	end
	
	always begin
		#5 clk = ~clk;
	end
      
endmodule

