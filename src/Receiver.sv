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
		
			// ### À compléter ###

   	extern function new(string name = "Receiver", virtual Interface_to_alu alu_interface);
   	extern task 	start();

endclass

function Receiver::new(string name = "Receiver", virtual Interface_to_alu alu_interface);
	this.name = name;
	this.alu_interface = alu_interface;

	// ### À compléter ###

endfunction

task Receiver::start();

	$display($time, " [RECEIVER] Task Started");

	// ### À compléter ###

	$display ($time, " [RECEIVER] Task finished");
endtask



endpackage : pkg_alu_receiver