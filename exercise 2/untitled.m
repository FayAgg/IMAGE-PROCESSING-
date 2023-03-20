inputImage = imread('memory.jpg');

J = inputImage;
% scale transform
tform1 = affine2d([3 0 0; 0 0.5 0; 0 0 1]);
tform2 = affine2d([2 0 0; 0 4 0; 0 0 1]);
tform3 = affine2d([0.1 0 0; 0 1 0; 0 0 1]);
tform4 = affine2d([0.2 0 0; 0 0.2 0; 0 0 1]);

firstScale = imwarp(J, tform1);
secondScale = imwarp(J, tform2);
thirdScale = imwarp(J, tform3);
forthScale = imwarp(J, tform4);
 

array = {firstScale,secondScale,thirdScale,forthScale};
montage(array);

% shear transform
puddingImage = imread('pudding.png');
sheartform = affine2d([1 2 0; 3 1 0; 0 0 1]);


for i=1:1:7
    for j=4:1:11
        sheartform = affine2d([1 i 0; j 1 0; 0 0 1]);
        shear = imwarp(puddingImage, sheartform);
        list{i} = imresize(shear,[256,256]);
    end
end


video = VideoWriter('yourvideo.avi'); %create the video object
open(video); %open the file for writing
for i=1:length(list) %where N is the number of images
  I = list{i}; %read the next image
  writeVideo(video,I); %write the image to file
end


% sheared pudding x stathero

shearedpuddingImage = imread('pudding.png');


for i=1:1:7
    a = -i/100;
    sheartform = affine2d([1 0 0; a 1 0; 0 0 1]);
    shear = imwarp(shearedpuddingImage, sheartform);
    shearlist{i} = imresize(shear,[265,256]);
end

montage(shearlist);


sheared_pudding = VideoWriter('sheared_pudding.avi'); %create the video object
open(sheared_pudding); %open the file for writing
for i=1:length(shearlist) %where N is the number of images
  I = shearlist{i}; %read the next image
  writeVideo(sheared_pudding,I); %write the image to file
end

%anemomilos
img = imread('windmill.png');
background = imread('windmill_back.jpeg');
mask = imread('windmill_mask.png');



% Convert the image, mask, and background to double precision format
img = im2double(img);
mask = im2double(mask);
background = im2double(background);

% Resize the mask and background to match the size of the image
img = rgb2gray(img);
mask = rgb2gray(mask);
background = rgb2gray(background);

% Resize the mask and background to match the size of the image
outputSize = size(img);
mask = imresize(mask, outputSize, 'method', 'bicubic');
background = imresize(background, outputSize, 'method', 'bicubic');


% Create a binary mask by thresholding the mask image
thresholdValue = 0.5;
binaryMask = mask < thresholdValue;

listOfRotations = {};
for j = 1:1:16
    i = j*15;
    rotateform = affine2d([ cos(i) sin(i) 0; -sin(i) cos(i) 0; 0 0 1]);
    shear1 = imwarp(img, rotateform);
    shear = imwarp(binaryMask, rotateform);
    
    shear = im2double(shear);
    sizeOfShear = size(shear);
    resizedImg = imresize(background, sizeOfShear);
    shear1 = imresize(shear1,sizeOfShear);
    % Use the binary mask to create the fused image
    fusedImg = bsxfun(@times, shear1, shear) + bsxfun(@times, resizedImg, 1 - shear);
    fusion = imresize(fusedImg,[600,600]);
    imgUint8 = im2uint8(fusion);
    listOfRotations{j} = imgUint8;

end

% Display the fused image
imshow(fusedImg);

videoOfWindMill = VideoWriter('transf_windmill.avi'); %create the video object
open(videoOfWindMill); %open the file for writing
for l=1:length(listOfRotations) %where N is the number of images
  I = listOfRotations{l}; %read the next image
  writeVideo(videoOfWindMill,I); %write the image to file
end






%anemomilos pt 2
img = imread('windmill.png');
background = imread('windmill_back.jpeg');
mask = imread('windmill_mask.png');



% Convert the image, mask, and background to double precision format
img = im2double(img);
mask = im2double(mask);
background = im2double(background);

% Resize the mask and background to match the size of the image
img = rgb2gray(img);
mask = rgb2gray(mask);
background = rgb2gray(background);

% Resize the mask and background to match the size of the image
outputSize = size(img);
mask = imresize(mask, outputSize, 'method', 'nearest');
background = imresize(background, outputSize, 'method', 'nearest');


% Create a binary mask by thresholding the mask image
thresholdValue = 0.5;
binaryMask = mask < thresholdValue;

listOfRotations = {};
for j = 1:1:16
    i = j*15;
    rotateform = affine2d([ cos(i) sin(i) 0; -sin(i) cos(i) 0; 0 0 1]);
    shear1 = imwarp(img, rotateform);
    shear = imwarp(binaryMask, rotateform);
    
    shear = im2double(shear);
    sizeOfShear = size(shear);
    resizedImg = imresize(background, sizeOfShear);
    shear1 = imresize(shear1,sizeOfShear);
    % Use the binary mask to create the fused image
    fusedImg = bsxfun(@times, shear1, shear) + bsxfun(@times, resizedImg, 1 - shear);
    fusion = imresize(fusedImg,[600,600]);
    imgUint8 = im2uint8(fusion);
    listOfRotations{j} = imgUint8;

end

