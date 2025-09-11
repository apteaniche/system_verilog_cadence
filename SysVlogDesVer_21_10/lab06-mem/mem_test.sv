///////////////////////////////////////////////////////////////////////////
// (c) Copyright 2013 Cadence Design Systems, Inc. All Rights Reserved.
//
// File name   : mem_test.sv
// Title       : Memory Testbench Module
// Project     : SystemVerilog Training
// Created     : 2013-4-8
// Description : Defines the Memory testbench module
// Notes       :
// 
///////////////////////////////////////////////////////////////////////////

module mem_test ( input logic clk, 
                  output logic read, 
                  output logic write, 
                  output logic [4:0] addr, 
                  output logic [7:0] data_in,     // data TO memory
                  input  wire [7:0] data_out     // data FROM memory
                );
// SYSTEMVERILOG: timeunit and timeprecision specification
timeunit 1ns;
timeprecision 1ns;

// SYSTEMVERILOG: new data types - bit ,logic
bit         debug = 1;
logic [7:0] rdata;      // stores data read from memory for checking

// Monitor Results
  initial begin
      $timeformat ( -9, 0, " ns", 9 );
// SYSTEMVERILOG: Time Literals
      #40000ns $display ( "MEMORY TEST TIMEOUT" );
      $finish;
    end

initial
  begin: memtest
  int error_status;

    $display("Clear Memory Test");

    for (int i = 0; i< 32; i++)
       // Write zero data to every address location
       write_mem(.debug(debug), .address(i), .write_data('0));

    for (int i = 0; i<32; i++)
      begin 
       // Read every address location
       read_mem(.debug(debug), .address(i), .read_data(rdata));

       // check each memory location for data = 'h00
       if (rdata !== '0) begin
	       error_status++;
       end


      end

   // print results of test
   printstatus(error_status);

   error_status = 0;
    $display("Data = Address Test");

    for (int i = 0; i< 32; i++)
       // Write data = address to every address location
       write_mem(.debug(debug), .address(i), .write_data(i));
       
    for (int i = 0; i<32; i++)
      begin
       // Read every address location
       read_mem(.debug(debug), .address(i), .read_data(rdata));

       // check each memory location for data = address
       if (rdata !== i) begin
	       error_status++;
       end

      end

   // print results of test
   printstatus(error_status);

    $finish;
  end

// add read_mem and write_mem tasks
task write_mem (
	input bit debug = 0,
	input logic [7:0] write_data,
	input logic [4:0] address);

	data_in = write_data;
	addr = address;
	@ (negedge clk)
	read = 1'b0;
	write = 1'b1;
	@ (negedge clk)
	write = 1'b0;
	if (debug) begin
		$display("WRITE addr=%0d data=%0h", address, write_data);
	end
endtask: write_mem

task read_mem(
	input bit debug = 0,
	input logic [4:0] address,
	output logic [7:0] read_data);

	addr = address;
	@(negedge clk)
	write = 1'b0; read = 1'b1;
	@(posedge clk)
	#1 read_data = data_out;
	@(negedge clk) read = 1'b0;
	if (debug) begin
		$display("READ addr=%0d data=%0h", address, read_data);
	end
endtask: read_mem



// add result print function
function void printstatus (
	input int status);
	
	if (status == 0) $display("TEST PASSED");
	else $display("TEST FAILED");
endfunction: printstatus

endmodule
