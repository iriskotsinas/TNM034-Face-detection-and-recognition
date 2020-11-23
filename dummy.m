%%%%READ SINGLE IMAGE FOR TESTING
function id = dummy(im)

 myimg = im2double(imread('images/DB1/db1_04.jpg'));
 myimg = whiteWorldCorrection(myimg);
myimg = faceMask(myimg);

eye = eyeMap(myimg) > 0.75;
mouth = mouthMap(myimg) > 0.9;

mask = eye + mouth;
mask(mask > 1) = 1;

myimg = myimg .* mask;

x = regionprops(mask, 'Centroid');
c = cat(1, x.Centroid);
   

mask = imbinarize(mask);
class(mask);
imshow(mask);
% figure;
% imshow(mask);
%Get positions of props
stats = regionprops('table', eye, 'Centroid', 'MajorAxisLength', 'MinorAxisLength');
statsMouth = regionprops('table', mouth, 'Centroid', 'MajorAxisLength', 'MinorAxisLength');

%Allocate memory, should be replace with size of stats.Centroid
x = zeros(4,1);
y = zeros(4,1);

%First, and last, should be position of the mouth
x(1,1)=statsMouth.Centroid(1,1);
y(1,1)=statsMouth.Centroid(1,2);
x(4,1)=statsMouth.Centroid(1,1);
y(4,1)=statsMouth.Centroid(1,2);

%Iterate over all possible triangles  (O(n^3)) Maximum efficiency

lka = size(stats.Centroid);
minimin =min(size(stats.Centroid));
%Allocate Triangle memory, based on how many triangles that will be
%available with the amount of vertices.
syms n;
amtTri = symsum(n-1, n, 1, lka(1));
amtTri = double(amtTri);
triangles = zeros(amtTri, 10);

count = 1;

mx = statsMouth.Centroid(1,1);
my = statsMouth.Centroid(1,2);

bestAng = 999999999999999;


for j=1:1:size(stats.Centroid)-1
    
    v1 = [mx my] - stats.Centroid(j,:);
    
%     y(1,1)=statsMouth.Centroid(1,2);
%     x(2,1)=stats.Centroid(j,1);
%     y(2,1)=stats.Centroid(j,2);
    
    for k=j+1:1:lka(1)
        v2 = [mx my] - stats.Centroid(k,:);
        ang = (180*acos(dot(v1,v2)/(norm(v1)*norm(v2))))/pi;
        
        x = [mx, stats.Centroid(j,1), stats.Centroid(k,1), mx];
        y = [my, stats.Centroid(j,2), stats.Centroid(k,2), my];
        

        hold on
        

        if (ang < 60 && ang > 30)
%             if y(2) < my && y(3) < my
               
%             end
            if (abs(norm(v1)-norm(v2)< 5))
                 plot(x, y, 'r');
            end
            
        end
        
        %plot(stats.Centroid(k,1), stats.Centroid(k,2), 'r*');
        
        
        
%         x(3,1)=stats.Centroid(k,1);
%         y(3,1)=stats.Centroid(k,2);
%         
%         diff(j) = 0;
%         LengthDiffVector(j) = 0;
%         %Calculate distance and angle between each point in a created
%         for w=1:1:3
%             
%             a = [x(w) y(w)];
%             b = [x(w+1) y(w+1)];
%             %Calculate the angle between the two points.
%             if(w==1)
%                LengthDiffVector(j,1) = norm(a-b);
%                ang = (180*acos(dot(a,b)/(norm(a)*norm(b))))/pi;
%                %The optimal angle between a face and eyes seem to be around 60
%                %degrees.
%                diff(j) = diff(j) + abs(ang-60);
%             end
%             
%             if(w==3)
%                 ang = (180*acos(dot(a,b)/(norm(a)*norm(b))))/pi;
%                 %The optimal angle between a face and eyes seem to be around 60
%                 %degrees.
%                 diff(j) = diff(j) + abs(ang-60);
%                LengthDiffVector(j,2) = norm(a-b);
%             end
        end
        %L(j) =  abs(LengthDiffVector(j,2)-LengthDiffVector(j,1));

       % count = count +1;
    end
end