`timescale 1ns / 1ps

//--------------------------------------------
module quicksort#(
    parameter ARR_WIDTH = 5)
    (
    input wire [ARR_WIDTH-1:0] array_in, 
    input wire clock, 
    input wire reset,
    input wire start,
    input wire hi_ind,
    input wire lo_ind,
	
	output reg [0:0] array_valid,
    output reg [ARR_WIDTH-1:0] array_out
    );
    
//--------------------------------------------    
reg [ARR_WIDTH-1:0] part_arr_nxt, part_arr_out_nxt;
wire [ARR_WIDTH-1:0] part_arr, part_arr_out;
reg curr_pivot_nxt,  temp_ctr_nxt, index_nxt, pivot_nxt, hi_ind_part, lo_ind_part, hi_ind_part_nxt, lo_ind_part_nxt;
wire curr_pivot, temp_ctr, index, pivot;
reg [0:0] valid, valid_nxt, left_vld, right_vld, left_vld_nxt, right_vld_nxt;
reg [0:0] part_done, part_done_nxt;

//--------------------------------------------
    partition #(.ARR_WIDTH(5)) my_partition
    (
        .array_in(part_arr),
        .clock(clock), 
        .reset(reset),
        .hi_ind(hi_ind_part),
        .lo_ind(lo_ind_part),
        .curr_pivot(curr_pivot),
        .valid(valid), //defines whether to perform partition
        .index_in(index),
        .temp_ctr_in(temp_ctr),
        
        .array_out(part_arr_out),
        .pivot(curr_pivot),
        .part_done(part_done),
        .index_out(index),
        .temp_ctr_out(temp_ctr)
    );
        
//curr_pivot <= pivot;
// STATE MACHINE -----------------------------
 
//states
localparam INIT  = 2'b00,
           LEFT  = 2'b01,
           RIGHT = 2'b10,
           PARTITION  = 2'b11;

reg [2:0] state, state_nxt;
	
//seq logic
//--------------------------------------------
	always @(posedge clock)
	begin
	if (reset)
        begin
        part_arr_nxt     <= {ARR_WIDTH{1'b0}};
        pivot 		    <= 0;
        pivot_nxt       <= 0;
        valid           <= 1'b0;
        valid_nxt       <= 1'b0;
        part_done       <= 1'b0;
        part_done_nxt   <= 1'b0;
        state           <= INIT;
        state_nxt       <= INIT;
        hi_ind_part     <= 0;
        hi_ind_part_nxt <= 0;
        lo_ind_part     <= 0;
        lo_ind_part_nxt <= 0;
        index           <= 0;
        index_nxt       <= 0;
        temp_ctr_nxt    <= 0;
        temp_ctr        <= 0;
        end //end if
	else 
		begin
        pivot 		  <= pivot_nxt;
        valid         <= valid_nxt;
        state         <= state_nxt;
        part_done     <= part_done_nxt;
        index         <= index_nxt;
        temp_ctr      <= temp_ctr_nxt;
		end //end else
	end
//comb logic	   
//--------------------------------------------	
	always @*
        begin
        left_vld_nxt  = 0;
        right_vld_nxt = 0;
        //--------------------------------------------
        case (state)
        //-------------------
           INIT:
               begin
               
               valid_nxt = 0;
               state_nxt = INIT;
               
               if ((lo_ind >= hi_ind) || (lo_ind < 0)) valid_nxt = 1;
               if (part_done == 1) state_nxt = LEFT;
               
               end
           //-------------------    
           LEFT: //left side of pivot
               begin
       
               valid_nxt = 0;
               state_nxt = LEFT;
                
               if ((lo_ind >= hi_ind) || (lo_ind < 0)) 
                   begin 
                   left_vld_nxt = 1;
                   lo_ind_part_nxt = lo_ind;
                   hi_ind_part_nxt = pivot_nxt - 1;
                   end 
               end   
           //-------------------    
           RIGHT: //right side of pivot
               begin
   
               valid_nxt = 0;
               state_nxt = RIGHT;
                
               if ((lo_ind >= hi_ind) || (lo_ind < 0)) right_vld_nxt = 1;
               lo_ind_part_nxt = pivot_nxt + 1;
               hi_ind_part_nxt = hi_ind;
        
               end 
           //-------------------    
           PARTITION:
               begin
               //
               end   
                
        endcase
        end
	
//--------------------------------------------	
 //assign array_valid = right_vld && left_vld;
assign part_arr = part_arr_out; 
endmodule //quicksort_algorithm
