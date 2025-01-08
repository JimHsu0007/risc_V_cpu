`include"define.sv"

module LSU(
	input	logic clk,
	input	logic write_read,
	input	logic [2:0] funct3,
	input	logic [31:0] write_data,
	input	logic [31:0] ram_addr,

	output	logic [31:0] read_data
);
	
	logic [29:0] ram_addr_0;
	logic [29:0] ram_addr_1;
	logic [29:0] ram_addr_2;
	logic [29:0] ram_addr_3;

	logic [29:0] ram_addr_p4;
	
	logic [7:0] read_data_0;
	logic [7:0] read_data_1;
	logic [7:0] read_data_2;
	logic [7:0] read_data_3;
	
	logic [7:0] write_data_0;
	logic [7:0] write_data_1;
	logic [7:0] write_data_2;
	logic [7:0] write_data_3;
	
	logic write_0;
	logic write_1;
	logic write_2;
	logic write_3;
	
	logic write_ram_0;
	logic write_ram_1;
	logic write_ram_2;
	logic write_ram_3;
	
	assign ram_addr_p4 = ram_addr[31:2] + 1;
	
	//分配四塊 RAM 之位址和寫入資料
	always_comb begin
		unique case (ram_addr[1:0])
			2'b00: begin
				ram_addr_0 = ram_addr[31:2]; 
				ram_addr_1 = ram_addr[31:2];
				ram_addr_2 = ram_addr[31:2];
				ram_addr_3 = ram_addr[31:2];
				write_data_0 = write_data[7:0];
				write_data_1 = write_data[15:8];
				write_data_2 = write_data[23:16];
				write_data_3 = write_data[31:24];
			end
			2'b01: begin
				ram_addr_0 = ram_addr_p4;
				ram_addr_1 = ram_addr[31:2]; 
				ram_addr_2 = ram_addr[31:2];
				ram_addr_3 = ram_addr[31:2];
				write_data_0 = write_data[31:24];
				write_data_1 = write_data[7:0];
				write_data_2 = write_data[15:8];
				write_data_3 = write_data[23:16];
			end
			2'b10: begin
				ram_addr_0 = ram_addr_p4;
				ram_addr_1 = ram_addr_p4;
				ram_addr_2 = ram_addr[31:2]; 
				ram_addr_3 = ram_addr[31:2];
				write_data_0 = write_data[23:16];
				write_data_1 = write_data[31:24];
				write_data_2 = write_data[7:0];
				write_data_3 = write_data[15:8];
			end
			2'b11: begin
				ram_addr_0 = ram_addr_p4;
				ram_addr_1 = ram_addr_p4;
				ram_addr_2 = ram_addr_p4;
				ram_addr_3 = ram_addr[31:2];
				write_data_0 = write_data[15:8];
				write_data_1 = write_data[23:16];
				write_data_2 = write_data[31:24];
				write_data_3 = write_data[7:0];
			end
		endcase
	end
	
	assign write_ram_0 = write_0 & write_read;
	assign write_ram_1 = write_1 & write_read;
	assign write_ram_2 = write_2 & write_read;
	assign write_ram_3 = write_3 & write_read;
	

	//決定哪些 RAM 可以寫入
	always_comb begin
		write_0 = 0;
		write_1 = 0;
		write_2 = 0;
		write_3 = 0;
		unique case (funct3)
			`F_SB: begin
				unique case (ram_addr[1:0])
					2'b00: write_0 = 1;
					2'b01: write_1 = 1;
					2'b10: write_2 = 1;
					2'b11: write_3 = 1;
				endcase
			end
			`F_SH: begin
				unique case (ram_addr[1:0])
					2'b00: begin
						write_0 = 1;
						write_1 = 1;
					end
					2'b01: begin
						write_1 = 1;
						write_2 = 1;
					end
					2'b10: begin
						write_2 = 1;
						write_3 = 1;
					end
					2'b11: begin
						write_3 = 1;
						write_0 = 1;
					end
				endcase
			end
			`F_SW: begin
				write_0 = 1;
				write_1 = 1;
				write_2 = 1;
				write_3 = 1;
			end
		endcase
	end	
	
	RAM ram_0	(
		.clk			(clk			),
		.write_read		(write_ram_0	),
		.write_data		(write_data_0	),
		.ram_addr		(ram_addr_0		),
			
		.read_data		(read_data_0	)
	);
	
	RAM ram_1	(
		.clk			(clk			),
		.write_read		(write_ram_1	),
		.write_data		(write_data_1	),
		.ram_addr		(ram_addr_1		),
					
		.read_data		(read_data_1	)
	);
	
	RAM ram_2	(
		.clk			(clk			),
		.write_read		(write_ram_2	),
		.write_data		(write_data_2	),
		.ram_addr		(ram_addr_2		),
			
		.read_data		(read_data_2	)
	);
	
	RAM ram_3	(
		.clk			(clk			),
		.write_read		(write_ram_3	),
		.write_data		(write_data_3	),
		.ram_addr		(ram_addr_3		),
			
		.read_data		(read_data_3	)
	);
	
	//組合四塊 RAM 的 read_data
	always_comb begin
		unique case (funct3)
            `F_LB: begin
				unique case (ram_addr[1:0])
					2'b00: read_data = {{24{read_data_0[7]}}, read_data_0};
					2'b01: read_data = {{24{read_data_1[7]}}, read_data_1};
					2'b10: read_data = {{24{read_data_2[7]}}, read_data_2};
					2'b11: read_data = {{24{read_data_3[7]}}, read_data_3};
				endcase
			end
            `F_LH: begin
				unique case (ram_addr[1:0])
					2'b00: read_data = {{16{read_data_1[7]}}, read_data_1, read_data_0};
					2'b01: read_data = {{16{read_data_2[7]}}, read_data_2, read_data_1};
					2'b10: read_data = {{16{read_data_3[7]}}, read_data_3, read_data_2};
					2'b11: read_data = {{16{read_data_0[7]}}, read_data_0, read_data_3};
				endcase
			end
			`F_LW: begin
				unique case (ram_addr[1:0])
					2'b00: read_data = {read_data_3, read_data_2, read_data_1, read_data_0};
					2'b01: read_data = {read_data_0, read_data_3, read_data_2, read_data_1};
					2'b10: read_data = {read_data_1, read_data_0, read_data_3, read_data_2};
					2'b11: read_data = {read_data_2, read_data_1, read_data_0, read_data_3};
				endcase
			end
            `F_LBU: begin
				unique case (ram_addr[1:0])
					2'b00: read_data = {24'h0, read_data_0};
					2'b01: read_data = {24'h0, read_data_1};
					2'b10: read_data = {24'h0, read_data_2};
					2'b11: read_data = {24'h0, read_data_3};
				endcase
			end
			`F_LHU: begin
				unique case (ram_addr[1:0])
					2'b00: read_data = {16'h0, read_data_1, read_data_0};
					2'b01: read_data = {16'h0, read_data_2, read_data_1};
					2'b10: read_data = {16'h0, read_data_3, read_data_2};
					2'b11: read_data = {16'h0, read_data_0, read_data_3};
				endcase
			end
        endcase
	end	
endmodule