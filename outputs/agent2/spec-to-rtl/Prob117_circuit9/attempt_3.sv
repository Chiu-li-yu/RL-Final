module TopModule (
    input clk,
    input a,
    output logic [2:0] q
);

    always @(posedge clk) begin
        if (a) begin
            q <= 3'b100;
        end else begin
            // Behavior: 4->5->6->0->1...
            // If we are at 4 and a=0, go to 5.
            // If we are at 6 and a=0, go to 0.
            // If we are at 7 and a=0, should it go to 0 or 1?
            // Spec: 6->0->1
            if (q == 3'b110)
                q <= 3'b000;
            else if (q == 3'b111)
                q <= 3'b000;
            else
                q <= q + 1'b1;
        end
    end

endmodule