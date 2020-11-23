% im: Image of unknown face, RGB-image in uint8 format in the 
% range [0,255]
%
% id: The identity number (integer) of the identified person,
% i.e. ‘1’, ‘2’,...,‘16’ for the persons belonging to ‘db1’ 
% and ‘0’ for all other faces.
function id = tnm034(im)

% for i=1:1:16
%     if i <= 9
%         myimg = im2double(imread(sprintf('images/DB1/db1_0%d.jpg', i)));
%     else
%        myimg = im2double(imread(sprintf('images/DB1/db1_%d.jpg', i))); 
%     end
%     
%     myimg = whiteWorldCorrection(myimg);
%     myimg = faceMask(myimg);
% 
%     eye = eyeMap(myimg) > 0.75;
% 
%     mouth = mouthMap(myimg) > 0.9;
%     mask = eye + mouth;
%     mask(mask > 1) = 1;
%     
%     myimg = myimg .* mask;
%     
%     subplot(4,4,i);
%     mouth = mouthMap(myimg) > 0.9;
%     mask = eye + mouth;
%     mask(mask > 1) = 1;
%     myimg = myimg .* mask;
%     imshow(mask);
% 
% end

%%%%READ SINGLE IMAGE FOR TESTING
 myimg = im2double(imread('images/DB1/db1_03.jpg'));
 myimg = whiteWorldCorrection(myimg);
    myimg = faceMask(myimg);
    eye = eyeMap(myimg) > 0.75;
    mouth = mouthMap(myimg) > 0.9;
    
    mask = eye + mouth;
    mask(mask > 1) = 1;
    
    myimg = myimg .* mask;
    
    x = regionprops(mask, 'Centroid');
    x
    c = cat(1, x.Centroid);
    c
   

mask = imbinarize(mask);
class(mask);
imshow(mask);
% figure;
% imshow(mask);
%Get positions of props
stats = regionprops('table', eye, 'Centroid', 'MajorAxisLength', 'MinorAxisLength')
statsMouth = regionprops('table', mouth, 'Centroid', 'MajorAxisLength', 'MinorAxisLength')

statsMouth.Centroid


%Allocate memory, should be replace with size of stats.Centroid
x = zeros(4,1);
y = zeros(4,1);

%First, and last, should be position of the mouth
x(1,1)=statsMouth.Centroid(1,1);
y(1,1)=statsMouth.Centroid(1,2);
x(4,1)=statsMouth.Centroid(1,1);
y(4,1)=statsMouth.Centroid(1,2);

%Iterate over all possible triangles  (O(n^3)) Maximum efficiency

lka = size(stats.Centroid)
minimin =min(size(stats.Centroid))
lka(1)
%Allocate Triangle memory, based on how many triangles that will be
%available with the amount of vertices.
syms n;
amtTri = symsum(n-1, n, 1, lka(1))
amtTri = double(amtTri);
triangles = zeros(amtTri, 10);

count = 1;

for j=1:1:size(stats.Centroid)-1
    triangles(count,1)=x(1,1);
    triangles(count,5)=y(1,1);
    triangles(count,4)=x(1,1);
    triangles(count,8)=y(1,1);
   
    y(1,1)=statsMouth.Centroid(1,2);
    
    x(2,1)=stats.Centroid(j,1);
    y(2,1)=stats.Centroid(j,2);
    
    
    triangles(count,2)=(x(2,1));
    triangles(count,6)=(y(2,1));
 
    
    for k=j+1:1:lka(1)
        triangles(count,1)=x(1,1);
        triangles(count,5)=y(1,1);
        triangles(count,4)=x(1,1);
        triangles(count,8)=y(1,1);
        triangles(count,2)=(x(2,1));
        triangles(count,6)=(y(2,1));
        
        x(3,1)=stats.Centroid(k,1);
        y(3,1)=stats.Centroid(k,2);
        
        triangles(count,3)=(x(3,1));
        triangles(count,7)=(y(3,1));
        
        diff(j) = 0;
        LengthDiffVector(j) = 0;
        %Calculate distance and angle between each point in a created
        for w=1:1:3
            
            a = [x(w) y(w)];
            b = [x(w+1) y(w+1)];
            %Calculate the angle between the two points.
            if(w==1)
               LengthDiffVector(j,1) = norm(a-b);
               ang = (180*acos(dot(a,b)/(norm(a)*norm(b))))/pi;
               %The optimal angle between a face and eyes seem to be around 60
               %degrees.
               diff(j) = diff(j) + abs(ang-60);
            end
            
            if(w==3)
                ang = (180*acos(dot(a,b)/(norm(a)*norm(b))))/pi;
                %The optimal angle between a face and eyes seem to be around 60
                %degrees.
                diff(j) = diff(j) + abs(ang-60);
               LengthDiffVector(j,2) = norm(a-b);
            end
        end
        L(j) =  abs(LengthDiffVector(j,2)-LengthDiffVector(j,1));
        
        triangles(count,9) = diff(j);
        triangles(count,10) = L(j);
        
        %diff(j) = abs(LengthDiff(j,2)-LengthDiff(j,1))
%         if(j==1)
%             diffXY = [x' ; y'];
%             diffmin = diff(j);
%             LengthXY = [x';y'];
%             Lengthmin = L(j);
%         end
%         
%         
% %         Update lengthmin(Length)
%         if(L(j)<Lengthmin)
%             LengthXY = [x';y'];
%             Lengthmin = L(j);
%         end
%         %Update diffmin(Angle)
%         if(diff(j)<(diffmin))
%             diffXY = [x' ; y'];
%             diffmin = diff(j);
%         end
        %Check where diffmin AND lengthmin is the smallest:
        
        
