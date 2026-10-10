`timescale 1ns / 1ps

module alu_tb();
    wire [7:0] result;
    wire [8:0] flag;
    reg [7:0] a, b;
    reg [3:0] opcode;
    alu_main uut (.result(result),.flag(flag),.a(a),.b(b),.opcode(opcode)
    );
    initial begin
        #5; a = 8'h10; b = 8'h00; opcode = 4'h0;
        #5; a = 8'hBB; b = 8'h55; opcode = 4'h1;
        #5; a = 8'hBB; b = 8'h55; opcode = 4'h2;
        #5; a = 8'hBB; b = 8'h46; opcode = 4'h3;
        #5; a = 8'hAC; b = 8'hEF; opcode = 4'h4;
        #5; a = 8'hAB; b = 8'h45; opcode = 4'h5;
        #5; a = 8'h7F; b = 8'h45; opcode = 4'h6;
        #5; a = 8'h45; b = 8'h7F; opcode = 4'h7;
        #5; a = 8'hFF; b = 8'h00; opcode = 4'h8;
        #5; a = 8'h00; b = 8'h00; opcode = 4'h9;
        #5; a = 8'h76; b = 8'h00; opcode = 4'hA;
        #5; a = 8'hCD; b = 8'h00; opcode = 4'hB;
        #5; a = 8'hDD; b = 8'h00; opcode = 4'hC;
        #5; a = 8'hFD; b = 8'h00; opcode = 4'hD;
        #5; a = 8'hCD; b = 8'hFA; opcode = 4'hE;
        #5; a = 8'h55; b = 8'h55; opcode = 4'hF;
        #5; a = 8'h90; b = 8'h20; opcode = 4'hF;
        #5; a = 8'h10; b = 8'h80; opcode = 4'hF;
        #10;
        $finish;
    end
endmodule