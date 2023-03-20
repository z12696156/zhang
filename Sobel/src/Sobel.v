module Sobel
#(
    parameter IMAGE_W   =   640  ,
    parameter IMAGE_H   =   480  ,
    parameter IMAGE_DW  =   8

)
(
    input                           InVideoClk  ,
    input                           InVideoVs   ,

    input                           InVideoDe   ,
    input   [IMAGE_DW -1 :0]        InVideoData ,

    output                          OutVideoClk ,
    output                          OutVideoVs  ,
    output                          OutVideoDe  ,
    output  [IMAGE_DW -1 :0]        OutVideoData
);


wire                                PosVsExt       ;
wire [8*3-1 :0]                     OutMatrixData1 ;
wire [8*3-1 :0]                     OutMatrixData2 ;
wire [8*3-1 :0]                     OutMatrixData3 ;
wire                                OutMatrixDe    ; 

wire  signed [15:0]                 X1Sum          ;
wire                                X1De           ;
wire  signed [15:0]                 X2Sum          ;
wire                                X2De           ;
wire  signed [15:0]                 X3Sum          ;
wire                                X3De           ;

reg   signed [15:0]                 rXSum           ;
reg                                 rXDe            ;
reg   signed [15:0]                 XSum           ;
reg                                 XDe            ;

wire  signed [15:0]                 Y1Sum          ;
wire                                Y1De           ;
wire  signed [15:0]                 Y2Sum          ;
wire                                Y2De           ;
wire  signed [15:0]                 Y3Sum          ;
wire                                Y3De           ;

reg   signed [15:0]                 rYSum           ;
reg                                 rYDe            ;
reg   signed [15:0]                 YSum            ;
reg                                 YDe             ; 

reg   [15:0]        AbsYSum     ;

reg   [15:0]        AbsXSum     ;

reg   [31:0]        SquareAbsYSum;

reg   [31:0]        SquareAbsXSum;

reg   [31:0]        SquareAbsXYSum;
reg   [2 :0]        rSquareAbsXYSumDe;

wire    [23:0]        SquareRootXY;
wire                  SquareRootXYDe;

reg     [7:0]         SobelResult =0;
reg                   SobelResultDe =0;




PluseDection PluseDection(
		.clk				(InVideoClk),       	
		.in_sig			    (InVideoVs),	
		.ext_pos_sig		(PosVsExt)

	);
		



Matrix
#(
    .IMAGE_W         (IMAGE_W),
    .IMAGE_H         (IMAGE_H)  
)
u_Matrix
(
    .InClk           (InVideoClk    ),
    .InClr           (PosVsExt      ),
    .InDe            (InVideoDe     ),
    .InData          (InVideoData   ),

    .OutMatrixData1  (OutMatrixData1),
    .OutMatrixData2  (OutMatrixData2),
    .OutMatrixData3  (OutMatrixData3),
    .OutMatrixDe     (OutMatrixDe   ) 
);


