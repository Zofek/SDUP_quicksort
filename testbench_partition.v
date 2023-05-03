`timescale 1ns / 1ps

module tb;
//-------------------------------------------------------
parameter ARR_WIDTH = 4;
//-------------------------------------------------------
reg clk, rst;
reg [3:0] hi_index, lo_index;
reg [0:0] start;
wire [0:0] ready;
wire [3:0] pivot_ind;
reg [ARR_WIDTH*4-1:0] array_in;
wire [ARR_WIDTH*4-1:0] array_out;
//-------------------------------------------------------
partition #(.ARR_WIDTH(ARR_WIDTH)) myPartition
    (
    .array_in(array_in), 
    .clock(clk), 
    .reset(rst),
    .start(start),
    .hi_ind(hi_index),
    .lo_ind(lo_index),
	
	.ready(ready),
	.pivot_ind(pivot_ind),
    .array_out(array_out)
    );  
//-------------------------------------------------------
// clock generation
always
    begin
    clk = 1'b0;
    #5;
    clk = 1'b1;
    #5;
    end
//-------------------------------------------------------
// initial assigns 
initial 
    begin 
    rst = 0;
    #1000;
    rst = 1;
    #1000;
    rst = 0;
    #1000;
    array_in[15:12] = 3'd1; //array = {1,5,0,2}
    array_in[11:8]  = 3'd5;
    array_in[7:4]   = 3'd0; 
    array_in[3:0]   = 3'd2;
    hi_index = 3;
    lo_index = 0;
    #10
    start = 1'b1;
    #20 
    start = 1'b0;
    wait (ready == 1);
    #1000;
    $finish;
    end
   
endmodule
