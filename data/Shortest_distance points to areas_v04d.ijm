/*
 This macro finds the shortest distance between points and area ROIs
 First select all your cells with a Multi-point tool and add it to 
 the ROI Manager as the first entry.
 Next, add each area ROI and add to ROI Manager one by one
 Macro adds the shortest distance lines in the ROI Manager

 If a point lies inside any of the area ROIs, the distance would be
 zero. In this case, macro adds a point in the ROI Manager in place of a line.

 Version 4d: 
	Added the dialog box entries for the user to define the shortest distance line width and its color

*/
// Author: Ved P. Sharma, 	January 24, 2018

width = getWidth();
height = getHeight();
if(roiManager("count") < 2)
	exit("The macro needs at least 2 entries in the ROI Manager");
Dialog.create("Shortest distance of points to 2D areas...");
Dialog.addNumber("Shortest distance line width:", 2, 0, 2, "pixels");
Dialog.addString("Shortest distance line color:", "cyan");
Dialog.addNumber("2D area Interpolation interval:", 2, 0, 2, "pixels");
Dialog.addCheckbox("Exclude cells close to the image edges", true);
Dialog.show();
strokeWd = Dialog.getNumber();
strokeCol = Dialog.getString();
interval = Dialog.getNumber();
exclude = Dialog.getCheckbox();

time0 = getTime();
roiManager("select", 0);
getSelectionCoordinates(x, y);
len1 = x.length;
count1 = 0; // count of cells close to the image edges
count2 = 0; // count of cells which are inside 2D areas

n = roiManager("count");
roiManager("select", 1);
run("Interpolate", "interval=&interval adjust");
roiManager("update");
getSelectionCoordinates(u, v);
for(k=2; k<n; k++) {
	roiManager("select", k);
	run("Interpolate", "interval=&interval adjust");
	roiManager("update");
	getSelectionCoordinates(u1, v1);
	u = Array.concat(u,u1);
	v = Array.concat(v,v1);
}
len2 = u.length;

for(j=0; j<len1; j++) {
	if(!pointInsideArea(j)) { 		// check if the point lies inside area, give dist = 0
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
				count1++; // counting the no. of cells which are too close to the image edge
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
	else {
		makePoint(x[j], y[j]);
		Roi.setStrokeColor(strokeCol);
		Roi.setStrokeWidth(strokeWd);
		roiManager("add");
		roiManager("Select", roiManager("count")-1);
		roiManager("Rename", "point "+(j+1));
	}
}
print("\nTotal cells analyzed: "+len1);
if(exclude)
	print("No. of cells excluded from the analysis: "+count1);
print("No. of cells inside 2D areas: "+count2);
time1 = (getTime()-time0)/1000; // time in secs
print("Total processing time(sec): "+time1);

function pointInsideArea(a) {
	for(i=1; i<n; i++) { // a and i local variables; n, x and y global
		roiManager("select", i);
		if(Roi.contains(x[a], y[a])) {
			count2++; // counting the no. of cells inside 2D areas
			return true;
		}
	}
	return false;
}

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
