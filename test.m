function x = test(uri, alpha)
    %uri = 'images/DB1/db1_01.jpg';
    
    clf;
    figure(1);
    
    % original image
    orgImg = im2double(imread(uri));
%     
    s = size(orgImg);
    diffw = 0.05 * s(1);
    diffh = 0.05 * s(2);
    orgImg = imcrop(orgImg, [diffw, diffh, s(2) - 2*diffw, s(1) - 2*diffh]);
    
    orgImg = imrotate(orgImg, alpha);
    orgImg = orgImg .* (1.3 - rand() * 0.6);
    
    

    subplot(3, 3, 1);
    imshow(orgImg);
    
    % white world correction
    img = whiteWorldCorrection(orgImg);
    subplot(3, 3, 2);
    imshow(img);
    
    % face mask
    img = faceMask(img);
    subplot(3, 3, 3);
    imshow(img);
    
    % mouth map
    tmp = mouthMap(img);
    subplot(3, 3, 4);
    imshow(tmp);
    tmp = tmp > 0.9;
    subplot(3, 3, 5);
    imshow(tmp > 0.9);
    
    % eye map
    tmp = eyeMap(img);
    subplot(3, 3, 6);
    imshow(tmp);
    tmp = tmp > 0.8;
    subplot(3, 3, 7);
    imshow(tmp);
    
    eyePair = eyeFilter(img);
    if eyePair == zeros(2,2)
        "no eyes found"
        uri
        x = -1
        return
    else
        hold on;
        plot([eyePair(1,1) eyePair(2,1)], [eyePair(1,2) eyePair(2,2)], '*r');
        hold off;
    end
    
    % rotate + crop image
    h = 281;
    w = 212;
    [image, xmin, ymin, width, height] = faceAlignment(orgImg, eyePair(1, :), eyePair(2, :));
    
%     subplot(3, 3, 8);
%     imshow(image);
    
    out = imcrop(image, [xmin, ymin, width, height]);
    dim = size(out);
    dim
    if (dim(1) == h && dim(2) == w)
        subplot(3, 3, 8);
        imshow(out);
        x = 1
    else
        "rotation failed"
        uri
        x = -1
    end
end