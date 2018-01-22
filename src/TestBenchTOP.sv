//======================================================================================= 
// TITLE : Top module for testbench execution
// DESCRIPTION : 
//
// FILE : TestBenchTOP.sv
//======================================================================================= 
// CREATION 
// DATE AUTHOR PROJECT REVISION 
// 2015/07/27 Etienne Gauthier INF8500 Laboratoire 1 Automne 2015
//======================================================================================= 
// MODIFICATION HISTORY 
// DATE AUTHOR PROJECT REVISION COMMENTS 
//======================================================================================= 
module TestBenchTOP;
	
	import pkg_testbench_defs::*;

	// Clock signal
	bit  clock = 1;
	
	// Inteface to DUT
	Interface_to_alu alu_interface(clock);

	// Creation of the DUT and assignment of the interface previously declared
	aluTOP dut(alu_interface);
	
	// Instantiation of the test program that controls the behavior of interfaces
	TestProgram test_prgm(alu_interface);  
 	
  	//!!! Instanciation et connection du module Monitor ici

	always begin : Clock_Generator
		#(CLK_PERIOD/2) clock = ~clock;
	end

endmodule : TestBenchTOP