`timescale 1ns / 1ps

//--------------------------------------------
module quicksort#(
    parameter ARR_WIDTH = 4)
    (
    input wire [ARR_WIDTH*4-1:0] array_in, 
    input wire clock, 
    input wire reset,
    input wire [0:0] enable,
    input wire [3:0] hi_ind,
    input wire [3:0 ]lo_ind,
	
	output reg [0:0] array_valid,
    output reg [ARR_WIDTH*4-1:0] sorted_array
    );

//--------------------------------------------    
reg  [0:0] start, start_nxt, idle_aux, idle_aux_nxt, left_valid_nxt, left_valid, right_valid_nxt, right_valid;
wire [0:0] part_valid;
wire [ARR_WIDTH*4-1:0] array_out;
reg  [ARR_WIDTH*4-1:0] sorted_array_nxt;
reg [3:0] hi_ind_part, hi_ind_part_nxt, 
          lo_ind_part, lo_ind_part_nxt;
wire [3:0] pivot_ind;
reg  [3:0] curr_pivot, curr_pivot_nxt;
//--------------------------------------------
    partition #(.ARR_WIDTH(4)) my_partition
    (
        .array_in(sorted_array),
        .clock(clock), 
        .reset(reset),
        .hi_ind(hi_ind_part),
        .lo_ind(lo_ind_part),
        .start(start),
        .pivot_ind_in(curr_pivot),
        
        .array_out(array_out),
        .part_valid(part_valid),
        .pivot_ind_out(pivot_ind)
    );

// STATE MACHINE -----------------------------
 
//states
localparam INIT         = 3'b000,
           IDLE_INIT    = 3'b001,
           LEFT         = 3'b010,
           IDLE_LEFT    = 3'b011,
           RIGHT        = 3'b100,
           IDLE_RIGHT   = 3'b101;
           

reg [2:0] state, state_nxt;
	
//seq logic
//--------------------------------------------
	always @(posedge clock)
	begin
	if (reset)
        begin
        sorted_array <= {ARR_WIDTH*4-1{1'b0}};
        start       <= 1'b0;
        state       <= INIT;
        idle_aux    <= 1'b1;
        array_valid <= 1'b0;
        lo_ind_part <= 4'b0;
        hi_ind_part <= 4'b0;
        right_valid <= 1'b0;
        left_valid  <= 1'b0;
        curr_pivot  <= 4'b0;
        end //end if
	else 
		begin
        sorted_array <= sorted_array_nxt;
        state        <= state_nxt;
        start        <= start_nxt;
        idle_aux     <= idle_aux_nxt;
        array_valid  <= left_valid_nxt && right_valid_nxt;
        lo_ind_part  <= lo_ind_part_nxt;
        hi_ind_part  <= hi_ind_part_nxt;
        curr_pivot   <= curr_pivot_nxt;
		end //end else
	end
	
//comb logic	   
//--------------------------------------------	
	always @*
    begin

    //--------------------------------------------
    case (state)
    //-------------------
        //-------------------    
        INIT:
            begin
            state_nxt       = INIT;
            left_valid_nxt = 1'b0;
            right_valid_nxt = 1'b0;
            start_nxt       = 1'b0;
            idle_aux_nxt    = 1'b1;
            sorted_array_nxt   = array_in;
            lo_ind_part_nxt = lo_ind;
            hi_ind_part_nxt = hi_ind;
            if (1 == enable) state_nxt = IDLE_INIT;
            end
            
       //------------------- 
       IDLE_INIT:
           begin
           if (lo_ind_part >= hi_ind_part || lo_ind_part < 0 )
               begin
               left_valid_nxt = 1'b1;
               right_valid_nxt = 1'b1;
               state_nxt = INIT;
               end
           else
               begin
               state_nxt = IDLE_INIT;
               if(1 == idle_aux) 
                    begin
                    start_nxt = 1'b1;
                    idle_aux_nxt = 1'b0;
                    end
               else 
                   begin
                   start_nxt = 1'b0;
                   if (1 == part_valid)
                       begin
                       state_nxt = LEFT;
                       idle_aux_nxt = 1'b1;
                       sorted_array_nxt = array_out;
                       curr_pivot_nxt = pivot_ind;
                       end
                   end
               end
           end
           
       //-------------------    
       LEFT: //left side of pivot
           begin
           if (curr_pivot == 0) hi_ind_part_nxt = 0;
           else hi_ind_part_nxt = curr_pivot - 1;
           lo_ind_part_nxt = lo_ind; //lo_ind_part;
           state_nxt       = IDLE_LEFT;
           end   
           
       //-------------------    
       IDLE_LEFT: //right side of pivot
           begin
           if (lo_ind_part >= hi_ind_part || lo_ind_part < 0 )
               begin
               state_nxt = RIGHT;
               end
           else
               begin
               state_nxt = IDLE_LEFT;
               if(1 == idle_aux) 
                    begin
                    start_nxt = 1'b1;
                    idle_aux_nxt = 1'b0;
                    end
               else 
                   begin
                   start_nxt = 1'b0;
                   if (1 == part_valid)
                       begin
                       state_nxt = LEFT;
                       idle_aux_nxt = 1'b1;
                       sorted_array_nxt = array_out;
                       curr_pivot_nxt = pivot_ind;
                       left_valid_nxt = 1'b1;
                       end
                   end
               end
           end 
           
       //-------------------    
       RIGHT: //left side of pivot
           begin
           hi_ind_part_nxt = hi_ind; //hi_ind_part; 
           lo_ind_part_nxt = curr_pivot + 1;
           state_nxt       = IDLE_RIGHT;
           end
       //-------------------    
       IDLE_RIGHT: //right side of pivot
           begin
           if (lo_ind_part >= hi_ind_part || lo_ind_part < 0 )
               begin
               right_valid_nxt = 1'b1;
               state_nxt = INIT;
               end
           else
               begin
               state_nxt = IDLE_RIGHT;
               if(1 == idle_aux) 
                    begin
                    start_nxt = 1'b1;
                    idle_aux_nxt = 1'b0;
                    end
               else 
                   begin
                   start_nxt = 1'b0;
                   if (1 == part_valid)
                       begin
                       right_valid_nxt = 1'b1;
                       state_nxt = LEFT;
                       idle_aux_nxt = 1'b1;
                       sorted_array_nxt = array_out;
                       curr_pivot_nxt = pivot_ind;
                       end
                   end
               end
           end 
    endcase
    end

//--------------------------------------------	
    
endmodule //quicksort_algorithm
