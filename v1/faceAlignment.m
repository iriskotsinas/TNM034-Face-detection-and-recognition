function [image, xmin, ymin, width, height] = faceAlignment(origimg, lefteye, righteye)
    
    %Get eye position
    c = [lefteye; righteye];
    
    % Get distance between eyes
    xlength = abs(c(1,1) - c(2,1));
    ylength = abs(c(1,2) - c(2,2));
    
    %Rotate image
    hypo = sqrt(xlength^2 + ylength^2);
    
    %Check which way to rotate
    if(c(1,2) < c(2,2))
        angle = atand(ylength / xlength);
    elseif(c(1,2) == c(2,2))
        angle = 0;
    else
        angle = -atand(ylength / xlength);
    end
    
    rotImage = imrotate(origimg, angle, 'bilinear', 'crop');
    
    %Get new position of eye
    
    leftEyeP = c(1,:)';    % coordinates of left eye point
    rightEyeP = c(2,:)';   % coordinates of right eye point
    
    alpha = angle;   % angle for rotation
    RotatedIm = rotImage;   % rotation of the main image (im)
    RotMatrix = [cosd(alpha) sind(alpha); -sind(alpha) cosd(alpha)]; 
    ImCenterA = (size(origimg(:,:,1))/2)';         % Center of the main image
    ImCenterB = (size(RotatedIm(:,:,1))/2)';  % Center of the transformed image
    
    rotateLeftEye = RotMatrix*(leftEyeP-ImCenterA)+ImCenterB;
    rotateRightEye = RotMatrix*(rightEyeP-ImCenterA)+ImCenterB;
    
    %Transpose
    rotateLeftEye = rotateLeftEye';
    rotateRightEye = rotateRightEye';
 
    %Return length between eyes
    length_x = abs(rotateRightEye(1,1) - rotateLeftEye(1,1));
       
    %Scale image
    image = imresize(rotImage, 111/length_x, 'bilinear');
    
    %Scale coordinates
    rotateLeftEye = rotateLeftEye.*(111/length_x); 
    rotateRightEye = rotateRightEye.*(111/length_x);

    xmin = floor(rotateLeftEye(1,1) - 50);
    ymin = floor(rotateLeftEye(1,2) - 100);
    width = 211;
    height = 280;
    
end