% Display the fused imageS
imshow(fusedImg);

videoOfWindMill = VideoWriter('transf_windmill_nearest.avi'); %create the video object
open(videoOfWindMill); %open the file for writing
for l=1:length(listOfRotations) %where N is the number of images
  I = listOfRotations{l}; %read the next image
  writeVideo(videoOfWindMill,I); %write the image to file
end





%ball
ball3d = imread('ball.jpg');
mask3d = imread('ball_mask.jpg');
beach = imread('beach.jpg');

imshow(beach);
graybeach = rgb2gray(beach);

ball = rgb2gray(ball3d);
mask = rgb2gray(mask3d);

ballf = imresize(ball,0.2);
maskf = imresize(mask,0.2);

% Create a binary mask by thresholding the mask image
thresholdValue = 0.5;
binaryMask = maskf < thresholdValue;

listOfRotations = {};
for j = 1:1:30
    i = j*15;
    
    rotateform = affine2d([ cos(i) sin(i) 0; -sin(i) cos(i) 0; 0 0 1]);
    
    shear1 = imwarp(ballf, rotateform);
    shear = imwarp(binaryMask, rotateform);

    shear = im2double(shear);S
    shear1 = im2double(shear1);
    fusedImg = bsxfun(@times, shear1, shear);
    fusion = imresize(fusedImg,[130,130]);
    imgUint8 = im2uint8(fusion);

    %ws edw transform maskas kai mpalas

    [Matrow,Matcols] = size(graybeach);
    % Create a blank canvas of the desired size
    canvas = zeros(Matrow, Matcols);
    canvas(:,:) = 255;
    opacity = 0;
    
    lims = stretchlim(canvas);
    low = lims(1);
    high = lims(2);

    canvas = imadjust(canvas, [low, high], [0, opacity]);
    ballImg = imfuse(canvas, imgUint8);
  
    if j<= 10
        dx = j*10;
        dy = j*40;
    elseif j>10 && j <= 17
        dx = j*10;
        dy = -j*30;
    elseif j>17 && j <= 24
        dx = j*10;
        dy = -j*21;
    elseif j>24 && j <= 27
        dx = j*5;
        dy = j*18;
    else
        dx = j*5;
        dy = j*16;
    end
    
    endiameso= imtranslate(ballImg, [dx, dy]);
    final = imfuse(endiameso, graybeach);
    final = rgb2gray(final);
    listOfRotations{j} = final;

end


% Display the fused image
imshow(fusedImg);

balltrans = VideoWriter('ballBounce.avi'); %create the video object
open(balltrans); %open the file for writing
for l=1:length(listOfRotations) %where N is the number of images
  I = listOfRotations{l}; %read the next image
  writeVideo(balltrans,I); %write the image to file
 end

%%%%% zoom ball
 ball3d = imread('ball.jpg');
mask3d = imread('ball_mask.jpg');
beach = imread('beach.jpg');

graybeach = rgb2gray(beach);
ball = rgb2gray(ball3d);
mask = rgb2gray(mask3d);

ballf = imresize(ball,0.2);
maskf = imresize(mask,0.2);

% Create a binary mask by thresholding the mask image
thresholdValue = 0.5;
binaryMask = maskf < thresholdValue;

listOfRotations = {};
j=5;
for j=1:1:9

    shear = im2double(ballf);
    shear1 = im2double(binaryMask);

    % Use the binary mask to create the fused image
    fusedImg = bsxfun(@times, shear1, shear);
    fusion = imresize(fusedImg,[130,130]);
    imgUint8 = im2uint8(fusion);

    %ws edw transform maskas kai mpalas
    
    [Matrow,Matcols] = size(graybeach);
    % Create a blank canvas of the desired size
    canvas = zeros(Matrow, Matcols);
    canvas(:,:) = 255;
    opacity = 0;
    
    lims = stretchlim(canvas);
    low = lims(1);
    high = lims(2);

    canvas = imadjust(canvas, [low, high], [0, opacity]);
    listOfRotations = {};
    %ws edw transparency kai mpala kai canvas 
    dy = 500;
    if j == 1
        
        tform = affine2d([ 1 0 0; 0 1 0; 0 0 1]);
        prin = imwarp(imgUint8, tform);
        ballCanvas = imfuse(canvas,prin);
        endiameso = imtranslate(ballCanvas, [800, dy]);
       
        final = imfuse(endiameso, graybeach);
        final = rgb2gray(final);
        listOfRotations{j} = final;
        imshow(final);
        
    else
        a = 1;
        dy = dy - j*10;
        a = a - j/10; 
        %metavolh gia j/10 kathe fora 
        transform = affine2d([ -a 0 0; 0 -a 0; 0 0 1]);
        % to plhn sto mhtrwo einai gia na kineitai pros ton orizonta h mpala
        prin = imwarp(imgUint8, transform);
        ballCanvas = imfuse(canvas,prin);
        endiameso = imtranslate(ballCanvas, [800, dy]);
       
        final = imfuse(endiameso, graybeach);
        final = rgb2gray(final);
        listOfRotations{j} = final;
        
    end
    

end


ballhorizon = VideoWriter('zooMball.avi'); %create the video object
open(ballhorizon); %open the file for writing
for l=1:length(listOfRotations) %where N is the number of images
  I = listOfRotations{l}; %read the next image
  writeVideo(ballhorizon,I); %write the image to file
 end


