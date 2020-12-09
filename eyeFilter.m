function [eyePair] = eyeFilter(img)
    mouth = mouthMap(img);
    mouth=(mouth-min(mouth(:)))/(max(mouth(:))-min(mouth(:)));
    mouth = mouth >= 1;
    
%     quantile((max(mouthMap(img))), 0.9);
%     if(quantile((max(mouthMap(img))), 0.9) < 0.1)
%         mouth = mouthMap(img) > 0.8;
%     else
%          mouth = mouthMap(img) > 0.8;
%     end
%     
    
    
    
    % TODO: check this plz!
    theMouth = regionprops('table', mouth, 'Centroid', 'MajorAxisLength', 'MinorAxisLength');
    m = theMouth.Centroid(1, :);
    m
    

    
    
    o = zeros(size(img));
    boxSizedown = 150;
    boxSizeUpper = 200;
    %%@@TODO: Make sure to check different mouth candidates, right now we
    %%assume that we have chosen the correct point right away!
    %img(upleft, RIGHT) ish
     hold on;
    plot(m(1),m(2),'g*');
    hold off;
    try
        o(floor(m(1,1)-boxSizedown-150):floor(m(1,1)), floor(m(1,2)-boxSizeUpper-50):floor(m(1,2)+boxSizeUpper+50)) =  img(floor(m(1,1)-boxSizedown-150):floor(m(1,1)), (floor(m(1,2)-boxSizeUpper-50):floor(m(1,2)+boxSizeUpper+50)));
        %Debug code to validate mouth candidate.
%         subplot(1,2,1);
%         imshow(img);
%         hold on;
%         plot(m(1),m(2),'g*');
%         hold off;
% 
%         subplot(1,2,2);
%         imshow(o)
%         hold on;
%         plot(m(1),m(2),'g*');
%         figure(2);

        eye = eyeMap(o);
    catch
        try
            %Try smaller box
            o(floor(m(1,1)-boxSizedown):floor(m(1,1)), floor(m(1,2)-boxSizeUpper):floor(m(1,2)+boxSizeUpper+50)) =  img(floor(m(1,1)-boxSizedown):floor(m(1,1)), (floor(m(1,2)-boxSizeUpper-50):floor(m(1,2)+boxSizeUpper)));
%             subplot(1,2,1);
%         imshow(img);
%         hold on;
%         plot(m(1),m(2),'g*');
%         hold off;
% 
%         subplot(1,2,2);
%         imshow(o)
%         hold on;
%         plot(m(1),m(2),'g*');
%         figure(2);
            eye = eyeMap(img);
        catch
            eye = eyeMap(img);
        end
        
    end
    
   

%     eye = eyeMap(o);
    eye=(eye-min(eye(:)))/(max(eye(:))-min(eye(:))) > 0.8;
    
    possibleEyes = regionprops('table', eye, 'Centroid', 'MajorAxisLength', 'MinorAxisLength');
    
    n = size(possibleEyes.Centroid, 1);
    
    eyePair = zeros(2, 2);

    minLength = 9999999;
    for i = 1:1:n-1
        v1 = m - possibleEyes.Centroid(i, :);

        for j = i+1:1:n
            v2 = m - possibleEyes.Centroid(j, :);

            ang = (180*acos(dot(v1,v2)/(norm(v1)*norm(v2))))/pi;
            diff = abs(norm(v1)-norm(v2));
            
            v3 = [0, 1];
            ang1 = (180*acos(dot(v1,v3)/(norm(v1)*norm(v3))))/pi;
            ang2 = (180*acos(dot(v2,v3)/(norm(v2)*norm(v3))))/pi;

            if ang < 70 && ang > 30 && ang1 < 60 && ang2 < 60
                if diff < minLength
                    eyePair(1, :) = possibleEyes.Centroid(i, :);
                    eyePair(2, :) = possibleEyes.Centroid(j, :);
                    minLength = diff;
                end
            end
        end
    end
end
