module CalCore
(
    input                       InClk       ,
    input       signed [8:0]    InData1     ,
    input       signed [8:0]    InData2     ,
    input       signed [8:0]    InData3     ,
    input       signed [2:0]    InK1        ,
    input       signed [2:0]    InK2        ,
    input       signed [2:0]    InK3        ,   
    input                       InDataDe    , 

    output     signed [15:0]   OutData      ,
    output                      OutDataDe         
);



(*use_dsp="yes"*) reg  signed    [15:0]  rInData1    =0;
(*use_dsp="yes"*) reg  signed    [15:0]  rInData2    =0;
(*use_dsp="yes"*) reg  signed    [15:0]  rInData3    =0;
(*use_dsp="yes"*) reg  signed    [15:0]  rOutData    =0;

reg         [2:0]           rInDataDe=0;

always@(posedge InClk)
begin
    if(InDataDe)
        begin
            rInData1<=InData1*InK1;
            rInData2<=InData2*InK2;
            rInData3<=InData3*InK3;
        end
    else
        begin
            rInData1<='d0;
            rInData2<='d0;
            rInData3<='d0;
        end
end

always@(posedge InClk)
begin
    rOutData<=rInData1+rInData2+rInData3;
end

assign OutData=rOutData;

always@(posedge InClk)
begin
    rInDataDe<={rInDataDe[1:0],InDataDe};
end

assign OutDataDe = rInDataDe[1];






endmodule
