voc_path = 'P:\prec\VOCtest_06-Nov-2007\VOCdevkit\VOC2007\';
folder_path = strcat(voc_path, 'Annotations');
objcount = 1;
files = dir( fullfile(folder_path, '*.xml'));
numFiles = numel(files);
obj=[];
ugh = {'1' '2' '3' '4' '5' '6' '7'};
things = [ugh];
for i = 1:numFiles
    annotation = xml2struct( files(i).name );
    numObjects = numel(annotation.annotation.object); 
    imgpath = strcat(voc_path, 'JPEGImages\', annotation.annotation.filename.Text );
    image=imread(imgpath);
    [y,x,z]=size(image);
    for j = 1:numObjects
        if numObjects == 1
            thisFeature = annotation.annotation.object.name.Text;
            thisPose = annotation.annotation.object.pose.Text;
            boundingBox = annotation.annotation.object.bndbox;
        else
            thisFeature = annotation.annotation.object{1,j}.name.Text;
            thisPose = annotation.annotation.object{1,j}.pose.Text;
            boundingBox = annotation.annotation.object{1,j}.bndbox; 
        end
        abasename = textscan(annotation.annotation.filename.Text,'%s',1,'delimiter','.');
        ahogfile = strcat('P:\HoGOutput\HoGOutput\', abasename{1}, '.txt');
        hogdat = readHoG( ahogfile{1} );
        a = sscanf(boundingBox.xmin.Text, '%d');
        b = sscanf(boundingBox.ymin.Text, '%d');
        c = sscanf(boundingBox.xmax.Text, '%d');
        d = sscanf(boundingBox.ymax.Text, '%d');
        hd = getHogDimensions( x, y, hogdat.width, hogdat.height, a, b, c, d );
        obj = {annotation.annotation.filename.Text thisFeature thisPose hd.x1 hd.y1 hd.x2 hd.y2};
        things(objcount,:) = obj;
        objcount = objcount + 1;
    end
end