module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output Q
);
    logic q_reg;
    
    // The problem asks to implement a submodule that acts as a D flip-flop 
    // with a 2:1 mux at the input. The flip-flop should capture the 
    // multiplexer output at the clock edge.
    // The previous attempt failed at t=5. This might be due to 
    // initial state or clock edge alignment.
    
    always_ff @(posedge clk) begin
        if (L)
            q_reg <= r_in;
        else
            q_reg <= q_in;
    end

    assign Q = q_reg;
endmodule
