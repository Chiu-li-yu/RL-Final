module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output logic [23:0] out_bytes,
    output logic done
);
    // States:
    // 0: Search for byte 1 (in[3]==1)
    // 1: Received byte 1, searching for byte 2
    // 2: Received byte 2, searching for byte 3
    // 3: Received byte 3, now signal done and check if current byte is potential byte 1
    
    logic [7:0] byte1, byte2, byte3;
    logic [1:0] state;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= 0;
            byte1 <= 0; byte2 <= 0; byte3 <= 0;
            out_bytes <= 0;
            done <= 0;
        end else begin
            case (state)
                0: begin
                    done <= 0;
                    if (in[3]) begin
                        byte1 <= in;
                        state <= 1;
                    end
                end
                1: begin
                    byte2 <= in;
                    state <= 2;
                end
                2: begin
                    byte3 <= in;
                    out_bytes <= {byte1, byte2, in};
                    done <= 1;
                    state <= 3;
                end
                3: begin
                    done <= 0;
                    if (in[3]) begin
                        byte1 <= in;
                        state <= 1;
                    end else begin
                        state <= 0;
                    end
                end
            endcase
        end
    end
endmodule
