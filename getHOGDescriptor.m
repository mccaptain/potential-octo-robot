function H = getHOGDescriptor(img)
% GETHOGDESCRIPTOR computes a HOG descriptor vector for the supplied image.
%   H = getHOGDescriptor(img)
%  
%   This function takes a 64x128 pixel gray scale image and computes a HOG
%   descriptor for the image, returning a 3,780 value column vector.
%
%   Parameters:
%     img - A grayscale image matrix with 128 rows and 64 columns.
%   Returns:
%     A column vector of length 3,780 containing the HOG descriptor.
%
%    The intent of this function is to implement the same design choices as
%    the original HOG descriptor for human detection by Dalal and Triggs.
%    Specifically, I'm using the following parameter choices:
%      - 8x8 pixel cells
%      - Block size of 2x2 cells
%      - 50% overlap between blocks
%      - 9-bin histogram
%
%     The above parameters give a final descriptor size of 
%     7 blocks across x 15 blocks high x 4 cells per block x 9 bins per hist
%     = 3,780 values in the final vector.
%
%    A couple other important design decisions:
%    - The histogram ranges from 0 to 360 degrees instead of 0 to 180 because
%      I'm not certain yet how to correctly compute the 0-180 version.
%    - Each gradient vector splits its contribution proportionally between the
%      two nearest bins.
%    - For the block normalization, I'm using L2 normalization.
%    - The order of the values in the final vector probably does not match the
%      order given by the OpenCV HOG descriptor. I'd like to make them match
%      but haven't done so yet.

% $Author: ChrisMcCormick $    $Date: 2013/05/08 22:00:00 $    $Revision: 1.0 $

% The number of bins to use in the histograms.
numBins = 9;

% The cells are 8 x 8 pixels.
cellSize = 8;

% Empty vector to store computed descriptor.
H = [];

% Verify the image size is 64 x 128.
[height, width] = size(img); 
if ((width ~= 64) || (height ~= 128))
    printf("Image size must be 64 x 128 pixels.\n");
    return;
end

% Compute the number cells horizontally and vertically (should be 8 x 16).    
numHorizCells = width / cellSize;
numVertCells = height / cellSize;

% ===============================
%    Compute Gradient Vectors
% ===============================
% Compute the gradient vector at every pixel in the image.

% Create the operators for computing image derivative at every pixel.
hx = [-1,0,1];
hy = -hx';

% Compute the derivative in the x and y direction for every pixel.
dx = imfilter(double(img), hx);
dy = imfilter(double(img), hy);

% Convert the gradient vectors to polar coordinates (angle and magnitude).
angles = atan2(dy, dx);
magnit = ((dy.^2) + (dx.^2)).^.5;

% =================================
%     Compute Cell Histograms 
% =================================
% Compute the histogram for every cell in the image. We'll combine the cells
% into blocks and normalize them later.

% Create a three dimensional matrix to hold the histogram for each cell.
histograms = zeros(numVertCells, numHorizCells, numBins);

% Cast the image to floating point values.
img = double(img);

% For each cell in the y-direction...
for row = 0:(numVertCells - 1)
    
    % Compute the row number in the 'img' matrix corresponding to the top
    % of the cells in this row. Add 1 since the matrices are indexed from 1.
    rowOffset = (row * cellSize) + 1;
    
    % For each cell in the x-direction...
    for col = 0:(numHorizCells - 1)
    
        % Select the pixels for this cell.
        
        % Compute column number in the 'img' matrix corresponding to the left
        % of the current cell. Add 1 since the matrices are indexed from 1.
        colOffset = (col * cellSize) + 1;
        
        % Compute the indices of the pixels within this cell.
        rows = rowOffset : (rowOffset + cellSize - 1);
        cols = colOffset : (colOffset + cellSize - 1);
        
        % Select the angles and magnitudes for the pixels in this cell.
        cellAngles = angles(rows, cols); 
        cellMagnitudes = magnit(rows, cols);
    
        % Compute the histogram for this cell.
        % Convert the cells to column vectors before passing them in.
        histograms(row + 1, col + 1, :) = getHistogram(cellMagnitudes(:), cellAngles(:), numBins);
    end
    
end

% ===================================
%       Block Normalization
% ===================================    

% Take 2 x 2 blocks of cells and normalize the histograms within the block.
% Normalization provides some invariance to changes in contrast, which can
% be thought of as multiplying every pixel in the block by some coefficient.

% For each cell in the y-direction...
for row = 1:(numVertCells - 1)    
    % For each cell in the x-direction...
    for col = 1:(numHorizCells - 1)
    
        % Get the histograms for the cells in this block.
        blockHists = histograms(row : row + 1, col : col + 1, :);
        
        % Put all the histogram values into a single vector (nevermind the 
        % order), and compute the magnitude.
        % Add a small amount to the magnitude to ensure that it's never 0.
        magnitude = norm(blockHists(:)) + 0.01;
    
        % Divide all of the histogram values by the magnitude to normalize 
        % them.
        normalized = blockHists / magnitude;
        
        % Append the normalized histograms to our descriptor vector.
        H = [H; normalized(:)];
    end
end
    
end