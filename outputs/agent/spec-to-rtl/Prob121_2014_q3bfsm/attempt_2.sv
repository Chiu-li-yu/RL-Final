
module TopModule (
    input clk,
    input reset,
    input x,
    output logic z
);

    localparam S0 = 3'b000;
    localparam S1 = 3'b001;
    localparam S2 = 3'b010;
    localparam S3 = 3'b011;
    localparam S4 = 3'b100;

    logic [2:0] state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        next_state = state;
        z = 1'b0;
        case (state)
            S0: begin
                z = 1'b0;
                next_state = x ? S1 : S0;
            end
            S1: begin
                z = 1'b0;
                next_state = x ? S4 : S1;
            end
            S2: begin
                z = 1'b0;
                next_state = x ? S1 : S2;
            end
            S3: begin
                z = 1'b1;
                next_state = x ? S2 : S1;
            end
            S4: begin
                z = 1'b1;
                next_state = x ? S4 : S3;
            end
            default: begin
                z = 1'b0;
                next_state = S0;
            end
        endcase
    end

endmodule
