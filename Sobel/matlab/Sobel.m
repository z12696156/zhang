clear all;
clear;
clc;

image_in_rgb=imread('Pic4.jpg');
[row,col,n]=size(image_in_rgb);
figure(1);
subplot(141);imshow(image_in_rgb);title('ԭʼͼ��');

image_in_gray=rgb2gray(image_in_rgb);
subplot(142);imshow(image_in_gray);title('�Ҷ�ͼ��');
image_in_gray=double(image_in_gray);


image_in_sobel=zeros(row,col);

x_mod = [-1,0,1;-2,0,2;-1,0,1];                     %%����ϵ��
y_mod = [1,2,1;0,0,0;-1,-2,-1];                     %%����ϵ��

for i = 2:row-1
    for j = 2:col-1 
        matrix11 = image_in_gray(i-1,j-1);          %�����һ������Ԫ��
        matrix12 = image_in_gray(i-1,j);
        matrix13 = image_in_gray(i-1,j+1);
        
        matrix21 = image_in_gray(i,j-1);            %����ڶ�������Ԫ��
        matrix22 = image_in_gray(i,j);
        matrix23 = image_in_gray(i,j+1);
        
        matrix31 = image_in_gray(i+1,j-1);          %�������������Ԫ��
        matrix32 = image_in_gray(i+1,j);
        matrix33 = image_in_gray(i+1,j+1);
        
        matrix = [matrix11,matrix12,matrix13;
                  matrix21,matrix22,matrix23;
                  matrix31,matrix32,matrix33];      %��������
        x_mult = matrix.*x_mod;                     %X������
        y_mult = matrix.*y_mod;                     %Y������

        gx1 = sum(sum(x_mult()));                   %��X����ľ����
        gy1 = sum(sum(y_mult()));                   %��Y����ľ����
        gx2 = abs(gx1)*abs(gx1);                    %ƽ��
        gy2 = abs(gy1)*abs(gy1);                    %ƽ��
        image_in_sobel(i,j) = sqrt(gx2+gy2);        %ƽ���Ϳ���
%{
  
%}

    end
end

image_in_sobel=uint8(image_in_sobel);
subplot(143);imshow(image_in_sobel);title('Sobel ͼ��');







                          






