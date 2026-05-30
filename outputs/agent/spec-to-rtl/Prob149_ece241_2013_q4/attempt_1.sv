module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    logic [2:0] current_s;
    logic [2:0] prev_s;
    logic reg_fr2, reg_fr1, reg_fr0, reg_dfr;

    assign fr2 = reg_fr2;
    assign fr1 = reg_fr1;
    assign fr0 = reg_fr0;
    assign dfr = reg_dfr;

    always_ff @(posedge clk) begin
        if (reset) begin
            current_s <= 3'b000;
            prev_s <= 3'b000;
        end else if (s != current_s) begin
            prev_s <= current_s;
            current_s <= s;
        end
    end

    always @(*) begin
        // Nominal Flow Rates based on current_s
        case (current_s)
            3'b111: {reg_fr2, reg_fr1, reg_fr0} = 3'b000;
            3'b011: {reg_fr2, reg_fr1, reg_fr0} = 3'b001;
            3'b001: {reg_fr2, reg_fr1, reg_fr0} = 3'b011;
            3'b000: {reg_fr2, reg_fr1, reg_fr0} = 3'b111;
            default: {reg_fr2, reg_fr1, reg_fr0} = 3'b111;
        endcase

        // Supplemental flow dfr
        if (reset) begin
            reg_dfr = 1'b1;
        end else if (prev_s > current_s) begin
            reg_dfr = 1'b1;
        end else begin
            reg_dfr = 1'b0;
        end
    end

endmodule
