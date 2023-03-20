

% Create a VideoReader object
video = VideoReader('video1_high.avi');

% Get the number of frames in the video
num_frames = video.NumFrames;
frames = zeros(video.Height, video.Width, num_frames, 'uint8');

% Loop through the frames and save each one as an image file
for i = 1:num_frames
    % Read in the current frame
    frame = readFrame(video);
    frames(:,:,i) = frame;
    % Save the frame as an image file
    imwrite(frame, sprintf('frame_%04d.jpg', i));
end


templetaetest1 = frames(:,:,1);
imagetest2 = frames(:,:,76);
ecc_lk_alignment(imagetest2, templetaetest1, 1, 1, 'affine', zeros(2,3));

%brightness
% Adjust the brightness by multiplying with a scalar value
brightnessFactor = 1.5; % Increase brightness by 50%
brightTemplate= templetaetest1 * brightnessFactor;
brightImage = imagetest2* brightnessFactor;

ecc_lk_alignment(brightImage, brightTemplate, 1, 1, 'affine', zeros(2,3));


imshow(frames(:,:,1));
imshow(frames(:,:,76));

%gauss noisee


templateGauss = imnoise(templetaetest1,'gaussian',0,12);
imshow(J);
imageGauss = imnoise(imagetest2,'gaussian',0,12);
figure;
subplot(1,2,1); imshow(templateGauss); 
subplot(1,2,2); imshow(imageGauss);


ecc_lk_alignment(imageGauss, templateGauss, 1, 1, 'affine', zeros(2,3));


%uniform noise

imgUniform = im2double(imagetest2);
templateUniform =  im2double(templetaetest1);
min_val = -18^(1/3);
max_val = 18^(1/3);
noise = min_val + (max_val - min_val)*rand(size(imagetest2));
noisy_imgUniform = imadd(imgUniform, noise);
noisy_templateUniform = imadd(templateUniform, noise);
figure;
subplot(1,2,2); imshow(noisy_templateUniform); title('Noisy image');
subplot(1,2,2); imshow(noisy_imgUniform); title('Noisy image');

ecc_lk_alignment(noisy_imgUniform, noisy_templateUniform, 1, 1, 'affine', zeros(2,3));


%SIMULINK



% Load image data into variable "im_struct"
im_struct = load('img.mat');

% Extract image data from structure
im_data = im_struct.img;

% Convert to real-valued image with uint8 data type
im_magnitude = abs(im_data);
im_magnitude = im_magnitude ./ max(im_magnitude(:));
simImg = uint8(im_magnitude .* 255);

% Save real-valued image to workspace variable "im_real"
assignin('base', 'simImg', simImg);

%%%%%%% 
img = zeros(2, 3, 3);


% Load the image struct from a MAT file

% Create a Video Writer object to create the video file
writerObj = VideoWriter('my_video.avi');  % Change 'my_video.avi' to the name you want for your video
open(writerObj);

% Loop through each frame in the image struct and write it to the video file
for i = 1:length(im_data)
    % Convert the frame from uint8 to double and normalize it to be in the range 0 to 1
    frame = double(im_data(i)) / 255;

    % Write the frame to the video file
    writeVideo(writerObj, frame);
end
% Close the video writer object


close(writerObj);


