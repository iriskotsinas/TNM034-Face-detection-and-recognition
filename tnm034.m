% im: Image of unknown face, RGB-image in uint8 format in the 
% range [0,255]
%
% id: The identity number (integer) of the identified person,
% i.e. ‘1’, ‘2’,...,‘16’ for the persons belonging to ‘db1’ 
% and ‘0’ for all other faces.
function id = tnm034(im)    
    [weights, eigenFaces, meanFace] = train();
    save('data.mat', 'weights', 'eigenFaces', 'meanFace');
    
    load('data.mat', 'weights', 'eigenFaces', 'meanFace');
    
    % TODO: im ska avändas här egentligen...!
    uri = 'images/DB1/db1_13.jpg';
    
    testImg = detection(im2double(imread(uri)));
    testImg = rgb2gray(testImg);
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
    
    clear weights eigenFaces meanFace;
end
