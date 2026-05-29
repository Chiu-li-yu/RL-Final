module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output logic [511:0] q
);

    logic [511:0] next_q;

    always @(*) begin
        for (int i = 0; i < 512; i++) begin
            logic l, c, r;
            c = q[i];
            l = (i == 511) ? 1'b0 : q[i+1];
            r = (i == 0) ? 1'b0 : q[i-1];
            next_q[i] = (c ^ r) | (~l & r);
        end
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule
