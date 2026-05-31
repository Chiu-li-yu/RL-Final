module TopModule (
    input clk,
    input a,
    output logic q
);
    logic [1:0] count;

    always_ff @(posedge clk) begin
        if (a == 1'b0) begin
            count <= 2'b0;
        end else begin
            if (count < 2'd2)
                count <= count + 1'b1;
        end
    end

    always_comb begin
        if (count < 2'd2)
            q = 1'b1;
        else
            q = 1'b0;
    end
endmodule
