clc;       
clear all; 

PicData=imread('Pic4.jpg');
figure(1);
subplot(121);
imshow(PicData);
title('oringe image');

[row,col,n]=size(PicData);
GrayData=rgb2gray(PicData);
figure(1);
subplot(122);
imshow(GrayData);
title('Gray image');


RTxt=fopen('../doc/pre_R.txt','w');%% open txt
GTxt=fopen('../doc/pre_G.txt','w');%% open txt
BTxt=fopen('../doc/pre_B.txt','w');%% open txt
GrayTxt=fopen('../doc/pre_gray.txt','w');


for y=1:row
    for x=1:col
           fprintf(RTxt,'%x\n',PicData(y,x,1));
           fprintf(GTxt,'%x\n',PicData(y,x,2));
           fprintf(BTxt,'%x\n',PicData(y,x,3));
           fprintf(GrayTxt,'%x\n',GrayData(y,x));
    end
end

fclose(RTxt);
fclose(GTxt);
fclose(BTxt);




