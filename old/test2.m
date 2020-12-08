function test2()
    load('data.mat', 'weights', 'eigenFaces', 'meanFace');
    
    % TODO: im ska avändas här egentligen...!
    uri = 'images/DB1/db1_06.jpg';
    
    testImg = im2double(imread(uri));

    img = whiteWorldCorrection(testImg);
    img = faceMask(img);
    
    %imshow(eyeMap(img) > 0.85);
    
    
    eyePair = eyeFilter(img)
    
    clf;
    %imshow(img);
    hold on;
    plot([eyePair(1,1) eyePair(2,1)], [eyePair(1,2) eyePair(2,2)], '*r');    
    if (eyePair == zeros(2,2))
        index = -1337
    else
       [image, xmin, ymin, width, height] = faceAlignment(testImg, eyePair(1, :), eyePair(2, :));
        out = imcrop(image, [xmin, ymin, width, height]);
           %imshow(out);

        s = size(out)
            %if (s(1) ~= 301 || s(2) ~= 282)
            if (s(1) ~= 241 || s(2) ~= 197)
                123
            end
        
    
    testImg = rgb2gray(out);
    testImg = reshape(testImg, [], 1);
    testImg = testImg - meanFace;
    
    testWeights = eigenFaces' * testImg;
    
    [magnitude, index] = min(sum((testWeights - weights).^2, 1));
    
    % TODO: undersök vilket värde på felet
    if magnitude > 50
        id = 0;
    else
        id = index;
    end
    
    if (index < 10)
            uri = sprintf('images/train/image_000%d.jpg', index); 
        elseif (index < 100)
            uri = sprintf('images/train/image_00%d.jpg', index);
        else
            uri = sprintf('images/train/image_0%d.jpg', index);
    end
        
    imshow(im2double(imread(uri)));
    
end
end

% rätt: 1, 2, 5, 6, 8, 10, 12, 13, 16
% fel: 3, 4, 7, 9, 11, 14, 15,