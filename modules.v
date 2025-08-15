timescale 1ns / 1ps


module fifo(rst,ren,wen,wclk,rclk,wr_data,rd_data,full,empty,overflow,underflow);
  input ren,wen;
  input rst,wclk,rclk;
  parameter fifo_width = 8;
  parameter fifo_depth = 8;
  parameter address_size = 3;
  reg [address_size-1:0]rd_ptr,wr_ptr;
  input [fifo_width-1:0]wr_data;
  output reg [fifo_width-1:0]rd_data;
  output reg full;
  output reg empty;
  output reg overflow;
  output reg underflow;
  reg [address_size:0]rd_ptr_b2g;
  reg [address_size:0]wr_ptr_b2g;
  reg [address_size:0]rd_ptr_sy1, rd_ptr_sy2;
  reg [address_size:0]wr_ptr_sy1, wr_ptr_sy2;
  reg [address_size:0]wr_ptr_sy2_g2b,rd_ptr_sy2_g2b;
  reg [fifo_width-1:0]mem[fifo_depth-1:0];
  
 
  always @(*)
  begin
    if(rst) begin 
    rd_ptr<=0;
    wr_ptr<=0;
    underflow<=0;
     overflow<=0;
     full <=0;
     empty <=1;
    end
    
    end
  always @(posedge wclk)
    begin
          if(wen && !full)
          begin
          mem[wr_ptr]<=wr_data;
            wr_ptr<= wr_ptr+1;
           
            end
    end
  
  always @(posedge rclk)
    begin
          if(ren && !empty)
          begin
          rd_data<= mem[rd_ptr];
        rd_ptr <= rd_ptr+1;
          end
       
    end    
  
  always @(posedge rclk )
  begin
    empty<=(wr_ptr_sy2_g2b[address_size:0] == rd_ptr[address_size:0])?1:0;
       end
     
  
  always @(posedge wclk)
  begin
 
    full<=({~wr_ptr[address_size],wr_ptr[address_size-1:0]} == rd_ptr_sy2_g2b[address_size:0])?1:0;
      
     end
 
  always @(posedge rclk )
    begin 
      if(ren && empty)
        underflow <=1;
      else
        underflow<=0;
    end
  
  always @(posedge wclk or posedge rst)
    begin 
      if(wen && full)
        overflow <=1;
      else
        overflow<=0;
    end

  always @(*)
    begin 
  rd_ptr_b2g <= rd_ptr^(rd_ptr>>1);
  wr_ptr_b2g <= wr_ptr^(wr_ptr>>1);
    end
  
  always @(posedge wclk)
    begin 
      rd_ptr_sy1 <= rd_ptr_b2g;
      rd_ptr_sy2 <= rd_ptr_sy1;
    end
  
  always @(posedge rclk)
    begin 
      wr_ptr_sy1 <= wr_ptr_b2g;
      wr_ptr_sy2 <= wr_ptr_sy1;
    end
  integer i;
  always @(*)
        begin 
      wr_ptr_sy2_g2b[address_size] <= wr_ptr_sy2[address_size];
      
      for( i = address_size - 1 ; i>=0;i=i-1)
        wr_ptr_sy2_g2b[i] <= wr_ptr_sy2_g2b[i+1]^wr_ptr_sy2[i];
        end

  always @(*)
        begin 
      rd_ptr_sy2_g2b[address_size] <= rd_ptr_sy2[address_size];
      
      for(i= address_size - 1 ; i>=0;i = i-1)
        rd_ptr_sy2_g2b[i]<= rd_ptr_sy2_g2b[i+1]^rd_ptr_sy2[i];
       end
  
endmodule
