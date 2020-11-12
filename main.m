im1 = imread("bl_10.jpg");

whiteWorldImage = whiteWorldCorrection(im1);

eyeMapImage = eyeMap(im1);

mouthMapImage = mouthMap(im1);

figure
imshow(whiteWorldImage)
figure
imshow(eyeMapImage)

figure
imshow(mouthMapImage)


