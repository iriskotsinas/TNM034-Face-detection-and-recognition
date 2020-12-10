function asdf()
    clf;
      db2 = [
        "bl_01.jpg"
        "bl_02.jpg"
        "bl_04.jpg"
        "bl_05.jpg"
        "bl_06.jpg"
        "bl_07.jpg"
        "bl_10.jpg"
        "bl_13.jpg"
        "bl_14.jpg"
        "cl_01.jpg"
        "cl_02.jpg"
        "cl_03.jpg"
        "cl_04.jpg"
        "cl_05.jpg"
        "cl_06.jpg"
        "cl_07.jpg"
        "cl_08.jpg"
        "cl_09.jpg"
        "cl_10.jpg"
        "cl_11.jpg"
        "cl_12.jpg"
        "cl_13.jpg"
        "cl_14.jpg"
        "cl_15.jpg"
        "cl_16.jpg"
        "ex_01.jpg"
        "ex_03.jpg"
        "ex_04.jpg"
        "ex_07.jpg"
        "ex_09.jpg"
        "ex_11.jpg"
        "ex_12.jpg"
        "il_01.jpg"
        "il_07.jpg"
        "il_08.jpg"
        "il_09.jpg"
        "il_12.jpg"
        "il_16.jpg"
    ];
    s = size(db2);
%     for k = 1:1:s(1)
%         uri = "images/DB2/" + db2(k);
%     for k = 1:1:4
%         uri = sprintf('images/DB0/db0_%d.jpg', k);
    
    for k = 1:1:16
        if (k < 10)
            uri = sprintf('images/DB1/db1_0%d.jpg', k); 
        else
            uri = sprintf('images/DB1/db1_%d.jpg', k);
        end
    %uri = "images/test/db1_07.jpg";
    img = im2double(imread(uri));
    
    %img = imrotate(img, 10);
    %img = imrotate(img, rand() * 20 - 10);
    
    
    img = img .* (1.3 - rand() * 0.6);
    
    %     
    s = size(img);
    diffw = 0.05 * s(1);
    diffh = 0.05 * s(2);
    img = imcrop(img, [diffw, diffh, s(2) - 2*diffw, s(1) - 2*diffh]);
    
    
    
    orgImg = img;
    realOrgImg = img;
    
    
    
    
    
    %img = img .* 0.7;
    %img = img .* 1.3;
%     
%     img(:, :, 1)  = imadjust(img(:, :, 1), [0.05, 0.95]);
%     img(:, :, 2)  = imadjust(img(:, :, 2),[0.05, 0.95]); 
%     img(:, :, 3) = imadjust(img(:, :, 3), [0.05, 0.95]);
    
    %img = im2double(imread("images/DB1/db1_01.jpg"));
    %img = im2double(imread("images/DB2/cl_01.jpg"));
    
    figure(1);
    subplot(4, 3, 1);
    imshow(img);
    
    img = colorCorrectionGrayWorld(img);
    subplot(4, 3, 2);
    imshow(img);
    
    [hue, ~, ~] = rgb2hsv(img);
    %subplot(4, 1, 4);
    %imhist(hue);
    x = mean(hue, 'all');
    %x
    
    tmp = rgb2ycbcr(img);
    cb = tmp(:,:,2);
    cr = tmp(:,:,3);
    
    crx = imgaussfilt(cr, 15);
    level = graythresh(crx);
    level
    subplot(4, 3, 3);
    imshow(imbinarize(crx, level));
    img = imbinarize(crx, level);
    
    %[r,c] = find(cb>=77 & cb<=200 & cr>=134 & cr<=173);
    %[r,c] = find(cb>=90 & cb<=150 & cr>=120 & cr<=150);
    %[r,c] = find(hue > 0.5 & hue < 0.7);
    [r,c] = find(hue > 0.63 & cr > 120 & cr < 160); % & cb > 90 & cb < 150);
    numind = size(r,1);

    %Set value to pixels with skin color
    s = size(img);
    img = zeros(s(1), s(2));
    for i=1:numind
        img(r(i),c(i)) = 1;
    end
    
    imgSize = size(img);
    theend = imgSize(1);
    start = theend - floor(theend * 0.05);
    img(start:1:theend, :) = 0;
    
    
    img = imclose(img, strel('disk', 30, 8));
    %img = imopen(img, strel('disk', 10, 4));

    img = im2bw(imfill(img, 'holes'));
    img = medfilt2(bwareafilt(img, 1));
    
    subplot(4, 3, 4);
    imshow(img);
    
    orgImg(:, :, 1) = orgImg(:, :, 1) .* img;
    orgImg(:, :, 2) = orgImg(:, :, 2) .* img;
    orgImg(:, :, 3) = orgImg(:, :, 3) .* img;
    subplot(4, 3, 5);
    imshow(orgImg);
    
    % mouth map
    tmp = mouthMap(orgImg);
    mouth = tmp;
    subplot(4, 3, 6);
    imshow(tmp);
    tmp = tmp > 0.9;
    subplot(4, 3, 7);
    imshow(tmp > 0.9);
    
    % eye map
    tmp = eyeMap(orgImg);
    subplot(4, 3, 8);
    imshow(tmp);
    tmp = tmp > 0.8;
    subplot(4, 3, 9);
    imshow(tmp);
    
    eyePair = eyeFilter(orgImg);
    if eyePair == zeros(2,2)
        "no eyes found"
        uri
        x = -1
        continue
    else
        hold on;
        plot([eyePair(1,1) eyePair(2,1)], [eyePair(1,2) eyePair(2,2)], '*r');
        hold off;
    end
    
    theMouth = regionprops('table', mouth, 'Centroid', 'MajorAxisLength', 'MinorAxisLength');
    m = theMouth.Centroid(1, :);
    
    subplot(4, 3, 10);
    imshow(realOrgImg);
    hold on;
    plot([eyePair(1,1) eyePair(2,1) m(1,1) eyePair(1,1)], [eyePair(1,2) eyePair(2,2) m(1,2) eyePair(1,2)], 'r');
    hold off;
    
    
    % rotate + crop image
    h = 281;
    w = 221;
    [image, xmin, ymin, width, height] = faceAlignment(realOrgImg, eyePair(1, :), eyePair(2, :));
    width
    out = imcrop(image, [xmin, ymin, width, height]);
    subplot(4, 3, 11);
    imshow(out);
