function im = Segmentation(I)
%Convert image to YCbCr color space
a=rgb2ycbcr(I);
%Make a conversion to HSV color space as well.
[hue, ~,~] = rgb2hsv(I);

cb = a(:,:,2);
cr = a(:,:,3);

%Get the size of the image
[w, h]=size(I(:,:,1));

%Allocate memory for the segment mask
segment = zeros(w,h);


% ll= impixel(hue);
% ll
%Create the mask by using threshold values from the input image.
for i=1:w
    for j=1:h            
        if  (0.48<=cr(i,j) && cr(i,j)<=0.6 && 0.4<=cb(i,j) && cb(i,j)<=0.52 &&  hue(i,j)>=0 && hue(i,j)<=0.12) || hue(i,j)>= 0.8    
            segment(i,j)=1;            
        else       
            segment(i,j)=0;    
        end    
    end
end

imshow(segment)
figure;
%Open the image
se = strel('disk',120,10);
segment = imclose(segment,se);
segment = imopen(segment,se);
%Close the image


imshow(segment);
figure;
%Add the different color channels multiplied by the segment mask.
im(:,:,1)=I(:,:,1).*segment;   
im(:,:,2)=I(:,:,2).*segment; 
im(:,:,3)=I(:,:,3).*segment; 

figure;
imshow(segment);



% imshow(im);

%returnimage = Segmentation(im);


end