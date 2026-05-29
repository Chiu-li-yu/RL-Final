
module TopModule (
    input clk,
    input reset,
    input in,
    output logic disc,
    output logic flag,
    output logic err
);

    localparam S0 = 4'd0,
               S1 = 4'd1,
               S2 = 4'd2,
               S3 = 4'd3,
               S4 = 4'd4,
               S5 = 4'd5,
               S6 = 4'd6,
               S7 = 4'd7,
               S_DISC = 4'd8,
               S_FLAG = 4'd9;

    logic [3:0] state, next_state;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= S0;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        next_state = state;
        disc = 1'b0;
        flag = 1'b0;
        err = 1'b0;

        case (state)
            S0: begin
                next_state = in ? S1 : S0;
            end
            S1: begin
                next_state = in ? S2 : S0;
            end
            S2: begin
                next_state = in ? S3 : S0;
            end
            S3: begin
                next_state = in ? S4 : S0;
            end
            S4: begin
                next_state = in ? S5 : S0;
            end
            S5: begin
                next_state = in ? S6 : S_DISC;
            end
            S6: begin
                next_state = in ? S7 : S_FLAG;
            end
            S7: begin
                next_state = in ? S7 : S0;
                err = 1'b1;
            end
            S_DISC: begin
                next_state = in ? S1 : S0;
                disc = 1'b1;
            end
            S_FLAG: begin
                next_state = in ? S1 : S0;
                flag = 1'b1;
            end
            default: begin
                next_state = S0;
            end
        endcase
    end

endmodule
