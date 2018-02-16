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
import pkg_alu_generator::*;
import pkg_alu_scoreboard::*;
import pkg_alu_receiver::*;


program automatic TestProgram(Interface_to_alu alu_interface);

	// Initialisation of the communication channel
	TestPacketQueue mail1 			= new();
	TestPacketQueue mail2 			= new();
	TestResultQueue mail3 			= new();

	// Initialisation of the test classes
	Driver     		drvr;
	Receiver 			rcvr;
	Generator 		gen;
	Scoreboard 		board;


	initial begin
      	// Instanciation des diver modules du testbench ici
      	// Generator
      	// Receiver
      	// Scoreboard

		drvr 	= new("drvr[0]",	alu_interface, mail1, mail2);
		rcvr 	= new("rcrv[0]" , 	alu_interface, mail3);
		gen 	= new("gen[0]", 	mail1);
		board 	= new("board[0]", 	alu_interface, mail2, mail3);

		covergroup cover_group;
		// a mon avis cest faut
			coverpoint uart_cfg.parity;
		endgroup

		// cg = new ()
		$display ($time, "[START] Test starts.");

		fork : test
      			drvr.start();
						rcvr.start();
						gen.start();
						board.start();
		join_any;
		disable test;

		$display ($time, "[END] Test done.");

		$finish;
	end


endprogram
