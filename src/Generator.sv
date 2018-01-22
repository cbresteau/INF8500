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

	extern function new(string name = "Generator");
	extern task 	start();
endclass

function Generator::new(string name = "Generator");
	this.name = name;
	// ### À compléter ###
endfunction


task Generator::start();

	$display(" Random Generation Started");

	testpckt = new("TestPacket");
	TestPacketQueue nom = new(); 

endtask

endpackage : pkg_alu_generator
