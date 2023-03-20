module PluseDection(
		input 	clk				,       	
		input 	in_sig			,	
		output 	out_sig			,	
		output 	pos_sig			,	
		output  ext_pos_sig		,
		output 	neg_sig			,
		output  ext_neg_sig	
	);
		
reg[1:0] in_sig_r;

reg   		[9:0]		rPosSig	=0;
reg   		[9:0]		rNegSig =0;

always @(posedge clk)
	in_sig_r <= {in_sig_r[0],in_sig};


always@(posedge clk)
begin
	rPosSig<={rPosSig[8:0],pos_sig};
	rNegSig<={rNegSig[8:0],neg_sig};
end



assign pos_sig = ~in_sig_r[1] & in_sig_r[0];
assign neg_sig = in_sig_r[1] & ~in_sig_r[0];
assign out_sig = in_sig_r[1];
assign ext_pos_sig=|rPosSig;
assign ext_neg_sig=|rNegSig;
	
endmodule

