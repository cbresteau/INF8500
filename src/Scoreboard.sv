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

	// test 		: sortie du calcul du goldenModel
	// mail_driver 		: entree du goldenModel et sert pour les calculs pour test
	// mail_receiver	: entree a comparer avec les valeurs de test
	TestPacketQueue mail_driver;
	TestResultQueue mail_receiver;
	TestResultQueue test;

	extern function new(string name = "Scoreboard", TestPacketQueue mail_driver, TestResultQueue mail_receiver);//Mod ici
	extern task start();
	extern task check();
	extern task goldenModel();
endclass

function Scoreboard::new(string name = "Scoreboard", TestPacketQueue mail_driver, TestResultQueue mail_receiver); //Mod ici
	this.name =  name;
	this.mail_driver = mail_driver;
	this.mail_receiver = mail_receiver;
	this.test = new();
endfunction

task Scoreboard::start();

	$display ($time, " [SCOREBOARD] Task Started");

	// ### À compléte ###

endtask


task Scoreboard::goldenModel(); // a verifier

	$display(" Création du GoldenModel ");

	// Récupère les opérations telles quelles de l'UAL ou non ?? exemple pour ADD ?

	case(this.mail_driver.op) // pas le bon "op"
		op_add: begin
			this.test.result = this.mail_driver.operand_a + this.mail_driver.operand_b;// TODO Faire proporement
		end

		op_add_c: begin
			if (this.mail_driver.flag_carry)
				this.test.result = this.mail_driver.operand_a + this.mail_driver.operand_b;
			else
				this.test.result = 0;
		end

		op_sub: begin
			this.test.result = this.mail_driver.operand_a - this.mail_driver.operand_b;
		end

		op_sub_c: begin
			if (this.mail_driver.flag_carry)
				this.test.result = this.mail_driver.operand_a - this.mail_driver.operand_b;
			else
				this.test.result = 0;
		end

		op_and: begin
			this.test.result = this.mail_driver.operand_a & this.mail_driver.operand_b;
			this.test.flag_carry = 0;
			this.test.flag_neg = 0;
			this.test.flag_aux_carry = 1;
		end

		op_xor: begin
			this.test.result = this.mail_driver.operand_a ^ this.mail_driver.operand_b;
			this.test.flag_carry = 0;
			this.test.flag_neg = 0;
			this.test.flag_aux_carry = 0;
		end

		op_or: begin
			this.test.result = this.mail_driver.operand_a | this.mail_driver.operand_b;
			this.test.flag_carry = 0;
			this.test.flag_neg = 0;
			this.test.flag_aux_carry = 0;
		end

		op_cp: begin
			this.test.result =  this.mail_driver.operand_a - this.mail_driver.operand_b;
			if(this.test.result == 0)
				this.test.flag_zero = 1;
			else if ( this.test.result < 0 )
				this.test.flag_neg = 1;
		end

		op_inc: begin
			this.test.result = this.mail_driver.operand_b + 1;
		end

		op_dec: begin
			this.test.result = this.mail_driver.operand_b - 1;
		end

		op_daa: begin
			if(this.mail_driver.flag_aux_carry == 1 || this.mail_driver.operand_a[3:0] > 9)
				this.test.flag_carry = 1;
				this.test.result[3:0] = this.mail_driver.operand_a[3:0] + 6;
				this.test.result[7:4] = this.mail_driver.operand_a[7:4] + 1;
			if(this.mail_driver.flag_carry == 1 || this.mail_driver.operand_a[7:4] > 9)
				this.test.result[7:4] = this.mail_driver.operand_a[7:4] + 6;
			this.test.flag_aux_carry = 0;
		end

		op_rlca: begin
			this.test.flag_carry = this.mail_driver.operand_a[7];
			this.test.result = this.mail_driver.operand_a <<< 1;
		end

		op_rrca: begin
			this.test.flag_carry = this.mail_driver.operand_a[0];
			this.test.result = this.mail_driver.operand_a >>> 1;
		end

		op_rla: begin
			if(this.mail_driver.operand_a[7] == 0)
				begin
					this.test.result = this.mail_driver.operand_a <<< 1;
					this.test.result[0] = this.mail_driver.flag_carry;
					this.test.flag_carry = 0 ;
				end
			else
				begin
					this.test.result = this.mail_driver.operand_a <<< 1;
					this.test.result[0] = this.mail_driver.flag_carry;
					this.test.flag_carry = 1 ;
				end
		end
		op_rra: begin
			if(this.mail_driver.operand_a[0] == 0)
				begin
					this.test.result = this.mail_driver.operand_a >>> 1;
					this.test.result[7] = this.mail_driver.flag_carry;
					this.test.flag_carry = 0 ;
				end
			else
				begin
					this.test.result = this.mail_driver.operand_a >>> 1;
					this.test.result[7] = this.mail_driver.flag_carry;
					this.test.flag_carry = 1 ;
				end
		end

		op_cpl: begin
			this.test.result = ~this.mail_driver.operand_a;
			// Erreur enonce dans le carry flag qui reste id.
		end
		op_ccf: begin
			this.test.result = ~this.mail_driver.flag_carry;
			this.test.flagcarry = ~this.mail_driver.flag_carry;
		end

		op_scf: begin
			this.test.result = ~this.mail_driver.operand_a;
			this.test.flagcarry = 1;
			// Sortie pas importante seul le carry_flag importe
		end
	endcase

