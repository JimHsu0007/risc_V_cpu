`include"define.sv"
module ALU(
	input logic [3:0]op,
	input logic [31:0]alu_a,alu_b,
	output logic [31:0]alu_out
	);
	always_comb begin 
		unique case(op)
			4'h0: alu_out = alu_a + alu_b;
			4'h1: alu_out =  $signed (alu_a) - $signed(alu_b);
			4'h2: alu_out = alu_a & alu_b;
			4'h3: alu_out = alu_a | alu_b;
			4'h4: alu_out = alu_a ^ alu_b;
			4'h5: alu_out = alu_a;
			4'h6: alu_out = alu_a + 4;
			4'h7: alu_out = alu_a < alu_b;
			4'h8: alu_out = $signed(alu_a) < $signed(alu_b);
			4'h9: alu_out = alu_a << alu_b[4:0];
			4'hA: alu_out = alu_a >> alu_b[4:0];
			4'hB: alu_out = $signed(alu_a) >>> alu_b[4:0];
			4'hC: alu_out = alu_b;
			4'hD: alu_out = alu_a;
			4'hE: alu_out = alu_b;
			4'hF: begin 
			if(alu_a >= alu_b) begin 
				alu_out = alu_a - alu_b;
				if (alu_out[31] == 1) alu_out = alu_b - alu_a;
				end
			else begin 
			alu_out = alu_b - alu_a;
			if (alu_out[31] == 1) alu_out = alu_a - alu_b;
			end
			end
			
			default : alu_out = alu_a;
		endcase
	end
endmodule
	
	