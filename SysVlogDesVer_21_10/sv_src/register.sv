module register(output reg [7:0] out,
	input reg [7:0] data,
	input enable,
	input clk,
	input rst_);
	
	timeunit 1ns;
	timeprecision 100ps;
	always_ff @(posedge clk) begin
		if (!rst_) begin
			out <= 8'b0;
		end else if (enable) begin
			out <= data;
		end
	end
	endmodule

