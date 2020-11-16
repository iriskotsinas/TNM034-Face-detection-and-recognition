function [image, xmin, ymin, width, height ] = faceAlignment(origimg, eye, mouth)

    %Get eye position
    x = regionprops(eye, 'centroid');
    c = cat(1, x.Centroid);
    
    % Get distance between eyes
    xlength = abs(c(1,1) - c(1,2));
    ylength = abs(c(2,1) - c(2,2));
    
    %Get mouth position
    x = regionprops(mouth, 'centroid');
    m = cat(1, x.Centroid);
    mouth_x = m(1,1);
    mouth_y = m(1,2);
    
    %Rotate image
    hypo = sqrt(xlength^2 + ylength^2);
    angle = acosd(xlength / hypo);
    image = imrotate(origimg, -angle); % <--- RETURN VALUE
    
    
    %Get new position of eye
    alpha = angle;   % angle for rotation
    RotatedIm = imrotate(origimg,alpha);   % rotation of the main image (im)
    RotMatrix = [cosd(alpha) -sind(alpha); sind(alpha) cosd(alpha)]; 
    ImCenterA = (size(origimg(:,:,1))/2)';        % Center of the main image
    ImCenterB = (size(RotatedIm(:,:,1))/2)'; % Center of the transformed image
    
    P = c(:,1);   % coordinates of lefteye old
    RotatedP = RotMatrix*(P-ImCenterA)+ImCenterB;
    c(:,1) = RotatedP;
    
    P = c(:,2);   % coordinates of righteye old
    RotatedP = RotMatrix*(P-ImCenterA)+ImCenterB;
    c(:,2) = RotatedP;
    
    hold on;
    plot(c(:, 1), c(:,2), 'red');
    
    xmin = c(1,1) - 90;
    ymin = c(1,1) - 100;
    width = c(1,2) + 90 - xmin;
    height = mouth_y + 90 - ymin;
    
end