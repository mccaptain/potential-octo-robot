function [ output ] = loadHoG( file )
%LOADHOG Summary of this function goes here
%   Detailed explanation goes here

output = struct();
fp = fopen(file, 'r');
height = str2num(fgetl(fp))
width = str2num(fgetl(fp))
depth = str2num(fgetl(fp))
mat = zeros(height*width*depth, 1);
i = 1;

line = fgetl(fp);
while line ~= -1
    mat(i) = str2num(line);
    line = fgetl(fp);
    i = i + 1;
end

output.height = height;
output.width = width;
output.depth = depth;
output.matrix = reshape(mat, height, width, depth);


end

