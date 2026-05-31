module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);
    // Let's use a simple case statement to check if the logic is correct
    // F(a,b,c,d) = 1 if 2, 7, 15
    // F(a,b,c,d) = 0 if 0, 1, 4, 5, 6, 9, 10, 13, 14
    
    logic f;
    always_comb begin
        if ({a,b,c,d} == 4'd2 || {a,b,c,d} == 4'd7 || {a,b,c,d} == 4'd15) f = 1;
        else if ({a,b,c,d} == 4'd0 || {a,b,c,d} == 4'd1 || {a,b,c,d} == 4'd4 || {a,b,c,d} == 4'd5 || 
                 {a,b,c,d} == 4'd6 || {a,b,c,d} == 4'd9 || {a,b,c,d} == 4'd10 || {a,b,c,d} == 4'd13 || {a,b,c,d} == 4'd14) f = 0;
        else f = 1'bx;
    end
    
    assign out_sop = f;
    assign out_pos = f;
endmodule
