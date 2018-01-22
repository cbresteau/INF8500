//======================================================================================= 
// TITLE : TestBench parameters
// DESCRIPTION : 
// Specify global parameters for the testbench
//
// FILE : TestBenchDefs.sv
//======================================================================================= 
// CREATION 
// DATE AUTHOR PROJECT REVISION 
// 2015/07/27 Etienne Gauthier INF8500 Laboratoire 1 Automne 2015
//======================================================================================= 
// MODIFICATION HISTORY 
// DATE AUTHOR PROJECT REVISION COMMENTS 
// 2018/01/21 Etienne Gauthier Ajout des déclarations pour l'encapsulation des cas de test
//======================================================================================= 
`include "Sharp_LR35902_alu_opcodes.v"
package pkg_testbench_defs;

	parameter DEBUG_ENABLE = 1;
	parameter CLK_PERIOD = 200ns; // clock period in ns
	parameter DATA_SIZE = 8; // Data size

	typedef enum {op_add, op_add_c, op_sub, op_sub_c, op_and, op_or, op_xor, op_cp,
	op_inc, op_dec, op_daa, op_rlca, op_rrca, op_rla, op_rra, op_cpl, op_ccf, op_scf } AluOperation;

	function reg[7:0] enum_to_op(AluOperation op);

		case(op)
			op_add:	enum_to_op = `OP_ADD;
			op_add_c: enum_to_op = `OP_ADDC;	
			op_sub: enum_to_op = `OP_SUB;	
			op_sub_c: enum_to_op = `OP_SUBC;
			op_and: enum_to_op = `OP_AND;
			op_xor: enum_to_op = `OP_XOR;
			op_or: enum_to_op = `OP_OR;
			op_cp: enum_to_op = `OP_CP;
			op_inc: enum_to_op = `OP_INC;
			op_dec: enum_to_op = `OP_DEC;
			op_daa: enum_to_op = `OP_DAA;
			op_rlca: enum_to_op = `OP_RLCA;
			op_rrca: enum_to_op = `OP_RRCA;
			op_rla: enum_to_op = `OP_RLA;
			op_rra: enum_to_op = `OP_RRA;
			op_cpl: enum_to_op = `OP_CPL;
			op_ccf: enum_to_op = `OP_CCF;
			op_scf: enum_to_op = `OP_SCF;
		endcase
	endfunction : enum_to_op


	// ## À Compléter. Les class pour l'encapsulation des cas de test
	class TestPacket;
		string 					name;

		function new(string name = "TestPacket");
			this.name = name;
		endfunction
	endclass

	class ResultPacket;
		string 					name;

		function new(string name = "ResultPacket");
			this.name = name;
		endfunction
	endclass

	// Utilisation de mailbox afin de faire voyager les packet de module en module
	//typedef mailbox #(ResultPacket) TestResultQueue;
	//typedef mailbox #(TestPacket) TestPacketQueue;
	

endpackage : pkg_testbench_defs