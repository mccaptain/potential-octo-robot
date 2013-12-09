function [ output ] = getHoGFrom(hogfilepath, things)
output = struct();
files = dir( fullfile(hogfilepath, '*.xml'));
[numsamples, w] = size(things);
numsamples = 50;
dataheight = (max([things{:,6}]) - min([things{:,4}])) * (max(([things{:,7}])) - min([things{:,5}])) *9;
ldadata = zeros(numsamples, dataheight);
lasthog = '';
ugh = {'1'};
labels = [ugh];
for i = 1:(numsamples)
    thething = things(i,:);%what type, pose and where x1,y1 x2,y2
    temp = textscan(thething{1},'%s',1,'delimiter','.');
    abasename = temp{1};
    atype = thething(2);
    apose = thething(3);
    labels(i,:) = strcat(atype, apose);
    hogfile = strcat(hogfilepath, abasename, '.txt');
    if( strcmpi(lasthog, abasename) == 0 )
        ahog = loadHoG(hogfile{1});
        lasthog = abasename;
    end
    imgx1 = thething{4};
    imgx2 = thething{6};
    imgy1 = thething{5};
    imgy2 = thething{7};
    theimgsection = ahog.matrix(thething{5}:thething{7}, thething{4}:thething{6}, 1:ahog.depth);
    [imx,imy,imz] = size(theimgsection);
%     lsdkjfalksj = (thething{6}-thething{4})*(thething{7}-thething{5}) * 9;
    
    theldarowentry = reshape(theimgsection, 1, imx*imy*imz); 
    thepaddedar = padarray(theldarowentry, [0 (dataheight-numel(theldarowentry))],'post');
    ldadata(i,:) = thepaddedar;
end
    ldadata = ldadata + 1;
    output.data = ldadata;
    output.labels = labels;
    output.dataheight = dataheight;
end