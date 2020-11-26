function vec = eigenface(mean, faces)
    A = zeros(size(faces));
    
    for i = 1:1:16
        A(:, i) = faces(:, i) - mean;
    end
    
    v = A' * A;
    %size(eig(v))
 
    %u = A * v;
    %u = (16, 16) 
    
    figure(2);
    clf
    
    
    for i = 1:1:16
        u = A * v(:,i);
        figure(2);
        u2 = reshape(u, 301, 282);
        
        img1 = max(u2, 0);
        img1 = img1 / max(img1(:));
        img2 = u2 - min(u2(:));
        img2 = img2 / max(img2(:));

        %subplot(4, 4, i);
        imshow(img2);
        class(u2)
    end
    
    vec = 1
%     
%     class(faces)
%     class(mean)
%     class(A)
end