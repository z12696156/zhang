`timescale 1ns/1ns

module tb();

parameter                       IMAGE_W               = 640;
parameter                       IMAGE_H               = 480;      
parameter                       IMAGE_DW              = 8  ;


reg                             Clk50M =0;

wire                            InVideoClk  ;
wire                            InVideoDe   ;
wire                            InVideoVs   ;
wire                            InVideoHs   ;
wire        [23:0]              InVideoData ;

wire                            OutVideoClk;
wire                            OutVideoDe;
wire                            OutVideoVs;
wire                            OutVideoHs;
wire       [31:0]                 OutVideoData;

always #10 Clk50M=~Clk50M;


VesaDriver u_VesaDriver
(
    .InPixClk                   (Clk50M        ), //pix clk
    .InVesaHtt                  (800           ), //H total time
    .InVesaHft                  (7'd16         ), //H fronch  time
    .InVesaHat                  (640           ), //H addrable    time
    .InVesaHbt                  (48            ), //H back time
    .InVesaHst                  (96            ), //Hsync  time

    .InVesaVtt                  (525-1         ), //V total   time
    .InVesaVat                  (480           ), //V addrable time
    .InVesaVst                  (2             ), //V sync time
    .InVesaVbt                  (33            ), //V back time
    .InVesaVft                  ('d10          ), 
    .OutPixClk                  (InVideoClk    ), //pix clock      
    .OutVsync                   (InVideoVs     ), //Vsync
    .OutHsync                   (InVideoHs     ), //Hsync
    .OutPixValid                (InVideoDe     )  //de
);

///////////////////////////////////////////////////////////////
 reg     [1:0]       DataClr=0;

 always@(posedge InVideoClk)
 begin
     DataClr<={DataClr[0],InVideoVs};
 end

PicSim
#(
   .IMAGE_W      (IMAGE_W  ),
   .IMAGE_H      (IMAGE_H  ),
   .IMAGE_DW     (IMAGE_DW ),
   .IMAGE_C      (1        )
)
PicSim(
   .InWrPixClk   (InVideoClk         ),
   .InWrPicDe    (InVideoDe          ),
   .InWrPicClr   ((DataClr==2'b01)   ),
   .OutWrPixData (InVideoData[23:0]  ),
   .InRdPixClk   (OutVideoClk        ),
   .InRdPicDe    (OutVideoDe        ),
   .InRdPicClr   ((DataClr==2'b01)),
   .InRdPicData  (OutVideoData[7:0]       )
);


//
reg     [7:0]      TestData=0;

always@(posedge InVideoClk)
begin
  if(InVideoDe)
    TestData<=TestData+1'b1;
  else 
    TestData<='d0;

end


Sobel
#(
    .IMAGE_W          (IMAGE_W )  ,
    .IMAGE_H          (IMAGE_H )  ,
    .IMAGE_DW         (IMAGE_DW   )
)
u_Sobel
(
    .InVideoClk       (InVideoClk   ),
    .InVideoVs        (InVideoVs    ),

    .InVideoDe        (InVideoDe    ),
    .InVideoData      (InVideoData[7:0]     ),

    .OutVideoClk      (OutVideoClk  ),
    .OutVideoVs       (OutVideoVs   ),
    .OutVideoDe       (OutVideoDe   ),
    .OutVideoData     (OutVideoData[7:0])
);    










endmodule

