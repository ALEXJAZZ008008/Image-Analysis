% L11_Exercise_02

warning off;

% Test image size
data_size = 160;
num_circles = 8;
circle_radius = [1 2 4 8 16 32 48 64];
test_image = zeros(data_size,data_size,num_circles);

for k=1:num_circles

    % Create circles
    for i=1:data_size
        for j=1:data_size
            dist = sqrt((i-data_size/2)*(i-data_size/2) + (j-data_size/2)*(j-data_size/2));
            if dist <= circle_radius(k), test_image(i,j,k) = 255; end
        end
    end
    
    % Take notches out to create concavity
    for i=1:data_size
        for j=1:data_size
            offset = circle_radius(k)+1;
            dist = sqrt((i-data_size/2)*(i-data_size/2) + (j-data_size/2-offset)*(j-data_size/2-offset));
            if dist <= circle_radius(k), test_image(i,j,k) = 0; end
        end
    end

    figure
    imshow(test_image(:,:,k), [0 255]);
    titletext = sprintf('Extent of %d pixels', circle_radius(k));
    title(titletext)
    
end

pause

circle_area = zeros(1,num_circles);
circle_convex_hull = zeros(1,num_circles);

for k=1:num_circles

    bw_image = test_image(:,:,k)>0;
    shape_info = regionprops(bw_image, 'Area', 'ConvexHull');
    
    white_image = ones(data_size,data_size);
    [~,convex_hull_image] = roifill(white_image, shape_info.ConvexHull(:,1), shape_info.ConvexHull(:,2));
    
    circle_area(k) = shape_info.Area;
    circle_convex_hull(k) = sum(convex_hull_image(:));
    
end

% Display results
message = sprintf('Convex Hull Results');
message = char(message, sprintf(''));
for k=1:num_circles
    message = char(message, sprintf('Radius = %d    Area = %d    Convexity = %.3f', circle_radius(k), circle_area(k), circle_area(k)/circle_convex_hull(k)));
end
hd = msgbox(cellstr(message), 'Convex Hull Dependence on ROI Size');
set(hd, 'position', [300 300 350 170]);

pause

%clear all
%close all