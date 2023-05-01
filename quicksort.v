`timescale 1ns / 1ps

//--------------------------------------------
module quicksort#(
    parameter ARR_WIDTH = 4)
    (
    input wire [ARR_WIDTH*4-1:0] array_in, 
    input wire clock, 
    input wire reset,
    input wire start,
    input wire hi_ind,
    input wire lo_ind,
	
	output wire [0:0] array_valid,
    output wire [ARR_WIDTH*4-1:0] array_out
    );

//--------------------------------------------    
reg [ARR_WIDTH*4-1:0] part_arr, part_arr_nxt;
reg curr_pivot, temp_ctr, index, 
    hi_ind_part, lo_ind_part, 
    hi_ind_part_nxt, lo_ind_part_nxt;
wire curr_pivot_nxt, temp_ctr_nxt, index_nxt;
reg [0:0] left_vld, left_vld_nxt,
          right_vld, right_vld_nxt;
reg [1:0] part_status, part_status_nxt;
//--------------------------------------------
    partition #(.ARR_WIDTH(4)) my_partition
    (
        .array_in(part_arr),
        .clock(clock), 
        .reset(reset),
        .hi_ind(hi_ind_part),
        .lo_ind(lo_ind_part),
        .curr_pivot(curr_pivot),
        .part_status_in(part_status), //defines whether to perform partition
        .index_in(index),
        .temp_ctr_in(temp_ctr),
        
        .array_out(part_arr),
        .pivot(curr_pivot_nxt),
        .part_status_out(part_status),
        .index_out(index_nxt),
        .temp_ctr_out(temp_ctr_nxt)
    );
 //test comment       
//curr_pivot <= pivot;
// STATE MACHINE -----------------------------
 
//states
localparam IDLE  = 2'b00,
           LEFT  = 2'b01,
           RIGHT = 2'b10,
           INIT  = 2'b11;

reg [2:0] state, state_nxt;
	
//seq logic
//--------------------------------------------
	always @(posedge clock)
	begin
	if (reset)
        begin
        part_arr        <= {ARR_WIDTH*4{1'b0}};
        curr_pivot      <= 0;
        part_status     <= 0;
        state           <= INIT;
        hi_ind_part     <= 0;
        lo_ind_part     <= 0;
        index           <= 0;
        temp_ctr        <= 0;
        end //end if
	else 
		begin
		part_arr      <= part_arr_nxt;
		hi_ind_part   <= hi_ind_part_nxt;
		lo_ind_part   <= lo_ind_part_nxt;
        curr_pivot    <= curr_pivot_nxt;
        state         <= state_nxt;
        index         <= index_nxt;
        temp_ctr      <= temp_ctr_nxt;
        part_status   <= part_status_nxt;
		end //end else
	end
	
//comb logic	   
//--------------------------------------------	
	always @*
        begin
        left_vld_nxt  = 0;
        right_vld_nxt = 0;
        //curr_pivot_nxt = 1;
        //--------------------------------------------
        case (state)
        //-------------------
           INIT:
               begin
               /*
               valid_nxt = 0;
               state_nxt = INIT;
               //TO DO initialize curr_pivot as pivot = arr_in[hi]
               //TO DO initialize index = lo_ind - 1 
               if ((lo_ind >= hi_ind) || (lo_ind < 0)) valid_nxt = 1;
               if (part_done == 1) state_nxt = LEFT;
               */
               end
           //-------------------    
           LEFT: //left side of pivot
               begin
               /*
               valid_nxt = 0;
               state_nxt = LEFT;
                
               if ((lo_ind >= hi_ind) || (lo_ind < 0)) 
                   begin 
                   left_vld_nxt = 1;
                   lo_ind_part_nxt = lo_ind;
                   hi_ind_part_nxt = curr_pivot - 1;
                   end 
               */
               end   
           //-------------------    
           RIGHT: //right side of pivot
               begin
               /*
               valid_nxt = 0;
               state_nxt = RIGHT;
                
               if ((lo_ind >= hi_ind) || (lo_ind < 0)) right_vld_nxt = 1;
               lo_ind_part_nxt = curr_pivot + 1;
               hi_ind_part_nxt = hi_ind;
               */
               end 
           //-------------------    
           IDLE:
               begin
               //
               end
        endcase
        end
	
//--------------------------------------------	
assign array_valid = right_vld && left_vld;
assign array_out   = part_arr;
    
endmodule //quicksort_algorithm
