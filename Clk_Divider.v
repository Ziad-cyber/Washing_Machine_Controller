module Clk_Divider (
input  wire RST ,
input  wire Clk ,
//input  wire [1:0] Clk_Freq,
output reg  Clk_8MHz,
output reg  Clk_4MHz,
output reg  Clk_2MHz,
output reg  Clk_1MHz
);

reg [3:0] Counter;

always @ (posedge Clk or negedge RST)
begin
    if (!RST) 
        Counter <= 4'b0;
    else 
        Counter <= Counter + 1'b1;
end

always @ (*)
begin
            Clk_8MHz =Counter [0];
            Clk_4MHz =Counter [1];
            Clk_2MHz =Counter [2];
            Clk_1MHz =Counter [3];
end

endmodule