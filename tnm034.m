% im: Image of unknown face, RGB-image in uint8 format in the 
% range [0,255]
%
% id: The identity number (integer) of the identified person,
% i.e. ‘1’, ‘2’,...,‘16’ for the persons belonging to ‘db1’ 
% and ‘0’ for all other faces.
function id = tnm034(im)
    meanFace = getMeanFace(); 
    [u, w] = getEigenfaces(meanFace);
    
    org = im2double(imread('images/DB1/db1_01.jpg'));
    
    img = detection(org);
    img = rgb2gray(img);
    
    test = reshape(img, [], 1);
    test = test - meanFace;

    
    ww = u' * test;

    [val, idx] = min(sum(sqrt((ww-w).^2),1));
    idx
    %[V,index] = min(sum(sqrt((ww-w).^2)));
    %index

    
%     figure(1);
%     imshow(img);
%     
%     load('eigenfaces.mat');
%     load('meanface.mat');
%     
%     img = reshape(img, [], 1);
%     
%     phi = img - meanface;
%     
%     
%     
%     w = phi' * A;
%     w = normr(w);
%     w
    
    
    
%     W = zeros(1, 16);
%     for k = 1:1:16
%         W(1,i) = eigenfaces * phi;
%     end


%     figure(1);
%     clf
%     
%     meanFace = zeros(301*282, 1);
%     faces = zeros(301*282, 16);
%     
%     for i=1:1:16
%         if i <= 9
%             org = im2double(imread(sprintf('images/DB1/db1_0%d.jpg', i)));
%         else
%             org = im2double(imread(sprintf('images/DB1/db1_%d.jpg', i))); 
%         end
%         
%         img = detection(org);
%         img = rgb2gray(img);
%         
%         subplot(4, 4, i);
%         imshow(img);
%         
%         
%         vec = reshape(img, [], 1);
%         
%         faces(:, i) = vec;
%         
% 
%         
%         meanFace = meanFace + vec;
%         
%         %imshow(org);
%         %hold on;
%         %plot(eyePair(:, 1), eyePair(:, 2), 'r*');
%     end
%     
%     meanFace = meanFace .* (1/16);
%     
%     figure(2);
%     meanFace = reshape(meanFace, [301, 282]);
%     imshow(meanFace);
%    
%        test = eigenface(meanFace, faces);

    
    
end
