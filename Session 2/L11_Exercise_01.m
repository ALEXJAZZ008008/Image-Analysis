% L11_Exercise_01

warning off;

% Test image size
data_size = 160;
num_circles = 8;
circle_radius = [1 2 4 8 16 32 48 64];
test_image = zeros(data_size,data_size,num_circles);

for k=1:num_circles

    for i=1:data_size
        for j=1:data_size
            dist = sqrt((i-data_size/2)*(i-data_size/2) + (j-data_size/2)*(j-data_size/2));
            if dist <= circle_radius(k), test_image(i,j,k) = 255; end
        end
    end

    figure
    imshow(test_image(:,:,k), [0 255]);
    titletext = sprintf('Circle of radius %d pixels', circle_radius(k));
    title(titletext)
    
end

pause

circle_area = zeros(1,num_circles);
circle_perimeter = zeros(1,num_circles);
circularity = zeros(1,num_circles);

for k=1:num_circles

    bw_image = test_image(:,:,k)>0;
    shape_info = regionprops(bw_image, 'Area');
    circle_area(k) = shape_info.Area;
    
    perim_sum = 0;
    bw_perim = bwperim(test_image(:,:,k),4);
    
    for i=1:data_size
        for j=1:data_size
            if bw_perim(i,j)==1,
                test_sum = 4 - (bw_image(i,j-1)+bw_image(i+1,j)+bw_image(i,j+1)+bw_image(i-1,j));
                if test_sum == 1, perim_sum = perim_sum + 1; end
                if test_sum == 2, perim_sum = perim_sum + sqrt(2); end
                if test_sum == 3, perim_sum = perim_sum + 1 + sqrt(2); end
            end
        end
    end

    circle_perimeter(k) = perim_sum;
    
    circularity(k) = 4*pi*circle_area(k)/(circle_perimeter(k)*circle_perimeter(k));
    
end

% Display results
message = sprintf('Circularity Results');
message = char(message, sprintf(''));
for k=1:num_circles
    message = char(message, sprintf('Radius = %d    Area = %d    Perimeter = %.1f   Circularity = %.3f', circle_radius(k), circle_area(k), circle_perimeter(k), circularity(k)));
end
hd = msgbox(cellstr(message), 'Circularity Dependence on ROI Size');
set(hd, 'position', [300 300 350 170]);

