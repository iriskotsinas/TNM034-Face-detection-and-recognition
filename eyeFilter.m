function [eyePair] = eyeFilter(img)

    eye = eyeMap(img) > 0.85;
    mouth = mouthMap(img) > 0.9;
    
    possibleEyes = regionprops('table', eye, 'Centroid', 'MajorAxisLength', 'MinorAxisLength');
    
    % TODO: check this plz!
    theMouth = regionprops('table', mouth, 'Centroid', 'MajorAxisLength', 'MinorAxisLength');
    m = theMouth.Centroid(1, :);

    n = size(possibleEyes.Centroid, 1);
    
    eyePair = zeros(2, 2);

    minLength = 9999999;
    for i = 1:1:n-1
        v1 = m - possibleEyes.Centroid(i, :);

        for j = i+1:1:n
            v2 = m - possibleEyes.Centroid(j, :);

            ang = (180*acos(dot(v1,v2)/(norm(v1)*norm(v2))))/pi;
            diff = abs(norm(v1)-norm(v2));

            if ang < 70 && ang > 30
                if diff < minLength
                    eyePair(1, :) = possibleEyes.Centroid(i, :);
                    eyePair(2, :) = possibleEyes.Centroid(j, :);
                    minLength = diff;
                end
            end
        end
    end
end