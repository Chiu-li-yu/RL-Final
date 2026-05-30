module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);
    logic [2:0] state;
    logic [2:0] prev_state;
    logic dfr_reg;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= 3'b000;
            prev_state <= 3'b000;
            dfr_reg <= 1'b1;
        end else if (s != state) begin
            prev_state <= state;
            state <= s;
            dfr_reg <= (state > s);
        end
    end

    assign fr2 = (state == 3'b000);
    assign fr1 = (state == 3'b000 || state == 3'b001);
    assign fr0 = (state == 3'b000 || state == 3'b001 || state == 3'b011);
    assign dfr = dfr_reg;
endmodule
