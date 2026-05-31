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
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            BYTE1: next_state = (in[3]) ? BYTE2 : BYTE1;
            BYTE2: next_state = BYTE3;
            BYTE3: next_state = (in[3]) ? BYTE2 : BYTE1;
            default: next_state = BYTE1;
        endcase
    end

    assign done = (state == BYTE3);

endmodule
