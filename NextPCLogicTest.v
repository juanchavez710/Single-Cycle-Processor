`timescale 1ns / 1ps

`define STRLEN 15
module NextPCLogicTest_v;
   	initial //This initial block used to dump all wire/reg values to dump file
     begin
       $dumpfile("NextPCLogic.vcd");
       $dumpvars(0,NextPCLogicTest_v);
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
	        input [63:0] setCurrentPC;
		input [63:0] setSignExtImm64;
	        input setBranch;
	        input setALUZero;
                input setUncondbranch;
       	        output [63:0] newCurrentPC;
                output [63:0] newSignExtImm64;
	        output newBranch;
	        output newALUZero;
	        output newUncondbranch;
		
		begin
			#90;
		   newCurrentPC = setCurrentPC;
		   newSignExtImm64 = setSignExtImm64;
		   newBranch = setBranch;
		   newALUZero = setALUZero;
		   newUncondbranch = setUncondbranch;
		end
	endtask

        // Inputs
   reg [63:0] CurrentPC, SignExtImm64;
   reg Branch, ALUZero, Uncondbranch;
   reg [7:0] passed;
   
   
   //Outputs
   wire [63:0] NextPC;

   //test wires

   //insantiate UUT
   NextPCLogic uut(
	           .NextPC(NextPC),
		   .CurrentPC(CurrentPC),
		   .SignExtImm64(SignExtImm64),
		   .Branch(Branch),
		   .ALUZero(ALUZero),
		   .Uncondbranch(Uncondbranch)
		   );
   initial begin
      //initialize input
      CurrentPC = 0;
      SignExtImm64 = 0;
      Branch = 0;
      ALUZero = 0;
      Uncondbranch = 0;

      passed = 0;

      stim(0, 4, 0, 0, 0, CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch);
      #10;
      $display("%d, %d, %d, %d, %d, %d",CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch, NextPC);
      passTest(NextPC, 4, "Input 0", passed);
      stim(0, 16, 0, 1, 1, CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch);
      
      #10
      ;$display("%d, %d, %d, %d, %d, %d",CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch, NextPC);
      passTest(NextPC, 16, "Input 1", passed); 
      #90;

      allPassed(passed,2);
      

      end // initial begin
endmodule
	  
