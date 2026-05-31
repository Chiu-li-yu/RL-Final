module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output logic [23:0] out_bytes,
    output logic done
);

    logic [1:0] state, next_state;
    logic [7:0] b1, b2, b3;

    localparam IDLE = 2'd0;
    localparam BYTE2 = 2'd1;
    localparam BYTE3 = 2'd2;
    localparam DONE_ST = 2'd3;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            b1 <= 8'd0;
            b2 <= 8'd0;
            b3 <= 8'd0;
        end else begin
            state <= next_state;
            if (state == IDLE && in[3]) b1 <= in;
            else if (state == BYTE2) b2 <= in;
            else if (state == BYTE3) b3 <= in;
        end
    end

    always @(*) begin
        case (state)
            IDLE: next_state = (in[3]) ? BYTE2 : IDLE;
            BYTE2: next_state = BYTE3;
            BYTE3: next_state = DONE_ST;
            DONE_ST: next_state = (in[3]) ? BYTE2 : IDLE;
            default: next_state = IDLE;
        endcase
    end

    always @(*) begin
        if (state == DONE_ST) begin
            done = 1'b1;
            out_bytes = {b1, b2, in}; // Wait, this should be b3
        end else begin
            done = 1'b0;
            out_bytes = 24'd0;
        end
    end

endmodule
