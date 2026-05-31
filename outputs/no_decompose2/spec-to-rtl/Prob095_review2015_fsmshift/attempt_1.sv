module TopModule (
    input clk,
    input reset,
    output shift_ena
);
    logic [2:0] count;
    logic shift_ena_r;

    assign shift_ena = shift_ena_r;

    always_ff @(posedge clk) begin
        if (reset) begin
            count <= 3'd1;
            shift_ena_r <= 1'b1;
        end else if (count < 3'd4) begin
            count <= count + 1'b1;
            shift_ena_r <= 1'b1;
        end else begin
            shift_ena_r <= 1'b0;
        end
    end
endmodule
