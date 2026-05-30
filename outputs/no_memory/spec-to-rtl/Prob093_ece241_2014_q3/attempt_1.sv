module TopModule (
    input c,
    input d,
    output logic [3:0] mux_in
);
    // Based on K-map analysis:
    // When ab=00, f = c|d
    // When ab=01, f = 0
    // When ab=11, f = c&d
    // When ab=10, f = ~d

    assign mux_in[0] = (c | d); // ab=00
    assign mux_in[1] = 1'b0;    // ab=01
    assign mux_in[2] = (~d);    // ab=10
    assign mux_in[3] = (c & d); // ab=11

endmodule
