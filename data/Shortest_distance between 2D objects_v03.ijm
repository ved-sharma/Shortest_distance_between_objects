/*
 This version finds the shorest distance between 2 sets of 2D areas
 Each set can contain multiple 2D areas
 There should be only two composite ROIs in the ROI Manger
 Shortest distance of individual ROIs in composite ROI #1 with composite ROI #2 
 will be determined.

 Version 3: 
	starting version: 2b
	New features:
	1. Macro now works if there are only 1 2D areas in either ROI1 or ROI2
	2. Macro excludes the cases where an ROI from set 1 intersects any ROI in set 2
	3. added a dialog box for interpolation input from the user
	4. added code for excluding cases where ROIs are too close to the boundary
	5. Added the dialog box entries for the user to define the shortest distance line width and its color
*/

// Author: Ved P. Sharma, 	January 24, 2018

width = getWidth();
height = getHeight();
if(roiManager("count") < 2)
	exit("The macro needs atleast 2 area ROIs in the ROI Manager");
Dialog.create("Shortest distance between 2D objects...");
Dialog.addNumber("Shortest distance line width:", 2, 0, 2, "pixels");
Dialog.addString("Shortest distance line color:", "cyan");
Dialog.addNumber("2D area Interpolation interval:", 2, 0, 2, "pixels");
Dialog.addCheckbox("Exclude points close to the image edges", false);
Dialog.show();
strokeWd = Dialog.getNumber();
strokeCol = Dialog.getString();
interval = Dialog.getNumber();
exclude = Dialog.getCheckbox();

roiManager("select", 0);
if(selectionType() == 9)
	roiManager("Split");
else
	roiManager("Add"); // if ROI1 is not a composite
n = roiManager("count") - 2; // no. of individual ROI in composite ROI #1

roiManager("select", 1);
if(selectionType() == 9)
	roiManager("Split");
else
	roiManager("Add"); // if ROI2 is not a composite
m = roiManager("count") - n - 2; // no. of individual ROI in composite ROI #2

// concat x and y values of all the ROIs in ROI #2
roiManager("select", 2+n);
run("Interpolate", "interval=&interval adjust");
roiManager("update");
getSelectionCoordinates(u, v);
for(i=1; i<m; i++) {
	roiManager("select", 2+n+i);
	run("Interpolate", "interval=&interval adjust");
	roiManager("update");
	getSelectionCoordinates(ui, vi);
	u = Array.concat(u, ui);
	v = Array.concat(v, vi);
}
len2 = u.length;

count1 = 0; // count of 2D ROIs close to the image edges
count2 = 0; // count of 2D ROIs in set 1 which intersect ROIs in set 2
// this for loop runs on each ROI in composite ROI #1
for(r=0; r<n; r++) {
	roiManager("select", 2+r);
	run("Interpolate", "interval=&interval adjust");
	roiManager("update");
	getSelectionCoordinates(x, y);
	len1 = x.length;

	if(ROIintersecting()) {// checking to see if the current area ROI (x,y) from set 1 intersects any of the ROIs in set 2
		count2++;
//		print("ROI "+(r+1)+" from set 1 is intersecting set 2 ROI");
	}
	else {
		distFinal = sqrt((u[0]-x[0])*(u[0]-x[0]) + (v[0]-y[0])*(v[0]-y[0]));
		xStart = x[0];
		yStart = y[0];
		uEnd = u[0];
		vEnd = v[0];
		for(j=1; j<len2; j++)
			for(i=1; i<len1; i++) {
			dist = sqrt((u[j]-x[i])*(u[j]-x[i]) + (v[j]-y[i])*(v[j]-y[i]));
			if(dist < distFinal) {
				distFinal = dist;
				xStart = x[i];
				yStart = y[i];
				uEnd = u[j];
				vEnd = v[j];
			}
		}
		if(exclude) {
			if(closeToBoundary(r))
				count1++;
			else {
				makeLine(xStart, yStart, uEnd, vEnd);
				Roi.setStrokeColor(strokeCol);
				Roi.setStrokeWidth(strokeWd);
				roiManager("add");
				roiManager("Select", roiManager("count")-1);
				roiManager("Rename", "line "+(r+1));
			}
		}
		else {
			makeLine(xStart, yStart, uEnd, vEnd);
			Roi.setStrokeColor(strokeCol);
			Roi.setStrokeWidth(strokeWd);
			roiManager("add");
			roiManager("Select", roiManager("count")-1);
			roiManager("Rename", "line "+(r+1));
		}
	}
}
// delete split ROIs at the end
for(i=0; i<n+m; i++) {
	roiManager("select", 2);
	roiManager("Delete");
}

print("\nTotal 2D ROIs analyzed: "+n);
if(count1+count2 >0) {
	if(exclude) {
		print("No. of 2D ROIs excluded from the analysis: "+(count1+count2));
		print("Details for exclusion:");
		print("--------------------------");
		print("No. of 2D ROIs too close to the image boundary: "+count1);
		print("No. of 2D ROIs in set 1, intersecting ROIs in set 2: "+count2);
	}
	else {
		print("No. of 2D ROIs excluded from the analysis: "+count2);
		print("Details for exclusion:");
		print("--------------------------");
		print("No. of 2D ROIs in set 1, intersecting ROIs in set 2: "+count2);
	}
}
//if(exclude)
//	print("No. of 2D ROIs excluded from the analysis: "+count1);
//if(count2>0)
//	print("No. of 2D ROIs in set 1, which intersect ROIs in set 2: "+count2);

// ***************** Functions ***********************
function ROIintersecting() {
	for(i=2+n; i<2+n+m; i++) { // i local variable; n, m, x, y, len1 global
		roiManager("select", i);
		for(j=0; j<len1; j++)
			if(Roi.contains(x[j], y[j]))
				return true;
	}
	return false;
}

function closeToBoundary (a) { // a local variable, is the number of the ROI in set 1, to be checked for being close to the boundary
	roiManager("select", 2+a);
	getSelectionBounds(rect_x0, rect_y0, rectWd, rectHt);
	if(rect_x0 < distFinal)
		return true;
	else if ((width - rect_x0 - rectWd) < distFinal)
		return true;
	else if (rect_y0 < distFinal)
		return true;
	else if ((height - rect_y0 - rectHt) < distFinal)
		return true;
	else
		return false;
}
