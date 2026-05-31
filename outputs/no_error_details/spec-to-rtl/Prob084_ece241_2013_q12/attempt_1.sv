module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);
    logic [7:0] q;
    logic [2:0] addr;

    assign addr = {A, B, C};

    always_ff @(posedge clk) begin
        if (enable) begin
            q <= {q[6:0], S};
        end
    end

    assign Z = q[addr];

endmodule
