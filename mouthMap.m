function output = mouthMap(im)
%im = imread("db1_09.jpg");
%im = im2double(im);

im_ycbcr = rgb2ycbcr(im);

y = im_ycbcr(:,:,1);
cb = im_ycbcr(:,:,2);
cr = im_ycbcr(:,:,3); 

n_cb = size(cb,1)*size(cb,2);
n_cr = size(cr,1)*size(cr,2);

%Fr�ga om 1/n ska va med eller kan det tas bort?
%Fr�ga om normalizering?
%Fr�ga om dilate + masking i slutet
eta = 0.95*( ((1/n_cb)*sum(cr(:).^2)) / ((1/n_cr)*sum(cr(:)./cb(:))) );

mouthMapImage = cr.^2 .* (cr.^2 - (eta* (( cr./cb )))).^2;

mouthMapImage = mouthMapImage./max(mouthMapImage(:));

r = 20; 
SE = strel('disk', r);
mouthMapImage = imdilate(mouthMapImage,SE);

output = mouthMapImage;
end



