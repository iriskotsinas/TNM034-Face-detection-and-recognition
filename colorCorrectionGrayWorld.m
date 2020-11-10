function [ output ] = colorCorrectionGrayWorld(input)
    %Scale each of the R, G and B-channels using 3 global adjustment
    %factors, to achieve equal mean values
    
    input = im2double(input);

    R = input(:,:,1);
    G = input(:,:,2);
    B = input(:,:,3);
    
    Ravg = mean(mean(R));
    Gavg = mean(mean(G));
    Bavg = mean(mean(B));

    alpha = Gavg/Ravg;
    beta = Gavg/Bavg;

    R = alpha * R;
    B = beta * B;

    output(:,:,1) = uint8(alpha * R * 255);
    output(:,:,2) = uint8(G * 255);
    output(:,:,3) = uint8(beta * B * 255);
end