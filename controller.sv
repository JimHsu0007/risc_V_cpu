`include"define.sv"
module controller(
	input logic[6:0] funct7_,opcode_,
	input logic[2:0] funct3,
	input logic clk,rst,
	input logic [31:0] rs1_value,rs2_value,
	output logic rst_pc_,write_reg_en_,
	output logic[3:0] op_,
	output logic [1:0] sel_alu_b_,
	output logic flush_IFID_,flush_IDEX_,sel_pc,sel_alu_a_,sel_jump_,write_read_,
	output logic [1:0] sel_rd_value
);
	typedef enum { s0, s1, s2, s3}FSM_STATE;
	
	FSM_STATE ps, ns;
	
	always_ff @(posedge clk)
	begin
		if(rst) ps<=s0;
		else ps <= ns;
	end
	 
	always_comb 
	begin 
	op_ = 0;
	write_reg_en_ = 0;
	rst_pc_     =0;
	flush_IFID_ =0;
	flush_IDEX_ =0;
	sel_alu_b_  =0;
	sel_pc      = 0;
	sel_alu_a_ = 0;
	sel_jump_ =  1;
	ns          = ps;
	sel_rd_value = 0;
	write_read_ = 0;
	case(ps)
		s0:
		begin
			flush_IFID_ = 1;
			flush_IDEX_ = 1;
			rst_pc_    = 1;
			ns = s1;
		end
		s1:
		begin
			flush_IFID_ = 1;
			flush_IDEX_ = 1;
			rst_pc_    = 1;
			ns = s2;
		end
		s2:
		begin
		case(opcode_)
			`Opcode_I:
				begin
					write_reg_en_ = 1;
					case(funct3)
						`F_ADDI:
							begin
								op_ = `ALUOP_ADD;
							end
						`F_SLTI:
							begin
								op_ = `ALUOP_LT;
							end
						`F_SLTIU:
							begin
								op_ = `ALUOP_LTU;
							end
						`F_ANDI:
							begin
								op_ = `ALUOP_AND;
							end
						`F_ORI:
							begin
								op_ = `ALUOP_OR;
							end
						`F_XORI:
							begin
								op_ = `ALUOP_XOR;
							end
						`F_SLLI:
							begin
								op_ = `ALUOP_SLL;
							end
						`F_SRLI_SRAI:
							begin
								if(funct7_[5])		op_ = `ALUOP_SRA;
								else				op_ = `ALUOP_SRL;
							end
						default:op_ = `ALUOP_A;
					endcase
					end
			`Opcode_R_M:
				begin				
					if(funct7_ == 7'b000_0001)
						begin
						case(funct3)
						`F_MUL : begin 
							write_reg_en_ = 1;
							sel_rd_value  = 2;
							end
						`F_MULH : begin 
							write_reg_en_ = 1;
							sel_rd_value  = 2;
							end 
						`F_MULHSU: begin 
							write_reg_en_ = 1;
							sel_rd_value  = 2;
							end
						`F_MULHU : begin 
							write_reg_en_ = 1;
							sel_rd_value  = 2;
							end
						`F_DIV   : begin 
							write_reg_en_ = 1;
							sel_rd_value  = 3;
							end
						`F_DIVU  : begin 
							write_reg_en_ = 1;
							sel_rd_value  = 3;
							end
						`F_REM   : begin 
							write_reg_en_ = 1;
							sel_rd_value  = 3;
							end
						`F_REMU  : begin 
							write_reg_en_ = 1;
							sel_rd_value  = 3;
							end
						endcase
					end
					else
					begin
						write_reg_en_ = 1;
						sel_alu_b_ = 1;
						case(funct3)
							`F_AND:
								begin 
									op_ = `ALUOP_AND;
								end
							`F_ADD_SUB:
								begin 
									if(funct7_ == 0000000)op_ = `ALUOP_ADD;
									else op_ = `ALUOP_SUB;
								end
							`F_SLL:
								begin 
									op_ = `ALUOP_SLL;
								end
							`F_SLT:
								begin 
									op_ = `ALUOP_LT;
								end
							`F_SLTU:
								begin 
									op_ = `ALUOP_LTU;
								end
							`F_OR:
								begin 
									op_ = `ALUOP_OR;
								end
							`F_XOR:
								begin 
									op_ = `ALUOP_XOR;
								end
							`F_XOR:
								begin 
									op_ = `ALUOP_XOR;
								end
							`F_SRL_SRA:
								begin 
									if(funct7_ == 0000000)op_ = `ALUOP_SRL;
									else op_ = `ALUOP_SRA;
								end
						endcase
					end
				end
			`Opcode_B:
				begin
					case(funct3)
					`F_BEQ : begin
						if(rs1_value == rs2_value)begin
							sel_pc = 1;
							flush_IFID_ = 1;
							flush_IDEX_ = 1;
						end
					end
					`F_BNE : begin
						if(rs1_value != rs2_value)begin
							sel_pc = 1;
							flush_IFID_ = 1;
							flush_IDEX_ = 1;
						end
					end
					`F_BLT : begin
						if($signed(rs1_value) < $signed(rs2_value))begin
							sel_pc = 1;
							flush_IFID_ = 1;
							flush_IDEX_ = 1;
						end
					end
					`F_BGE : begin
						if($signed(rs1_value) >= $signed(rs2_value))begin
							sel_pc = 1;
							flush_IFID_ = 1;
							flush_IDEX_ = 1;
						end
					end
					`F_BLTU : begin
						if(rs1_value < rs2_value)begin
							sel_pc = 1;
							flush_IFID_ = 1;
							flush_IDEX_ = 1;
						end
					end
					`F_BGEU : begin
						if(rs1_value >= rs2_value)begin
							sel_pc = 1;
							flush_IFID_ = 1;
							flush_IDEX_ = 1;
						end
					end
				endcase
				end
			`Opcode_test: 
			begin
				write_reg_en_ = 1;
				sel_alu_b_ = 1;
				case(funct7_)
				`f_Min : begin
					if(rs1_value >= rs2_value)op_ = `ALUOP_min_2;
					else op_ = `ALUOP_min_1;
				end
				`f_Sunabs : begin
					op_ = `ALUOP_abs_1;
					end
				endcase
			end
				
			`Opcode_JAL : begin
				sel_pc = 1;
				write_reg_en_ = 1;
				op_ = `ALUOP_ADD;
				flush_IFID_ =1;
				flush_IDEX_ =1;
				sel_alu_b_  =2;
				sel_alu_a_  = 1;
				sel_jump_ = 1;
				end
			`Opcode_JALR : begin
				sel_pc = 1;
				flush_IFID_ =1;
				flush_IDEX_ =1;
				op_ = `ALUOP_ADD;
				sel_alu_a_  = 1;
				sel_alu_b_  =2;
				sel_jump_ = 0;
				write_reg_en_ = 1;
				end
			`Opcode_LUI : begin
				sel_alu_b_ = 0;
				write_reg_en_ = 1;
				op_ = `ALUOP_B;
				end
			`Opcode_AUIPC : begin
				sel_alu_b_ = 0;
				sel_alu_a_ = 1;
				write_reg_en_ = 1;
				op_ = `ALUOP_ADD;
				end
			`Opcode_L : begin
				case(funct3)
					`F_LB: begin
						op_= `ALUOP_ADD;
						sel_rd_value = 1;
						write_reg_en_ = 1;
						end
				   `F_LH: begin
						op_= `ALUOP_ADD;
						sel_rd_value = 1;
						write_reg_en_ = 1;
						end
					`F_LW :begin
						op_= `ALUOP_ADD;
						sel_rd_value = 1;
						write_reg_en_ = 1;
						end
					`F_LBU:begin	
						op_= `ALUOP_ADD;
						sel_rd_value = 1;
						write_reg_en_ = 1;
						end
					`F_LHU:begin	
						op_= `ALUOP_ADD;
						sel_rd_value = 1;
						write_reg_en_ = 1;
						end
					endcase
					end
				`Opcode_S : begin
					case(funct3)
					`F_SB : begin
						op_ = `ALUOP_ADD;
						write_read_ = 1;
						end
					`F_SH : begin
						op_ = `ALUOP_ADD;
						write_read_ = 1;
						end
					`F_SW : begin
						op_ = `ALUOP_ADD;
						write_read_ = 1;
						end
					endcase
				end
	endcase    
	end        
	endcase    
	end
endmodule
			