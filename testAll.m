function testAll()

% img = imread("images/DB1/db1_01.jpg");
% img = imrotate(img, -15);
% 
% tnm034(img) 
% pause(1);
% tnm034(imread("images/DB1/db1_01.jpg"))


% TEST DB1
% for k = 1:1:4
%         uri = sprintf('images/DB0/db0_%d.jpg', k); 

% for k = 1:1:16
%     if (k < 10)
%         uri = sprintf('images/DB1/db1_0%d.jpg', k); 
%     else
%         uri = sprintf('images/DB1/db1_%d.jpg', k);
%     end
%     
%     im = imread(uri);
%     
%     im(:, :, 1) = im(:, :, 1) .* 1.0;
%     %im = imrotate(im, 0);
%     
%     tnm034(im)
%     pause(2);
% %     
% %     fel = 0;
% %     if (tnm034(im) ~= k)
% %         fel = fel + 1;
% %     end
% end

 




% 
%     for k = 1:1:16
%         if (k < 10)
%             uri = sprintf('images/DB1/db1_0%d.jpg', k);
%          else
%              uri = sprintf('images/DB1/db1_%d.jpg', k);
%         end
%         
%         %im = imread(uri);
%         
%         %im = imrotate(im, rand(1,1) * 10);
%         
%         %figure(2);
%         %imshow(im);
%         
%         test(uri, rand(1,1) * 20 - 10);
%         
%         %tnm034(im)
%         pause(2);
%     end
    
%     for k = 1:1:12
%        if (k == 2 || k == 5 || k == 6 || k == 8 || k == 10)
%         continue;
%        end
% %        
%        if (k < 10)
%            uri = sprintf('images/DB2/ex_0%d.jpg', k);
%        else
%             uri = sprintf('images/DB2/ex_%d.jpg', k);
%        end
%         
%        test3(uri);
%        pause(2);
%    end


%     for k = 1:1:4
%         uri = sprintf('images/DB0/db0_%d.jpg', k);
%         test3(uri);
%         pause(2);
%     end
    
    db2 = [
        "bl_01.jpg"
        "bl_02.jpg"
        "bl_04.jpg"
        "bl_05.jpg"
        "bl_06.jpg"
        "bl_07.jpg"
        "bl_10.jpg"
        "bl_13.jpg"
        "bl_14.jpg"
        "cl_01.jpg"
        "cl_02.jpg"
        "cl_03.jpg"
        "cl_04.jpg"
        "cl_05.jpg"
        "cl_06.jpg"
        "cl_07.jpg"
        "cl_08.jpg"
        "cl_09.jpg"
        "cl_10.jpg"
        "cl_11.jpg"
        "cl_12.jpg"
        "cl_13.jpg"
        "cl_14.jpg"
        "cl_15.jpg"
        "cl_16.jpg"
        "ex_01.jpg"
        "ex_03.jpg"
        "ex_04.jpg"
        "ex_07.jpg"
        "ex_09.jpg"
        "ex_11.jpg"
        "ex_12.jpg"
        "il_01.jpg"
        "il_07.jpg"
        "il_08.jpg"
        "il_09.jpg"
        "il_12.jpg"
        "il_16.jpg"
    ];

s = size(db2);
for k = 1:1:s(1)
   tnm034(imread("images/DB2/" + db2(k))) 
end

% 
% %tnm034(imread("images/DB2/" + db2(1)))
%     s = size(db2);
%     s
%     c = 0;
%     for k = 1:1:s(1)
%         x = test("images/DB2/" + db2(k), 0);
%         if (x == -1)
%             c = c + 1;
%         end
%         pause(2);
%         %tnm034(imread("images/DB2/" + db2(k)))
%         %test3("images/DB2/" + db2(k));
%         %pause(2);
%     end
%     
%     c

% for k = 1:1:4
%     test("images/DB1/db1_01.jpg", rand(1,1) * 20 - 10);
%     pause(2);
% end

end