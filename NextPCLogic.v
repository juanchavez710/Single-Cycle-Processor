`timescale 1ns / 1ps
module NextPCLogic(NextPC, CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch); 
       input [63:0] CurrentPC, SignExtImm64; 
       input Branch, ALUZero, Uncondbranch; 
       output reg [63:0] NextPC; 
       /* write your code here */

   wire 	     Selector;
   wire 	     ZeroANDBranch;
   and and0(ZeroANDBranch, ALUZero, Branch);

   or or0(Selector, ZeroANDBranch, Uncondbranch);

   always @ (Selector) begin
      case(Selector)
	0:
	  NextPC <= #2 CurrentPC + 4;
	1:
	  NextPC <= #3 CurrentPC + SignExtImm64;
       
      endcase // case (Selector)
   end
   
   
endmodule
