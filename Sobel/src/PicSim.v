module PicSim
#(
    parameter IMAGE_W =192,
    parameter IMAGE_H =108,
    parameter IMAGE_DW=8,
    parameter IMAGE_C =3  

)
(
    input                               InWrPixClk  ,
    input                               InWrPicDe   ,
    input                               InWrPicClr  ,

    output  [IMAGE_DW*IMAGE_C-1:0]      OutWrPixData,

    input                               InRdPixClk  ,
    input                               InRdPicDe   ,
    input                               InRdPicClr  ,
    input   [IMAGE_DW*IMAGE_C-1:0]      InRdPicData
);


reg         [IMAGE_DW-1:0]      WrRData [IMAGE_W*IMAGE_H:0] ;   
reg         [IMAGE_DW-1:0]      WrGData [IMAGE_W*IMAGE_H:0] ;   
reg         [IMAGE_DW-1:0]      WrBData [IMAGE_W*IMAGE_H:0] ; 
reg         [IMAGE_DW-1:0]      WrGrayData [IMAGE_W*IMAGE_H:0] ;   
reg         [31:0]              WrPixCnt=0;

reg         [31:0]              RdPixCnt=0;
reg         [2:0]               RdFrameCnt=0;

integer     OutRFile;
integer     OutGFile;
integer     OutBFile;
integer     OutGrayFile;

initial
begin
    $readmemh("../doc/pre_R.txt",WrRData);
    $readmemh("../doc/pre_G.txt",WrGData);
    $readmemh("../doc/pre_B.txt",WrBData);
    $readmemh("F:/image_process/Sobel/doc/pre_gray.txt",WrGrayData);
end


initial
begin
    OutRFile =$fopen("../doc/post_R.txt");
    OutGFile =$fopen("../doc/post_G.txt");
    OutBFile =$fopen("../doc/post_B.txt");   
    OutGrayFile =$fopen("F:/image_process/Sobel/doc/post_Gray.txt");   
end





always@(posedge InWrPixClk)
begin
    if(InWrPicClr)
        WrPixCnt<='d0;
    else if(InWrPicDe)
        begin
            if(WrPixCnt==IMAGE_W*IMAGE_H-1)
                WrPixCnt<='d0;
            else 
                WrPixCnt<=WrPixCnt+1'b1;
        end

end


// assign OutWrPixData={WrRData[WrPixCnt],WrGData[WrPixCnt],WrBData[WrPixCnt]};

assign OutWrPixData=WrGrayData[WrPixCnt];
 


always@(posedge InRdPixClk)
begin
    if(InRdPicClr)
        RdPixCnt   <='d0;
    else if(InRdPicDe)
        begin
            if(RdPixCnt==IMAGE_W*IMAGE_H-1)
                RdPixCnt<='d0;
            else 
                RdPixCnt<=RdPixCnt+1'b1;
        end  
end

always@(posedge InRdPixClk)
begin
    if(InRdPicClr)
        RdFrameCnt<=RdFrameCnt+1'b1;
end


always@(posedge InRdPixClk)
begin
    if(RdFrameCnt==2&&InRdPicDe)
        begin
        $fdisplay(OutRFile,"%h",InRdPicData[23:16]);
        $fdisplay(OutGFile,"%h",InRdPicData[15:8]);
        $fdisplay(OutBFile,"%h",InRdPicData[7:0]);
        $fdisplay(OutGrayFile,"%h",InRdPicData[7:0]);
        end
    else if(RdFrameCnt==3)
        $stop;
end












endmodule
