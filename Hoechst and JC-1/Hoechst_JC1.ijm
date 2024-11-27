// @File (style = "open") stack
// @File (style = "directory") Folder_results
// @int BG_rolling_ball_radius

// This program thresholds counts nuclei based on Hoechst fluorescence
// and measures JC-1 fluorescence. 
//
// Usage:
// * Run in FIJI (www.fiji.sc)
//
// Author: Jens Loncke, KU Leuven, jens.loncke@kuleuven.be
// January 2024

// Open files and create directories
open(stack);
roiManager("reset");
File.makeDirectory(Folder_results+"/ROIs/");
File.makeDirectory(Folder_results+"/Measure/");
title = getTitle();
BF = getTitle();
NUC = replace(BF, "C=3", "C=0");
JC_590 = replace(BF, "C=3", "C=2");
JC_525 = replace(BF, "C=3", "C=1");

// Subtract background
window_titles = getList("image.titles");
for ( i = 0; i < window_titles.length; i++ ) {
	selectWindow(window_titles[i]);
	run("Subtract Background...", "rolling=BG_rolling_ball_radius sliding");
}

// Remove influential debris
setTool("freehand");
waitForUser("Please delete regions containing debris. When finished, press OK.");


// Threshold ROIs
selectWindow(NUC);
run("Duplicate...", " ");
run("Bandpass Filter...", "filter_large=40 filter_small=3 suppress=None tolerance=5 autoscale saturate");
run("Unsharp Mask...", "radius=2 mask=0.90");
//run("Threshold...");
setAutoThreshold("Yen dark");
run("Convert to Mask");
run("Watershed");
run("Analyze Particles...", "size=100-Infinity pixel summarize");
saveAs("Results", Folder_results+"/Measure/"+NUC+"_nuclei.csv");
run("Clear Results");

// Measure green
selectWindow(JC_525);
run("Set Measurements...", "mean display redirect=None decimal=3");
run("Measure");
saveAs("Results", Folder_results+"/Measure/"+JC_525+"_green.csv");
run("Clear Results");

// Measure red
selectWindow(JC_590);
run("Set Measurements...", "mean modal display redirect=None decimal=3");
run("Duplicate...", " ");
run("Gaussian Blur...", "sigma=2");
run("Convolve...", "text1=[-1 -1 -1 -1 -1\n-1 -1 -1 -1 -1\n-1 -1 24 -1 -1\n-1 -1 -1 -1 -1\n-1 -1 -1 -1 -1\n] normalize");
setAutoThreshold("Triangle dark");
//run("Threshold...");
run("Convert to Mask");
run("Dilate");
run("Analyze Particles...", "size=0-Infinity pixel add");
roiManager("deselect");
roiManager("Combine");
roiManager("Add");
nROIs = roiManager("count");
roiManager("select", "last");
selectWindow(JC_590);
roiManager("measure");
saveAs("Results", Folder_results+"/Measure/"+JC_590+"_red.csv");
run("Clear Results");

// Close everything
roiManager("reset");
close("*");
selectWindow("Results"); 
run("Close");
