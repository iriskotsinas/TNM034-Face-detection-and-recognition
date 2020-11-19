function [image, xmin, ymin, width, height ] = faceAlignment(origimg, eye, mouth)
    
    %Get eye position
    x = regionprops(eye, 'centroid');
    c = cat(1, x.Centroid);
    
    % Get distance between eyes
    xlength = abs(c(1,1) - c(2,1));
    ylength = abs(c(1,2) - c(2,2));
    
    %Get mouth position
    x = regionprops(mouth, 'centroid');
    m = cat(1, x.Centroid);
    
    %Rotate image
    hypo = sqrt(xlength^2 + ylength^2);
    
    %Check which way to rotate
    if(c(1,2) < c(2,2))
        angle = -acosd(xlength / hypo);
    elseif(c(1,2) == c(2,2))
        angle = 0;
    else
        angle = acosd(xlength / hypo);
    end
    
    image = imrotate(origimg, -angle); % <--- RETURN VALUE
    figure
    imshow(image)
    title('Rotated Image')
    
    %Get new position of eye
    
    leftEyeP = c(1,:)';    % coordinates of left eye point
    rightEyeP = c(2,:)';   % coordinates of right eye point
    mouthP = m'; % coordinates of mouth point
    
    alpha = angle;   % angle for rotation ---- VARFÖR FUNKAR DETTA?? DET SKA VÄL VA -angle??
    RotatedIm = imrotate(origimg,alpha);   % rotation of the main image (im)
    RotMatrix = [cosd(alpha) -sind(alpha); sind(alpha) cosd(alpha)]; 
    ImCenterA = (size(origimg(:,:,1))/2)';         % Center of the main image
    ImCenterB = (size(RotatedIm(:,:,1))/2)';  % Center of the transformed image
    
    rotateLeftEye = RotMatrix*(leftEyeP-ImCenterA)+ImCenterB;
    rotateRightEye = RotMatrix*(rightEyeP-ImCenterA)+ImCenterB;
    rotateMouth = RotMatrix*(mouthP-ImCenterA)+ImCenterB;
    
    %Transpose
    rotateLeftEye = rotateLeftEye';
    rotateRightEye = rotateRightEye';
    rotateMouth = rotateMouth';
    
    %Plot x and y position of rotated eye and mouth
    hold on;
    plot(rotateLeftEye(1,1), rotateLeftEye(1,2), 'Oy'); 
   	hold on;
    plot(rotateRightEye(1,1), rotateRightEye(1,2) , 'Oy');
    hold on;
    plot(rotateMouth(1,1), rotateMouth(1,2), '*y');
    hold off
    
    %Plot initial image
    figure
    imshow(origimg)
    title('Initial Image')
    hold on
    plot(c(1,1),c(1,2), 'Og');
    plot(c(2,1),c(2,2), 'Og');
    
    hold on;
    plot(m(1,1), m(1,2), '*g');
    hold off;
    
    %Return variables used for cropping
    xmin = rotateLeftEye(1,1) - 90;
    ymin = rotateLeftEye(1,2) - 200;
    width = rotateRightEye(1,1) + 90 - xmin;
    height = rotateMouth(1,2) + 90 - ymin;
    
end