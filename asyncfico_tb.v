`timescale 1ns / 1ps


module fifo_tb();

  
  reg ren, wen;
  reg rst, wclk, rclk;
  reg [7:0] wr_data; 

  wire [7:0] rd_data;
  wire full, empty, overflow, underflow;

  
  fifo dut (
    .rst(rst),
    .ren(ren),
    .wen(wen),
    .wclk(wclk),
    .rclk(rclk),
    .wr_data(wr_data),
    .rd_data(rd_data),
    .full(full),
    .empty(empty),
    .overflow(overflow),
    .underflow(underflow)
  );
initial begin 
rst = 1'b1;
ren = 1'b1;
wen = 1'b1;
wclk = 0;
rclk = 0;
wr_data = 8'b10001111;
#50 rst = 1'b0;
#60 wr_data = 8'b11111111;
#100 wr_data = 8'b11111001;
#150 wr_data = 8'b11100001;
#200 wr_data = 8'b11111001;
#250 wr_data = 8'b01111001;
#300 wr_data = 8'b00111001;
#400 wr_data = 8'b11111011;
 #1000 $stop;
 end

always begin 
#10 wclk = ~wclk;
end
always begin
#20 rclk = ~rclk;
end
initial 
begin
  $dumpfile("dump.vcd");
$dumpvars;

end
endmodule
