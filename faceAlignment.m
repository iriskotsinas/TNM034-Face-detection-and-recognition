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
        %angle = acosd(xlength / hypo);
        angle = -atand(ylength / xlength);
    end
    
    rotImage = imrotate(origimg, angle, 'bilinear', 'crop'); % <--- RETURN VALUE
    
    %Get new position of eye
    
    leftEyeP = c(1,:)';    % coordinates of left eye point
    rightEyeP = c(2,:)';   % coordinates of right eye point
    
    alpha = angle;   % angle for rotation ---- VARF�R FUNKAR DETTA?? DET SKA V�L VA -angle??
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
    image = imresize(rotImage, 111/length_x, 'bilinear'); %<---- RETURN VALUE

    
    %Scale coordinates
    rotateLeftEye = rotateLeftEye.*(111/length_x); 
    rotateRightEye = rotateRightEye.*(111/length_x);

    xmin = floor(rotateLeftEye(1,1) - 50);
    ymin = floor(rotateLeftEye(1,2) - 100);
    width = 211;
    %width = floor(rotateRightEye(1,1) + 60 - xmin); % 221
    height = 280;
    
end



% wtf = padarray(orgImg, [500 500], 0, 'both');
% 
% dx = abs(eyePair(1,1) - eyePair(2,1));
% dy = abs(eyePair(2,1) - eyePair(2,2));
% angle = atand(dy / dx);
% 
% imgSize = size(wtf)
% if (angle > 0)
%     trans = [floor(imgSize(1)/2) floor(imgSize(2)/2)] - eyePair(1, :) - 500;
% else
%     trans = [floor(imgSize(1)/2) floor(imgSize(2)/2)] - eyePair(2, :) - 500;
% end
% 
% % translate left eye to center
% tmp = imtranslate(wtf, trans);
% sBefore = size(tmp);
% % rotate
% if (eyePair(1,2) > eyePair(2,2))
%  angle = -angle;
% end
% 
% tmp = imrotate(tmp, angle, 'bilinear', 'crop');
% sAfter = size(tmp);
% 
% diff = sBefore - sAfter;
% diff = [0 0];
% 
% sBefore == sAfter
% 
% tmp = imresize(tmp, 100/dx, 'bilinear');
% 
% %tmp = imtranslate(tmp, -trans);
% %imgSize = size(tmp)
% subplot(4, 3, 10);
% imshow(tmp);
% 
% eyePair(1,:) = [floor(imgSize(1)/2) - diff(1)*0.5 floor(imgSize(2)/2) - diff(2)*0.5];
% eyePair(2,:) = [eyePair(1,1)+dx eyePair(1,2)]; % minus i vissa fall!
% 
% eyePair(1,:) = eyePair(1,:) .* 100/dx;
% eyePair(2,:) = eyePair(2,:) .* 100/dx;
% 
%  hold on;
% plot([eyePair(1,1)], [eyePair(1,2)], '*r');
% plot([eyePair(2,1)], [eyePair(2,2)], '*g');
%  %plot([eyePair(1,1) eyePair(2,1) eyePair(1,1)], [eyePair(1,2) eyePair(2,2) eyePair(1,2)], 'r');
% hold off;   
% % 
% xmin = eyePair(1,1) - 61;
% ymin = eyePair(1,2) - 100;
% out = imcrop(tmp, [xmin, ymin, 221, 280]);
% subplot(4, 3, 10);
% imshow(out);
% size(out)
% 
%  hold on;
% plot([eyePair(1,1) - xmin], [eyePair(1,2) - ymin], '*r');
% plot([eyePair(2,1) - xmin], [eyePair(2,2) - ymin], '*g');
%  %plot([eyePair(1,1) eyePair(2,1) eyePair(1,1)], [eyePair(1,2) eyePair(2,2) eyePair(1,2)], 'r');
% hold off; 
% 
% 
% 
% 
% 
% return;