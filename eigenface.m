% im: Image of unknown face, RGB-image in uint8 format in the 
% range [0,255]
%
% id: The identity number (integer) of the identified person,
% i.e. ‘1’, ‘2’,...,‘16’ for the persons belonging to ‘db1’ 
% and ‘0’ for all other faces.
%function id = tnm034(im)
    clear
    close all
    %myimg = im2double(imread('images/DB1/db1_01.jpg'));
    
    I = cell(1,16);
    for i=1:16
        if(i < 10)
        I{i}= im2double (imread(sprintf('images/DB1/db1_0%d.jpg',i)));
        
        else
        I{i}= im2double (imread(sprintf('images/DB1/db1_%d.jpg',i)));
        end
    end
    
    for i = 1:16
    subplot(4,4,i);
    imshow(I{i});
    title('Initial Images')
    end
    
    
    %%
    for i = 1:16
        
    myimg = whiteWorldCorrection(I{i});
    origimg = myimg;
    
    myimg = faceMask(myimg);
    eye = eyeMap(myimg) > 0.9;
    mouth = mouthMap(myimg) > 0.9;
    
    mask = eye + mouth;
    mask(mask > 1) = 1;
    
    myimg = myimg .* mask;
    %figure
    %imshow(myimg);
    %title('Mask')
    
    figure
    imshow(origimg)
    [x, y] = ginput(2)
    lefteye = [x(1), y(1)];
    righteye = [x(2), y(2)];
    
    %Align image
    [rotImg, xmin, ymin, width, height] = faceAlignment(origimg, eye, mouth, lefteye , righteye);
    
    
    %Crop image
    I{i} = imcrop(rotImg,[xmin ymin width height]);
    
    %figure
    %imshow(I{i})
    %title('Cropped Image')
    
    end
   
    %%
    for i = 1:16
    subplot(4,4,i);
    imshow(I{i});
    title('Cropped Images')
    end
    
%end       
