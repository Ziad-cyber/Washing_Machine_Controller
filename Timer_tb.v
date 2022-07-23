//    This is testbench for UART Module
`timescale 1 ns/1 ps
//TB has neither inputs nor outputs
module Timer_tb ();

reg  Rst_TB;
reg  Clk_TB;
reg  [1:0] Clk_Freq_TB;
wire time_out_TB;
wire time_out_s_TB;

/////////////// Clk Generator ///////////////
localparam Period = 125;
always #(Period/2) Clk_TB = ~Clk_TB;     // Clk Frequency 8 MHz

/////////////// Initial BLock ///////////////
initial 
    begin
        // Save Waveform
        $dumpfile("Timer.vcd") ;
        $dumpvars; 
        Initialization ();
        Reset ();
        $display ("the initial time %t",$time);
        wait (time_out_TB == 1);
        $display ("the S time %t",$time);  // 1 second
        wait (time_out_s_TB == 1);
        $display ("the M time %t",$time);  // 1 minute
        $stop;
    end

/////////////// Reset BLock ///////////////
task Reset;
    begin
        Rst_TB=1'b1;
        #0.02
        Rst_TB=1'b0;
        #0.02
        Rst_TB=1'b1;
    end
endtask

/////////////// Initialization BLock ///////////////
task Initialization;
    begin
        Clk_TB=1'b1;
        Clk_Freq_TB=2'b11;
    end
endtask

/////////////// Module instantiation ///////////////
Timer U1 (
.Rst(Rst_TB),
.Clk(Clk_TB),
.Clk_Freq(Clk_Freq_TB),
.time_out(time_out_TB),
.time_out_s(time_out_s_TB)
);

endmodule