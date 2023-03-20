clc;
clear all;
GRAY = imread('../img/gray.bmp');
[row,col] = size(GRAY);
GRAY = double(GRAY);
sobel_result = zeros(row,col);
x_mod = [-1,0,1;-2,0,2;-1,0,1];
y_mod = [1,2,1;0,0,0;-1,-2,-1];
for i = 2:row-1
    for j = 2:col-1 
        matrix11 = GRAY(i-1,j-1);
        matrix12 = GRAY(i-1,j);
        matrix13 = GRAY(i-1,j+1);
        
        matrix21 = GRAY(i,j-1);
        matrix22 = GRAY(i,j);
        matrix23 = GRAY(i,j+1);
        
        matrix31 = GRAY(i+1,j-1);
        matrix32 = GRAY(i+1,j);
        matrix33 = GRAY(i+1,j+1);
        
        matrix = [matrix11,matrix12,matrix13;matrix21,matrix22,matrix23;matrix31,matrix32,matrix33];
        x_mult = matrix.*x_mod;
        y_mult = matrix.*y_mod;
        gx1 = sum(x_mult());
        gy1 = sum(sum(y_mult()));
        gx2 = abs(gx1)*abs(gx1);
        gy2 = abs(gy1)*abs(gy1);
        sobel_result(i,j) = sqrt(gx2+gy2);
    end
end


matalb_Y = uint8(floor(sobel_result));
imshow(matalb_Y);
a = textread('../data/post.txt','%s');
IMdec = hex2dec(a);

col = 640;
row = 480;

IM = reshape(IMdec,col,row);
fpga_Y = uint8(IM)';

subplot(1,2,1)
imshow(matalb_Y);
subplot(1,2,2)
imshow(fpga_Y);

sub = matalb_Y - fpga_Y;

min_sub = min(min(sub));
max_sub = max(max(sub));




