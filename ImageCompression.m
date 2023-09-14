
%read image and display RGB 

Img=imread("task image.bmp");
Comp=Img;
figure;
Comp(:,:,2)=0;                 
Comp(:,:,3)=0;                 

subplot(1,3,1);
imshow(Comp);
title('RED Image Component');

Comp=Img;                     
Comp(:,:,1)=0;                 
Comp(:,:,3)=0;                 

subplot(1,3,2);
imshow(Comp);
title('Green Image Component');

Comp=Img;                     
Comp(:,:,1)=0;                 
Comp(:,:,2)=0;                 

subplot(1,3,3);
imshow(Comp);
title('Blue Image Component');
                        

%Get the RGB components

R_comp = im2double(Img(:,:,1));
G_comp = im2double(Img(:,:,2));
B_comp = im2double(Img(:,:,3));

%display the gray scaled comonents

figure;
subplot(1,3,1);
imshow(R_comp);
title('RED Image Component');                

subplot(1,3,2);
imshow(G_comp);
title('Green Image Component');                

subplot(1,3,3);
imshow(B_comp);
title('Blue Image Component');

%Divide into 8*8 Blocks and apply DCT

Trans_M=dctmtx(8);
dct=@(block_struct) Trans_M * block_struct.data * Trans_M';

R_Block = blockproc(R_comp,[8 8],dct);
G_Block = blockproc(G_comp,[8 8],dct);
B_Block = blockproc(B_comp,[8 8],dct);

%store data in m*m blocks

RedCompressed = cell(1,4);
GreenCompressed = cell(1,4);
BlueCompressed = cell(1,4);

 for m=1:4
RRedCompressed = zeros(135*m,240*m);
GGreenCompressed = zeros(135*m,240*m);
BBlueCompressed = zeros(135*m,240*m);
    for i = 0:1:134
          for j =0:1:239
               RRedCompressed(m*i+1:m*i+m,m*j+1:m*j+m) = R_Block(i*8+1:i*8+m,j*8+1:j*8+m);
               GGreenCompressed(m*i+1:m*i+m,m*j+1:m*j+m) = G_Block(i*8+1:i*8+m,j*8+1:j*8+m);
               BBlueCompressed(m*i+1:m*i+m,m*j+1:m*j+m) = B_Block(i*8+1:i*8+m,j*8+1:j*8+m);
          end 
    end
RedCompressed{1,m}= RRedCompressed;
GreenCompressed{1,m}= GGreenCompressed;
BlueCompressed{1,m}= BBlueCompressed;
end


%Recombine RGB components of the compressed image

compressed_image_M1 = cat(3, RedCompressed{1,1},GreenCompressed{1,1},BlueCompressed{1,1});
compressed_image_M2 = cat(3, RedCompressed{1,2},GreenCompressed{1,2},BlueCompressed{1,2});
compressed_image_M3 = cat(3, RedCompressed{1,3},GreenCompressed{1,3},BlueCompressed{1,3});
compressed_image_M4 = cat(3, RedCompressed{1,4},GreenCompressed{1,4},BlueCompressed{1,4});

%Store the Compressed images

imwrite(compressed_image_M1,'compressed_image_1.bmp');
imwrite(compressed_image_M2,'compressed_image_2.bmp');
imwrite(compressed_image_M3,'compressed_image_3.bmp');
imwrite(compressed_image_M4,'compressed_image_4.bmp');  


%for Decompression, padding zeros to the rest of 8*8 blocks

ReddeCompressed = cell(1,4);
GreendeCompressed = cell(1,4);
BluedeCompressed = cell(1,4);
RReddeCompressed = zeros(1080,1920);
GGreendeCompressed = zeros(1080,1920);
BBluedeCompressed = zeros(1080,1920);

for m=1:4

