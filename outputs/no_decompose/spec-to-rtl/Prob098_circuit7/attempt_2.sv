module TopModule(
    input clk,
    input a,
    output logic q
);

    logic q_int;
    initial q_int = 0; // Assuming initial state is 0 for q based on the problem

    always_ff @(posedge clk) begin
        if (a == 0)
            q_int <= 1;
        else
            q_int <= ~q_int;
    end

    assign q = q_int;

endmodule
