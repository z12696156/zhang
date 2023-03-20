module Matrix
#(
    parameter       IMAGE_W         =   640     ,
    parameter       IMAGE_H         =   480     
)
(
    input  wire                         InClk            ,
    input  wire                         InClr            ,
    input  wire                         InDe             ,
    input  wire [8 -1 :0]               InData           ,

    output reg [8*3-1 :0]               OutMatrixData1 =0  ,
    output reg [8*3-1 :0]               OutMatrixData2 =0  ,
    output reg [8*3-1 :0]               OutMatrixData3 =0  ,
    output reg                          OutMatrixDe    =0    
);

localparam          LINE_NUM    =   3;


reg             [15:0]          ColCnt       =   0   ;
reg             [15:0]          RowCnt       =   0   ;
wire                            NegDe                ;


wire            [7:0]           DataLine3         ;
wire            [7:0]           DataLine2         ;
wire            [7:0]           DataLine1         ;
wire                            FifoRdEn1         ;
wire                            FifoRdEn2         ;

PluseDection PluseDection
(
	.clk			  (InClk    ),       	
	.in_sig			  (InDe     ),	
	.neg_sig		  (NegDe    ) 
);

always@(posedge InClk)
begin
    if(InDe)
        ColCnt<=ColCnt+'d1;
    else 
        ColCnt<='d0;
end

always@(posedge InClk)
begin
    if(InClr)
        RowCnt<='d0;
    else if(NegDe)
        RowCnt<=RowCnt+1'b1;
end






assign   FifoRdEn1=InDe&&(|RowCnt)  ;
assign   FifoRdEn2=InDe&&(RowCnt>1) ;

assign   DataLine3=InData;



Fifo_In8x1024_Out8x1024 u0_Fifo_In8x1024_Out8x1024 (
  .rst              (InClr       ),                
  .wr_clk           (InClk       ),           
  .rd_clk           (InClk       ),             
  .din              (InData      ),                 
  .wr_en            (InDe        ),                

  .rd_en            (FifoRdEn1   ),
  .dout             (DataLine2   ), 
  .full             (            ),
  .empty            (            ),
  .almost_empty     (            ) 
);

Fifo_In8x1024_Out8x1024 u1_Fifo_In8x1024_Out8x1024 (
  .rst              (InClr       ),               
  .wr_clk           (InClk       ),               
  .rd_clk           (InClk       ),               
  .din              (DataLine2  ),                
  .wr_en            (FifoRdEn1   ),               

  .rd_en            (FifoRdEn2   ),               
  .dout             (DataLine1   ),               
  .full             (            ),               
  .empty            (            ),               
  .almost_empty     (            )                
);


always@(posedge InClk)
begin
    OutMatrixData1<={OutMatrixData1[15:0],DataLine1};/*  */
    OutMatrixData2<={OutMatrixData2[15:0],DataLine2};
    OutMatrixData3<={OutMatrixData3[15:0],DataLine3};
end

always@(posedge InClk)
begin
    OutMatrixDe<=InDe;
end











endmodule

