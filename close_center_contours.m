% Specify the number of contours to select
numContoursToSelect = 8;

% Initialize cell arrays for storing neighborhood centroids and colors
neighborhoodCentroids = cell(numContoursToSelect, 1);
neighborhoodContourLengths = cell(numContoursToSelect, 1);

% Specify the index of the image you want to visualize
imageIndex = 29;

% Read the image
img = hyper{imageIndex};

% Set a threshold for creating the binary image
threshold = 180;
binaryImage = img > threshold;

% Apply bwperim to get the perimeter
perimeterImage = bwperim(binaryImage);

% Label connected components in the perimeter image
labeledPerimeter = bwlabel(perimeterImage);

% Compute region properties for the labeled perimeter
statsPerimeter = regionprops(labeledPerimeter, 'Centroid', 'Perimeter');

% Find the contours with centroids closest to the center of the image
center = [size(img, 2) / 2, size(img, 1) / 2];  % Center of the image

% Sort contours based on distance to the center
distancesToCenter = sqrt(sum((cat(1, statsPerimeter.Centroid) - center).^2, 2));
[~, sortedIndices] = sort(distancesToCenter);

% Make sure numContoursToSelect is less than sortedIndicess
if numContoursToSelect > numel(sortedIndices)
    error('numContoursToSelect exceeds the number of available contours.');
end

selectedIndices = sortedIndices(1:numContoursToSelect);

% Adding more colors Red, blue, green, magenta, cyan, yellow, black, white
colors = {'r', 'b', 'g', 'm', 'c', 'y', 'k', 'w'};  

% Specify the neighborhood radius
neighborhoodRadius = 60;

% Display the original image with the perimeter and centroids
figure;

% Plot the original image
subplot(2, 2, 1);
imshow(img);
title('Original Image');

% Plot the perimeter
subplot(2, 2, 2);
imshow(img);
hold on;
contour(perimeterImage, 'r');
title('Perimeter');

% Plot the selected perimeters with centroids
subplot(2, 2, 3);
imshow(img);
hold on;

for j = 1:numContoursToSelect
    selectedIndex = selectedIndices(j);
    selectedCentroid = statsPerimeter(selectedIndex).Centroid;
    neighborhoodIndices = find(sqrt(sum((cat(1, statsPerimeter.Centroid) - selectedCentroid).^2, 2)) < neighborhoodRadius);

    % Access centroids and contour lengths for the selected neighborhood
    centroids = cat(1, statsPerimeter(neighborhoodIndices).Centroid);
    contourLengths = cat(1, statsPerimeter(neighborhoodIndices).Perimeter);

    % Store centroids and contour lengths for the current neighborhood
    neighborhoodCentroids{j} = centroids;
    neighborhoodContourLengths{j} = contourLengths;

    % Plot the perimeter with a unique color
    contour(labeledPerimeter == selectedIndex, 'Color', colors{j});
    
    % Plot the centroid with a green dot
    plot(selectedCentroid(1), selectedCentroid(2), 'go', 'MarkerSize', 10);
end

