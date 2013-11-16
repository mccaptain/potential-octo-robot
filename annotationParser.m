xmlfile = fullfile('C:\Users\Mike Dude\Google Drive\PatternRec\PJ3\VOC2007\Annotations\009961.xml');
xDoc = xmlread(xmlfile);
filen = xDoc.getElementsByTagName('filename');
thisElement = filen.item(0);
found = char(thisElement.getFirstChild.getData);