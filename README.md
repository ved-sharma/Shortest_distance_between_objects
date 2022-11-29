# ImageJ/Fiji macros for measuring shortest distance between two sets of objects in 2D
A variety of open-source (e.g. QuPath) and commerical (e.g. Imaris) image analysis softwares implement ways to measure the shortest distance between two sets of objects. 

This functionality was missing (as far as I know when I wrote these macros in 2018!) in ImageJ/Fiji, one of the most widely-used image analayis software used by the biomedical community.   

Therefore, I wrote a series of four ImageJ/Fiji macros to measure shortest distances between two sets of objects:

## Case 1: Point ROIs to 2D ROIs  
#### <a href="https://github.com/ved-sharma/Shortest_distance_between_objects/blob/a3988020a3cd070b212eb6c99545ef23601b0a0d/data/Shortest_distance%20points%20to%20areas_v04d.ijm" download>Download macro<a/>

Object 1 = a set of points (multipoints), Object 2 = 2D areas

Following image shows points selected with a multipoint tool in ImageJ and added as the 1st entry in the ROI Manager.

2D area ROIs are shown in yellow in the image and added individually in the ROI Manager.

Goal is to find the shortest distance of each point to the nearest 2D area.

![image](data/point_to_2D_summary.png)

## Case 2: Point ROIs to line ROIs  
#### <a href="https://github.com/ved-sharma/Shortest_distance_between_objects/blob/18edeefa2a9812b590492c58d3df162bfc17f1d3/data/Shortest_distance%20points%20to%20lines_v01b.ijm" download>Download macro<a/> 

Input image has a set of points (multipoints in white) as object 1 and a line ROI (in yellow) as object 2, added to the ROI Manager  

![image](data/points_to_lines_ss_input.png)

After running the macro, you get the shortest distance (shown in cyan) of each of the points to the line ROI.  

![image](data/points_to_lines_ss_output1.png)

Similar to case 1, this macro can also be run with the "Exclude" option to exclude all the points close to the image boundary for which the shortest distance can not be determined.  

![image](data/points_to_lines_ss_output2.png)

## Case 3: Point ROIs to point ROIs- WORK IN PROGRESS  
#### Downaload macro  
Object 1 = a set of points (multipoints), Object 2 = another set of points (multipoints)

Following image shows points selected with a multipoint tool in ImageJ and added as the 1st entry in the ROI Manager.

Another set of points are also added to the ROI Manager as the second entry.

Goal is to find the shortest distance of each point in set 1 to the nearest point in set 2.

## Case 4: 2D ROIs to 2D ROIs- WORK IN PROGRESS  
#### Downaload macro  
Object 1 = a set of 2D areas, Object 2 = another set of 2D areas

Following image shows 2 sets of 2D areas (composite ROI set 1 in yellow and composite ROI set 2 in white) added to the ROI Manager.

Goal is to find the shortest distance of each of the 2D areas in set 1 to the nearest 2D area in set 2.  

# How to cite
Sharma VP, Tang B, Wang Y, Duran CL, Karagiannis GS, Xue EA, Entenberg D, Borriello L, Coste A, Eddy RJ, Kim G, Ye X, Jones JG, Grunblatt E, Agi N, Roy S, Bandyopadhyaya G, Adler E, Surve CR, Esposito D, Goswami S, Segall JE, Guo W, Condeelis JS, Wakefield LM, Oktay MH. Live tumor imaging shows macrophage induction and TMEM-mediated enrichment of cancer stem cells during metastatic dissemination. Nat Commun. 2021 Dec 15;12(1):7300. doi: 10.1038/s41467-021-27308-2. PMID: 34911937; PMCID: PMC8674234.

# Questions
[Image.sc](https://forum.image.sc/) is the best place to ask questions about these macros. Please post your question with the @vedsharma tag so I get the notification..
