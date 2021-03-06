function [ output ] = getHogDimensions(imgx, imgy, hogx, hogy, x1, y1, x2, y2)

output = struct();
hx = hogx/imgx;
hy = hogy/imgy;
output.x1 = ceil(x1 * hx);
output.y1 = ceil(y1 * hy);
output.x2 = ceil(x2 * hx);
output.y2 = ceil(y2 * hy);
end