%     dx = abs(eyePair(1,1) - eyePair(2,1));
%     dy = abs(eyePair(1,2) - eyePair(2,2));
%     angle = atand(dy / dx);
%     if (eyePair(1,2) > eyePair(2,2))
%         angle = -angle;
%     end
%     rotatedImage = imrotate(realOrgImg, angle);
%     
%         s1 = size(realOrgImg);
%     s1 = [floor(s1(1) / 2) floor(s1(2) / 2)];
%     s2 = size(rotatedImage);
%     s2 = [floor(s2(1) / 2) floor(s2(2) / 2)];
%     diff = s1 - s2;
%     
%     %rotatedImage = imtranslate(rotatedImage, diff);
%     subplot(4, 3, 11);
%     imshow(rotatedImage);
%     
%     angle = -angle;
%     R = [cosd(angle) -sind(angle); sind(angle) cosd(angle)]; 
% %     
%     s1 = size(realOrgImg);
%     s1 = [floor(s1(1) / 2) floor(s1(2) / 2)];
%     s2 = size(rotatedImage);
%     s2 = [floor(s2(1) / 2) floor(s2(2) / 2)];
%     diff = s1 - s2;
%     
%     %rotatedImage = imtranslate(rotatedImage, [diff(1) diff(2)]);
%     
%     %diff = [floor(s1(1) / 2) floor(s1(2) / 2)] - [floor(s2(1) / 2) floor(s2(2) / 2)]; 
% %     diff
% 
% 
% %     new_left = R * (eyePair(1, :) - [-s1(1) s1(2)])';
% %     new_left = new_left' + [-s1(1) s1(2)];
% %     %new_left = new_left'; % - diff;
% %     new_right = R * eyePair(2, :)';
% %     new_right = new_right';
% %     %new_right = new_right' + s2; %- diff;
% %     new_mouth = R * m(1, 1);
% 
% 
%     new_left = R * (eyePair(1, :) - s1)';
%     new_left = new_left' + s1; % - diff;
%     new_right = R * (eyePair(2, :) - s2)';
%     new_right = new_right' + s2; %- diff;
%     new_mouth = R * m(1, 1);
%     
%     eyePair(1, :) = new_left;
%     eyePair(2, :) = new_right;
%     
% %     wtf1 = size(realOrgImg);
% %     wtf2 = size(rotatedImage);
% %     diff = wtf2 - wtf1;
% %     diff
% % 
% %     if (angle > 0)
% %         eyePair(1,1) = eyePair(1,1) + diff(1)*0.5; 
% %         eyePair(1,2) = eyePair(1,2) - diff(2)*0.5; 
% %         eyePair(2,1) = eyePair(2,1) + diff(1)*0.5; 
% %         eyePair(2,2) = eyePair(2,2) - diff(2)*0.5; 
% %     else
% %         eyePair(1,1) = eyePair(1,1) + diff(1)*0.5; 
% %         eyePair(1,2) = eyePair(1,2) + diff(2)*0.5; 
% %         eyePair(2,1) = eyePair(2,1) + diff(1)*0.5; 
% %         eyePair(2,2) = eyePair(2,2) + diff(2)*0.5; 
% %     end
%     
%     hold on;
%     plot([eyePair(1,1) eyePair(2,1) m(1,1) eyePair(1,1)], [eyePair(1,2) eyePair(2,2) m(1,2) eyePair(1,2)], 'r');
%     hold off;
    
    pause(1);
   end
    
    
%     %pause(2);
%     tmp = rgb2ycbcr(img);
%     cb = im2double(tmp(:,:,2));
%     cr = im2double(tmp(:,:,3));
%     
%     subplot(2, 1, 1);
%     imshow(cb);
%     subplot(2, 1, 2);
%     imshow(cr);
%     
%     x = [cb, cr]';
%     size(x)
%     
%     m = mean(x, 'all');
%     m
%     
%     C = (x - m) * (x - m)';
%     
%     %%−0.5(x−m)TC−1(x−m)
% 
%     P = -0.5 * (x - m)' * C.^-1  * (x - m);
%     
%     
%     figure(2);
%     mesh(P);
end