// return this.test.op; pas de return dans les tasks

endtask : goldenModel;


task Scoreboard::check();


	$display($time, "[SCOREBOARD -> CHECKROUTINE] OP: %s, OPERA: %b, OPERB: %b, CARRY %b, ZERO %b, NEG %b, AUX CARRY %b", this.test.op, this.test.operand_a, this.test.operand_b,
		this.test.flag_carry, this.test.flag_zero, this.test.flag_neg, this.test.flag_aux_carry );
	$display($time, "[SCOREBOARD -> CHECKROUTINE] Computed result: %b, received result: %b", this.test.op , this.mail_receiver.op );
	$display($time, "[SCOREBOARD -> CHECKROUTINE] Computed flag_carry: %b, received flag_carry: %b", this.test.flag_carry, this.mail_receiver.flag_carry );
	$display($time, "[SCOREBOARD -> CHECKROUTINE] Computed flag_zero: %b, received flag_zero: %b", this.test.flag_zero, this.mail_receiver.flag_zero );
	$display($time, "[SCOREBOARD -> CHECKROUTINE] Computed flag_sub: %b, received flag_sub: %b", this.test.flag_sub, this.mail_receiver.flag_sub );
	$display($time, "[SCOREBOARD -> CHECKROUTINE] Computed flag_aux_carry: %b, received flag_aux_carry: %b", this.test.flag_aux_carry, this.mail_receiver.flag_aux_carry );

	 //Si erreur
	$error($time, "[SCOREBOARD -> CHECKROUTINE] Check failed, result received: %b .Expected %b", this.mail_receiver.op, this.test.op  );
	$error($time, "[SCOREBOARD -> CHECKROUTINE] Check failed, flag_carry received: %b .Expected %b", this.mail_receiver.flag_carry, this.test.flag_carry );
	$error($time, "[SCOREBOARD -> CHECKROUTINE] Check failed, flag_zero received: %b .Expected %b", this.mail_receiver.flag_zero, this.test.flag_zero);
	$error($time, "[SCOREBOARD -> CHECKROUTINE] Check failed, flag_sub received:  %b .Expected %b", this.mail_receiver.flag_sub, this.test.flag_sub );
	$error($time, "[SCOREBOARD -> CHECKROUTINE] Check failed, flag_aux_carry received: %b .Expected %b", this.mail_receiver.flag_aux_carry, this.test.flag_aux_carry );

endtask

endpackage : pkg_alu_scoreboard
