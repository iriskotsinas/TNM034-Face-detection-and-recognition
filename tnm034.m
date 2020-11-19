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
 myimg = im2double(imread('images/DB1/db1_02.jpg'));
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
%Allocate Triangle memory
triangles = zeros(23, 10);

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
            
            ang = (180*acos(dot(a,b)/(norm(a)*norm(b))))/pi;
            diff(j) = diff(j) + abs(ang-60);
            
            
            
            if(w==1)
               LengthDiffVector(j,1) = norm(a-b);
            end
            
            if(w==3)
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

count

hold on;
sizeTri = size(triangles)
for j=1:1:sizeTri(1)
    
    
   
   plot(triangles(j,(1:4)),triangles(j,(5:8)), 'r');
end



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
