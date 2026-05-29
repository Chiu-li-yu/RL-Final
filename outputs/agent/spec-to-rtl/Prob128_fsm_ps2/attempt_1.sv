module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output logic done
);

    localparam S_SEARCH = 2'd0;
    localparam S_BYTE2  = 2'd1;
    localparam S_BYTE3  = 2'd2;
    localparam S_DONE   = 2'd3;

    logic [1:0] state, next_state;

    always @(*) begin
        case (state)
            S_SEARCH: begin
                if (in[3]) next_state = S_BYTE2;
                else       next_state = S_SEARCH;
            end
            S_BYTE2: begin
                next_state = S_BYTE3;
            end
            S_BYTE3: begin
                next_state = S_DONE;
            end
            S_DONE: begin
                if (in[3]) next_state = S_BYTE2;
                else       next_state = S_SEARCH;
            end
            default: next_state = S_SEARCH;
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= S_SEARCH;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        done = (state == S_DONE);
    end

endmodule
