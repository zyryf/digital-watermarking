%% ALGORITHM FOR WATERMARKING USING DCT

%% SYSTEM CLEARING
close all;
clearvars;
clc;

%% INPUTS AND SETTINGS
nameOfPicture = 'mona_lisa.jpg';
nameOfWatermark = 'eka.jpg'; 
power=100;

%% PICTURE AND WATERMARK READING
picture = imread(nameOfPicture);
figure(1); imshow(picture); title('Original picture');
watermark = imread(nameOfWatermark); 
figure(2); imshow(watermark); title('Original watermark');

%% PICTURE AND WATERMARK PREPROCESSING
im = rgb2gray(picture);
im = imresize(im,[512 512]);
figure(3); imshow(im); title('Grayscaled, resized picture');
wat = im2bw(watermark);
wat = imresize(wat,[64 64]);
figure(4); imshow(wat); title('Binary, resized watermark');


%% WTAERMARKING
x={};
dct_img=blkproc(im,[8,8],@dct2);
m=dct_img;

k=1; dr=0; dc=0;
for ii=1:8:512 
    for jj=1:8:512 
        for i=ii:(ii+7) 
            dr=dr+1;
            for j=jj:(jj+7) 
                dc=dc+1;
                z(dr,dc)=m(i,j);
            end
            dc=0;
        end
        x{k}=z; k=k+1;
        z=[]; dr=0;
    end
end
nn=x;

i=[]; j=[]; w=1; wmrk=wat; welem=numel(wmrk);
for k=1:4096
    kx=(x{k});
    for i=1:8 
        for j=1:8 
            if (i==8) && (j==8) && (w<=welem)                            
                 if wmrk(w)==0
                    kx(i,j)=kx(i,j)+ power;
                elseif wmrk(w)==1
                    kx(i,j)=kx(i,j)- power;
                 end                                
            end            
        end        
    end
    w=w+1;
    x{k}=kx; kx=[]; 
end     

i=[]; j=[]; data=[]; count=0;
embimg1={};  
for j=1:64:4096
    count=count+1;
    for i=j:(j+63)
        data=[data,x{i}];
    end
    embimg1{count}=data;
    data=[];
end

i=[]; j=[]; data=[]; 
embimg=[];
for i=1:64
    embimg=[embimg;embimg1{i}];
end
embimg=(uint8(blkproc(embimg,[8 8],@idct2)));
figure(5); imshow(embimg); title('Watermarked picture');

%% PICTURE MODIFICATIONS
% Put watermarked picture modifiactins there for impact verification

%embimg = imnoise(embimg,'salt & pepper', 0.1);

% embimg = imnoise(embimg,'gaussian', 0.1);

%embimg = imrotate(embimg,180);

% embimg = imrotate(embimg,90);

% embimg = imrotate(embimg,45);
 
% embimg = imresize(embimg,[1200 1200]);

%embimg = imresize(embimg,[400 400]);

%windowSize = 15;
%avg3 = ones(windowSize) / windowSize^2;
%embimg = imfilter(embimg, avg3, 'conv');

embimg = imresize(embimg,[512 512]);
figure(6); imshow(embimg); title('Watermarked picture after modifications');
%% DEWATERMARKING
[row clm]=size(embimg);
m=embimg;
k=1; dr=0; dc=0;
for ii=1:8:row 
    for jj=1:8:clm
        for i=ii:(ii+7) 
            dr=dr+1;
            for j=jj:(jj+7)
                dc=dc+1;
                z(dr,dc)=m(i,j);
            end
            dc=0;
        end
        x{k}=z; k=k+1;
        z=[]; dr=0;
    end
end
nn=x;

wm=[]; wm1=[]; k=1; wmwd=[]; wmwd1=[];
while(k<4097)
    for i=1:64
        kx=x{k}; 
        dkx=blkproc(kx,[8 8],@dct2); 
        nn{k}=dkx; 
        wm1=[wm1 dkx(8,8)];
        wmwd1=[wmwd1 kx(8,8)];
        k=k+1;
    end
    wm=[wm;wm1]; wm1=[];
    wmwd=[wmwd;wmwd1]; wmwd1=[];
end

for i=1:64
    for j=1:64
        diff=wm(i,j); 
        if diff >=0
            wm(i,j)=0;
        elseif diff < 0
            wm(i,j)=1;
        end
    end
end
wm=wm';
figure(7); imshow(wm); title('Received watermark');