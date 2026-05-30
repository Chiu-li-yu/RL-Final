module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output logic [23:0] out_bytes,
    output logic done
);

    typedef enum logic [1:0] {
        IDLE = 2'b00,
        BYTE2 = 2'b01,
        BYTE3 = 2'b10
    } state_t;

    logic [1:0] state, next_state;
    logic [23:0] buffer, next_buffer;
    logic next_done;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            buffer <= 24'b0;
            done <= 1'b0;
            out_bytes <= 24'b0;
        end else begin
            state <= next_state;
            buffer <= next_buffer;
            done <= next_done;
            if (next_done) begin
                out_bytes <= next_buffer;
            end
        end
    end

    always @(*) begin
        next_state = state;
        next_buffer = buffer;
        next_done = 1'b0;

        case (state)
            IDLE: begin
                if (in[3]) begin
                    next_buffer[23:16] = in;
                    next_state = BYTE2;
                end
            end
            BYTE2: begin
                next_buffer[15:8] = in;
                next_state = BYTE3;
            end
            BYTE3: begin
                next_buffer[7:0] = in;
                next_done = 1'b1;
                next_state = IDLE;
            end
        endcase
    end
endmodule