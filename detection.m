function out = detection(orgImg)
    % white correction
    img = whiteWorldCorrection(orgImg);
 
    % get face mask
    img = faceMask(img);
    
    % find eyes
    eyePair = eyeFilter(img);
    
    % rotate + crop image
    [image, xmin, ymin, width, height] = faceAlignment(orgImg, eyePair(1, :), eyePair(2, :));
    out = imcrop(image, [xmin, ymin, width, height]);
end