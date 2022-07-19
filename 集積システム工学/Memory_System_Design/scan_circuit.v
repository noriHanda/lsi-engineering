module three_by_three_scan(clk, s00, s01, s02, s10, s11, s12, s20, s21, s22);
	input clk;
	output s00, s01, s02, s10, s11, s12, s20, s21, s22;

	reg x0, x1, x2, y0, y1, y2;
	initial x0 = 1;
	initial x1 = 0;
	initial x2 = 0;
	initial y0 = 1;
	initial y1 = 0;
	initial y2 = 0;

	always @(posedge clk) begin
		y0 <= y2;
		y1 <= y0;
		y2 <= y1;
			
		if (x2 == 1) begin
			x0 <= x2;
			x1 <= x0;
			x2 <= x1;
		end
	end

	assign s00 = (x0 && y0) ? 1 : 0;
	assign s01 = (x1 && y0) ? 1 : 0;
	assign s02 = (x2 && y0) ? 1 : 0;
	assign s10 = (x0 && y1) ? 1 : 0;
	assign s11 = (x1 && y1) ? 1 : 0;
	assign s12 = (x2 && y1) ? 1 : 0;
	assign s20 = (x0 && y2) ? 1 : 0;
	assign s21 = (x1 && y2) ? 1 : 0;
	assign s22 = (x2 && y2) ? 1 : 0;

endmodule