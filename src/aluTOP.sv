//======================================================================================= 
// TITLE : TestBench Top module for Sharp LR35902 ALU
// DESCRIPTION : 
// Sharp_LR35902_alu  instancitation and connection to the interface
//
// FILE : aluTOP.sv
//======================================================================================= 
// CREATION 
// DATE AUTHOR PROJECT REVISION 
// 2015/07/27 Etienne Gauthier INF8500 Laboratoire 1 Automne 2015
//======================================================================================= 
// MODIFICATION HISTORY 
// DATE AUTHOR PROJECT REVISION COMMENTS 
//======================================================================================= 


module aluTOP(Interface_to_alu bfm);

 Sharp_LR35902_alu alu ( // make an instance
    .in_op(bfm.in_op), 
    .in_oper_a(bfm.in_oper_a), 
    .in_oper_b(bfm.in_oper_b),
    .in_flag_carry(bfm.in_flag_carry),
    .in_flag_zero(bfm.in_flag_zero),
    .in_flag_neg(bfm.in_flag_neg),
    .in_flag_aux_carry(bfm.in_flag_aux_carry), 
    .out_result(bfm.out_result),
    .out_flag_carry(bfm.out_flag_carry), 
    .out_flag_zero(bfm.out_flag_zero), 
    .out_flag_neg(bfm.out_flag_neg), 
    .out_flag_aux_carry(bfm.out_flag_aux_carry)
    );

endmodule : aluTOP
