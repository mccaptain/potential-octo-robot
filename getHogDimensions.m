function H = getHogDimensions(imgx, imgy, hogx, hogy, x1, y1, x2, y2)
    hx = hogx/imgx;
    hy = hogy/imgy;
    hogCoords = [ x1 * hx, y1 * hy, x2 * hx, y2 * hy];
    H = ceil(hogCoords);
end