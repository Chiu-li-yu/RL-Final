module TopModule(
    input a,
    input b,
    input c,
    input d,
    input e,
    output logic [24:0] out
);
    logic [4:0] inputs;
    assign inputs = {a, b, c, d, e};

    always @(*) begin
        out[24] = ~(inputs[4] ^ inputs[4]);
        out[23] = ~(inputs[4] ^ inputs[3]);
        out[22] = ~(inputs[4] ^ inputs[2]);
        out[21] = ~(inputs[4] ^ inputs[1]);
        out[20] = ~(inputs[4] ^ inputs[0]);
        
        out[19] = ~(inputs[3] ^ inputs[4]);
        out[18] = ~(inputs[3] ^ inputs[3]);
        out[17] = ~(inputs[3] ^ inputs[2]);
        out[16] = ~(inputs[3] ^ inputs[1]);
        out[15] = ~(inputs[3] ^ inputs[0]);
        
        out[14] = ~(inputs[2] ^ inputs[4]);
        out[13] = ~(inputs[2] ^ inputs[3]);
        out[12] = ~(inputs[2] ^ inputs[2]);
        out[11] = ~(inputs[2] ^ inputs[1]);
        out[10] = ~(inputs[2] ^ inputs[0]);
        
        out[9]  = ~(inputs[1] ^ inputs[4]);
        out[8]  = ~(inputs[1] ^ inputs[3]);
        out[7]  = ~(inputs[1] ^ inputs[2]);
        out[6]  = ~(inputs[1] ^ inputs[1]);
        out[5]  = ~(inputs[1] ^ inputs[0]);
        
        out[4]  = ~(inputs[0] ^ inputs[4]);
        out[3]  = ~(inputs[0] ^ inputs[3]);
        out[2]  = ~(inputs[0] ^ inputs[2]);
        out[1]  = ~(inputs[0] ^ inputs[1]);
        out[0]  = ~(inputs[0] ^ inputs[0]);
    end
endmodule
