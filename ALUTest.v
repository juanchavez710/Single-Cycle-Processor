`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:06:33 03/02/2009
// Design Name:   ALU 
// Module Name:   E:/home/pi/ECEN_350_Labs/ECEN350_RasPI/Lab07/ALU/ALUTest.v
// Project Name:  ALU
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
module ALUTest_v;

	initial //This initial block used to dump all wire/reg values to dump file
     begin
       $dumpfile("ALUTest.vcd");
       $dumpvars(0,ALUTest_v);
     end

	task passTest;
		input [63:0] BusW, expectedBusW;
	        input Zero, expectedZero;
	   
		input [`STRLEN*8:0] testType;
		inout [7:0] passed;
	
		if((BusW == expectedBusW)&&(Zero == expectedZero)) begin $display ("%s passed", testType); passed = passed + 1; end
		else $display ("%s failed: %d should be %d", testType, BusW, expectedBusW);
	endtask
	
	task allPassed;
		input [7:0] passed;
		input [7:0] numTests;
		
		if(passed == numTests) $display ("All tests passed");
		else $display("Some tests failed");
	endtask // allPassed


   	task stim;
		input [63:0] newBusA;
	   input [63:0]      newBusB;
	        
		input [3:0] newALUCtrl;
		output [63:0] setBusA;
	   output [63:0]      setBusB;
	   
		output [3:0] setALUCtrl;
		
		begin
			#90;
			setBusA = newBusA;
		   setBusB = newBusB;
		   
			setALUCtrl = newALUCtrl;
		end
	endtask

	
	// Inputs
	reg [63:0] BusA,BusB;
	reg [3:0] ALUCtrl;
   reg [7:0] 	  passed;
   

	// Outputs
	wire [63:0] BusW;
	wire Zero;

	// Instantiate the Unit Under Test (UUT)
	ALU uut (
		.BusW(BusW), 
		.BusA(BusA),
		.BusB(BusB),
		.ALUCtrl(ALUCtrl),
		.Zero(Zero)
	);

	initial begin
		// Initialize Inputs
	   BusA = 1;
	   BusB = 1;
	   ALUCtrl = 0;
	   passed = 0;
	   

		// Add stimulus here
	   #90; stim(1,1,0, BusA, BusB, ALUCtrl); #10; passTest(BusW, 1, Zero, 0, "Input 0", passed);
		#90; stim(0,0,1, BusA, BusB, ALUCtrl); #10; passTest(BusW, 0, Zero, 1, "Input 1", passed);
		#90; stim(2,3,2, BusA, BusB, ALUCtrl); #10; passTest(BusW, 5, Zero, 0, "Input 2", passed);
		#90; stim(2,2,6, BusA, BusB, ALUCtrl); #10; passTest(BusW, 0, Zero, 1, "Input 3", passed);
           #90; stim(20,20,7, BusA, BusB, ALUCtrl); #10; passTest(BusW, 20, Zero, 0, "Input 4", passed);
	   #90;
	   
	   
		
		allPassed(passed, 4);

	end
      
endmodule
