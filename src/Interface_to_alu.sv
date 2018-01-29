//=======================================================================================
// TITLE : ALU interface
// DESCRIPTION :
//
// FILE : Interface_to_alu.sv
//=======================================================================================
// CREATION
// DATE AUTHOR PROJECT REVISION 
// 2015/07/27 Etienne Gauthier INF8500 Laboratoire 1 Automne 2015
//=======================================================================================
// MODIFICATION HISTORY
// DATE AUTHOR PROJECT REVISION COMMENTS
//=======================================================================================

interface Interface_to_alu(input bit clock);
	import pkg_testbench_defs::*;

	logic[7:0] in_op;
	logic[DATA_SIZE-1 : 0] in_oper_a;
	logic[DATA_SIZE-1 : 0] in_oper_b;
	logic[DATA_SIZE-1 : 0] out_result;
	logic in_flag_carry;
	logic in_flag_zero;
	logic in_flag_neg;
	logic in_flag_aux_carry;
	logic out_flag_carry;
	logic out_flag_zero;
	logic out_flag_neg;
	logic out_flag_aux_carry;

  	default clocking cb @(posedge clock);
		output in_op;
		output in_oper_a;
		output in_oper_b;
		output in_flag_carry;
		output in_flag_zero;
		output in_flag_neg;
		output in_flag_aux_carry;
     	input out_result;
     	input out_flag_carry;
		input out_flag_zero;
		input out_flag_neg;
		input out_flag_aux_carry;
  	endclocking

	task send_op(input logic[7:0] op, input logic[DATA_SIZE-1 : 0] operand_a, input logic[DATA_SIZE-1 : 0] operand_b,
		input logic in_flag_carry, input logic in_flag_zero, input logic in_flag_neg, input logic in_flag_aux_carry );
		cb.in_op <=  op;
		cb.in_oper_a <= operand_a;
		cb.in_oper_b <= operand_b;
		cb.in_flag_carry <=  in_flag_carry;
		cb.in_flag_zero <= in_flag_zero;
		cb.in_flag_neg <= in_flag_neg;
		cb.in_flag_aux_carry <= in_flag_aux_carry;
	endtask : send_op

	task read_op_result(output logic[DATA_SIZE-1 : 0] result, output logic flag_carry, output logic flag_zero, output logic flag_neg, output logic flag_aux_carry);
		result = cb.out_result;
		flag_carry = cb.out_flag_carry;
		flag_zero = cb.out_flag_zero;
		flag_neg = cb.out_flag_neg;
		flag_aux_carry = cb.out_flag_aux_carry;
	endtask : read_op_result

	task wait_clk(input integer cycles);
		##cycles;
	endtask : wait_clk
endinterface
