% im: Image of unknown face, RGB-image in uint8 format in the 
% range [0,255]
%
% id: The identity number (integer) of the identified person,
% i.e. ‘1’, ‘2’,...,‘16’ for the persons belonging to ‘db1’ 
% and ‘0’ for all other faces.
function id = tnm034(im)
% 
% for i=1:1:16
%     if i <= 9
%         myimg = im2double(imread(sprintf('images/DB1/db1_0%d.jpg', i)));
%     else
%        myimg = im2double(imread(sprintf('images/DB1/db1_%d.jpg', i))); 
%     end
%     
%     myimg = whiteWorldCorrection(myimg);
%     myimg = faceMask(myimg);
%     
% %     figure
% %     imshow(myimg);
% %     
%     eye = eyeMap(myimg) > 0.75;
% 
%     mouth = mouthMap(myimg) > 0.9;
%     mask = eye + mouth;
%     mask(mask > 1) = 1;
%     
%     myimg = myimg .* mask;
%     
% %     mouth = mouthMap(myimg) >0.9;
%     
%     subplot(4,4,i);
%       mouth = mouthMap(myimg) > 0.9;
%     mask = eye + mouth;
%     mask(mask > 1) = 1;
%     
%     myimg = myimg .* mask;
%     imshow(mask);
% 
% end

%%%%READ SINGLE IMAGE FOR TESTING
 myimg = im2double(imread('images/DB1/db1_02.jpg'));
 myimg = whiteWorldCorrection(myimg);
    myimg = faceMask(myimg);
    eye = eyeMap(myimg) > 0.75;
    mouth = mouthMap(myimg) > 0.9;
    
    
    mask = eye + mouth;
    mask(mask > 1) = 1;
    
    myimg = myimg .* mask;
    
%     x = regionprops(mask, 'Centroid');
%     x
%     c = cat(1, x.Centroid);
%     c
%     imshow(mask);
%     hold on;
%     plot(x.Centroid(:,1), x.Centroid(1,:), 'r*');

mask = imbinarize(mask);
class(mask);
imshow(mask);
stats = regionprops('table', mask, 'Centroid', 'MajorAxisLength', 'MinorAxisLength');


   
%     xlength = abs(c(1,1) - c(1,2));
%     ylength = abs(c(2,1) - c(2,2));
%     
%     hypo = sqrt(xlength^2 + ylength^2);
%     
%     angle = acosd(xlength / hypo);
%     
%     newimg = imrotate(myimg, -angle);
%     
%     imshow(newimg);
%     
%     %test = atan2d(c(:, 1), c(:, 2));
%     
%     %imshow(eye);
%    
%     hold on;
%     plot(c(:, 1), c(:,2), 'red');
    
%     
%     x = regionprops(eye, 'centroid');
%     c = cat(1, x.Centroid);
%     
%     xlength = abs(c(1,1) - c(1,2));
%     ylength = abs(c(2,1) - c(2,2));
%     
%     hypo = sqrt(xlength^2 + ylength^2);
%     
%     angle = acosd(xlength / hypo);
%     
%     newimg = imrotate(myimg, -angle);
%     
%     imshow(newimg);
%     
%     %test = atan2d(c(:, 1), c(:, 2));
%     
%     %imshow(eye);
%     hold on;
%     plot(c(:, 1), c(:,2), 'red');
%     
    %size(c)
   
%     
%     mouth = mouthMap(myimg) > 0.9;
%     mask = eye + mouth;
%     mask(mask > 1) = 1;
%     
%     myimg = myimg .* mask;
%     
%     imshow(myimg);
end       
