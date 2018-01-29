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
	mailbox #(TestPacket) mail1 = new();
	mailbox #(TestPacket) mail2 = new();
	mailbox #(ResultPacket) mail3 = new();
	Driver     	drvr;		//  Module driver
	Receiver rcrv;
	Generator gen;
	Scoreboard board;


	initial begin

      	// Instanciation des diver modules du testbench ici
      	// Generator
      	// Receiver
      	// Scoreboard

  		drvr = new("drvr[0]", alu_interface, mail1, mail2); // MOD ici
			rcvr = new("rcrv[0]" , alu_interface, mail3);
			gen = new("gen[0]", mail1);
			board = new("board[0]", alu_interface, mail2, mail3); 

		$display ($time, "[START] Test starts.");

		fork : test
      			drvr.start();
		join_any;
		disable test;

		$display ($time, "[END] Test done.");

		$finish;
	end


endprogram
