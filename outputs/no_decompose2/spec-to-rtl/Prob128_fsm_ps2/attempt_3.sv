module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output logic done
);

    localparam BYTE1 = 2'd0;
    localparam BYTE2 = 2'd1;
    localparam BYTE3 = 2'd2;

    logic [1:0] state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            state <= BYTE1;
            done <= 1'b0;
        end else begin
            state <= next_state;
            if (next_state == BYTE1 && state == BYTE3)
                done <= 1'b1;
            else
                done <= 1'b0;
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            BYTE1: begin
                if (in[3])
                    next_state = BYTE2;
                else
                    next_state = BYTE1;
            end
            BYTE2: begin
                next_state = BYTE3;
            end
            BYTE3: begin
                if (in[3])
                    next_state = BYTE2;
                else
                    next_state = BYTE1;
            end
        endcase
    end
endmodule
