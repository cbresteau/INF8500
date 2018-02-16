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
	// unique identifier
	string   				name;
	
	// interface signals
	virtual Interface_to_alu		alu_interface;
	TestResultQueue 			out_box;


   	extern function new(string name = "Receiver", virtual Interface_to_alu alu_interface, TestResultQueue out_box);
   	extern task 	start();
endclass

function Receiver::new(string name = "Receiver", virtual Interface_to_alu alu_interface, TestResultQueue out_box);
	this.name 		= name;
	this.alu_interface 	= alu_interface;
	this.out_box 		= out_box;
	// Pas mettre qqch dans 'this.result_pkt' parce que c'est la sortie de l'interface

endfunction

task Receiver::start();

	int packets_sent = 0;

	// Futur parametre du test packet qui va etre ajoute
	reg [DATA_SIZE-1 : 0] 		result;
	reg 				out_flag_carry;
	reg				out_flag_zero;
	reg				out_flag_neg;
	reg 				out_flag_aux_carry;
	ResultPacket 			out_mail;


	$display ($time, " [RECEIVER] Task Started");
	forever begin
		//Comment on sort de la loop ?

		// Wait for signal to propagate
		this.alu_interface.wait_clk(1);

		// Read result
		this.alu_interface.read_op_result(result, out_flag_carry, out_flag_zero, out_flag_neg, out_flag_aux_carry);
		// MOD ICI same as driver

		// les OUT de alu_interface sont possiblement pas definit correctement.
		// voir s'il faut pas plutot utiliser result_pkt
		
		out_mail = new("out_mail",result, out_flag_carry, out_flag_zero, out_flag_neg, out_flag_aux_carry);
		this.out_box.put(out_mail);

		$display($time, " [RECEIVER] RESULT: %b, FLAG_CARRY: %b, FLAG_ZERO: %b, FLAG_SUB: %b, FLAG_AUX_CARRY: %b", result, out_flag_carry, out_flag_zero, out_flag_neg, out_flag_aux_carry);

		if(packets_sent >= 5) begin
			break; // Exit loop
		end

	end //forever
	$display ($time,  " [RECEIVER] Task finished");

endtask



endpackage : pkg_alu_receiver
