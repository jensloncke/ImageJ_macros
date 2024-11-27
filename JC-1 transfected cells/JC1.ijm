// @File (style = "open") stack
// @File (style = "directory") Folder_results
// @int BG_rolling_ball_radius

// This program thresholds cells based on mCherry fluorescence
// and measures JC-1 fluorescence. 
//
// Usage:
// * Run in FIJI (www.fiji.sc)
//
// Author: Jens Loncke, KU Leuven, jens.loncke@kuleuven.be
// August 2024

// Open files and create directories
open(stack);
roiManager("reset");
File.makeDirectory(Folder_results+"/ROIs/");
File.makeDirectory(Folder_results+"/Measure/");

// Threshold mCherry positives
title = getTitle();
mCherry = replace(title, "C=4", "C=2")
selectWindow(mCherry);
run("Duplicate...", " ");
run("Median...", "radius=10");
setAutoThreshold("Li dark");
setOption("BlackBackground", true);
run("Convert to Mask");
run("Analyze Particles...", "exclude add");
JC_590 = title
JC_525 = replace(title, "C=4", "C=3");

// Subtract background
window_titles = getList("image.titles");
for ( i = 0; i < window_titles.length; i++ ) {
	selectWindow(window_titles[i]);
	run("Subtract Background...", "rolling=BG_rolling_ball_radius sliding");
}

// Remove influential debris
setTool("freehand");
waitForUser("Please delete regions containing debris. When finished, press OK.");
roiManager("Save", Folder_results+"/ROIs/"+title+".zip");

// Measure green
selectWindow(JC_525);
run("Set Measurements...", "mean display redirect=None decimal=3");
roiManager("Measure");
saveAs("Results", Folder_results+"/Measure/"+JC_525+"_green.csv");
run("Clear Results");

// Measure red
selectWindow(JC_590);
roiManager("measure");
saveAs("Results", Folder_results+"/Measure/"+JC_590+"_red.csv");
run("Clear Results");

// Close everything
roiManager("reset");
close("*");
selectWindow("Results"); 
run("Close");


