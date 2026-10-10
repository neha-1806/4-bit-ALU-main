`timescale 1ns / 1ps

module alu_main(
    input [7:0] a,b,
    input [3:0] opcode,
    output reg [7:0] result,
    output reg [8:0] flag
    );
    parameter 
    NOT=4'h0,
    OR=4'h1,
    AND=4'h2,
    NAND=4'h3,
    NOR=4'h4,
    XNOR=4'h5,
    ADD=4'h6,
    SUB=4'h7,
    INC=4'h8,
    DEC=4'h9,
    SL=4'ha,
    SR=4'hb,
    RL=4'hc,
    RR=4'hd,
    COMP=4'he;
    
    // flag declearation
//    flag[0]=zero
//    flag[1]=carry
//    flag[2]=borrow
//    flag[3]=overflow
//    flag[4]=negative
//    flag[5]=parity
//    flag[6]=equal
//    flag[7]=greater
//    flag[8]=less
    //
    reg [8:0] temp;
    always @(*)
    begin
    result=8'b00000000;
    flag=9'b000000000;
    temp=9'b000000000;
    case (opcode)
    NOT     : begin 
                result = ~(a);
              end
    OR      : begin
                result = a|b;
              end
    AND     : begin
                result = a&b ;
              end
    NAND    : begin
                result = ~(a&b);
              end
    NOR     : begin
                result = ~(a|b);
              end
    XNOR    : begin
                result = ~(a^b);
              end
    ADD     : begin
                temp=a+b;
                result = temp[7:0];
                flag[1]=temp[8];
                flag[3] = (a[7] == b[7]) && (result[7] != a[7]); // overflow
              end
    SUB     : begin
                result = a-b;
                flag[2]= (a<b); //borrow
                flag[3] = (a[7] != b[7]) && (result[7] != a[7]); //overflow
              end
    INC     : begin 
                temp = a+1;
                result = temp[7:0];
                flag[1]=temp[8]; //carry
                flag[3]=(a==8'b01111111); //+127+1 overflow
              end
    DEC     : begin
                result = a - 1;
                flag[2] = (a == 8'b00000000); //borrow
                flag[3]=(a==8'b10000000); //overflow
              end
    SL      : begin
                result = a<<1;
                flag[1]=a[7];
              end
    SR      : begin
                result = a>>1;
                flag[1] = a[0];
              end
    RL      : begin 
                result = {a[6:0],a[7]};
                flag[1] = a[7];
              end
    RR      : begin
                result = {a[0],a[7:1]};
                flag[1] = a[0];
              end
    COMP    : begin 
                result=8'h00; 
              end
    default: begin
                result = 8'b00000000;
            end
    endcase
   
    //for zero flag
    if(result==0)
        flag[0]=1;
    else 
        flag[0]=0;
    if(result[7]==1)
        flag[4]=1;
    else
        flag[4]=0;
    //parity
    flag[5]= ~(^result);
    //equal
    if(a==b)
        flag[6]=1;
    else 
        flag[6]=0;
    //greater
    if(a>b)
        flag[7]=1;
    else 
        flag[7]=0;
    //less
    if(a<b)
        flag[8]=1;
    else 
        flag[8]=0;
    end
endmodule
