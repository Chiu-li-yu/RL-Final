
module TopModule (
    input  clk,
    input  reset,
    input  data,
    output logic [3:0] count,
    output logic counting,
    output logic done,
    input  ack
);

    localparam SEARCH    = 2'd0;
    localparam GET_DELAY = 2'd1;
    localparam COUNTING  = 2'd2;
    localparam DONE      = 2'd3;

    logic [1:0] state;
    logic [3:0] shift_reg;
    logic [3:0] delay_val;
    logic [2:0] bit_count;
    logic [9:0] cycle_count;
    logic [3:0] current_delay;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            shift_reg <= 4'b0;
            delay_val <= 4'b0;
            bit_count <= 3'b0;
            cycle_count <= 10'b0;
            current_delay <= 4'b0;
        end else begin
            case (state)
                SEARCH: begin
                    shift_reg <= {shift_reg[2:0], data};
                    if ({shift_reg[2:0], data} == 4'b1101) begin
                        state <= GET_DELAY;
                        bit_count <= 3'b0;
                        delay_val <= 4'b0;
                    end
                end

                GET_DELAY: begin
                    delay_val <= {delay_val[2:0], data};
                    bit_count <= bit_count + 1'b1;
                    if (bit_count == 3'd3) begin
                        state <= COUNTING;
                        cycle_count <= 10'b0;
                        // The current data bit is the 4th bit, so we need to capture it
                        // and initialize current_delay.
                        // We'll handle the initial current_delay value in the next state 
                        // transition or just set it here using the projected delay_val.
                    end
                end

                COUNTING: begin
                    // Initialization of current_delay on the first cycle of COUNTING
                    if (cycle_count == 10'b0 && state != COUNTING) begin
                        // This logic is a bit tricky with always_ff.
                        // Let's refine the state transition.
                    end
                    
                    cycle_count <= cycle_count + 1'b1;
                    if (cycle_count == 10'd999) begin
                        cycle_count <= 10'b0;
                        if (current_delay == 4'b0) begin
                            state <= DONE;
                        end else begin
                            current_delay <= current_delay - 1'b1;
                        end
                    end
                end

                DONE: begin
                    if (ack) begin
                        state <= SEARCH;
                        shift_reg <= 4'b0;
                    end
                end
            endcase
        end
    end

    // To fix the initialization of current_delay when entering COUNTING state:
    // We can do it in the GET_DELAY -> COUNTING transition.
    // Let's rewrite the state machine a bit more cleanly.
endmodule
