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

%Create the mask by using threshold values from the input image.
for i=1:w
    for j=1:h            
        if  0.5<=cr(i,j) && cr(i,j)<=0.6 && 0.4<=cb(i,j) && cb(i,j)<=0.5 && 0<=hue(i,j) && hue(i,j)<=0.075 %|| hue(i,j)>= 0.65    
            segment(i,j)=1;            
        else       
            segment(i,j)=0;    
        end    
    end
end

imshow(segment);
%Add the different color channels multiplied by the segment mask.
im(:,:,1)=I(:,:,1).*segment;   
im(:,:,2)=I(:,:,2).*segment; 
im(:,:,3)=I(:,:,3).*segment; 
figure,imshow((mat2gray(im)));
%returnimage = Segmentation(im);


end