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
`include "Sharp_LR35902_alu_opcodes.v"
package pkg_alu_scoreboard;
import pkg_testbench_defs::*;

class Scoreboard;
	string   			name;				// unique identifier

	virtual Interface_to_alu 	alu_interface;			// interface signal

	// Il nous faut au moins les queues pour lier le module au reste
	TestPacketQueue 	mail_driver;
	TestResultQueue 	mail_receiver;

	TestPacket 		test_driver;
	ResultPacket 		result_receiver;
	ResultPacket 		result_golden;

covergroup cover_group;
	cov_OP: coverpoint this.test_driver.op{
		bins binOP_add 		= {op_add};
		bins binOP_addc 	= {op_add_c};
		bins binOP_sub 		= {op_sub};
		bins binOP_subc 	= {op_sub_c};
		bins binOP_and 		= {op_and};
		bins binOP_xor 		= {op_xor};
		bins binOP_or 		= {op_or};
		bins binOP_cp 		= {op_cp};
		bins binOP_inc 		= {op_inc};
		bins binOP_dec 		= {op_dec};
		bins binOP_daa 		= {op_daa};
		bins binOP_rlca 	= {op_rlca};
		bins binOP_rrca 	= {op_rrca};
		bins binOP_rla 		= {op_rla};
		bins binOP_rra 		= {op_rra};
		bins binOP_cpl 		= {op_cpl};
		bins binOP_ccf 		= {op_ccf};
		bins binOP_scf 		= {op_scf};
	}
	cov_OPA: coverpoint this.test_driver.operand_a{
		bins opA1 = {8'b1};
		bins opA2 = {8'b10};
		bins opA4 = {8'b100};
		bins opA8 = {8'b1000};
		bins opA16 = {8'b10000};
		bins opA32 = {8'b100000};
		bins opA64 = {8'b1000000};
		bins opA128 = {8'b10000000};
		bins opA_al = {8'b?1?????1}; //wildcard ? Ajout de tests aléatoires comme demandé
	}
	cov_OPB: coverpoint this.test_driver.operand_b{
		bins opB1 = {8'b1};
		bins opB2 = {8'b10};
		bins opB4 = {8'b100};
		bins opB8 = {8'b1000};
		bins opB16 = {8'b10000};
		bins opB32 = {8'b100000};
		bins opB64 = {8'b1000000};
		bins opB128 = {8'b10000000};
	}
	cov_flagC: coverpoint this.test_driver.flag_carry{
		bins C_0 = {0};
		bins C_1 = {1};
	}
	cov_flagN: coverpoint this.test_driver.flag_neg{
		bins N_0 = {0};
		bins N_1 = {1};
	}
	cov_flagZ: coverpoint this.test_driver.flag_zero{
		bins Z_0 = {0};
		bins Z_1 = {1};
	}
	cov_flagAuxC: coverpoint this.test_driver.flag_aux_carry{
		bins AC_0 = {0};
		bins AC_1 = {1};
	}

	crossADD: cross cov_OP, cov_OPA, cov_OPB{
		bins add = binsof(cov_OP.binOP_add);
		bins ope = binsof(cov_OPA) && binsof(cov_OPB);
		//ignore_bins c_add = ! binsof(cov_OP.binOP_add);// intersect{cov_OPA, cov_OPB};
	}

	crossADDC: cross cov_OP, cov_OPA, cov_OPB, cov_flagC{
		bins c_addc1  = binsof(cov_OP.binOP_addc) && binsof(cov_flagC.C_0) && binsof(cov_OPB.opB1);
		bins
		//ignore_bins c_addc  = ! binsof(cov_OP.binOP_addc); // Inclure directement les bins qu'on veut tester
		//ignore_bins c_flag0 =  ! binsof(cov_flagC.C_0);
		//ignore_bins c_opB   =  ! binsof(cov_OPB.opB1);
	}

	crossADDC_2: cross cov_OP, cov_OPA, cov_OPB, cov_flagC{
		ignore_bins c_addc  = ! binsof(cov_OP.binOP_addc);
		ignore_bins c_flag1 =  ! binsof(cov_flagC.C_1);
		ignore_bins c_opA   =  ! binsof(cov_OPA.opA1);
	}

//	crossSUB: cross cov_OP, cov_OPA, cov_OPB{
//		ignore_bins c_sub = ! binsof(cov_OP.binOP_sub);
//	}


endgroup

	extern function new(string name = "Scoreboard", virtual Interface_to_alu alu_interface, TestPacketQueue mail_driver, TestResultQueue mail_receiver);//Mod ici
	extern task start();
	extern task check(input TestPacket test_driver, input ResultPacket result_golden, input ResultPacket result_receiver);
	extern task goldenModel(input TestPacket test_driver, output ResultPacket result_golden);
endclass

function Scoreboard::new(string name = "Scoreboard", virtual Interface_to_alu alu_interface, TestPacketQueue mail_driver, TestResultQueue mail_receiver); //Mod ici
	this.name =  name;
	this.alu_interface = alu_interface;

	// On affecte les queues, on travaille sur les paquets dans le start
	this.mail_driver = mail_driver;
	this.mail_receiver = mail_receiver;
	//this.test_mail_driver = mail_driver.get(1);
	//this.test_mail_receiver = mail_receiver.get(1);
	//this.test = new("test", this.test_mail_driver.result, this.test_mail_driver.flag_carry,
	//	this.test_mail_driver.flag_zero, this.test_mail_driver.flag_neg, this.test_mail_driver.flag_aux_carry);
endfunction



task Scoreboard::start();
	$display ($time, " [SCOREBOARD] Task Started");

	// Iteration sur la taille des queues
	forever begin
		// Faire un test sur la taille de la liste de test
		// Il faudrait aussi rajouter une facon d'attendre qu'il y ai quelque chose dans les listes

		// Wait for signal to propagate
		alu_interface.wait_clk(1);

		// Resultat du test pour le golden model
		this.test_driver = this.mail_driver.get(1);
		goldenModel(test_driver, this.result_golden);

		// Resultat du test pour l'UAL
		this.result_receiver = this.mail_receiver.get(1);

		//Comparaison des deux resultats
		check(this.test_driver, this.result_golden, this.result_receiver);

	end //forever

	$display ($time,  " [SCOREBOARD] Task finished");
endtask


task Scoreboard::goldenModel(input TestPacket test_driver, output ResultPacket result_golden); // a verifier
	reg 				result;
	reg 				flag_carry;
	reg				flag_zero;
	reg				flag_neg;
	reg 				flag_aux_carry;

	$display(" Création du GoldenModel ");

	// Récupère les opérations telles quelles de l'UAL ou non ?? exemple pour ADD ?

	case(test_driver.op) // pas le bon "op"
		op_add: begin
			result_golden.result = test_driver.operand_a + test_driver.operand_b;// TODO Faire proporement
		end

		op_add_c: begin
			if (test_driver.flag_carry)
				result_golden.result = test_driver.operand_a + test_driver.operand_b;
			else
				result_golden.result = 0;
		end

		op_sub: begin
			result_golden.result = test_driver.operand_a - test_driver.operand_b;
		end

		op_sub_c: begin
			if (test_driver.flag_carry)
				result_golden.result = test_driver.operand_a - test_driver.operand_b;
			else
				result_golden.result = 0;
		end

		op_and: begin
			result_golden.result = test_driver.operand_a & test_driver.operand_b;
			result_golden.flag_carry = 0;
			result_golden.flag_neg = 0;
			result_golden.flag_aux_carry = 1;
		end

		op_xor: begin
			result_golden.result = test_driver.operand_a ^ test_driver.operand_b;
			result_golden.flag_carry = 0;
			result_golden.flag_neg = 0;
			result_golden.flag_aux_carry = 0;
		end

		op_or: begin
			result_golden.result = test_driver.operand_a | test_driver.operand_b;
			result_golden.flag_carry = 0;
			result_golden.flag_neg = 0;
			result_golden.flag_aux_carry = 0;
		end

		op_cp: begin
			result_golden.result =  test_driver.operand_a - test_driver.operand_b;
			if(result_golden.result == 0)
				result_golden.flag_zero = 1;
			else if ( result_golden.result < 0 )
				result_golden.flag_neg = 1;
		end

		op_inc: begin
			result_golden.result = test_driver.operand_b + 1;
		end

		op_dec: begin
			result_golden.result = test_driver.operand_b - 1;
		end

		op_daa: begin
			if(test_driver.flag_aux_carry == 1 || test_driver.operand_a[3:0] > 9)
				result_golden.flag_carry = 1;
				result_golden.result[3:0] = test_driver.operand_a[3:0] + 6;
				result_golden.result[7:4] = test_driver.operand_a[7:4] + 1;
			if(test_driver.flag_carry == 1 || test_driver.operand_a[7:4] > 9)
				result_golden.result[7:4] = test_driver.operand_a[7:4] + 6;
			result_golden.flag_aux_carry = 0;
		end

		op_rlca: begin
			result_golden.flag_carry = test_driver.operand_a[7];
			result_golden.result = test_driver.operand_a <<< 1;
		end

		op_rrca: begin
			result_golden.flag_carry = test_driver.operand_a[0];
			result_golden.result = test_driver.operand_a >>> 1;
		end

		op_rla: begin
			if(test_driver.operand_a[7] == 0)
				begin
					result_golden.result = test_driver.operand_a <<< 1;
					result_golden.result[0] = test_driver.flag_carry;
					result_golden.flag_carry = 0 ;
				end
			else
				begin
					result_golden.result = test_driver.operand_a <<< 1;
					result_golden.result[0] = test_driver.flag_carry;
					result_golden.flag_carry = 1 ;
				end
		end
		op_rra: begin
			if(test_driver.operand_a[0] == 0)
				begin
					result_golden.result = test_driver.operand_a >>> 1;
					result_golden.result[7] = test_driver.flag_carry;
					result_golden.flag_carry = 0 ;
				end
			else
				begin
					result_golden.result = test_driver.operand_a >>> 1;
					result_golden.result[7] = test_driver.flag_carry;
					result_golden.flag_carry = 1 ;
				end
		end

		op_cpl: begin
			result_golden.result = ~test_driver.operand_a;
			// Erreur enonce dans le carry flag qui reste id.
		end
		op_ccf: begin
			result_golden.result = ~test_driver.flag_carry;
			result_golden.flag_carry = ~test_driver.flag_carry;
		end

		op_scf: begin
			result_golden.result = ~test_driver.operand_a;
			result_golden.flag_carry = 1;
			// Sortie pas importante seul le carry_flag importe
		end
	endcase

endtask : goldenModel;


task Scoreboard::check(input TestPacket test_driver, input ResultPacket result_golden, input ResultPacket result_receiver);


	$display($time, "[SCOREBOARD -> CHECKROUTINE] OP: %s, OPERA: %b, OPERB: %b, CARRY %b, ZERO %b, NEG %b, AUX CARRY %b", test_driver.op, test_driver.operand_a, test_driver.operand_b,
		test_driver.flag_carry, test_driver.flag_zero, test_driver.flag_neg, test_driver.flag_aux_carry );
	$display($time, "[SCOREBOARD -> CHECKROUTINE] Computed result: %b, received result: %b", 		result_golden.result , result_receiver.result );
	$display($time, "[SCOREBOARD -> CHECKROUTINE] Computed flag_carry: %b, received flag_carry: %b", 	result_golden.flag_carry, result_receiver.flag_carry );
	$display($time, "[SCOREBOARD -> CHECKROUTINE] Computed flag_zero: %b, received flag_zero: %b", 		result_golden.flag_zero, result_receiver.flag_zero );
	$display($time, "[SCOREBOARD -> CHECKROUTINE] Computed flag_neg: %b, received flag_neg: %b", 		result_golden.flag_neg, result_receiver.flag_neg );
	$display($time, "[SCOREBOARD -> CHECKROUTINE] Computed flag_aux_carry: %b, received flag_aux_carry: %b", result_golden.flag_aux_carry, result_receiver.flag_aux_carry );

	// Rajouter une condition
	 //Si erreur
	$error($time, "[SCOREBOARD -> CHECKROUTINE] Check failed, result received: %b .Expected %b", 		result_receiver.result, result_golden.result  );
	$error($time, "[SCOREBOARD -> CHECKROUTINE] Check failed, flag_carry received: %b .Expected %b", 	result_receiver.flag_carry, result_golden.flag_carry );
	$error($time, "[SCOREBOARD -> CHECKROUTINE] Check failed, flag_zero received: %b .Expected %b", 	result_receiver.flag_zero, result_golden.flag_zero);
	$error($time, "[SCOREBOARD -> CHECKROUTINE] Check failed, flag_sub received:  %b .Expected %b", 	result_receiver.flag_neg, result_golden.flag_neg );
	$error($time, "[SCOREBOARD -> CHECKROUTINE] Check failed, flag_aux_carry received: %b .Expected %b", 	result_receiver.flag_aux_carry, result_golden.flag_aux_carry );

endtask


endpackage : pkg_alu_scoreboard
