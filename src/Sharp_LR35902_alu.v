//======================================================================================= 
// TITLE : Sharp LR35902 ALU
// DESCRIPTION : 
//  Behavioural description of the Sharp LR35902 ALU
//
//  DATA_SIZE: operands size (default 8bits)
//
//
// FILE : alu.v
//======================================================================================= 
// CREATION 
// DATE AUTHOR PROJECT REVISION 
// 2015/06/22 Etienne Gauthier INF8500 Laboratoire 1 Automne 2015
//======================================================================================= 
// MODIFICATION HISTORY 
// DATE AUTHOR PROJECT REVISION COMMENTS 
//======================================================================================= 
`include "Sharp_LR35902_alu_opcodes.v"

module Sharp_LR35902_alu #(parameter DATA_SIZE = 8)(
	input reg [7:0]   			in_op,
	input reg [DATA_SIZE-1:0] 	in_oper_a, // input A (from Accumulator register ACT)
	input reg [DATA_SIZE-1:0] 	in_oper_b, // input B (from Temporary register TMP)
	input reg 					in_flag_carry,
	input reg 					in_flag_zero,
	input reg 					in_flag_neg,
	input reg 					in_flag_aux_carry,
	output reg [DATA_SIZE-1:0] 	out_result,
	output reg 					out_flag_carry,
	output reg 					out_flag_zero,
	output reg 					out_flag_neg,
	output reg 					out_flag_aux_carry
);

	// Internal wire to link carries from operation to flag process
	reg w_aux_carry, w_carry;

 	task fourbitAdder(input reg [3:0] operand_a, input reg [3:0] operand_b, input reg cin, output reg [3:0] result, output reg cout);
 		begin : fourbitAdder_block
 			reg [4 : 0] extended_a, extended_b;
 			extended_a = {1'b0,operand_a};
 			extended_b = {1'b0,operand_b};
 			{cout, result[3:0]} = extended_a + (extended_b + cin);
 		end
 	endtask

 	task Add(input reg [DATA_SIZE-1:0] operand_a, input reg [DATA_SIZE-1:0] operand_b, input reg cin, output reg [DATA_SIZE-1:0] result, output reg aux_carry_out, output reg carry_out);
 		begin
 			fourbitAdder(operand_a[(DATA_SIZE-1)/2:0], operand_b[(DATA_SIZE-1)/2:0], cin, result[(DATA_SIZE-1)/2:0], aux_carry_out );
			fourbitAdder(operand_a[(DATA_SIZE-1):(DATA_SIZE/2)], operand_b[(DATA_SIZE-1):(DATA_SIZE/2)], aux_carry_out, result[(DATA_SIZE-1):(DATA_SIZE/2)], carry_out );
 		end
 	endtask

	// Control Path (Flag register process)
	always @ ( in_op, w_carry, w_aux_carry, out_result, in_oper_a, in_oper_b, in_flag_carry) begin : flags_process
		
		casex (in_op)
			`OP_ADD: begin // ADD (A+B)						
				out_flag_carry <= w_carry;
				out_flag_aux_carry <= w_aux_carry;
				out_flag_neg <= 1'b0;
				if(out_result == 0 ) begin
					out_flag_zero <= 1'b1;
				end
				else begin
					out_flag_zero <= 1'b0;
				end
			end
			`OP_ADDC: begin // ADD with carry (A+B+Carry)
				out_flag_carry <= w_carry;
				out_flag_aux_carry <= w_aux_carry;
				out_flag_neg <= 1'b0;
				if(out_result == 0 ) begin
					out_flag_zero <= 1'b1;
				end
				else begin
					out_flag_zero <= 1'b0;
				end
			end
			`OP_SUB: begin // SUB (A - B)
				out_flag_carry <= w_carry;
				out_flag_aux_carry <= w_aux_carry;
				out_flag_neg <= 1'b1;
				if(out_result == 0 ) begin
					out_flag_zero <= 1'b1;
				end
				else begin
					out_flag_zero <= 1'b0;
				end
			end
			`OP_SUBC: begin // SUB Carry (A - (B + Carry))
				out_flag_carry <= w_carry;
				out_flag_aux_carry <= w_aux_carry;
				out_flag_neg <= 1'b1;
				if(out_result == 0 ) begin
					out_flag_zero <= 1'b1;
				end
				else begin
					out_flag_zero <= 1'b0;
				end
			end
			`OP_AND: begin // AND					
				out_flag_carry <= 1'b0; 
				out_flag_aux_carry <= 1'b1; 
				out_flag_neg <= 1'b0;
				if(out_result == 0 ) begin
					out_flag_zero <= 1'b1;
				end
				else begin
					out_flag_zero <= 1'b0;
				end
			end
			`OP_XOR: begin // XOR
				out_flag_carry <= 1'b0; 
				out_flag_aux_carry <= 1'b0; 
				out_flag_neg <= 1'b0;
				if(out_result == 0 ) begin
					out_flag_zero <= 1'b1;
				end
				else begin
					out_flag_zero <= 1'b0;
				end
			end
			`OP_OR: begin // OR
				out_flag_carry <= 1'b0; 
				out_flag_aux_carry <= 1'b0; 
				out_flag_neg <= 1'b0;
				if(out_result == 0 ) begin
					out_flag_zero <= 1'b1;
				end
				else begin
					out_flag_zero <= 1'b0;
				end
			end
			`OP_CP: begin // CP compare (A) 
				if (in_oper_a < in_oper_b) begin
					out_flag_carry <= 1'b1;
				end
				else begin
					out_flag_carry <= 1'b0;
				end
				out_flag_aux_carry <= w_aux_carry; 
				out_flag_neg <= 1'b1;
				if (in_oper_a == in_oper_b) begin
					out_flag_zero <= 1'b1;
				end
				else begin
					out_flag_zero <= 1'b0;
				end
			end

			`OP_INC: begin // INR (B) 
				out_flag_neg <= 1'b0;
				out_flag_carry <= in_flag_carry;
				out_flag_aux_carry <= w_aux_carry;
				if(out_result == 0 ) begin
					out_flag_zero <= 1'b1;
				end
				else begin
					out_flag_zero <= 1'b0;
				end
			end
			`OP_DEC: begin // DCR (B) 
				out_flag_neg <= 1'b1;
				out_flag_carry <= in_flag_carry;
				out_flag_aux_carry <= w_aux_carry;
				if(out_result == 0 ) begin
					out_flag_zero <= 1'b1;
				end
				else begin
					out_flag_zero <= 1'b0;
				end
			end
			`OP_RLCA: begin // RLC rotate accumulator (A) left, Only Carry affected, reset others
				out_flag_carry <= in_oper_a[7];
				out_flag_aux_carry <= 1'b0;
				out_flag_neg <= 1'b0;
				out_flag_zero <= 1'b0;
			end
			`OP_RRCA: begin // RRC rotate accumulator (A) right, Only Carry affected, reset others
				out_flag_carry <= in_oper_a[0];
				out_flag_aux_carry <= 1'b0;
				out_flag_neg <= 1'b0;
				out_flag_zero <= 1'b0;
			end
			`OP_RLA: begin // RAL rotate accumulator (A) left throught carry, Only Carry affected, reset others
				out_flag_carry <= in_oper_a[7];
				out_flag_aux_carry <= 1'b0;
				out_flag_neg <= 1'b0;
				out_flag_zero <= 1'b0;
			end
			`OP_RRA: begin // RAR rotate accumulator (A) right throught carry, Only Carry affected, reset others
				out_flag_carry <= in_oper_a[0];
				out_flag_aux_carry <= 1'b0;
				out_flag_neg <= 1'b0;
				out_flag_zero <= 1'b0;
			end
			`OP_DAA: begin // DAA decimal ajust accumulator (A)
				out_flag_carry <= w_carry;
				out_flag_aux_carry <= 1'b0;
				out_flag_neg <= in_flag_neg;
				if(out_result == 0 ) begin
					out_flag_zero <= 1'b1;
				end
				else begin
					out_flag_zero <= 1'b0;
				end
			end
			`OP_CCF: begin // CMC Complement carry flag (CY -> 'CY) 
				out_flag_aux_carry <= 1'b0;
				out_flag_carry <= ~in_flag_carry;
				out_flag_neg <= 1'b0;
				out_flag_zero <= in_flag_zero;
			end
			`OP_CPL: begin // CMS Complement accumulator (A -> 'A)
				out_flag_neg <= 1'b1;
				out_flag_carry <= in_flag_carry;
				out_flag_aux_carry <= 1'b1;
				out_flag_zero <= in_flag_zero;
			end
			`OP_SCF: begin // STC Set Carry flag (CY = 1) 
				out_flag_carry <= 1'b1;
				out_flag_aux_carry <= 1'b0;
				out_flag_neg <= 1'b0;
				out_flag_zero <= in_flag_zero;
			end
		endcase
	end 
	

	// Data Path (operation execution)
	always @ (in_op, in_oper_a, in_oper_b, in_flag_carry, in_flag_aux_carry) begin : alu_process
		
		out_result = {DATA_SIZE{1'b0}};

		casex (in_op)
			`OP_ADD: begin// ADD
				Add(in_oper_a, in_oper_b, 1'b0, out_result, w_aux_carry, w_carry);
			end 
			`OP_ADDC: begin// ADD carry (A+B+Carry)
				Add(in_oper_a, in_oper_b, in_flag_carry, out_result, w_aux_carry, w_carry);
			end
			`OP_SUB: begin// SUB
				Add(in_oper_a, (-in_oper_b), 1'b0, out_result, w_aux_carry, w_carry);
			end 
			`OP_SUBC: begin// SUB Carry (A - (B + Carry))
				Add(in_oper_a, -(in_oper_b + in_flag_carry), 1'b0, out_result, w_aux_carry, w_carry);
			end
			`OP_AND: // AND
				out_result = (in_oper_a & in_oper_b);
			`OP_XOR: // XOR
				out_result = (in_oper_a ^ in_oper_b);
			`OP_OR: // OR
				out_result = (in_oper_a | in_oper_b);
			`OP_CP: begin // CP compare (A) - r 
				Add(in_oper_a, (-in_oper_b), 1'b0, out_result, w_aux_carry, w_carry);
			end
			`OP_INC: begin // INC (B)
				Add(in_oper_b, 8'b00000001 , 1'b0, out_result, w_aux_carry, w_carry);
			end
			`OP_DEC: begin //DEC  (B)
				Add(in_oper_b, 8'b11111111 , 1'b0, out_result, w_aux_carry, w_carry);
			end
			`OP_RLCA: // RLCA rotate accumulator (A) left
				out_result = {in_oper_a[6:0], in_oper_a[7]};
			`OP_RRCA: // RRCA rotate accumulator (A) right
				out_result = {in_oper_a[0],in_oper_a[7:1]};
			`OP_RLA: // RLA rotate accumulator (A) left throught carry
				out_result = {in_oper_a[6:0],in_flag_carry};
			`OP_RRA: // RRA rotate accumulator (A) right throught carry
				out_result = {in_flag_carry,in_oper_a[7:1]};
			`OP_DAA: begin : DAA // DAA decimal ajust accumulator (A) 
					// Label DDA to enable varibale declaration

					// DAA op (op 1 bit extended)
					reg [(DATA_SIZE/2):0] high, low; 

					low = in_oper_a[3:0];
					high = in_oper_a[7:4];

					if(in_flag_aux_carry || low > 9 ) 
						low = low + 6;

					high = high + low[4];
					
					if(in_flag_carry || high > 9) 
						high = high + 6;
					
					w_aux_carry = low[4];
					w_carry = high[4];
					out_result = {high[3:0], low[3:0]};
				end
			`OP_CPL: // CPL Complement accumulator (A -> 'A)
				out_result = ~in_oper_a;
			`OP_CCF:// CCF Complement carry flag (CY -> 'CY) ## TODO May be external to ALU
				out_result = {7'b0, ~in_flag_carry};
			`OP_SCF: // SCF Set Carry flag (CY = 1) ## TODO May be external to ALU
				out_result = 1'b1;
			default:
				out_result = {DATA_SIZE{1'b0}};
		endcase
	end

endmodule // alu