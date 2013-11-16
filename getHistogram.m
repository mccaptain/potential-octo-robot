function H = getHistogram(magnitudes, angles, numBins)
% GETHISTOGRAM Computes a histogram for the supplied gradient vectors.
%   H = getHistogram(magnitudes, angles, numBins)
%   
%   This function takes the supplied gradient vectors and places them into a 9
%   bin histogram based on their orientation. Each bin covers a range of 40
%   degrees. Each gradient's contribution to the histogram is equal to its 
%   magnitude. The gradient's contribution is split between the two nearest
%   bins, in proportion to the distance between the two nearest bin centers.
%
%   Parameters:
%     magnitudes - A column vector storing the magnitudes of the gradient 
%                  vectors.
%     angles     - A column vector storing the angles in radians of the 
%                  gradient vectors.
%     numBins    - The number of bins to place the gradients into.
%   Returns:
%     A row vector of length 'numBins' containing the histogram.

% $Author: ChrisMcCormick $    $Date: 2013/05/08 22:00:00 $    $Revision: 1.0 $

% Compute the bin size in radians. 360 degress = 2*pi.
binSize = (2 * pi) / numBins;

% The angle values will range from -pi to pi.
minAngle = -pi;

% The gradient angle for each pixel will fall between two bin centers.
% For each pixel, we split the bin contributions between the bin to the left
% and the bin to the right based on how far the angle is from the bin centers.

% For each pixel, compute the index of the bin to the left and to the right.
%
% The histogram needs to wrap around at the edges--pixels on the far edges of
% the histogram (i.e., close to -pi or pi) will contribute partly to the bin
% at that edge, and partly to the bin on the other end of the histogram.
% For pixels on the far left edge of the histogram, leftBinIndex will be 0. 
% Likewise, for pixels on the far right edge, rightBinIndex will be 10. 
leftBinIndex = round((angles - minAngle) / binSize);
rightBinIndex = leftBinIndex + 1;

% For each pixel, compute the center of the bin to the left.
leftBinCenter = ((leftBinIndex - 0.5) * binSize) - pi;

% For each pixel, compute the fraction of the magnitude
% to contribute to each bin.
rightPortions = angles - leftBinCenter;
leftPortions = binSize - rightPortions;
rightPortions = rightPortions / binSize;
leftPortions = leftPortions / binSize;

% Before using the bin indeces, we need to fix the '0' and '10' values.
% Recall that the histogram needs to wrap around at the edges--bin "0" 
% contributions, for example, really belong in bin 9.
% Replace index 0 with 9 and index 10 with 1.
leftBinIndex(leftBinIndex == 0) = 9;
rightBinIndex(rightBinIndex == 10) = 1;

% Create an empty row vector for the histogram.
H = zeros(1, numBins);

% For each bin index...
for (i = 1:numBins)
    % Find the pixels with left bin == i
    pixels = (leftBinIndex == i);
    
    % For each of the selected pixels, add the gradient magnitude to bin 'i',
    % weighted by the 'leftPortion' for that pixel.
    H(1, i) += sum(leftPortions(pixels)' * magnitudes(pixels));
    
    % Find the pixels with right bin == i
    pixels = (rightBinIndex == i);
    
    % For each of the selected pixels, add the gradient magnitude to bin 'i',
    % weighted by the 'rightPortion' for that pixel.
    H(1, i) += sum(rightPortions(pixels)' * magnitudes(pixels));
end    

end