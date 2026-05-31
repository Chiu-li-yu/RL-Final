module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output done
);

    logic [1:0] state;
    logic [1:0] next_state;
    logic done_q;

    // States: 
    // 00: Search for first byte (in[3] == 1)
    // 01: Received 1st byte, waiting for 2nd
    // 10: Received 2nd byte, waiting for 3rd
    // 11: Received 3rd byte (done signal)

    always @(*) begin
        next_state = state;
        case (state)
            2'b00: begin
                if (in[3])
                    next_state = 2'b01;
                else
                    next_state = 2'b00;
            end
            2'b01: next_state = 2'b10;
            2'b10: next_state = 2'b11;
            2'b11: begin
                if (in[3])
                    next_state = 2'b01;
                else
                    next_state = 2'b00;
            end
            default: next_state = 2'b00;
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b00;
            done_q <= 1'b0;
        end else begin
            state <= next_state;
            if (state == 2'b10)
                done_q <= 1'b1;
            else
                done_q <= 1'b0;
        end
    end

    assign done = done_q;

endmodule
