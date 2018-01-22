//======================================================================================= 
// TITLE : Driver for Sharp LR35902 ALU
// DESCRIPTION : 
// 
// Breaks down the test packet from the Generator in operations understandable 
// by the Sharp LR35902 ALU
//
// FILE : Driver.sv
//======================================================================================= 
// CREATION 
// DATE AUTHOR PROJECT REVISION 
// 2015/07/27 Etienne Gauthier INF8500 Laboratoire 1 Automne 2015
//======================================================================================= 
// MODIFICATION HISTORY 
// DATE AUTHOR PROJECT REVISION COMMENTS 
//======================================================================================= 
package pkg_alu_driver;

`include "Sharp_LR35902_alu_opcodes.v"

import pkg_testbench_defs::*;


class Driver;

	virtual Interface_to_alu 	alu_interface;	// interface signal   
 			string    			name;			// unique identifier

			// TODO: Generator mailbox
			//TestPacketQueue in_box;

			reg [7 : 0]					op;                     
			reg [DATA_SIZE-1 : 0] 		operand_a;             
			reg [DATA_SIZE-1 : 0] 		operand_b;   
			reg 						flag_carry;
			reg							flag_zero;
			reg							flag_neg;
			reg 						flag_aux_carry;


	extern function new(string name = "Driver", virtual Interface_to_alu alu_interface);
  	extern task 	start();

endclass

function Driver::new(string name = "Driver",  virtual Interface_to_alu alu_interface);
	this.name = name;
	this.alu_interface = alu_interface;
endfunction


task Driver::start();

	
	int packets_sent = 0;

	reg [DATA_SIZE-1 : 0] 		result;   
	reg 						out_flag_carry;
	reg							out_flag_zero;
	reg							out_flag_neg;
	reg 						out_flag_aux_carry;

	$display ($time, " [DRIVER] Task Started");
	forever begin

		AluOperation op = op_add;

		this.op = enum_to_op(op);
		this.operand_a =  $urandom_range(255,0);
		this.operand_b = $urandom_range(255,0);

		this.flag_carry =  $urandom_range(1,0);
		this.flag_zero = $urandom_range(1,0);
		this.flag_neg =  $urandom_range(1,0);
		this.flag_aux_carry = $urandom_range(1,0);


		if(DEBUG_ENABLE) begin
			$display ($time, " [DRIVER] Sending OP: %s, OPERA: %b, OPERB: %b, CARRY: %b, ZERO: %b, NEG: %b, AUXCARRY: %b", 
				op.name(), this.operand_a, this.operand_b, this.flag_carry, this.flag_zero, this.flag_neg, this.flag_aux_carry);
		end
		
		// Send payload
		alu_interface.send_op(this.op, this.operand_a, this.operand_b, this.flag_carry, this.flag_zero, this.flag_neg, this.flag_aux_carry);
		
		packets_sent++;

		// Wait for signal to propagate
		alu_interface.wait_clk(1); 

	    // Read result
		alu_interface.read_op_result(result, out_flag_carry, out_flag_zero, out_flag_neg, out_flag_aux_carry);
		
		$display($time, " [DRIVER] RESULT: %b, FLAG_CARRY: %b, FLAG_ZERO: %b, FLAG_SUB: %b, FLAG_AUX_CARRY: %b", result, out_flag_carry, out_flag_zero, out_flag_neg, out_flag_aux_carry);

		if(packets_sent >= 5) begin
			break; // Exit loop
		end

	end //forever
	$display ($time,  " [DRIVER] Task finished");	

endtask

endpackage : pkg_alu_driver
