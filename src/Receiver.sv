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

			TestResultQueue out_box;
			ResultPacket result_pkt;

   	extern function new(string name = "Receiver", virtual Interface_to_alu alu_interface, TestResultQueue out_box);
   	extern task 	start();

endclass

function Receiver::new(string name = "Receiver", virtual Interface_to_alu alu_interface, TestResultQueue out_box);
	this.name = name;
	this.alu_interface = alu_interface;
	this.out_box.put(out_box) ;
	this.result_pkt = out_box.get(1);
	// ### À compléter ###

endfunction

task Receiver::start();

	$display($time, " [RECEIVER] Task Started");

	this.alu_interface.wait_clk(1);

	// Read result
	this.alu_interface.read_op_result(result_pkt.result, result_pkt.flag_carry, result_pkt.flag_zero, result_pkt.flag_neg, result_pkt.flag_aux_carry);
	// MOD ICI same as driver

	// les OUT de alu_interface sont possiblement pas definit correctement.
	// voir s'il faut pas plutot utiliser result_pkt
	ResultPacket out_mail = new("out_mail", this.alu_interface.out_op, this.alu_interface.out_result, this.alu_interface.out_flag_carry, this.alu_interface.out_flag_zero, this.alu_interface.out_flag_neg, this.alu_interface.out_flag_aux_carry);

	$display ($time, " [RECEIVER] Task finished");
endtask



endpackage : pkg_alu_receiver
