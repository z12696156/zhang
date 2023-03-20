clear all;
clear;
clc;

image_in_rgb=imread('Pic4.jpg');
[row,col,n]=size(image_in_rgb);
figure(1);
subplot(141);imshow(image_in_rgb);title('原始图像');

image_in_gray=rgb2gray(image_in_rgb);
subplot(142);imshow(image_in_gray);title('灰度图像');
image_in_gray=double(image_in_gray);


image_in_sobel=zeros(row,col);

x_mod = [-1,0,1;-2,0,2;-1,0,1];                     %%矩阵系数
y_mod = [1,2,1;0,0,0;-1,-2,-1];                     %%矩阵系数

for i = 2:row-1
    for j = 2:col-1 
        matrix11 = image_in_gray(i-1,j-1);          %矩阵第一行三个元素
        matrix12 = image_in_gray(i-1,j);
        matrix13 = image_in_gray(i-1,j+1);
        
        matrix21 = image_in_gray(i,j-1);            %矩阵第二行三个元素
        matrix22 = image_in_gray(i,j);
        matrix23 = image_in_gray(i,j+1);
        
        matrix31 = image_in_gray(i+1,j-1);          %矩阵第三行三个元素
        matrix32 = image_in_gray(i+1,j);
        matrix33 = image_in_gray(i+1,j+1);
        
        matrix = [matrix11,matrix12,matrix13;
                  matrix21,matrix22,matrix23;
                  matrix31,matrix32,matrix33];      %创建矩阵
        x_mult = matrix.*x_mod;                     %X方向卷积
        y_mult = matrix.*y_mod;                     %Y方向卷积

        gx1 = sum(sum(x_mult()));                   %求X方向的卷积和
        gy1 = sum(sum(y_mult()));                   %求Y方向的卷积和
        gx2 = abs(gx1)*abs(gx1);                    %平方
        gy2 = abs(gy1)*abs(gy1);                    %平方
        image_in_sobel(i,j) = sqrt(gx2+gy2);        %平方和开根
%{
  
%}

    end
end

image_in_sobel=uint8(image_in_sobel);
subplot(143);imshow(image_in_sobel);title('Sobel 图像');







                          






