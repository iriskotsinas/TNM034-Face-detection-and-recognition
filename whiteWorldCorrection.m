function out_im = whiteWorldCorrection(im) 
%im = imread("db1_01.jpg");
%im = im2double(im);

%Split image to each channel
im_R = im(:,:,1);
im_G = im(:,:,2);
im_B = im(:,:,3);

%Get mean top 5% of values
R_sorted = sort(im_R(:),'descend');    % Sort Descending
G_sorted = sort(im_G(:),'descend');    % Sort Descending
B_sorted = sort(im_B(:),'descend');    % Sort Descending

max_R = mean(R_sorted(1:ceil(length(R_sorted)*0.05)));   % Desired Output
max_G = mean(G_sorted(1:ceil(length(G_sorted)*0.05)));   % Desired Output
max_B = mean(B_sorted(1:ceil(length(B_sorted)*0.05)));   % Desired Output

alpha = max_G/max_R;
beta = max_G/max_B;

out_R = uint8(alpha*im_R*255);
out_G = uint8(im_G*255);
out_B = uint8(beta*im_B*255);

new_im = cat(3, out_R,out_G,out_B);
%figure;
%subplot(1,2,1);
%imshow(im);

%subplot(1,2,2);
%imshow(new_im);

out_im = im2double(new_im);
end
