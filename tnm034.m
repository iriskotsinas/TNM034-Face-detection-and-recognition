% im: Image of unknown face, RGB-image in uint8 format in the 
% range [0,255]
%
% id: The identity number (integer) of the identified person,
% i.e. ‘1’, ‘2’,...,‘16’ for the persons belonging to ‘db1’ 
% and ‘0’ for all other faces.
function id = tnm034(im)    
% % TEST
% im = imread("images/DB1/db1_01.jpg");
% % TEST

load('data.mat', 'weights', 'eigenFaces', 'meanFace');

img = im2double(im);
testImg = detection(img, true);
if (testImg == -1)
    id = 0;
    return;
end

testImg = rgb2gray(testImg);
testImg = reshape(testImg, [], 1);
testImg = testImg - meanFace;

testWeights = eigenFaces' * testImg;

[magnitude, index] = min(sum((testWeights - weights).^2, 1));

magnitude

if magnitude > 50
    id = 0;
else
    id = index;
end
end
