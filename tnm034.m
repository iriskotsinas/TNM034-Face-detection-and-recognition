% im: Image of unknown face, RGB-image in uint8 format in the 
% range [0,255]
%
% id: The identity number (integer) of the identified person,
% i.e. ‘1’, ‘2’,...,‘16’ for the persons belonging to ‘db1’ 
% and ‘0’ for all other faces.
function id = tnm034(im)
    x = im2double(imread("images/DB1/db1_01.jpg"));
    y = whiteWorldCorrection(x)
    
    %z = Segmentation(y)
    %imshow(z)
end       
