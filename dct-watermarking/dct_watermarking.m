%% DIGITAL WATERMARKING USING DCT %%

%% SYSTEM CLEARING
clear all;
close all;
clearvars;
clc;

%% INPUTS AND SETTINGS
nameOfPicture = 'mona_lisa.jpg';
nameOfWatermark = 'eka.jpg'; 
coeff=10;

%% PICTURE AND WATERMARK READING
picture = imread(nameOfPicture);
watermark = imread(nameOfWatermark);

%% PICTURE DCT
pictureGray = rgb2gray(picture);
dct2Picture = dct2(pictureGray);
figure(1);
imshow(pictureGray);

%% WATERMARK PREPARATION
watermarkGray = rgb2gray(watermark);
[watermarkBw, cmap] = gray2ind(watermarkGray, 2);
watermarkDb = double(watermarkBw);
figure(2);
imshow(watermarkGray);
save watermarkBinary.dat watermarkDb -ascii
load watermarkBinary.dat
[xW, yW] = size(watermarkBinary);

%% WATERMARKING
dct2Picture(1:xW, 1:yW) = dct2Picture(1:xW,1:yW) + coeff * watermarkBinary;
resultPicture = idct2(dct2Picture)/255;
figure(3);
imshow(resultPicture);

%% DEWATERMARKING WITH KNOWN MASK
watermarkedPicture = resultPicture*255;
dct2Image = dct2(watermarkedPicture);
dct2Image(1:xW, 1:yW) = dct2Image(1:xW,1:yW) - coeff * watermarkBinary;
idct2Image = idct2(dct2Image)/255;
figure(4);
imshow(idct2Image);


