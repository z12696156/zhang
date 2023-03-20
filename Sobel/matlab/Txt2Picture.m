clc;
clear all;


row=480;
col=640;

post_image=uint8(zeros(row,col,3));
fidGray=fopen('F:/image_process/Sobel/doc/post_Gray.txt','r');
post_image_gray=uint8(zeros(row,col));




for y=1:row
    for x=1:col
        post_image_gray(y,x)=fscanf(fidGray,'%x',1);
    end
end

figure(1);
subplot(121);
imshow(post_image_gray);
imwrite(post_image_gray,'F:/image_process/Sobel/doc/FPGA Sobel.jpg');






