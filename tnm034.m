% im: Image of unknown face, RGB-image in uint8 format in the 
% range [0,255]
%
% id: The identity number (integer) of the identified person,
% i.e. ‘1’, ‘2’,...,‘16’ for the persons belonging to ‘db1’ 
% and ‘0’ for all other faces.
function id = tnm034(im)
    myimg = im2double(imread('images/DB1/db1_05.jpg'));
    myimg = whiteWorldCorrection(myimg);
    myimg = faceMask(myimg);
    
    myimg1 = eyeMap(myimg);
    myimg2 = mouthMap(myimg);
    
    figure
    imshow(myimg1)
    
    figure
    imshow(myimg2)
end       
