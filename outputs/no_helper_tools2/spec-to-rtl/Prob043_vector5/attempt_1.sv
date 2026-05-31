module TopModule(
    input a,
    input b,
    input c,
    input d,
    input e,
    output [24:0] out
);
    logic [4:0] inputs;
    assign inputs = {a, b, c, d, e};

    always @(*) begin
        // out[24] = a==a, out[23] = a==b, ..., out[0] = e==e
        // Row 0: a compared with a, b, c, d, e (out[24:20])
        // Row 1: b compared with a, b, c, d, e (out[19:15])
        // Row 2: c compared with a, b, c, d, e (out[14:10])
        // Row 3: d compared with a, b, c, d, e (out[9:5])
        // Row 4: e compared with a, b, c, d, e (out[4:0])
        
        // Equation: out = ~(A ^ B) which is equal to A == B
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
