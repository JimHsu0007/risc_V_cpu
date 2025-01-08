`include"define.sv"
module core(
	input logic clk,rst,
	output logic[31:0] regs_31
	
	);
	
	logic [31:0]pc_next,pc,inst_,inst_r,base_addr,j_addr_;
	logic rst_or_flush_IFID_,flush_IFID_,flush_IFID_r,flush_IDEX_,flush_IDEX_r;
	logic [6:0] funct7_,opcode_;
	logic [2:0] funct3,funct3_r;
	logic[3:0] op_r,op_;
	logic [4:0] addr_rd_r,addr_rd_, addr_rs1_,addr_rs2_;
	logic [31:0] imm_r,imm_,rs2_value_r,rs1_value,rs2_value,rs1_value_r,alu_out,rd_value_,ch_b,ch_a,rs2_value_,rs1_value_;
	logic rst_pc_,write_read_,write_read_r;
	logic write_regf_en_r,write_regf_en_,sel_alu_a_,sel_jump_,sel_alu_a_r,sel_jump_r;
	logic [1:0] sel_alu_b_,sel_alu_b_r;
	logic sel_pc_r,sel_pc_;
	logic [31:0] jump_addr_,pc_r,pc_rr,read_data,div_out,mul_out;
	logic [1:0]sel_rd_value_,sel_rd_value_r;
	logic sel_rs1_value_,sel_rs2_value_;

	always_comb
	begin
		if (sel_pc_r)  pc_next = jump_addr_;
		else  pc_next = pc + 4;
	end
	
	
	always_ff@(posedge clk)
	begin 
		if (rst | rst_pc_) pc <= 0;
		else pc <= pc_next;
	end
	
	Program_Rom k(
	.Rom_addr( pc),
	.Rom_data( inst_)
	);
	assign rst_or_flush_IFID_ = rst | flush_IFID_r;
	always_ff @(posedge clk)
	begin
		if (rst_or_flush_IFID_) begin 
			pc_r <= 0;
			inst_r <= 32'h13;
		end
		else 
		begin
		inst_r <= inst_;
		pc_r <= pc;
		end
	end
	 inst_dec k1(
	.inst_r(inst_r),
	.funct7_(funct7_),
	.opcode_(opcode_),
	.funct3(funct3),
	.addr_rd_(addr_rd_), 
	.addr_rs1_(addr_rs1_),
	.addr_rs2_(addr_rs2_),
	.imm_(imm_)
	);
	
	controller k3(
	.funct7_(funct7_),
	.opcode_(opcode_),
	.funct3(funct3),
	.clk(clk),
	.rst(rst),
	.rst_pc_(rst_pc_),
	.write_reg_en_(write_regf_en_),
	.op_(op_),
	.sel_pc(sel_pc_),
	.flush_IFID_(flush_IFID_),
	.sel_alu_b_(sel_alu_b_),
	.flush_IDEX_(flush_IDEX_),
	.rs1_value(rs1_value_),
	.rs2_value(rs2_value_),
	.sel_alu_a_(sel_alu_a_),
	.sel_jump_( sel_jump_),
	.write_read_(write_read_),
	.sel_rd_value(sel_rd_value_)
	);
	
	Reg_file k4(
	.clk              (clk),
	.rst              (rst),
	.write_regf_en    (write_regf_en_r),
	.addr_rd          (addr_rd_r),
	.addr_rs1         (addr_rs1_), 
	.addr_rs2         (addr_rs2_),
	.rd_value         (rd_value_),
   .rs1_value        (rs1_value), 
	.rs2_value        (rs2_value),
	.regs_31          (regs_31)
	);
	assign sel_rs1_value_ = write_regf_en_r & (addr_rd_r == addr_rs1_);
	assign sel_rs2_value_ = write_regf_en_r & (addr_rd_r == addr_rs2_);
	assign rs1_value_ = sel_rs1_value_ ? rd_value_ : rs1_value;
	assign rs2_value_ = sel_rs2_value_ ? rd_value_ : rs2_value;
	assign rst_or_flush_IDEX_ = rst | flush_IDEX_r;
	always_ff @(posedge clk)
	begin
		if (rst_or_flush_IDEX_)
		begin 
		imm_r <= 0;
		sel_pc_r = 0;
		addr_rd_r <= 0;
		op_r <= op_;
		sel_alu_b_r <= 0;
		write_regf_en_r <= 0;
		rs1_value_r <= 0;
		rs2_value_r <= 0;
		flush_IDEX_r <=  0;
		flush_IFID_r <=  0;
		pc_rr <= 0;
		sel_alu_a_r<= 0;
		sel_jump_r <=0;
		sel_rd_value_r<= 0;
		write_read_r<=0;
		funct3_r <= 0;
		end
		else 
		begin
		addr_rd_r <= addr_rd_;
		imm_r <= imm_;
		op_r <= op_;
		sel_alu_b_r <= sel_alu_b_;
		sel_alu_a_r<= sel_alu_a_;
		sel_jump_r <=sel_jump_;
		write_regf_en_r <= write_regf_en_;
		rs1_value_r <= rs1_value_;
		rs2_value_r <= rs2_value_;
		sel_pc_r <= sel_pc_;
		pc_rr <= pc_r;
		flush_IDEX_r <=  flush_IDEX_;
		flush_IFID_r <=  flush_IFID_;
		sel_rd_value_r<= sel_rd_value_ ;
		write_read_r<= write_read_;
		funct3_r<= funct3;
		end
	end
	always_comb
	begin
		if(sel_alu_a_r) ch_a = pc_rr;
		else ch_a = rs1_value_r;
		if (sel_alu_b_r == 2) ch_b = 4;
		else if (sel_alu_b_r == 1) ch_b = rs2_value_r;
	   else 	ch_b = imm_r;
	end
	
	
	ALU k5(
	.op   (op_r),
	.alu_a(ch_a),
	.alu_b(ch_b),
	.alu_out(alu_out)
	);
	
	
	LSU k6(
	.clk(clk),
	.write_read(write_read_r),
	.funct3(funct3_r),
	.write_data(rs2_value_r),
	.ram_addr(alu_out),

	.read_data(read_data)
);
	MUL k7(
	.funct3(funct3_r),
	.rs1_value(rs1_value_r),
	.rs2_value(rs2_value_r),
	.mul_out(mul_out)
);

	DIV k8(
	.funct3(funct3_r),
	.rs1_value(rs1_value_r),
	.rs2_value(rs2_value_r),
	.div_out(div_out)
);
	
	always_comb 
	begin
	rd_value_ = alu_out; 
		case(sel_rd_value_r)
		0:begin rd_value_ = alu_out; end
		1:begin rd_value_ = read_data; end
		2:begin rd_value_ = mul_out; end
		3:begin rd_value_ = div_out; end
		endcase
	end
	assign base_addr = sel_jump_r ? pc_rr: rs1_value_r;
	assign j_addr_ = base_addr +  imm_r;
	assign jump_addr_ = {j_addr_[31:1],(j_addr_[0] & sel_jump_r)};
endmodule	
	