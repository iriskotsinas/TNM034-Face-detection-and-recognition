function output = eyeMap(im)
%im = imread("db1_01.jpg");
%im = im2double(im);

im_ycbcr = rgb2ycbcr(im);

y = im_ycbcr(:,:,1);
cb = im_ycbcr(:,:,2);
cr = im_ycbcr(:,:,3); 
cr_neg = 1-cr; %fr�ga daniel

EyeMapC = (1/3)*( (cb.^2) + (cr_neg.^2) + (cb./cr) );
EyeMapC = EyeMapC./max(EyeMapC(:));

r = 10; 
SE = strel('disk', r);

y_dilate = imdilate(y,SE);
y_erode = imerode(y,SE);

EyeMapL = y_dilate./(y_erode + 1);
EyeMapL = EyeMapL./max(EyeMapL(:));

output = EyeMapC .* EyeMapL;

output = imdilate(output,SE);



end







