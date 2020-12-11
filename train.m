function train()
    % cropped image dimensions
%     w = 282;    
%     h = 301;
    w = 212;
    h = 281;
    
    n = 16;
    
    meanFace = zeros(w*h, 1);
    phi = zeros(w*h, 16);
    
    
    for k = 1:1:n
        if k <= 9
            img = im2double(imread(sprintf('images/DB1/db1_0%d.jpg', k)));
        else
            img = im2double(imread(sprintf('images/DB1/db1_%d.jpg', k))); 
        end
        
        % crop image to face
        img = detection(img, true);
        size(img)
        
        % color => black/white
        img = rgb2gray(img);  
        
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
    
    weights = eigenFaces' * phi;
    
    save('data.mat', 'weights', 'eigenFaces', 'meanFace');
end