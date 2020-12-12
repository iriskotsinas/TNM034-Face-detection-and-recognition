function output = mouthMap(im)

im_ycbcr = rgb2ycbcr(im);

y = im_ycbcr(:,:,1);
cb = im_ycbcr(:,:,2);
cr = im_ycbcr(:,:,3); 

n_cb = size(cb,1)*size(cb,2);
n_cr = size(cr,1)*size(cr,2);

eta = 0.95*( ((1/n_cb)*sum(cr(:).^2)) / ((1/n_cr)*sum(cr(:)./cb(:))) );

mouthMapImage = cr.^2 .* (cr.^2 - (eta* (( cr./cb )))).^2;

mouthMapImage = mouthMapImage./max(mouthMapImage(:));

r = 20; 
SE = strel('disk', r);
mouthMapImage = imdilate(mouthMapImage,SE);

output = mouthMapImage;
end



