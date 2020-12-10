% function swag()
%     clf;
%       db2 = [
%         "bl_01.jpg"
%         "bl_02.jpg"
%         "bl_04.jpg"
%         "bl_05.jpg"
%         "bl_06.jpg"
%         "bl_07.jpg"
%         "bl_10.jpg"
%         "bl_13.jpg"
%         "bl_14.jpg"
%         "cl_01.jpg"
%         "cl_02.jpg"
%         "cl_03.jpg"
%         "cl_04.jpg"
%         "cl_05.jpg"
%         "cl_06.jpg"
%         "cl_07.jpg"
%         "cl_08.jpg"
%         "cl_09.jpg"
%         "cl_10.jpg"
%         "cl_11.jpg"
%         "cl_12.jpg"
%         "cl_13.jpg"
%         "cl_14.jpg"
%         "cl_15.jpg"
%         "cl_16.jpg"
%         "ex_01.jpg"
%         "ex_03.jpg"
%         "ex_04.jpg"
%         "ex_07.jpg"
%         "ex_09.jpg"
%         "ex_11.jpg"
%         "ex_12.jpg"
%         "il_01.jpg"
%         "il_07.jpg"
%         "il_08.jpg"
%         "il_09.jpg"
%         "il_12.jpg"
%         "il_16.jpg"
%     ];
%     s = size(db2);
% %     for k = 1:1:s(1)
% %         uri = "images/DB2/" + db2(k);
% %     for k = 1:1:4
% %         uri = sprintf('images/DB0/db0_%d.jpg', k);
    
function out = detection(img, debug)
%     for k = 1:1:16
%         if (k < 10)
%             uri = sprintf('images/DB1/db1_0%d.jpg', k); 
%         else
%             uri = sprintf('images/DB1/db1_%d.jpg', k);
%         end
%         img = im2double(imread(uri));
% 
% debug = true;

% REMOVE
orgImg = img;
img = colorCorrectionGrayWorld(img);
    
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
        uri
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
h = 280;
w = 221;
[image, xmin, ymin, width, height] = faceAlignment(orgImg, eyePair(1, :), eyePair(2, :));
out = imcrop(image, [xmin, ymin, width, height]);
% if (width ~= w || height ~= h)
%     out = -1;
%     return;
% end

if (debug)
    subplot(4, 3, 10);
    imshow(out);
    pause(1);
end

end