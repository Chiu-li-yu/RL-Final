
module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output shift_ena,
    output counting,
    output done
);

    localparam S_IDLE  = 3'd0;
    localparam S_1     = 3'd1;
    localparam S_11    = 3'd2;
    localparam S_110   = 3'd3;
    localparam S_SHIFT = 3'd4;
    localparam S_COUNT = 3'd5;
    localparam S_DONE  = 3'd6;

    logic [2:0] state, next_state;
    logic [2:0] count;

    always @(posedge clk) begin
        if (reset) begin
            state <= S_IDLE;
            count <= 3'd0;
        end else begin
            state <= next_state;
            if (state == S_SHIFT) begin
                count <= count + 3'd1;
            end else begin
                count <= 3'd0;
            end
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            S_IDLE: begin
                if (data == 1'b1) next_state = S_1;
                else next_state = S_IDLE;
            end
            S_1: begin
                if (data == 1'b1) next_state = S_11;
                else next_state = S_IDLE;
            end
            S_11: begin
                if (data == 1'b0) next_state = S_110;
                else next_state = S_11;
            end
            S_110: begin
                if (data == 1'b1) next_state = S_SHIFT;
                else next_state = S_IDLE;
            end
            S_SHIFT: begin
                if (count == 3'd3) next_state = S_COUNT;
                else next_state = S_SHIFT;
            end
            S_COUNT: begin
                if (done_counting == 1'b1) next_state = S_DONE;
                else next_state = S_COUNT;
            end
            S_DONE: begin
                if (ack == 1'b1) next_state = S_IDLE;
                else next_state = S_DONE;
            end
            default: next_state = S_IDLE;
        endcase
    end

    assign shift_ena = (state == S_SHIFT);
    assign counting = (state == S_COUNT);
    assign done = (state == S_DONE);

endmodule
