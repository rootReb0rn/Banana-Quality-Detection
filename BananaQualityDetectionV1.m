% ----------------------------------------
%                                        |
%  Banana Quality Detection              |
%                                        |
%-----------------------------------------

% TEAM MEMBERS :-
% PAVEETHERAN A/L THINAGARAN [B031910470]
% SHIVEDHASSEN BALASINGAM [B031810360]



%-----------------------------------------
% P R O G R A M    S T A R T             |
%-----------------------------------------

% Cleaning Enviroment 
clc, clear all, close all

% Load Image
banana = imread('assets/banana10.png');

% K-Means Clustering 
[L, Centers1] = imsegkmeans(banana, 5);
rgbImage = labeloverlay(banana,L);

% Split the original image into color bands.
redBand = rgbImage(:,:, 1);
greenBand = rgbImage(:,:, 2);
blueBand = rgbImage(:,:, 3);

% Threshold each color band.
redthreshold = 100;
greenThreshold = 140;
blueThreshold = 170;

% Create Masking
redMask = (redBand < redthreshold);
greenMask = (greenBand > greenThreshold);
blueMask = (blueBand < blueThreshold);

% Combine the masks to find where all 3 are "TRUE"
% [ EXAMPLE ]
%
%   |-  0 1 1   -|      |-  1 0 1   -|      |-  0 0 1   -|
%   |   0 0 1    |  X   |   0 1 0    |  =   |   0 0 0    |
%   |_  1 1 0   _|      |_  1 0 1   _|      |_  1 0 0   _|

damagedAreasMask = uint8(redMask & greenMask & blueMask);
%subplot(4, 5, 7);
%imshow(damagedAreasMask, []);
%title('Damaged Areas Mask');
maskedrgbImage = uint8(zeros(size(damagedAreasMask))); 

% Initialize
maskedrgbImage(:,:,1) = rgbImage(:,:,1) .* damagedAreasMask;
maskedrgbImage(:,:,2) = rgbImage(:,:,2) .* damagedAreasMask;
maskedrgbImage(:,:,3) = rgbImage(:,:,3) .* damagedAreasMask;

reqInfo = maskedrgbImage(:, :, 1) > 0 & maskedrgbImage(:, :, 2) > 0 & maskedrgbImage(:, :, 3) > 0;
imshow(reqInfo);
title('Damaged Areas Mask');
res = sum(reqInfo(:));
disp(res)
fullRotten = 30000;
halfRotten = 12000;
startRotten = 6000;

% Displaying all the outputs
figure('Name','RGB Analysis Data');
subplot(4,3,1),imshow(redBand),title("Red Band")
subplot(4,3,2),imshow(greenBand),title("Green Band")
subplot(4,3,3),imshow(blueBand),title("Blue Band")
subplot(4,3,4),imhist(redBand),title("Red Band Histogram")
subplot(4,3,5),imhist(greenBand),title("Green Band Histogram")
subplot(4,3,6),imhist(blueBand),title("Blue Band Histogram")
subplot(4,3,7),imshow(redMask),title("Red Mask")
subplot(4,3,8),imshow(greenMask),title("Green Mask")
subplot(4,3,9),imshow(blueMask),title("Blue Mask")
subplot(4,3,10),imshow(maskedrgbImage(:,:,1)),title("Damaged Red Mask")
subplot(4,3,11),imshow(maskedrgbImage(:,:,2)),title("Damaged Green Mask")
subplot(4,3,12),imshow(maskedrgbImage(:,:,3)),title("Damaged Blue Mask")

figure('Name','Overall Data');
subplot(2,3,1),imshow(banana),title("Original")
subplot(2,3,2),imshow(rgbImage),title("K-Means Clustering")
subplot(2,3,3),imshow(damagedAreasMask,[]),title("Damaged Areas Mask")

if res>fullRotten
    subplot(2,3,[4,5,6]),imshow(banana),title('Result: Full Rotten');
elseif res>halfRotten
    subplot(2,3,[4,5,6]),imshow(banana),title('Result: Half Rotten');
elseif res>startRotten
    subplot(2,3,[4,5,6]),imshow(banana),title('Result: Start Rotten');
else
    subplot(2,3,[4,5,6]),imshow(banana),title('Result: Healthy');
end  


