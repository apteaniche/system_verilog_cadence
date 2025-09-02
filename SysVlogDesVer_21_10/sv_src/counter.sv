module counter (
	output logic [4:0] count,
	input logic [4:0] data,
	input enable,
	input clk,
	input load,
	input rst_);

timeunit 1ns;
timeprecision 100ps;

always_ff @(posedge clk or negedge rst_) begin
	if (!rst_) begin
		count <= 5'b0;
	end
	else if (load) begin
		count <= data;
	end
	else if (enable) begin
		count <= count + 1;
	end
end
endmodule
