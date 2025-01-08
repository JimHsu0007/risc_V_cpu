module pc(
	input logic clk,rst,
	output logic [31:0]pc_next,pc
	);
	
	assign pc_next = pc + 4;
	
	always_ff@(posedge clk)
	begin 
		if (rst) pc <= 0;
		else pc <= pc_next;
	end
endmodule	