RRedCompressed= RedCompressed{1,m};
GGreenCompressed= GreenCompressed{1,m};
BBlueCompressed= BlueCompressed{1,m};

    for i = 0:1:134
          for j =0:1:239
               RReddeCompressed(i*8+1:i*8+m,j*8+1:j*8+m) = RRedCompressed(m*i+1:m*i+m,m*j+1:m*j+m);
               GGreendeCompressed(i*8+1:i*8+m,j*8+1:j*8+m) = GGreenCompressed(m*i+1:m*i+m,m*j+1:m*j+m);
               BBluedeCompressed(i*8+1:i*8+m,j*8+1:j*8+m) = BBlueCompressed(m*i+1:m*i+m,m*j+1:m*j+m);
          end 
    end
ReddeCompressed{1,m}= RReddeCompressed;
GreendeCompressed{1,m}= GGreendeCompressed;
BluedeCompressed{1,m}= BBluedeCompressed;
end

%Apply inverse DCT  
  
INV_DCT = @(block_struct) Trans_M' * block_struct.data * Trans_M;

   R_INV = cell(1:4);
   G_INV = cell(1:4);
   B_INV = cell(1:4);
for m=1:4
   R_INV{1,m}  = blockproc(ReddeCompressed{1,m},[8 8],INV_DCT);
   G_INV{1,m}  = blockproc(GreendeCompressed{1,m},[8 8],INV_DCT);
   B_INV{1,m}  = blockproc(BluedeCompressed{1,m},[8 8],INV_DCT);
end  

%convert to 8-bit 

   R_INV_8 = cell(1:4);
   G_INV_8 = cell(1:4);
   B_INV_8 = cell(1:4);
for m=1:4
   R_INV_8{1,m}  = im2uint8(R_INV{1,m});
   G_INV_8{1,m}  = im2uint8(G_INV{1,m});
   B_INV_8{1,m}  = im2uint8(B_INV{1,m});
end

%Recombine RGB components of the Decompressed image


Decompressed_image_M1 = cat(3, R_INV_8{1,1},G_INV_8{1,1},B_INV_8{1,1});
Decompressed_image_M2 = cat(3, R_INV_8{1,2},G_INV_8{1,2},B_INV_8{1,2});
Decompressed_image_M3 = cat(3, R_INV_8{1,3},G_INV_8{1,3},B_INV_8{1,3});
Decompressed_image_M4 = cat(3, R_INV_8{1,4},G_INV_8{1,4},B_INV_8{1,4});

%Store the Decompressed images

imwrite(Decompressed_image_M1,'Dcompressed_image_1.bmp');
imwrite(Decompressed_image_M2,'Dcompressed_image_2.bmp');
imwrite(Decompressed_image_M3,'Dcompressed_image_3.bmp');
imwrite(Decompressed_image_M4,'Dcompressed_image_4.bmp');

%Display the Decompressed images

figure;
subplot(3,3,[1 5]);
imshow(Img);
title('Original Image');

subplot(3,3,3);
imshow(Decompressed_image_M1);
title('Decompressed Image m=1');

subplot(3,3,6);
imshow(Decompressed_image_M2);
title('Decompressed Image m=2');

subplot(3,3,9);
imshow(Decompressed_image_M3);
title('Decompressed Image m=3');

subplot(3,3,[7 8]);
imshow(Decompressed_image_M4);
title('Decompressed Image m=4');

%Calculating MSE 
err_M1 = immse(Img,Decompressed_image_M1);
err_M2 = immse(Img,Decompressed_image_M2);
err_M3 = immse(Img,Decompressed_image_M3);
err_M4 = immse(Img,Decompressed_image_M4);

%Calculating PSNR 
 peak = 255;
PSNR_1 = 10*log10(peak^2 / err_M1);
PSNR_2 = 10*log10(peak^2 / err_M2);
PSNR_3 = 10*log10(peak^2 / err_M3);
PSNR_4 = 10*log10(peak^2 / err_M4);

%plot M vs PSNR

M = 1:1:4;
PSNR = [PSNR_1,PSNR_2,PSNR_3,PSNR_4];
figure;
plot(M,PSNR);

