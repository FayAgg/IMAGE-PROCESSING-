% Load the image
img = imread('cat.jpg');

% Define the number of pyramid levels
levels = 8;

% Initialize the Gaussian pyramid
G = cell(1, levels);
G{1} = img;

% Build the Gaussian pyramid
for i = 2:levels
    % Apply a Gaussian filter to the previous level
    G{i-1} = im2double(G{i-1});
    h = fspecial('gaussian', [5 5], 1);
    G{i-1} = imfilter(G{i-1}, h, 'replicate');
    % Downsample the filtered image
    G{i} = G{i-1}(1:2:end, 1:2:end, :);
end

% Display the pyramid levels
for i = 1:levels
    figure(i)
    imshow(G{i})
    title(['Level ', num2str(i)])
end


%%%%% laplacian


img = imread('apple.jpg');
imOrange = imread('orange.jpg');
% Set the number of levels in the pyramid
num_levels = 5;

img = rgb2gray(img);
% Initialize the pyramid cell array
lap_pyramid = cell(1, num_levels);

% Build the pyramid
for i = 1:num_levels
    
    % Downsample the image using Gaussian filtering
    img_down = imfilter(img, fspecial('gaussian', [7 7 ], 1), 'symmetric', 'conv');
    img_down = img_down(1:2:end, 1:2:end, :);
    
    % Upsample the downsampled image
    img_up = imresize(img_down, size(img), 'bicubic');
    
    % Compute the Laplacian image
    lap = double(img) - double(img_up);
    
    % Store the Laplacian image in the pyramid
    lap_pyramid{i} = lap;
    
    % Set the input image to the downsampled image for the next level
    img = img_down;
end


% Display the Laplacian pyramid
for i = 1:num_levels
    figure;
    imshow(lap_pyramid{i});
    title(['Level ' num2str(i)]);
end


%%%%%%%%% masks


% Load the input image
img = imread('woman.png');
hand = imread('hand.png');
imshow(img);

img = rgb2gray(img);
hand = rgb2gray(hand);
xmin = min(80,80);
ymin = min(80,80);
width = 50;
height = 40;
roi = [xmin ymin width height];

img = imresize(img,[189,200]);
imshow(img);

% Crop the image to the selected ROI
eyeCropped = imcrop(img, roi);
imshow(eyeCropped);
[canvrows,canvcols] = size(hand);

canvas = zeros(canvrows,canvcols);
canvas(:,:)=255;
opacity = 1;

canvas(80:120, 80:130) = 0;
imshow(canvas);

lims = stretchlim(canvas);
low = lims(1);
high = lims(2);

canvas = imadjust(canvas, [low, high], [0, opacity]);
imshow(canvas);
img = im2double(img);
hand = im2double(hand);

fusedImg1 = bsxfun(@times, img, 1-canvas);
fusedImg2 = bsxfun(@times, hand, canvas);

imshow(fusedImg1);
imshow(fusedImg2);
fused = bsxfun(@times, img, 1-canvas) + bsxfun(@times, hand, canvas);
imshow(fused);


%%% laplacian 
% Load two images
img1 = imread('apple.jpg');
img2 = imread('orange.jpg');

% Determine the size of the image
[h, w, ~] = size(img1);

% Crop the image in half vertically
cropped_img = imcrop(img1, [0 0 w/2 h]);
cropped_img2 = imcrop(img2, [(w/2 +1)  0 w h]);


%%%%%%%%%%%%%%%%%
% Display the cropped image


imshow(cropped_img);
imshow(cropped_img2);


% Create an all-white canvas for the new image
new_img = uint8(ones(h, 420, 3) * 255);
imshow(new_img);
% Paste the first image on the left side of the new image
new_img(1:h, 1:210, :) = cropped_img;

% Paste the second image on the right side of the new image
new_img(1:h, 210+1:end, :) = cropped_img2;

% Display the new image
imshow(new_img);


image = new_img;



laplacian = 0;
% Define the number of levels you want in your Laplacian pyramid
num_levels = 5;

% Define the size of the high-pass filter
filter_size = 3;

% Define the brightness reduction factor
brightness_factor = 0.9;

% Create a Laplacian pyramid 
for i = 1:num_levels
    % Blur the image with a Gaussian filter
    blur = imgaussfilt(image, 2^(i-1));

    % Create a Laplacian filter
    filter = [0 1 0; 1 -4 1; 0 1 0];


    % Subtract the filtered image from the original image
    laplacian = double(image) - double(laplacian);

    % Multiply the Laplacian by the brightness reduction factor
    laplacian = laplacian * brightness_factor^(i-1);

    % Set the current level of the Laplacian pyramid
    lap_pyr{i} = uint8(laplacian);

    % Set the image for the next level to be the blurred image
    image = blur;
end

% Display each level of the Laplacian pyramid
for i = 1:num_levels
    subplot(num_levels, 1, i)
    imshow(lap_pyr{i})
end


%%%%%%%








