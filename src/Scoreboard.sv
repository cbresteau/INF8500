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
// 2018/01/21 Etienne Gauthier Ajout du format de la classe Scoreboard
//=======================================================================================
package pkg_alu_scoreboard;

import pkg_testbench_defs::*;

class Scoreboard;
	string   			name;				// unique identifier


	TestPacketQueue mail_driver:
	TestPacketQueue mail_receiver;
	reg ADD; // Mod ici

	extern function new(string name = "Scoreboard", TestPacketQueue mail_driver, TestPacketQueue mail_receiver);//Mod ici
	extern task start();
	extern task check();
	extern task goldenModel();
	// ### À compléter ###

endclass

function Scoreboard::new(string name = "Scoreboard", TestPacketQueue mail_driver, TestPacketQueue mail_receiver); //Mod ici
	this.name =  name;
	this.mail_driver = mail_driver;
	this.mail_receiver = mail_receiver;
endfunction

task Scoreboard::start();

	$display ($time, " [SCOREBOARD] Task Started");

	// ### À compléter ###
endtask


task Scoreboard::goldenModel(mail_driver);

	$display(" Création du GoldenModel ")
	// Récupère les opérations telles quelles de l'UAL ou non ?? exemple pour ADD ??
	ADD = mail_driver.operand_a + mail_driver.operand_b;


endtask : goldenModel;


task Scoreboard::check();


	$display($time, "[SCOREBOARD -> CHECKROUTINE] OP: %s, OPERA: %b, OPERB: %b, CARRY %b, ZERO %b, NEG %b, AUX CARRY %b", test_op, test_operand_a, test_operand_b,
		test_flag_carry, test_flag_zero, test_flag_neg, test_flag_aux_carry );
	$display($time, "[SCOREBOARD -> CHECKROUTINE] Computed result: %b, received result: %b", computed_result, received_result );
	$display($time, "[SCOREBOARD -> CHECKROUTINE] Computed flag_carry: %b, received flag_carry: %b", computed_flag_carry, received_flag_carry );
	$display($time, "[SCOREBOARD -> CHECKROUTINE] Computed flag_zero: %b, received flag_zero: %b", computed_flag_zero, received_flag_zero );
	$display($time, "[SCOREBOARD -> CHECKROUTINE] Computed flag_sub: %b, received flag_sub: %b", computed_flag_sub, received_flag_sub );
	$display($time, "[SCOREBOARD -> CHECKROUTINE] Computed flag_aux_carry: %b, received flag_aux_carry: %b", computed_flag_aux_carry, received_flag_aux_carry );

	 Si erreur
	$error($time, "[SCOREBOARD -> CHECKROUTINE] Check failed, result received: %b .Expected %b", received_result, computed_result  );
	$error($time, "[SCOREBOARD -> CHECKROUTINE] Check failed, flag_carry received: %b .Expected %b", received_flag_carry, computed_flag_carry );
	$error($time, "[SCOREBOARD -> CHECKROUTINE] Check failed, flag_zero received: %b .Expected %b", received_flag_zero, computed_flag_zero);
	$error($time, "[SCOREBOARD -> CHECKROUTINE] Check failed, flag_sub received:  %b .Expected %b", received_flag_sub, computed_flag_sub );
	$error($time, "[SCOREBOARD -> CHECKROUTINE] Check failed, flag_aux_carry received: %b .Expected %b", received_flag_aux_carry, computed_flag_aux_carry );

endtask

endpackage : pkg_alu_scoreboard
