function out = detection(orgImg)
    h = 281;
    w = 212;

    % white correction
    img = whiteWorldCorrection(orgImg);
 
    % get face mask
    img = faceMask(img);
    
    % find eyes
    eyePair = eyeFilter(img);
    if eyePair == zeros(2,2)
        "no eyes found"
        out = -1;
        return
    end
        
    % rotate + crop image
    [image, xmin, ymin, width, height] = faceAlignment(orgImg, eyePair(1, :), eyePair(2, :));
    out = imcrop(image, [xmin, ymin, width, height]);
    dim = size(out);
    if (dim(1) ~= h && dim(2) ~= w)
        "rotation falied"
        out = -1; 
    end
end