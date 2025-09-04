///////////////////////////////////////////////////////////////////////////
// (c) Copyright 2013 Cadence Design Systems, Inc. All Rights Reserved.
//
// File name   : control.sv
// Title       : Control Module
// Project     : SystemVerilog Training
// Created     : 2013-4-8
// Description : Defines the Control module
// Notes       :
// 
///////////////////////////////////////////////////////////////////////////

// import SystemVerilog package for opcode_t and state_t
import typedefs::*;;

module control  (
                output logic      load_ac ,
                output logic      mem_rd  ,
                output logic      mem_wr  ,
                output logic      inc_pc  ,
                output logic      load_pc ,
                output logic      load_ir ,
                output logic      halt    ,
                input  opcode_t opcode  , // opcode type name must be opcode_t
                input             zero    ,
                input             clk     ,
                input             rst_   
                );
// SystemVerilog: time units and time precision specification
timeunit 1ns;
timeprecision 100ps;


state_t state, next_state;

always_ff @(posedge clk or  negedge rst_) begin
  if (!rst_)
	  state <= INST_ADDR;
  else
	  state <= next_state;
end

always_comb begin
	unique case (state)
		INST_ADDR: begin
			load_ac = 1'b0;
			mem_rd = 1'b0;
			mem_wr = 1'b0;
			inc_pc = 1'b0;
			load_pc = 1'b0;
			load_ir = 1'b0;
			halt = 1'b0;
			next_state = INST_FETCH;
		end

		INST_FETCH: begin
			load_ac = 1'b0;
			mem_rd = 1'b1;
			mem_wr = 1'b0;
			inc_pc = 1'b0;
			load_pc = 1'b0;
			load_ir = 1'b0;
			halt = 1'b0;
			next_state = INST_LOAD;
		end
		INST_LOAD: begin
			load_ac = 1'b0;
			mem_rd = 1'b1;
			mem_wr = 1'b0;
			inc_pc = 1'b0;
			load_pc = 1'b0;
			load_ir = 1'b1;
			halt = 1'b0;
			next_state = IDLE;
		end
		IDLE: begin
			load_ac = 1'b0;
			mem_rd = 1'b1;
			mem_wr = 1'b0;
			inc_pc = 1'b0;
			load_pc = 1'b0;
			load_ir = 1'b1;
			halt = 1'b0;
			next_state = OP_ADDR;
		end
		OP_ADDR: begin
			load_ac = 1'b0;
			mem_rd = 1'b0;
			mem_wr = 1'b0;
			inc_pc = 1'b1;
			load_pc = 1'b0;
			load_ir = 1'b0;
			halt = (opcode === HLT);
			next_state = OP_FETCH;
		end
		OP_FETCH: begin
			load_ac = 1'b0;
			mem_rd = (opcode === ADD) || (opcode === AND) || (opcode === XOR) || (opcode === LDA);
			mem_wr = 1'b0;
			inc_pc = 1'b0;
			load_pc = 1'b0;
			load_ir = 1'b0;
			halt = 1'b0;
			next_state = ALU_OP;
		end
		ALU_OP: begin
			load_ac = (opcode === ADD || opcode === AND || opcode === XOR || opcode === LDA);
			mem_rd = (opcode === ADD || opcode === AND || opcode === XOR || opcode === LDA);
			mem_wr = 1'b0;
			inc_pc = (opcode === SKZ && zero == 1'b1);
			load_pc = (opcode === JMP);
			load_ir = 1'b0;
			halt = 1'b0;
			next_state = STORE;
		end
		STORE: begin
			load_ac = (opcode === ADD || opcode === AND || opcode === XOR || opcode === LDA);
			mem_rd = (opcode === ADD || opcode === AND || opcode === XOR || opcode === LDA);
			mem_wr = (opcode === STO);
			inc_pc = (opcode === JMP);
			load_pc = (opcode === JMP);
			load_ir = 1'b0;
			halt = 1'b0;
			next_state = INST_ADDR;
		end
		default: begin
			load_ac = 1'bx;
			mem_rd = 1'bx;
			mem_wr = 1'bx;
			inc_pc = 1'bx;
			load_pc = 1'bx;
			load_ir = 1'bx;
			halt = 1'bx;
		end
	endcase
end
endmodule
