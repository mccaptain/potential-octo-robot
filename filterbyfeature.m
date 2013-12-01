function [filenames, xmin, ymin, xmax, ymax] = filterbyfeature( feature, pose, folder_path )
filenames = [];
xmin = [];
ymin = [];
xmax = [];
ymax = [];

files = dir( fullfile(folder_path, '*.xml'));
numFiles = numel(files);
for i = 1:numFiles
    annotation = xml2struct( files(i).name );
    numObjects = numel(annotation.annotation.object);
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
        if strcmpi( thisFeature, feature) && strcmpi( thisPose, pose )
            filenames = [filenames; annotation.annotation.filename.Text];
            xmin = [xmin; str2num(boundingBox.xmin.Text)];
            ymin = [ymin; str2num(boundingBox.ymin.Text)];
            xmax = [xmax; str2num(boundingBox.xmax.Text)];
            ymax = [ymax; str2num(boundingBox.ymax.Text)];
        end
    end
end
