function [u, w] = getEigenfaces(meanFace)
    HEIGHT = 301;
    WIDTH = 282;
    
    A = zeros(HEIGHT*WIDTH, 16);

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
        
        % add to faces
        A(:, i) = img - meanFace;
    end
    
    % A = n x M (M = 16)
    % calculate 16 eigenvectors (A^T*A)
    C = A' * A;
    [V, ~] = eig(C);
    
    u = zeros(size(A));
    for k=1:1:16
        u(:,1) = A*V(:,i);
    end
    
    w = u' * A;
    
    
%     W = zeros(16, 16);
%     
%     for i = 1:1:16
%         u = A * v(:,i);
%         w = u' * A;
%         size(w)
%         W(:,i) = w(1, :)';
%         
%         uImg = reshape(u, HEIGHT, WIDTH);
%         temp = uImg - min(uImg(:));
%         temp = temp / max(temp(:));
%         subplot(4, 4, i);
%         imshow(temp);
%     end
%     
%     faces = A;
%     
%     W = normc(W);
%     
%     weights = W;
%     
%     save('eigenfaces.mat', 'weights', 'A');
    
    
end