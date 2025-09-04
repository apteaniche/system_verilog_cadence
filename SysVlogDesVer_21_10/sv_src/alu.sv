// Import code_t from typedef package
import typedefs::*;

//timeunit and timeprecision

module alu(
	output logic [7:0] out,
	output logic zero,
	input logic [7:0] accum,
	input logic [7:0] data,
	input opcode_t    opcode,
	input 		  clk
);
timeunit 1ns;
timeprecision 100ps;

always_comb begin
	zero = (accum == 8'b0);
end

always_ff @(negedge clk) begin
	unique case (opcode)
		HLT, SKZ, STO, JMP: out <= accum;
		ADD: out <= data + accum;
		AND: out <= data & accum;
		XOR: out <= data ^ accum;
		LDA: out <= data;
		default: out <= 8'bx;
	endcase
	end
endmodule
