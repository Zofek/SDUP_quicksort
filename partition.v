`timescale 1ns / 1ps

//Lomuto partition scheme
//--------------------------------------------
module partition#(
    parameter ARR_WIDTH = 4)
    (
    input wire [ARR_WIDTH*4-1:0] array_in, 
    input wire 					clock, 
    input wire 					reset,
    input wire 					hi_ind,
    input wire 					lo_ind,
    input wire                  curr_pivot,
	input wire [0:0]            start,
	input wire                  index_in,
	input wire                  temp_ctr_in, 
	
    output reg [ARR_WIDTH*4-1:0] array_out,
    output reg 				    pivot,
    output reg [0:0]            ready,
    output reg                  index_out,
    output reg                  temp_ctr_out
    );
    
//--------------------------------------------	
	reg [3:0] array_out_nxt [ARR_WIDTH*4-1:0];
	reg pivot_nxt, ind_out_nxt, temp_ctr_out_nxt;
	reg [0:0] ready_nxt;
	reg [1:0] state, state_nxt;
	
// STATE MACHINE -----------------------------
     
    //states
    localparam IDLE               = 2'b01,
               PARTITION_PENDING  = 2'b10;

//seq logic    
//--------------------------------------------
	always @(posedge clock)
	begin
	if (reset)
		begin
		array_out     <= {ARR_WIDTH*4-1{1'b0}};
		array_out_nxt[0] <= 3'b0;
		array_out_nxt[1] <= 3'b0;
		array_out_nxt[2] <= 3'b0;
		array_out_nxt[3] <= 3'b0;
		array_out        <= 0;
		pivot 		     <= 0;
		index_out        <= 0;
        temp_ctr_out     <= 0;
        ready            <= 0;
        state            <= IDLE;
		end 
	else 
		begin
		array_out[3:0]   <= array_out_nxt[0];
        array_out[7:4]   <= array_out_nxt[1];
        array_out[11:8]  <= array_out_nxt[2];
        array_out[15:12] <= array_out_nxt[3];
		pivot 		     <= pivot_nxt;
		ready            <= ready_nxt;
		index_out        <= ind_out_nxt;
		temp_ctr_out     <= temp_ctr_out_nxt;
		state            <= state_nxt;
		
		end 
	end 
	
//comb logic
//--------------------------------------------
	always @*
	   
        begin
        array_out_nxt[0]  = array_in[3:0];
        array_out_nxt[1]  = array_in[7:4];
        array_out_nxt[2]  = array_in[11:8];
        array_out_nxt[3]  = array_in[15:12];
        
        case (state)
        
        IDLE:
            begin
            ind_out_nxt      = index_in;
            pivot_nxt        = curr_pivot;
            temp_ctr_out_nxt = temp_ctr_in; 
            ready_nxt        = 1'b0;
            
            if (start == 1) state_nxt = PARTITION_PENDING;
            else            state_nxt = IDLE;      
            
            end 
        
        PARTITION_PENDING:
            begin
            ready_nxt = 1'b0;
            state_nxt = PARTITION_PENDING;
            
            if (temp_ctr_out < hi_ind)
                begin
                temp_ctr_out_nxt = temp_ctr_in + 1;
                if (array_in[temp_ctr_in] <= pivot_nxt)
                    begin
                    ind_out_nxt = index_in + 1;
                    array_out_nxt[ind_out_nxt] = array_out_nxt[temp_ctr_out_nxt];
                    array_out_nxt[temp_ctr_out_nxt] = array_out_nxt[ind_out_nxt];
                    end 
                end 
            else 
                begin
                state_nxt = IDLE;
                ready_nxt = 1'b1;
                end
                
            ind_out_nxt = ind_out_nxt + 1;
            array_out_nxt[ind_out_nxt] = array_out_nxt[hi_ind];
            array_out_nxt[hi_ind] = array_out_nxt[ind_out_nxt];                
            end 
 
        endcase
        end //always @*

endmodule //partition
