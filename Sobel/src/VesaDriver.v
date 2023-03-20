module VesaDriver
(
    input                                                     InPixClk        ,              //pix clk
                      
    input                  [11      :       0]                InVesaHtt       ,
    input                  [6       :       0]                InVesaHft       ,
    input                  [11      :       0]                InVesaHat       ,
    input                  [7       :       0]                InVesaHbt       ,
    input                  [5       :       0]                InVesaHst       ,

    input                  [10      :       0]                InVesaVtt       ,
    input                  [10      :       0]                InVesaVat       ,
    input                  [2       :       0]                InVesaVst       ,
    input                  [5       :       0]                InVesaVbt       ,
    input                  [2       :       0]                InVesaVft       ,  

    output                                                    OutPixClk       ,
    output      reg                                           OutVsync    =0  ,
    output      reg                                           OutHsync    =0  ,
    output      reg                                           OutPixValid =0  
);

//******************************************************************************
//                                <functions>
//******************************************************************************

//******************************************************************************
//                                <localparams>
//******************************************************************************

//******************************************************************************
//                              <internal signals>
//******************************************************************************
reg                        [11      :       0]              HorCnt        =0    ;
reg                        [11      :       0]              VerCnt        =0    ;
reg                                                         rValid1       =0    ;
reg                                                         rValid2       =0    ;
reg                                                         rValid3       =0    ;
reg                                                         rValid4       =0    ;
reg                                                         rHsync        =0    ;
reg                                                         rVsync        =0    ;
//******************************************************************************
//                                <module rtl >
//******************************************************************************


//******************************************************************************
//code

//col counter


always@(posedge InPixClk)
begin
    if(HorCnt==InVesaHtt)
        HorCnt<='d0;
    else 
        HorCnt<=HorCnt+1'b1;
end

//row counter
always@(posedge InPixClk)
begin
    if((HorCnt==InVesaHtt)&&(VerCnt==InVesaVtt))
        VerCnt<='d0;
    else if(HorCnt==InVesaHtt)
        VerCnt<=VerCnt+1'b1;
    else
        VerCnt<=VerCnt;
end

//Hsync
always@(posedge InPixClk)
begin
    if(HorCnt<=InVesaHst)
        rHsync<=1'b0;
    else 
        rHsync<=1'b1;
end

//Vsync
always@(posedge InPixClk)
begin
    if(VerCnt<=InVesaVst)
        rVsync<=1'b0;
    else
        rVsync<=1'b1;
end

always@(posedge InPixClk)
begin
    OutHsync<=rHsync;
    OutVsync<=rVsync;
end

//Pixvalid

always@(posedge InPixClk)
begin
    if(HorCnt>(InVesaHbt+InVesaHst))
        rValid1<=1'b1;
    else
        rValid1<=1'b0;
end

always@(posedge InPixClk)
begin
    if(HorCnt<=(InVesaHbt+InVesaHst+InVesaHat))
        rValid2<=1'b1;
    else
        rValid2<=1'b0;
end

always@(posedge InPixClk)
begin
    if(VerCnt>(InVesaVbt+InVesaVst))
        rValid3<=1'b1;
    else
        rValid3<=1'b0;
end

always@(posedge InPixClk)
begin
    if(VerCnt<=(InVesaVst+InVesaVbt+InVesaVat))
        rValid4<=1'b1;
    else
        rValid4<=1'b0;
end

always@(posedge InPixClk)
begin
    if(rValid1&rValid2&rValid3&rValid4)
        OutPixValid<=1'b1;
    else
        OutPixValid<=1'b0;
end



assign          OutPixClk=InPixClk;

//******************************************************************************


//******************************************************************************
//module

//******************************************************************************

endmodule