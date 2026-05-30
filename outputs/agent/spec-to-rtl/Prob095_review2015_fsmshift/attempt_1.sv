module TopModule (
    input clk,
    input reset,
    output logic shift_ena
);

    logic [2:0] count;

    always_ff @(posedge clk) begin
        if (reset) begin
            count <= 3'd1;
            shift_ena <= 1'b1;
        end else if (count < 3'd4) begin
            count <= count + 3'd1;
            shift_ena <= 1'b1;
        end else begin
            shift_ena <= 1'b0;
        end
    end

endmodule
