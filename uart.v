`timescale 1ns/10ps

`define S_IDLE 0
`define S_START 1
`define S_RECEIVE 2
`define S_STOP 3
`define S_ERROR 4

module uart(
	input rx,clk,rst,
	output [7:0]data,
	output data_valid
);
	
	reg [2:0]state_ff;
	reg [2:0]state_nxt;
	
	reg [7:0]data_nxt;
	reg [7:0]data_ff;

	reg data_valid_ff,data_valid_nxt;
	
	wire [3:0]baud;
	wire baud_en;
	reg baud_en_nxt,baud_en_ff;
	wire baud15;
	
	reg [2:0]middle;
	wire vote;
	maj maj_vote(.a(middle[2]),.b(middle[1]),.c(middle[0]),.o(vote));
	
	mod16cntr counter(.clk(clk),.rst(rst),.enable(baud_en_nxt),.count(baud));

	wire cntr_en;
	reg cntr_en_nxt,cntr_en_ff;
	wire c7;
	wire [2:0]c;
	mod8cntr counter2(.clk(clk),.rst(rst),.enable(cntr_en_nxt),.count(c));
	
	always @(*)
	begin
		state_nxt = state_ff;
		data_nxt = data_ff;
		baud_en_nxt = baud_en_ff;
		cntr_en_nxt = cntr_en_ff;
		
		if(baud == 4'b0111)
			middle = {rx, middle[1:0]};
		else if(baud == 4'b1000)
			middle = {middle[2], rx, middle[0]};
		else if(baud == 4'b1001)
			middle = {middle[2:1], rx};
		else
		begin
		end
			
		case(state_ff)
			`S_IDLE:
			begin
				if(rx)
				begin
					state_nxt = `S_IDLE;
					baud_en_nxt = 1'b0;
					cntr_en_nxt = 1'b0;
					data_valid_nxt = 1'b0;
				end
				else
				begin
					state_nxt = `S_START;
					baud_en_nxt = 1'b1;
				end
			end
			
			`S_START:
			begin
				if(baud15)
				begin
					if (~vote)
						state_nxt = `S_RECEIVE;
					else
						state_nxt = `S_IDLE;
				end
			end
				
			`S_RECEIVE:
			begin
				if(baud15)
				begin
					data_nxt[c] = vote;
					cntr_en_nxt = 1'b1;
					if(c == 3'b111)
					begin
						data_nxt[c] = vote;
						state_nxt = `S_STOP;
						data_valid_nxt = 1'b1;
					end
					else
						state_nxt = `S_RECEIVE;
				end
				else
					cntr_en_nxt = 1'b0;
			end

			`S_STOP:
			begin
				if(baud15)
				begin
					if(vote)
						state_nxt = `S_IDLE;
					else
						state_nxt = `S_ERROR;
				end
				cntr_en_nxt = 1'b0;
			end
			
			`S_ERROR:
			begin
				if(baud15)
					state_nxt = `S_IDLE;
			end
		endcase
	end
	
	always @(posedge clk or posedge rst)
	begin
		if(rst)
		begin
			state_ff <= `S_IDLE;
			data_ff <= 8'd0;
			baud_en_ff <= 1'b0;
			cntr_en_ff <= 1'b0;
			data_valid_ff <= 1'b0;
		end
		else
		begin
			state_ff <= state_nxt;
			data_ff <= data_nxt;
			baud_en_ff <= baud_en_nxt;
			cntr_en_ff <= cntr_en_nxt;
			data_valid_ff <= data_valid_nxt;
		end
	end
	
	assign data = data_ff;
	assign baud_en = baud_en_ff;
	assign cntr_en = cntr_en_ff;
	assign data_valid = data_valid_ff;

	assign baud15 = &baud;

endmodule