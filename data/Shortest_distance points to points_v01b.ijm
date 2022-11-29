/*
 This macro finds the shortest distance of each point (Xi, Yi) in set 1 to the points in set 2 (U, V)
 Select first set of points with a Multi-point tool and add it to the ROI Manager
 as the first entry. Next, select second set of points with the Multi-point tool and 
 add it to the ROI Manager as the second entry.
 Macro adds the shortest distance lines in the ROI Manager

 The color and width of added line ROIs can be set with functions 
 Roi.setStrokeColor() and Roi.setStrokeWidth() below

 Version 1b:
	starting version 1
	Added the dialog box entries for the user to define the shortest distance line width and its color
*/

// Author: Ved P. Sharma, 	January 24, 2018

width = getWidth();
height = getHeight();
if(roiManager("count") != 2)
	exit("The macro needs 2 multipoint ROIs in the ROI Manager");
Dialog.create("Shortest distance of points to points...");
Dialog.addNumber("Shortest distance line width:", 2, 0, 2, "pixels");
Dialog.addString("Shortest distance line color:", "cyan");
Dialog.addCheckbox("Exclude points close to the image edges", false);
Dialog.show();
strokeWd = Dialog.getNumber();
strokeCol = Dialog.getString();
exclude = Dialog.getCheckbox();

roiManager("select", 0);
getSelectionCoordinates(x, y);
len1 = x.length;
count = 0; // count of cells close to the image edges
roiManager("select", 1);
getSelectionCoordinates(u, v);
len2 = u.length;

for(j=0; j<len1; j++) {
	distFinal = sqrt((u[0]-x[j])*(u[0]-x[j]) + (v[0]-y[j])*(v[0]-y[j]));
	uFinal = u[0];
	vFinal = v[0];
	for(i=1; i<len2; i++) {
		dist = sqrt((u[i]-x[j])*(u[i]-x[j]) + (v[i]-y[j])*(v[i]-y[j]));
		if(dist < distFinal) {
			distFinal = dist;
			uFinal = u[i];
			vFinal = v[i];
		}
	}
	if(exclude) {
		if(!closeToBoundary(j)) {
			makeLine(x[j], y[j], uFinal, vFinal);
			Roi.setStrokeColor(strokeCol);
			Roi.setStrokeWidth(strokeWd);
			roiManager("add");
			roiManager("Select", roiManager("count")-1);
			roiManager("Rename", "line "+(j+1));
		}
		else
			count++; // counting the no. of cells which are too close to the image edge
	}
	else {
		makeLine(x[j], y[j], uFinal, vFinal);
		Roi.setStrokeColor(strokeCol);
		Roi.setStrokeWidth(strokeWd);
		roiManager("add");
		roiManager("Select", roiManager("count")-1);
		roiManager("Rename", "line "+(j+1));
	}
}
print("\nTotal points analyzed: "+len1);
if(exclude)
	print("No. of points excluded from the analysis: "+count);

function closeToBoundary (a) {
	if(x[a] < distFinal)
		return true;
	else if ((width - x[a]) < distFinal)
		return true;
	else if (y[a] < distFinal)
		return true;
	else if ((height - y[a]) < distFinal)
		return true;
	else
		return false;
}
