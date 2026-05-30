module TopModule (
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    logic [3:0] next_state_internal;
    logic out_internal;

    always @(*) begin
        case (state)
            4'b0001: begin // A
                next_state_internal = in ? 4'b0010 : 4'b0001;
                out_internal = 1'b0;
            end
            4'b0010: begin // B
                next_state_internal = in ? 4'b0010 : 4'b0100;
                out_internal = 1'b0;
            end
            4'b0100: begin // C
                next_state_internal = in ? 4'b1000 : 4'b0001;
                out_internal = 1'b0;
            end
            4'b1000: begin // D
                next_state_internal = in ? 4'b0010 : 4'b0100;
                out_internal = 1'b1;
            end
            default: begin
                next_state_internal = 4'b0001;
                out_internal = 1'b0;
            end
        endcase
    end

    assign next_state = next_state_internal;
    assign out = out_internal;

endmodule
