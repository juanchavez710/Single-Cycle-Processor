`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:06:33 03/02/2009
// Design Name:   Decode24
// Module Name:   E:/350/ECEN_350_Labs/ECEN350_RasPI/Lab07/SignExtender/SignExt.v
// Project Name:  SignExt
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Decode24
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

`define STRLEN 15
module SignExtTest_v;

	initial //This initial block used to dump all wire/reg values to dump file
     begin
       $dumpfile("SignExt.vcd");
       $dumpvars(0,SignExtTest_v);
     end

	task passTest;
		input [63:0] actualOut, expectedOut;
		input [`STRLEN*8:0] testType;
		inout [7:0] passed;
	
		if(actualOut == expectedOut) begin $display ("%s passed", testType); passed = passed + 1; end
		else $display ("%s failed: %d should be %d", testType, actualOut, expectedOut);
	endtask
	
	task allPassed;
		input [7:0] passed;
		input [7:0] numTests;
		
		if(passed == numTests) $display ("All tests passed");
		else $display("Some tests failed");
	endtask // allPassed

   	task stim;
		input [25:0] newImm;
		input [1:0] newCtrl;
		output [25:0] setImm;
		output [1:0] setCtrl;
		
		begin
			#90;
			setImm = newImm;
			setCtrl = newCtrl;
		end
	endtask
	
	// Inputs
	reg [25:0] Imm;
        reg [1:0] Ctrl;
	reg [7:0] passed;

	// Outputs
	wire [63:0] BusImm;
        wire [63:0] I = {52'b0,Imm[21:10]};
        wire [63:0] D = {{55{Imm[20]}}, Imm[20:12]};
        wire [63:0] B = {{36{Imm[25]}}, Imm[25:0], 2'b0};
        wire [63:0] CBZ = {{43{Imm[23]}}, Imm[23:5], 2'b0};
        wire [25:0] test = 26'b10101010101010101010101010;
   

	// Instantiate the Unit Under Test (UUT)
	SignExtender uut (
		.BusImm(BusImm), 
		.Imm(Imm),
		.Ctrl(Ctrl)     
	);

	initial begin
		// Initialize Inputs
		Imm = 0;
	        Ctrl = 0;
		passed = 0;


		// Add stimulus here
	   stim(test, 2'b00, Imm, Ctrl); #10; passTest(BusImm, I, "Input 0", passed);
	   stim(test, 2'b01, Imm, Ctrl); #10; passTest(BusImm, D, "Input 1", passed);
	   stim(test, 2'b10, Imm, Ctrl); #10; passTest(BusImm, B, "Input 2", passed);
	   stim(test, 2'b11, Imm, Ctrl); #10; passTest(BusImm, CBZ, "Input 3", passed);
		#90;
		
		allPassed(passed, 4);

	end
      
endmodule

