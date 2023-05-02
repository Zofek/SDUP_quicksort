`timescale 1ns / 1ps

//Lomuto partition scheme
//--------------------------------------------
module partition#(
    parameter ARR_WIDTH = 4)
    (
    input wire [ARR_WIDTH*4-1:0] array_in, 
    input wire 					clock, 
    input wire 					reset,
    input wire [3:0]		    hi_ind,
    input wire [3:0]			lo_ind,
	input wire [0:0]            start,
	
    output reg [ARR_WIDTH*4-1:0] array_out,
    output reg [0:0]            ready,
    output reg [3:0]            pivot_ind
    );
    
//--------------------------------------------	
	reg [3:0] array_out_2d  [ARR_WIDTH-1:0];
    reg [3:0] array_out_2d_nxt [ARR_WIDTH-1:0];
	reg [3:0] pivot_ind_nxt, counter, counter_nxt;
	reg [0:0] ready_nxt;
	reg [0:0] state, state_nxt;
	
// STATE MACHINE -----------------------------
     
    //states
    localparam IDLE               = 1'b0,
               PARTITION_PENDING  = 1'b1;

//seq logic    
//--------------------------------------------
	always @(posedge clock)
	begin
	if (reset)
		begin
		array_out        <= {ARR_WIDTH*4-1{1'b0}};
		array_out_2d[0]  <= 3'b0;
		array_out_2d[1]  <= 3'b0;
		array_out_2d[2]  <= 3'b0;
		array_out_2d[3]  <= 3'b0;
		array_out        <= 0;
		pivot_ind 		 <= 0;
        ready            <= 0;
        counter          <= 0;
        state            <= IDLE;
		end 
	else 
		begin
		array_out_2d[0]  <= array_out_2d_nxt[0];
        array_out_2d[1]  <= array_out_2d_nxt[1];
        array_out_2d[2]  <= array_out_2d_nxt[2];
        array_out_2d[3]  <= array_out_2d_nxt[3];
        array_out[3:0]   <= array_out_2d[3];
        array_out[7:4]   <= array_out_2d[2];
        array_out[11:8]  <= array_out_2d[1];
        array_out[15:12] <= array_out_2d[0];
		pivot_ind 		 <= pivot_ind_nxt;
		ready            <= ready_nxt;
		counter          <= counter_nxt;
		state            <= state_nxt;
		end 
	end 
	
//comb logic
//--------------------------------------------
	always @*
	   
        begin
        
        case (state)
        
        IDLE:
            begin
            array_out_2d[3]      = array_in[3:0];
            array_out_2d[2]      = array_in[7:4];
            array_out_2d[1]      = array_in[11:8];
            array_out_2d[0]      = array_in[15:12];
            array_out_2d_nxt[3]  = array_in[3:0];
            array_out_2d_nxt[2]  = array_in[7:4];
            array_out_2d_nxt[1]  = array_in[11:8];
            array_out_2d_nxt[0]  = array_in[15:12];
            pivot_ind_nxt    = lo_ind - 1;
            ready_nxt        = 1'b0;
            counter_nxt      = 0;
            
            if (start == 1) state_nxt = PARTITION_PENDING;
            else            state_nxt = IDLE;      
            
            end 
        
        PARTITION_PENDING:
            begin
            ready_nxt = 1'b0;
            state_nxt = PARTITION_PENDING;
            if (counter < hi_ind)
                begin
                counter_nxt = counter + 1;
                if (array_out_2d[counter] <= array_out_2d[hi_ind])
                    begin
                    pivot_ind_nxt = pivot_ind + 1;
                    array_out_2d_nxt[pivot_ind_nxt] = array_out_2d[counter];
                    array_out_2d_nxt[counter]       = array_out_2d[pivot_ind_nxt];
                    end 
                end 
            else 
                begin
                pivot_ind_nxt = pivot_ind + 1;
                array_out_2d_nxt[pivot_ind_nxt] = array_out_2d[hi_ind];
                array_out_2d_nxt[hi_ind] = array_out_2d[pivot_ind_nxt];    
                state_nxt = IDLE;
                ready_nxt = 1'b1;
                end
                     
            end 
        
        endcase
        end //always @*

endmodule //partition
