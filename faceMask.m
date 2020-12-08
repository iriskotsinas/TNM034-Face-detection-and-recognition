function im = faceMask(I)
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

crx = imgaussfilt(cr, 90);

for i=1:w
    for j=1:h  
       if (0.50 < crx(i,j) && 0.7 > crx(i,j))
           segment(i,j) = 1;
       else
           segment(i,j) = 0;
       end
    end
end

% keep biggest area in image
segment = medfilt2(bwareafilt(imbinarize(segment), 1));

cb = cb .* segment;
cr = cr .* segment;

for i=1:w
    for j=1:h            
        if  (0.52<=cr(i,j) && cr(i,j)<=0.6 && hue(i,j) > 0.02)
        %if  (0.52<=cr(i,j) && cr(i,j)<=0.6 && 0.4 < cb(i,j) && cb(i,j) < 0.6 && hue(i,j) > 0.01)
            segment(i,j)=1;            
        else       
            segment(i,j)=0;    
        end    
    end
end

segment = imfill(segment, 'holes');
%segment = imclose(segment, strel('disk', 14, 4));
%segment = imopen(segment, strel('disk', 14, 4));
segment = imclose(segment, strel('disk', 20, 4));
segment = imopen(segment, strel('disk', 20, 4));
segment = imopen(segment, strel('rectangle', [120, 1]));
segment = medfilt2(bwareafilt(segment, 1));

im(:,:,1)=I(:,:,1).*segment;   
im(:,:,2)=I(:,:,2).*segment; 
im(:,:,3)=I(:,:,3).*segment; 
end