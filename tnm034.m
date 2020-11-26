% im: Image of unknown face, RGB-image in uint8 format in the 
% range [0,255]
%
% id: The identity number (integer) of the identified person,
% i.e. ‘1’, ‘2’,...,‘16’ for the persons belonging to ‘db1’ 
% and ‘0’ for all other faces.
function id = tnm034(im)
    
    figure(1);
    clf
    
    for i=1:1:16
        if i <= 9
            org = im2double(imread(sprintf('images/DB1/db1_0%d.jpg', i)));
        else
            org = im2double(imread(sprintf('images/DB1/db1_%d.jpg', i))); 
        end

        img = whiteWorldCorrection(org);
        img = faceMask(img);
        
        eyePair = eyeFilter(img);
        
        [image, xmin, ymin, width, height] = faceAlignment(org, eyePair(1, :), eyePair(2, :));
        
        img = imcrop(image, [xmin, ymin, width, height]);
        
        

        %eyePair

        subplot(4, 4, i);
        imshow(img);
        %imshow(org);
        %hold on;
        %plot(eyePair(:, 1), eyePair(:, 2), 'r*');
    end
end
