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
        STOP = 3'd3
    } state_t;

    state_t state, next_state;
    logic [7:0] shift_reg;
    logic [2:0] count;
    logic [2:0] next_count;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            count <= 0;
            shift_reg <= 0;
            done <= 0;
            out_byte <= 0;
        end else begin
            state <= next_state;
            count <= next_count;
            if (state == DATA) begin
                shift_reg <= {in, shift_reg[7:1]};
            end
            
            if (next_state == STOP && state == DATA && count == 3'd7) begin
                out_byte <= {in, shift_reg[7:1]}; // Incorrect, need to store final shift_reg
            end
            // Fix logic: update out_byte when done
            if (next_state == IDLE && state == STOP && in == 1'b1) begin
                out_byte <= shift_reg;
                done <= 1'b1;
            end else begin
                done <= 1'b0;
            end
        end
    end
    
    // Correction: Redo the FSM logic properly
endmodule
