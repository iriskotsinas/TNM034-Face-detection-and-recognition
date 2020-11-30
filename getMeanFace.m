function face = getMeanFace()
    HEIGHT = 301;
    WIDTH = 282;
    
    face = zeros(HEIGHT*WIDTH, 1);

    for i=1:1:16
        if i <= 9
            org = im2double(imread(sprintf('images/DB1/db1_0%d.jpg', i)));
        else
            org = im2double(imread(sprintf('images/DB1/db1_%d.jpg', i))); 
        end
        
        % crop image to face
        img = detection(org);
        
        % color => black/white
        img = rgb2gray(img);  
        
        % reshape to row vector
        img = reshape(img, [], 1);
        
        % add to face matrix
        face = face + img;
    end
    
    % calculate mean value
    face = face .* (1/16);
    meanface = face;
    save('meanface.mat', 'meanface');
end
