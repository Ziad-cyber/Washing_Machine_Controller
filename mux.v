/*
-----this module for choosing the clk
*/
module mux (
input wire a,
input wire b,
input wire c,
input wire d,
input wire [1:0] sel,
output reg mux_out
);

always @ (*)
    begin
        case (sel) 
            2'b00: mux_out = a;
            2'b01: mux_out = b;
            2'b10: mux_out = c;
            2'b11: mux_out = d;
        endcase
    end

endmodule