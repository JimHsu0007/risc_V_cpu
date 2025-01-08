`include"define.sv"
module Program_Rom(
	input	logic [31:0] Rom_addr,
	output	logic [31:0] Rom_data
);    
  
    always_comb begin
        case (Rom_addr)
				  32'h00000000 : Rom_data = 32'h341CE137; // lui x2 213454
              32'h00000004 : Rom_data = 32'hF0C10113; // addi x2 x2 -244
              32'h00000008 : Rom_data = 32'h00202023; // sw x2 0(x0)
              32'h0000000C : Rom_data = 32'hBD006137; // lui x2 774150
              32'h00000010 : Rom_data = 32'h36510113; // addi x2 x2 869
              32'h00000014 : Rom_data = 32'h00202223; // sw x2 4(x0)
              32'h00000018 : Rom_data = 32'h00F00113; // addi x2 x0 15
              32'h0000001C : Rom_data = 32'h00200423; // sb x2 8(x0)
              32'h00000020 : Rom_data = 32'h00900193; // addi x3 x0 9
              32'h00000024 : Rom_data = 32'h6E056137; // lui x2 450646
              32'h00000028 : Rom_data = 32'hFF510113; // addi x2 x2 -11
              32'h0000002C : Rom_data = 32'h0021A023; // sw x2 0(x3)
              32'h00000030 : Rom_data = 32'h34435137; // lui x2 214069
              32'h00000034 : Rom_data = 32'hDF710113; // addi x2 x2 -521
              32'h00000038 : Rom_data = 32'h0021A223; // sw x2 4(x3)
              32'h0000003C : Rom_data = 32'h00C00113; // addi x2 x0 12
              32'h00000040 : Rom_data = 32'h00218423; // sb x2 8(x3)
              32'h00000044 : Rom_data = 32'h01200F13; // addi x30 x0 18
              32'h00000048 : Rom_data = 32'h00C00293; // addi x5 x0 12
              32'h0000004C : Rom_data = 32'h00000393; // addi x7 x0 0
              32'h00000050 : Rom_data = 32'h00900313; // addi x6 x0 9
              32'h00000054 : Rom_data = 32'h00038103; // lb x2 0(x7)
              32'h00000058 : Rom_data = 32'h00138183; // lb x3 1(x7)
              32'h0000005C : Rom_data = 32'h00238203; // lb x4 2(x7)
              32'h00000060 : Rom_data = 32'h00900413; // addi x8 x0 9
              32'h00000064 : Rom_data = 32'h00040603; // lb x12 0(x8)
              32'h00000068 : Rom_data = 32'h00340683; // lb x13 3(x8)
              32'h0000006C : Rom_data = 32'h00640703; // lb x14 6(x8)
              32'h00000070 : Rom_data = 32'h02C107B3; // mul x15 x2 x12
              32'h00000074 : Rom_data = 32'h02D18833; // mul x16 x3 x13
              32'h00000078 : Rom_data = 32'h02E208B3; // mul x17 x4 x14
              32'h0000007C : Rom_data = 32'h00F80933; // add x18 x16 x15
              32'h00000080 : Rom_data = 32'h01190933; // add x18 x18 x17
              32'h00000084 : Rom_data = 32'h012F1023; // sh x18 0(x30)
              32'h00000088 : Rom_data = 32'h001F0883; // lb x17 1(x30)
              32'h0000008C : Rom_data = 32'h011F0023; // sb x17 0(x30)
              32'h00000090 : Rom_data = 32'h012F00A3; // sb x18 1(x30)
              32'h00000094 : Rom_data = 32'h00140413; // addi x8 x8 1
              32'h00000098 : Rom_data = 32'h002F0F13; // addi x30 x30 2
              32'h0000009C : Rom_data = 32'hFC8294E3; // bne x5 x8 -56
              32'h000000A0 : Rom_data = 32'h00338393; // addi x7 x7 3
              32'h000000A4 : Rom_data = 32'hFA6398E3; // bne x7 x6 -80
              32'h000000A8 : Rom_data = 32'h01200193; // addi x3 x0 18
              32'h000000AC : Rom_data = 32'h00900213; // addi x4 x0 9
              32'h000000B0 : Rom_data = 32'h00019F83; // lh x31 0(x3)
              32'h000000B4 : Rom_data = 32'h00218193; // addi x3 x3 2
              32'h000000B8 : Rom_data = 32'hFFF20213; // addi x4 x4 -1
              32'h000000BC : Rom_data = 32'hFE021AE3; // bne x4 x0 -12

            default: Rom_data = 32'h00000013;   //NOP
        endcase
    end
endmodule
				
							
				