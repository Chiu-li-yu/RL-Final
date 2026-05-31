module TopModule (
    input clk,
    input in,
    input reset,
    output logic [7:0] out_byte,
    output logic done
);

    typedef enum logic [2:0] {
        IDLE = 3'd0,
        START = 3'd1,
        DATA = 3'd2,
        STOP = 3'd3,
        DONE = 3'd4
    } state_t;

    state_t state, next_state;
    logic [7:0] shift_reg;
    logic [2:0] bit_count;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 8'b0;
            bit_count <= 3'd0;
            out_byte <= 8'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            if (state == DATA) begin
                shift_reg <= {in, shift_reg[7:1]};
                bit_count <= bit_count + 1'b1;
            end else if (state == IDLE) begin
                bit_count <= 3'd0;
            end
            
            if (next_state == DONE) begin
                out_byte <= {in, shift_reg[7:1]}; // This needs to be carefully handled
                // Wait, let's adjust the logic: data is captured in DATA state.
            end
        end
    end

    // Correcting the logic
    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 8'b0;
            bit_count <= 3'd0;
            out_byte <= 8'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            case (state)
                IDLE: begin
                    done <= 1'b0;
                    if (in == 1'b0) begin
                        bit_count <= 3'd0;
                    end
                end
                DATA: begin
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count + 1'b1;
                end
                DONE: begin
                    out_byte <= shift_reg;
                    done <= 1'b1;
                end
            endcase
        end
    end

    always_comb begin
        next_state = state;
        case (state)
            IDLE: next_state = (in == 1'b0) ? START : IDLE;
            START: next_state = DATA;
            DATA: next_state = (bit_count == 3'd7) ? STOP : DATA;
            STOP: next_state = (in == 1'b1) ? DONE : STOP;
            DONE: next_state = IDLE;
        endcase
    end
endmodule