%         hold on;
%         plot(x,y,'color',rand(1,3));
        count = count +1;
    end
   

end
%All possible triangles are now saved. We will now compare them to find the
%optimal triangle for both angle and length.

hold on;
sizeTri = size(triangles);

    
    %Add the starting triangle as out 'best resulting triangle' for now
    optimalAngle = triangles(1, 9);
    optimalLength = triangles(1, 10);

    anglevalues = triangles(:,9)
    lengthvalues = triangles(:,10);
    [MinAng, AngIndex] = sort(anglevalues(:));
    [MinLen, LenIndex] = sort(lengthvalues(:));
    
    MinLen
    MinAng
%     plot(triangles(LenIndex(1), (1:4)), triangles(LenIndex(1), (5:8)));
    %+5 and +30 is random numbers taken for the average. It is not how this should be implemented
    resultingTriangle = triangles(1, :);
    
    
    maxvalLen = max(MinLen)
    minvalLen = min(MinLen)
    maxvalAng = max(MinAng)
    minvalAng = min(MinAng)
    
    resLen = abs(((maxvalLen-minvalLen)/100)*(triangles(:,10)-minvalLen))
    resAng = ((maxvalAng-minvalAng)/100)*(triangles(:,9)-minvalAng)
    
    resTot = resAng;
    
    
    [a,b] = min(resTot)
    
    resultingTriangle = triangles(b,:);
    
%     
%     optimalLength = mean(resLen);
%     optimalAngle = mean(resAng);
% for j=1:1:sizeTri(1)
%     
%     resLen = abs(((maxvalLen-minvalLen)/100)*(MinLen(j)-minvalLen));
%     resAng = ((maxvalAng-minvalAng)/100)*(MinAng(j)-minvalAng);
%     
%     
%     if(resAng<optimalAngle)
%         
%         if(resLen < optimalLength)
%             optimalAngle=MinAng(j);
%             optimalLength = MinLen(j);
%             resultingTriangle = triangles(AngIndex(j), :);
%          
%         end
% 
%     elseif(MinLen(j)< optimalLength)
%             if(MinLen(j) < optimalLength+20)
%                 optimalAngle=MinAng(j);
%                 optimalLength = MinLen(j);
%                 resultingTriangle = triangles(LenIndex(j), :);
%             end
%     elseif(resultingTriangle(1,1)==0)
%         resultingTriangle = triangles(j);
%     end
%     
% end
    
    
%     diff(j) = 0;
%     LengthDiffVector(j) = 0;
    
    
%     for w=1:1:3
%         %Instatiate a temporary triangle
%         temptri = triangle(j);
%         %these are two temporary points in.
%         x1temp = [temptri(w) temptri(w+3)];
%         x2temp = [temptri(w+1) temptri(w+4)];
% 
%         ang = (180*acos(dot(x1temp,x2temp)/(norm(x1temp)*norm(x2temp))))/pi;
%         
%         diff(j) = diff(j) + abs(ang-60);
%         %Store the distance between the points in a length vector to
%         %further down calculate the minimal distance.
%         if(w==1)
%            LengthDiffVector(j,1) = norm(x1temp-x2temp);
%         end
% 
%         if(w==3)
%            LengthDiffVector(j,2) = norm(x1temp-x2temp);
%         end
%     end

hold on;
plot(resultingTriangle((1:4)),resultingTriangle((5:8)));



% hold on;
% diffXY(:, 1)
% diffXY(:, 2)
% plot(diffXY(1,:),diffXY(2,:), 'g');
% plot(LengthXY(1,:),LengthXY(2,:), 'r');
% 
% hold off;
% plot(diff,'g');
% hold on;
% plot(L);
% 
% hold on;
% plot(stats.Centroid(1,:), statsMouth.Centroid(1,:),'r');
% plot(stats.Centroid(2,:), statsMouth.Centroid(1,:),'g');
% plot(stats.Centroid(1,:), stats.Centroid(2,:),'y');


   
%     xlength = abs(c(1,1) - c(1,2));
%     ylength = abs(c(2,1) - c(2,2));
%     
%     hypo = sqrt(xlength^2 + ylength^2);
%     
%     angle = acosd(xlength / hypo);
%     
%     newimg = imrotate(myimg, -angle);
%     
%     imshow(newimg);
%     
%     %test = atan2d(c(:, 1), c(:, 2));
%     
%     %imshow(eye);
%    
%     hold on;
%     plot(c(:, 1), c(:,2), 'red');
    
%     
%     x = regionprops(eye, 'centroid');
%     c = cat(1, x.Centroid);
%     
%     xlength = abs(c(1,1) - c(1,2));
%     ylength = abs(c(2,1) - c(2,2));
%     
%     hypo = sqrt(xlength^2 + ylength^2);
%     
%     angle = acosd(xlength / hypo);
%     
%     newimg = imrotate(myimg, -angle);
%     
%     imshow(newimg);
%     
%     %test = atan2d(c(:, 1), c(:, 2));
%     
%     %imshow(eye);
%     hold on;
%     plot(c(:, 1), c(:,2), 'red');
%     
    %size(c)
   
%     
%     mouth = mouthMap(myimg) > 0.9;
%     mask = eye + mouth;
%     mask(mask > 1) = 1;
%     
%     myimg = myimg .* mask;
%     
%     imshow(myimg);
end       
