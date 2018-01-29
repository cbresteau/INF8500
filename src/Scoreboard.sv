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
	TestResultQueue mail_receiver;
	TestPacketQueue test;

	extern function new(string name = "Scoreboard", TestPacketQueue mail_driver, TestResultQueue mail_receiver);//Mod ici
	extern task start();
	extern task check();
	extern task goldenModel();
endclass

function Scoreboard::new(string name = "Scoreboard", TestPacketQueue mail_driver, TestResultQueue mail_receiver); //Mod ici
	this.name =  name;
	this.mail_driver = mail_driver;
	this.mail_receiver = mail_receiver;
endfunction

task Scoreboard::start();

	$display ($time, " [SCOREBOARD] Task Started");

	// ### À compléter ###
endtask


function Scoreboard::goldenModel(); // a verifier

	$display(" Création du GoldenModel ")

	// Récupère les opérations telles quelles de l'UAL ou non ?? exemple pour ADD ??
	case(op)
		op_add: this.test.op = this.mail_driver.operand_a + this.mail_driver.operand_b; // TODO Faire proporement
		op_add_c: if (this.mail_driver.flag_carry){
								this.test.op = this.mail_driver.operand_a + this.mail_driver.operand_b;
						 }
							else{
								 this.test.op = 0;
							 };
		op_sub: this.test.op = this.mail_driver.operand_a - this.mail_driver.operand_b;
		op_sub_c: if (this.mail_driver.flag_carry){
								this.test.op = this.mail_driver.operand_a - this.mail_driver.operand_b;
						 }
							else{
								 this.test.op = 0;
							 };
		op_and: {this.test.op = this.mail_driver.operand_a & this.mail_driver.operand_b;
						 this.test.flag_carry = 0;
						 this.test.flag_neg = 0;
						 this.test.flag_aux_carry = 1;
					 };
		op_xor: {this.test.op = this.mail_driver.operand_a ^ this.mail_driver.operand_b;
						 this.test.flag_carry = 0;
						 this.test.flag_neg = 0;
						 this.test.flag_aux_carry = 0;
					 };
		op_or: {this.test.op = this.mail_driver.operand_a | this.mail_driver.operand_b;
						 this.test.flag_carry = 0;
						 this.test.flag_neg = 0;
						 this.test.flag_aux_carry = 0;
					 };
		op_cp: { this.test.op =  this.mail_driver.operand_a - this.mail_driver.operand_b
			if(this.test.op == 0){
				this.test.flag_zero = 1;
			}
			else if ( this.test.op < 0 ){
				this.test.flag_neg = 1;
			}
		};
		op_inc: this.test.op = this.mail_driver.operand_b + 1;
		op_dec: this.test.op = this.mail_driver.operand_b - 1;
		op_daa: this.test.op = {if(this.mail_driver.flag_aux_carry == 1 || this.mail_driver.operand_a[3:0] > 9){
			this.test.flag_carry = 1;
			this.mail_driver.operand_a[3:0] = this.mail_driver.operand_a[3:0] + 6;
			this.mail_driver.operand_a[7:4] = this.mail_driver.operand_a[7:4] + 1;
			}
			if(this.mail_driver.flag_carry == 1 || this.mail_driver.operand_a[7:4] > 9){
				this.mail_driver.operand_a[7:4] = this.mail_driver.operand_a[7:4] + 6;
			}
			this.test.flag_aux_carry = 0;
		};
		op_rlca: {
			this.test.flag_carry = this.mail_driver.operand_a[7];
			this.test.op = this.mail_driver.operand_a <<< 1;
		};
		op_rrca: {
			this.test.flag_carry = this.mail_driver.operand_a[0];
			this.test.op = this.mail_driver.operand_a >>> 1;
		};
		op_rla: {
			if(this.mail_driver.operand_a[7] == 0){
			this.mail_driver.operand_a <<< 1;
			this.mail_driver.operand_a[0] = TestResultQueue.flag_carry;
			this.test.flag_carry = 0 ;
		}
		else{
			this.mail_driver.operand_a <<< 1;
			this.mail_driver.operand_a[0] = TestResultQueue.flag_carry;
			this.test.flag_carry = 1 ;
		}
		this.test.op = this.mail_driver.operand_a;
		};
		op_rra: {
			if(this.mail_driver.operand_a[0] == 0){
			this.mail_driver.operand_a >>> 1;
			this.mail_driver.operand_a[7] = TestResultQueue.flag_carry;
			this.test.flag_carry = 0 ;
		}
		else{
			this.mail_driver.operand_a >>> 1;
			this.mail_driver.operand_a[7] = TestResultQueue.flag_carry;
			this.test.flag_carry = 1 ;
		}
		this.test.op = this.mail_driver.operand_a;
		};
		op_cpl: {
			this.test.op = ~this.mail_driver.operand_a;
			// Erreur énoncé dans le carry flag qui reste id.
		};
		op_ccf: {this.test.op = ~this.mail_driver.flag_carry;
			this.test.flagcarry = ~this.mail_driver.flag_carry;
		};
		op_scf:{this.test.op = ~this.mail_driver.operand_a;
			this.test.flagcarry = 1;
			// Sortie pas importante seul le carry_flag importe
		};
	endcase

return this.test.op;

endfunction : goldenModel;


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
