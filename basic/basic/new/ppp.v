`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:55:36 11/24/2023 
// Design Name: 
// Module Name:    ppp 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module ppp(
    input clk,
    output [7:0] ins
    );
	 reg [4:0] addr;
mmblock mmblock (
  .clka(clka), // input clka
  .addra(addr), // input [2 : 0] addra
  .douta(ins) // output [7 : 0] douta
);

endmodule
