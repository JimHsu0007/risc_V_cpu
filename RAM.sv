`include"define.sv"
module RAM(
	input	logic clk,
	input	logic write_read,
	input	logic [7:0] write_data,
	input	logic [29:0] ram_addr,

	output	logic [7:0] read_data
);
	
	logic [7:0] ram[0:127];
	
	assign read_data = ram[ram_addr]; 
	
	always_ff @(posedge clk) begin
		if (write_read) begin
			ram[ram_addr] <= #1 write_data;
		end
	end

endmodule

