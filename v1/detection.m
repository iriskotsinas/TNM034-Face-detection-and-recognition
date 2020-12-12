function out = detection(img, debug)
orgImg = img;
img = colorCorrectionGrayWorld(img);
colorCorreted = img;
    
if (debug)
    clf;
    figure(1);
    
    % original
    subplot(4, 3, 1);
    imshow(orgImg);
    
    % gray world corrected image
    subplot(4, 3, 2);
    imshow(img);
end


faceMask = newFaceMask(img);
maskedImage = zeros(size(orgImg));
maskedImage(:, :, 1) = orgImg(:, :, 1) .* faceMask;
maskedImage(:, :, 2) = orgImg(:, :, 2) .* faceMask;
maskedImage(:, :, 3) = orgImg(:, :, 3) .* faceMask;

if (debug)
    % face mask
    subplot(4, 3, 3);
    imshow(faceMask);
    
    % origina with face mask
    subplot(4, 3, 4);
    imshow(maskedImage);
end

thresholdMouth = 0.9;
thresholdEye = 0.8;

mouthFull = mouthMap(maskedImage);
mouth = mouthFull > thresholdMouth;
eyeFull = eyeMap(maskedImage);
eye = eyeFull > thresholdEye;

if (debug)
    subplot(4, 3, 5);
    imshow(mouthFull);
    subplot(4, 3, 6);
    imshow(mouth);
    subplot(4, 3, 7);
    imshow(eyeFull);
    subplot(4, 3, 8);
    imshow(eye);
end

eyePair = eyeFilter(orgImg, mouth, eye);
if (eyePair == zeros(2,2))
    if (debug)
        "no eyes found"
        
    end
    out = -1;
    return
else
    if (debug)
        hold on;
        plot([eyePair(1,1) eyePair(2,1)], [eyePair(1,2) eyePair(2,2)], '*r');
        hold off;
    end
end

if (debug)
    m = regionprops('table', mouth, 'Centroid', 'MajorAxisLength', 'MinorAxisLength');
    m = m.Centroid(1, :);
    
    subplot(4, 3, 9);
    imshow(orgImg);
    hold on;
    plot([eyePair(1,1) eyePair(2,1) m(1,1) eyePair(1,1)], [eyePair(1,2) eyePair(2,2) m(1,2) eyePair(1,2)], 'r');
    hold off;    
end

% rotate + crop image
h = 281;
w = 212;
[image, xmin, ymin, width, height] = faceAlignment(im2double(colorCorreted), eyePair(1, :), eyePair(2, :));
out = imcrop(image, [xmin, ymin, width, height]);
ss = size(out);
if (ss(1) ~= h || ss(2) ~= w)
    out = -1;
    return;
end

if (debug)
    subplot(4, 3, 10);
    imshow(out);
    pause(1);
end

end