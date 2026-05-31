module TopModule(
    input clk,
    input reset,
    output logic shift_ena
);

    logic [2:0] count;
    logic active;

    always @(posedge clk) begin
        if (reset) begin
            count <= 3'd0;
            active <= 1'b1;
        end else if (active) begin
            if (count < 3'd3) begin
                count <= count + 1'b1;
                active <= 1'b1;
            end else begin
                active <= 1'b0;
            end
        end
    end

    always @(*) begin
        shift_ena = active;
    end

endmodule