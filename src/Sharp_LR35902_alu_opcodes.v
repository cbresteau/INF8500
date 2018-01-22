//======================================================================================= 
// TITLE : Sharp LR35902 alu opcodes
// DESCRIPTION : 
// Subeset of the Sharp LR35902 opcodes for ALU execution
//
// FILE : TestBenchDefs.sv
//======================================================================================= 
// CREATION 
// DATE AUTHOR PROJECT REVISION 
// 2015/07/27 Etienne Gauthier INF8500 Laboratoire 1 Automne 2015
//======================================================================================= 
// MODIFICATION HISTORY 
// DATE AUTHOR PROJECT REVISION COMMENTS 
//======================================================================================= 

`define OP_ADD 			8'b1x000xxx
`define OP_ADDC 		8'b1x001xxx
`define OP_SUB 			8'b1x010xxx
`define OP_SUBC 		8'b1x011xxx
`define OP_AND 			8'b1x100xxx
`define OP_XOR 			8'b1x101xxx
`define OP_OR 			8'b1x110xxx
`define OP_CP 			8'b1x111xxx
`define OP_INC 			8'b00xxx100
`define OP_DEC 			8'b00xxx101
`define OP_RLCA			8'b00000111
`define OP_RRCA			8'b00001111
`define OP_RLA 			8'b00010111
`define OP_RRA 			8'b00011111
`define OP_DAA 			8'b00100111
`define OP_CPL 			8'b00101111
`define OP_CCF 			8'b00111111
`define OP_SCF 			8'b00110111


