function faceMask = newFaceMask(img)
% get hue
[hue, ~, ~] = rgb2hsv(img);

% get Cb and Cr channel
tmp = rgb2ycbcr(img);
cb = tmp(:,:,2);
cr = tmp(:,:,3);

% blur + graythresh
blured = imgaussfilt(cr, 15);
lvl = graythresh(blured);
img = imbinarize(blured, lvl);

% mask
imgSize = size(img);
img = zeros(imgSize(1), imgSize(2));

% create face mask
img(find(hue > 0.63 & cr > 120 & cr < 160)) = 1;

% remove top + bottom
w = floor(imgSize(1) * 0.05);
start = imgSize(1) - w;
img(1:1:w, :) = 0;
img(start:1:imgSize(1), :) = 0;

% morph. operations
img = imclose(img, strel('disk', 30, 8));
img = im2bw(imfill(img, 'holes'));
faceMask = medfilt2(bwareafilt(img, 1));
end