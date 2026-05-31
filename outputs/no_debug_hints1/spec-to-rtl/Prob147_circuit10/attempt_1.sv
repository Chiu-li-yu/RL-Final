module TopModule(
    input clk,
    input a,
    input b,
    output logic q,
    output logic state
);

    // 根據波形分析：
    // state 變化：
    // 65ns: state(65ns) = 0, a=1, b=1 -> state(75ns) = 1
    // 75ns: state(75ns) = 1, a=0, b=0 -> state(85ns) = 0
    // 85ns: state(85ns) = 0, a=1, b=1 -> state(95ns) = 1
    // 95ns: state(95ns) = 1, a=1, b=1 -> state(115ns) = 1
    // 115ns: state(115ns) = 1, a=1, b=0 -> state(125ns) = 1
    // 125ns: state(125ns) = 1, a=0, b=1 -> state(135ns) = 1
    // 135ns: state(135ns) = 1, a=0, b=0 -> state(145ns) = 0
    // 觀察可得: next_state = (a & b) | (state & (a | b))
    
    // q 變化：
    // q = a ^ b ^ state

    logic next_state;

    always @(*) begin
        next_state = (a & b) | (state & (a | b));
        q = a ^ b ^ state;
    end

    always @(posedge clk) begin
        state <= next_state;
    end

endmodule