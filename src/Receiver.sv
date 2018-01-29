//=======================================================================================
// TITLE : Result receiver for Sharp LR35902 ALU
// DESCRIPTION :
//
// Read result from the Sharp LR35902 ALU each clock cycle and send result packet to scoreboard
//
// FILE : Receiver.sv
//=======================================================================================
// CREATION
// DATE AUTHOR PROJECT REVISION
// 2015/07/28 Etienne Gauthier
//=======================================================================================
// MODIFICATION HISTORY
// DATE AUTHOR PROJECT REVISION COMMENTS
// 2018/01/21 Etienne Gauthier Ajout du format de la classe Receiver
//=======================================================================================
package pkg_alu_receiver;

import pkg_testbench_defs::*;

class Receiver;
	// interface signals
	virtual Interface_to_alu		alu_interface;

			// unique identifier
			string   				name;

			TestResultQueue result_mailbox

   	extern function new(string name = "Receiver", virtual Interface_to_alu alu_interface, TestResultQueue result_mailbox);
   	extern task 	start();

endclass

function Receiver::new(string name = "Receiver", virtual Interface_to_alu alu_interface, TestResultQueue result_mailbox);
	this.name = name;
	this.alu_interface = alu_interface;
	this.result_mailbox = result_mailbox ; // Mod ici

	// ### À compléter ###

endfunction

task Receiver::start();

	$display($time, " [RECEIVER] Task Started");

	alu_interface.wait_clk(1);

		// Read result
	alu_interface.read_op_result(result, out_flag_carry, out_flag_zero, out_flag_neg, out_flag_aux_carry);
	// MOD ICI same as driver

	ResultPacket out_mail = new()

	$display ($time, " [RECEIVER] Task finished");
endtask



endpackage : pkg_alu_receiver
