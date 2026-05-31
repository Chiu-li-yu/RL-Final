module TopModule (
    input clk,
    input in,
    input reset,
    output logic [7:0] out_byte,
    output logic done
);
    // The FSM states: IDLE, START (wait for start bit 0), DATA (receive 8 bits), STOP (wait for 1)
    localparam IDLE = 0, DATA = 1, STOP = 2, DONE = 3;
    logic [1:0] state, next_state;
    logic [7:0] data;
    logic [2:0] count;

    always_ff @(posedge clk) begin
        if (reset) state <= IDLE;
        else state <= next_state;
    end

    always_ff @(posedge clk) begin
        if (reset) begin
            data <= 8'b0;
            count <= 3'b0;
            done <= 1'b0;
            out_byte <= 8'b0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 1'b0;
                    count <= 3'b0;
                end
                DATA: begin
                    data <= {in, data[7:1]};
                    count <= count + 1'b1;
                end
                STOP: begin
                    if (in == 1'b1) begin
                        done <= 1'b1;
                        out_byte <= data;
                    end else begin
                        done <= 1'b0;
                    end
                end
                DONE: begin
                    done <= 1'b0;
                end
            endcase
        end
    end

    always @(*) begin
        case (state)
            IDLE: next_state = (in == 0) ? DATA : IDLE;
            DATA: next_state = (count == 3'd7) ? STOP : DATA;
            STOP: next_state = (in == 1) ? IDLE : STOP; // Wait for stop bit
            default: next_state = IDLE;
        endcase
    end
endmodule
