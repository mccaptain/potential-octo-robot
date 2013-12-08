function [filenames, xmin, ymin, xmax, ymax] = filterbyfeature( feature, pose, folder_path )
filenames = [];
xmin = [];
ymin = [];
xmax = [];
ymax = [];
objcount = 0;
files = dir( fullfile(folder_path, '*.xml'));
numFiles = numel(files);
for i = 1:numFiles
    objcount = objcount + 1;
    annotation = xml2struct( files(i).name );
    numObjects = numel(annotation.annotation.object);
    for j = 1:numObjects
        objcount = objcount + 1;
        if numObjects == 1
            thisFeature = annotation.annotation.object.name.Text;
            thisPose = annotation.annotation.object.pose.Text;
            boundingBox = annotation.annotation.object.bndbox;
            obj = {annotation.annotation.filename.Text thisFeature thisPose boundingBox };
        else
            thisFeature = annotation.annotation.object{1,j}.name.Text;
            thisPose = annotation.annotation.object{1,j}.pose.Text;
            boundingBox = annotation.annotation.object{1,j}.bndbox;
            obj = {annotation.annotation.filename.Text thisFeature thisPose boundingBox };
        if strcmpi( thisFeature, feature) && strcmpi( thisPose, pose )
            imgSize = annotation.annotation.size;
            filenames = [filenames; annotation.annotation.filename.Text];
            thisXMin = str2num(boundingBox.xmin.Text);
            thisYMin = str2num(boundingBox.ymin.Text);
            thisXMax = str2num(boundingBox.xmax.Text);
            thisYMax = str2num(boundingBox.ymax.Text);
            hogCoordinates = getHogDimensions( str2num(imgSize.width.Text),str2num(imgSize.height.Text),(thisXMax - thisXMin), (thisYMax - thisYMin), thisXMin, thisYMin, thisXMax, thisYMax);
            xmin = [xmin; hogCoordinates(1) ];
            ymin = [ymin; hogCoordinates(2) ];
            xmax = [xmax; hogCoordinates(3) ];
            ymax = [ymax; hogCoordinates(4) ];
        end
        
    end
    end
end

