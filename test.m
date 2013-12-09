function [output] = test( athing, width, ldaobj, expected )
   %what type, pose and where x1,y1 x2,y2
    temp = textscan(athing{1},'%s',1,'delimiter','.');
    abasename = temp{1};
    atype = thething(2);
    apose = thething(3);
    hogfile = strcat(hogfilepath, abasename, '.txt');
    if( strcmpi(lasthog, abasename) == 0 )
        ahog = loadHoG(hogfile{1});
        lasthog = abasename;
    end
    theimgsection = ahog.matrix(thething{5}:thething{7}, thething{4}:thething{6}, 1:ahog.depth);
    [imx,imy,imz] = size(theimgsection);  
    theldarowentry = reshape(theimgsection, 1, imx*imy*imz); 
    thetesthog = padarray(theldarowentry, [0 (width-numel(theldarowentry))],'post');
    thetesthog = thetesthog +1;
    prediction = predict( ldaobj, thetesthog );
    
    output = strcmpi(expected, prediction);
end