`timescale 1ns / 1 ps

module SignExtender(BusImm, Imm, Ctrl); 
  output reg [63:0]  BusImm; 
  input [25:0] Imm; 
  input [1:0] Ctrl; 

  //wire extBit = 1'b0; 
  //assign #1 extBit = (Ctrl ? 1'b0 : Imm16[15]); 
  //assign BusImm = {{16{extBit}}, Imm16};

  //00: I-type, 01: D-type, 10: B, 11: CBZ
  always @ (*)
  begin
     case(Ctrl)
       0 : BusImm #1 <= {52'b0,Imm[21:10]};
       1 : BusImm #1 <= {{55{Imm[20]}},Imm[20:12]};
       2 : BusImm #1 <= {{36{Imm[25]}},Imm[25:0],2'b0};
       3 : BusImm #1 <= {{43{Imm[23]}},Imm[23:5],2'b0};
     endcase // case (Ctrl)
  end

 

endmodule