//X方向矩阵相乘
//第一行
CalCore x1_CalCore                                                      
(
    .InClk     (InVideoClk                  ),
    .InData1   ({1'b0,OutMatrixData1[23:16]}),
    .InData2   ({1'b0,OutMatrixData1[15: 8]}),
    .InData3   ({1'b0,OutMatrixData1[7 : 0]}),
    .InK1      (-1                          ),
    .InK2      (0                           ),
    .InK3      (1                           ),   
    .InDataDe  (OutMatrixDe                 ), 

    .OutData   (X1Sum                       ),
    .OutDataDe (X1De                        )      
);

//第二行
CalCore x2_CalCore
(
    .InClk     (InVideoClk                  ),
    .InData1   ({1'b0,OutMatrixData2[23:16]}),
    .InData2   ({1'b0,OutMatrixData2[15: 8]}),
    .InData3   ({1'b0,OutMatrixData2[7 : 0]}),
    .InK1      (-2                          ),
    .InK2      (0                           ),
    .InK3      (2                           ),   
    .InDataDe  (OutMatrixDe                 ), 

    .OutData   (X2Sum                       ),
    .OutDataDe (X2De                        )      
);

//第三行
CalCore x3_CalCore
(
    .InClk     (InVideoClk                  ),
    .InData1   ({1'b0,OutMatrixData3[23:16]}),
    .InData2   ({1'b0,OutMatrixData3[15: 8]}),
    .InData3   ({1'b0,OutMatrixData3[7 : 0]}),
    .InK1      (-1                          ),
    .InK2      (0                           ),
    .InK3      (1                           ),   
    .InDataDe  (OutMatrixDe                 ), 

    .OutData   (X3Sum                       ),
    .OutDataDe (X3De                        )      
);
//求和
always@(posedge InVideoClk)
begin
    XSum<=X1Sum+X2Sum+X3Sum;
    XDe<=X3De&&X2De&&X1De;
end

always@(posedge InVideoClk)
begin
    if(XSum[15])
        AbsXSum<=65535-XSum;
    else 
        AbsXSum<=XSum;
end

always@(posedge InVideoClk)
begin
    SquareAbsXSum<=AbsXSum*AbsXSum;
end






CalCore y1_CalCore
(
    .InClk     (InVideoClk                  ),
    .InData1   ({1'b0,OutMatrixData1[23:16]}),
    .InData2   ({1'b0,OutMatrixData1[15: 8]}),
    .InData3   ({1'b0,OutMatrixData1[7 : 0]}),
    .InK1      (1                          ),
    .InK2      (2                           ),
    .InK3      (1                           ),   
    .InDataDe  (OutMatrixDe                 ), 

    .OutData   (Y1Sum                       ),
    .OutDataDe (Y1De                        )      
);

CalCore y2_CalCore
(
    .InClk     (InVideoClk                  ),
    .InData1   ({1'b0,OutMatrixData2[23:16]}),
    .InData2   ({1'b0,OutMatrixData2[15: 8]}),
    .InData3   ({1'b0,OutMatrixData2[7 : 0]}),
    .InK1      (0                          ),
    .InK2      (0                           ),
    .InK3      (0                           ),   
    .InDataDe  (OutMatrixDe                 ), 

    .OutData   (Y2Sum                       ),
    .OutDataDe (Y2De                        )      
);


CalCore y3_CalCore
(
    .InClk     (InVideoClk                  ),
    .InData1   ({1'b0,OutMatrixData3[23:16]}),
    .InData2   ({1'b0,OutMatrixData3[15: 8]}),
    .InData3   ({1'b0,OutMatrixData3[7 : 0]}),
    .InK1      (-1                          ),
    .InK2      (-2                           ),
    .InK3      (-1                           ),   
    .InDataDe  (OutMatrixDe                 ), 

    .OutData   (Y3Sum                       ),
    .OutDataDe (Y3De                        )      
);

always@(posedge InVideoClk)
begin
    YSum  <=    Y1Sum+Y2Sum+Y3Sum     ;
    YDe  <=    Y3De&&Y2De&&Y1De;
end

always@(posedge InVideoClk)
begin
    if(YSum[15])
        AbsYSum<=65535-YSum;
    else 
        AbsYSum<=YSum;
end

always@(posedge InVideoClk)
begin
    SquareAbsYSum<=AbsYSum*AbsYSum;
end


always@(posedge InVideoClk)
begin
    SquareAbsXYSum<=SquareAbsXSum+SquareAbsYSum;
end

always@(posedge InVideoClk)
begin
    rSquareAbsXYSumDe<={rSquareAbsXYSumDe[1:0],YDe&&XDe};
end

Square_Root Square_Root (
  .aclk                     (InVideoClk               ),                                        // input wire aclk
  .s_axis_cartesian_tvalid  (rSquareAbsXYSumDe[2]),  // input wire s_axis_cartesian_tvalid
  .s_axis_cartesian_tdata   (SquareAbsXYSum      ),    // input wire [31 : 0] s_axis_cartesian_tdata
  .m_axis_dout_tvalid       (SquareRootXYDe      ),            // output wire m_axis_dout_tvalid
  .m_axis_dout_tdata        (SquareRootXY        )              // output wire [23 : 0] m_axis_dout_tdata
);



always@(posedge InVideoClk)
begin
    if(SquareRootXY>255)
        SobelResult<=255;
    else 
        SobelResult<=SquareRootXY[7:0];
end

always@(posedge InVideoClk)
begin
    SobelResultDe<=SquareRootXYDe;
end


assign OutVideoClk=InVideoClk;
assign OutVideoData=SobelResult;
assign OutVideoVs=InVideoVs;
assign OutVideoDe=SobelResultDe;






























endmodule