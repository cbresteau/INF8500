//=======================================================================================
// TITLE :
// DESCRIPTION :
//
// FILE : TestProgram.sv
//=======================================================================================
// CREATION
// DATE AUTHOR PROJECT REVISION
// 2015/07/27 Etienne Gauthier INF8500 Laboratoire 1 Automne 2015
//=======================================================================================
// MODIFICATION HISTORY
// DATE AUTHOR PROJECT REVISION COMMENTS
//=======================================================================================
import pkg_testbench_defs::*;
import pkg_alu_driver::*;

program automatic TestProgram(Interface_to_alu alu_interface);

	// Déclaration des diver modules du testbench ici
	// Module generator
	// Module scoreboard
	// Module Receiver
	Driver     	drvr;		//  Module driver
	TestPacketQueue in_box; //Mod ici

	initial begin

      	// Instanciation des diver modules du testbench ici
      	// Generator
      	// Receiver
      	// Scoreboard
			in_box = new(); // Mod ici 
  		drvr = new("drvr[0]", alu_interface, in_box); // MOD ici

		$display ($time, "[START] Test starts.");

		fork : test
      			drvr.start();
		join_any;
		disable test;

		$display ($time, "[END] Test done.");

		$finish;
	end


endprogram
