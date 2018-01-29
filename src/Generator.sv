//=======================================================================================
// TITLE : Transactor for ALU test cases
// DESCRIPTION :
//
// Creates test cases for an ALU
//
// FILE : Generator.sv
//=======================================================================================
// CREATION
// DATE AUTHOR PROJECT REVISION
// 2015/07/28 Etienne Gauthier
//=======================================================================================
// MODIFICATION HISTORY
// DATE AUTHOR PROJECT REVISION COMMENTS
// 2018/01/21 Etienne Gauthier Ajout du format de la classe générateur
//=======================================================================================
package pkg_alu_generator;

import pkg_testbench_defs::*;

class Generator;
	string  		name;		// unique identifier
 TestPacketQueue	out_mail;
	// ### À compléter ###

	extern function new(string name = "Generator", TestPacketQueue out_mail);
	extern task 	start();
endclass

function Generator::new(string name = "Generator", TestPacketQueue out_mail);
	this.name = name;
	this.out_mail = out_mail;
endfunction


task Generator::start();


	$display(" Random Generation Started");


endtask

endpackage : pkg_alu_generator
