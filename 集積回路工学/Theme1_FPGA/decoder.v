`include "dec_7seg.v"

module decoder(B, LED, HEX);
	input [3:0] B;
	output [3:0] LED;
	output [6:0] HEX;

	// Please write down your code!
	// dec_7segを子モジュールとしてインスタンス化
	// それぞれの信号を7セグメントLEDの発光パターンに変換
	dec_7seg dec_B(B, HEX);

	assign LED = B;
endmodule