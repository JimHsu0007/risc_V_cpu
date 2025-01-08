`include"define.sv"
module Reg_file(
	input logic clk,
	input logic rst,
	input logic write_regf_en,
	input logic [4:0] addr_rd,addr_rs1, addr_rs2,
	input logic [31:0] rd_value,
	output logic [31:0] rs1_value, rs2_value,regs_31
	);
	logic [31:0] regs[0:31];
	logic addr_rd_not_0 ;
	integer i,j;
	
	assign rs1_value = regs[addr_rs1];
	assign rs2_value = regs[addr_rs2];
	assign addr_rd_not_0 = |addr_rd;
	
	
	always_ff @(posedge clk) begin
    if (rst) begin
        for (i = 0; i < 32; i = i + 1) begin: rst_keywords
            regs[i] <= 0;
        end
    end else begin
        if (write_regf_en && addr_rd_not_0) begin
            regs[addr_rd] <= rd_value;
            
        end
    end
end
assign regs_31 = regs[31];
	
	
endmodule	