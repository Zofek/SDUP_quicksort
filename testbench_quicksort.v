`timescale 1ns / 1ps

module testbench;

//-------------------------------------------------------
parameter ARR_WIDTH = 4;
//-------------------------------------------------------
reg clk, rst;
wire [0:0] valid;
reg  [0:0] enable; 
reg [ARR_WIDTH*4-1:0] array_1d;
wire [ARR_WIDTH*4-1:0] array_1d_out;
reg  [3:0] ind_hi, ind_lo;
//-------------------------------------------------------
quicksort #(.ARR_WIDTH(ARR_WIDTH)) myQuicksort
    (
    .array_in(array_1d), 
    .clock(clk), 
    .reset(rst),
    .enable(enable),
    .hi_ind(ind_hi),
    .lo_ind(ind_lo),
	  
	.array_valid(valid),
    .sorted_array(array_1d_out)
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

integer i_0;
integer i_1;
integer i_2;
integer i_3;
integer count = 0;
// initial assigns 
initial 
    begin 
    rst = 0;
    #1000;
    rst = 1;
    #1000;
    rst = 0;
    #1000;
    ind_hi = 3;
    ind_lo = 0;
    for (i_0 = 0 ; i_0 < 8 ; i_0 = i_0 + 1)
        begin
        for (i_1 = 0 ; i_1 < 8 ; i_1 = i_1 + 1)
            begin
            for (i_2 = 0 ; i_2 < 8 ; i_2 = i_2 + 1)
                begin
                for (i_3 = 0 ; i_3 < 8 ; i_3 = i_3 + 1)
                    begin
                    array_1d[15:12] = i_0;
                    array_1d[11:8]  = i_1;
                    array_1d[7:4]   = i_2; 
                    array_1d[3:0]   = i_3;
                    enable = 1'b1;
                    wait (valid == 1);
                    //$display("%x",array_1d_out);
                    if (array_1d_out[15:12] <= array_1d_out[11:8] && array_1d_out[11:8]  <= array_1d_out[7:4] && array_1d_out[7:4] <= array_1d_out[3:0]) ;//$display("PASSED");
                    else 
                        begin
                        $display("%x", array_1d);
                        $display("%x",array_1d_out);
                        $display("FAILED");
                        count = count + 1;
                        //$finish;
                        end
                    enable = 1'b0;
                    #20;
                    end
                end
            end
        end
    //array_1d[15:12] = 3'd0; //array = {1,5,0,2}
    //array_1d[11:8]  = 3'd0;
    //array_1d[7:4]   = 3'd1; 
    //array_1d[3:0]   = 3'd0;
    //ind_hi = 3;
    //ind_lo = 0;
    //enable = 1'b1;
    //wait (valid == 1);
    //enable = 1'b0;
    //#10;
    $display("Count: %d", count);
    $finish;
    end
endmodule
