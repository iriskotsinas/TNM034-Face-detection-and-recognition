function test()
% cropped image dimensions
    %w = 282;    
    %h = 301;
    w = 197;
    h = 241;
    
    n = 450;
    
    meanFace = zeros(w*h, 1);
    phi = zeros(w*h, n);    

    i = 1;
    clf;
    fel = 0;
    %for k = 220:1:259
    %for k = 40:1:79
    for k = 1:1:n
        if (k < 10)
            uri = sprintf('images/train/image_000%d.jpg', k); 
        elseif (k < 100)
            uri = sprintf('images/train/image_00%d.jpg', k);
        else
            uri = sprintf('images/train/image_0%d.jpg', k);
        end
       
        orgImg = im2double(imread(uri));

        img = whiteWorldCorrection(orgImg);
        img = faceMask(img);
        %img = eyeMap(img) > 0.85;
    
    % find eyes
        eyePair = eyeFilter(img);
        
        if (eyePair == zeros(2,2))
            %i = i + 1;
            fel = fel + 1;
            out = zeros(h, w, 3);
        else
            [image, xmin, ymin, width, height] = faceAlignment(orgImg, eyePair(1, :), eyePair(2, :));
            out = imcrop(image, [xmin, ymin, width, height]);
            s = size(out);
            s
            if (s(1) ~= h || s(2) ~= w)
            %if (size(out) ~= [301, 282, 3])
                fel = fel + 1;
                out = zeros(h, w, 3);
            end
        end
        
    %subplot(10, 4, i);
    %hold on;
    figure(3);
    imshow(out);
    i = mod(i, 40);
    i = i + 1;
    
    k
       
        % color => black/white
        img = rgb2gray(out);  
        
        % reshape to column vector
        img = reshape(img, [], 1);

        % append to meanface
        meanFace = meanFace + img;
        
        % add to phi
        phi(:, k) = img;
    end
    
    meanFace = meanFace ./ n;
    
        for k = 1:1:n
        phi(:, k) = phi(:, k) - meanFace;
    end
    
    % get convarians matrix
    C = phi' * phi;
    
    % get eigenvectors
    [eigenVectors, ~ ] = eig(C);
    
    % calculate eigenfaces
    eigenFaces = zeros(size(phi));
    for k = 1:1:n
        eigenFaces(:, k) = phi * eigenVectors(:, k);
    end
    
    % TODO: här borde vi bara ta de bästa egenvektorerna, om vi har flera
    eigenFaces = eigenFaces(:, 350:1:450);
    
    % bilder på samma person
    weights = eigenFaces' * phi;
    
    fel
    
    save('data.mat', 'weights', 'eigenFaces', 'meanFace');
    
end