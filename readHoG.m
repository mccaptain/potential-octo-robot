function [ output ] = readHoG( file )

output = struct();
fp = fopen(file, 'r');
width = str2num(fgetl(fp))+2;
height = str2num(fgetl(fp))+2;
depth = str2num(fgetl(fp));
mat = zeros(height*width*depth, 1);

output.height = height;
output.width = width;
output.depth = depth;
fclose(fp);

end