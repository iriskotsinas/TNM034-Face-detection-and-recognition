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
        %angle = -acosd(xlength / hypo);
    elseif(c(1,2) == c(2,2))
        angle = 0;
    else
        angle = -atand(ylength / xlength);
        %angle = acosd(xlength / hypo);
    end
    
    angle
    
    %clf;
    %figure(3);
    %subplot(1,2,1);
    %imshow(origimg);
    
    rotImage = imrotate(origimg, angle, 'bilinear'); % <--- RETURN VALUE
    %subplot(1,2,2);
   
    
    
    %Get new position of eye
    
    leftEyeP = c(1,:)';    % coordinates of left eye point
    rightEyeP = c(2,:)';   % coordinates of right eye point
    
    alpha = -angle;   % angle for rotation ---- VARF�R FUNKAR DETTA?? DET SKA V�L VA -angle??
    RotatedIm = imrotate(origimg,alpha);   % rotation of the main image (im)
    RotMatrix = [cosd(alpha) -sind(alpha); sind(alpha) cosd(alpha)]; 
    ImCenterA = (size(origimg(:,:,1))/2)';         % Center of the main image
    ImCenterB = (size(RotatedIm(:,:,1))/2)';  % Center of the transformed image
    
    rotateLeftEye = RotMatrix*(leftEyeP-ImCenterA)+ImCenterB;
    rotateRightEye = RotMatrix*(rightEyeP-ImCenterA)+ImCenterB;
    
%     leftEyeP = c(1,:);    % coordinates of left eye point
%     rightEyeP = c(2,:);   % coordinates of right eye point
%     
%     rotateLeftEye = zeros(1, 2);
%     rotateRightEye = zeros(1, 2);
%     center = floor(size(origimg(:,:,1))/2);
%     
%     hyp = 
%     
%     rotateLeftEye(1) = (leftEyeP(1) - center(1)) * cosd(-angle) - (leftEyeP(2) - center(2)) * sind(-angle) + center(1);
%     rotateLeftEye(2) = (leftEyeP(1) - center(1)) * sind(-angle) + (leftEyeP(2) - center(2)) * cosd(-angle) + center(2);
    
%     imshow(rotImage);
%     hold on;
%     plot([rotateLeftEye(1) rotateRightEye(1)], [rotateLeftEye(2) rotateRightEye(2)], '*g');
%     hold off;

    
    
%     figure(1);
%     imshow(rotImage);
%     hold on;
%     plot([rotateLeftEye(1) rotateRightEye(1)], [rotateLeftEye(2) rotateRightEye(2)], '*r');

    
    
    %Transpose
    rotateLeftEye = rotateLeftEye';
    rotateRightEye = rotateRightEye';

    
    %Return length between eyes
    length_x = abs(rotateRightEye(1,1) - rotateLeftEye(1,1));
   
    length_x
    %Scale image
    image = imresize(rotImage, 111/length_x, 'bilinear'); %<---- RETURN VALUE

    %figure(10);
    %imshow(image);
    
    %Scale coordinates
    rotateLeftEye = rotateLeftEye.*(111/length_x); 
    rotateRightEye = rotateRightEye.*(111/length_x);
    
    rotateLeftEye
    rotateRightEye

    diff = abs(ImCenterB(1) - ImCenterA(1)) * 0.5;
    diff
    
%     xmin = floor(rotateLeftEye(1,1) - 50);
    if (angle >= 0)
        xmin = floor(rotateRightEye(1,1) - 50 - 111);
    else
        xmin = floor(rotateRightEye(1,1) - 50 - 111 + diff);
    end
    
    ymin = floor(rotateLeftEye(1,2) - 100);
    %width = floor(rotateRightEye(1,1) + 60 - xmin);
    width = 211;
    height = 280;
    

end