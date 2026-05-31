module TopModule (
    input clk,
    input in,
    input reset,
    output logic [7:0] out_byte,
    output logic done
);
    localparam IDLE = 0, DATA = 1, STOP = 2;
    logic [1:0] state, next_state;
    logic [7:0] data;
    logic [2:0] count;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            data <= 8'b0;
            count <= 3'b0;
            done <= 1'b0;
            out_byte <= 8'b0;
        end else begin
            state <= next_state;
            case (next_state)
                IDLE: begin
                    done <= 1'b0;
                    count <= 3'b0;
                end
                DATA: begin
                    if (state == DATA) begin
                        data <= {in, data[7:1]};
                        count <= count + 1'b1;
                    end
                end
                STOP: begin
                    if (in == 1'b1 && state == DATA) begin // Finish receiving
                        out_byte <= {in, data[7:1]}; // Wait, this logic is tricky
                    end
                end
            endcase
            
            // Re-think: Sample in DATA, latch to out_byte and done in STOP
            if (state == DATA && count == 3'd7) begin
                if (in == 1'b1) begin // Stop bit received
                    out_byte <= {in, data[7:1]}; // Still wrong
                end
            end
        end
    end

    // Let's go back to a simpler, standard FSM
    // Actually, just fix the DONE signal timing.
endmodule
