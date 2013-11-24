function [] = bossHoG( imageFolder )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

outputFolder = 'HoGOutput';

imageList = dir(imageFolder);
nb_bins = 9;
cell_width = 8;
block_size = 2;

for i=1:length(imageList)
    if (length(imageList(i).name) == 10)
        disp(imageList(i).name)
        tempImage = imread(strcat(imageFolder,'/',imageList(i).name));
        tempFile = fopen(strcat(outputFolder, '/', imageList(i).name), 'w');
        x = size(tempImage, 1);
        y = size(tempImage, 2);
        hist1 = ceil(-0.5 + x / cell_width) - 1 - block_size + 1;
        hist2 = ceil(-0.5 + y / cell_width) - 1 - block_size + 1;
        fprintf(tempFile, '%d, %d, %d\n', hist1*block_size, hist2*block_size, nb_bins);
        tempHoGs = HoG(double(tempImage));
        for j = 1:length(tempHoGs)
            fprintf(tempFile,'%f\n',tempHoGs(j));
        end
        fclose(tempFile);
    end
end


end

