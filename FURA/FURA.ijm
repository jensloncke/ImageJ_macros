// @File (style = "open") Time_series
// @File (style = "directory") Folder_results
// @int BG_rolling_ball_radius

// This program finds ROIs based on the 380 FURA-2 channel and quantifies numeric values of both 340 and 380 FURA-2 channels.
//
// Usage:
// * Run in FIJI (www.fiji.sc)
//
// Author: Jens Loncke, KU Leuven, jens.loncke@kuleuven.be
// March 2023

// Clear everything and open files
run("Clear Results");
roiManager("reset");
open(Time_series);
title_380 = getTitle();
title_340 = replace(title_380, "C=1", "C=0");
// Make directories for ROIs and results
File.makeDirectory(Folder_results+"/ROIs/");
File.makeDirectory(Folder_results+"/Multi_measure/");

// Subtract background
window_titles = getList("image.titles");
for ( i = 0; i < window_titles.length; i++ ) {
	selectWindow(window_titles[i]);
	run("Subtract Background...", "rolling=BG_rolling_ball_radius stack");
}

// Find ROIs
selectWindow(title_380);
run("Duplicate...", "duplicate");
run("Z Project...", "projection=[Sum Slices]");
setOption("ScaleConversions", true);
run("8-bit");
setAutoThreshold("Huang dark");
setOption("BlackBackground", true);
run("Convert to Mask");
run("Fill Holes");
run("Watershed");
run("Analyze Particles...", "size=200-Infinity add");

// Let user do quality control of ROIs
setTool("freehand");
waitForUser("Please adapt ROIs if necessary. When finished press OK.");

// Measure
run("Clear Results");
selectWindow(title_380);
setSlice(1);
roiManager("save selected", Folder_results+"/ROIs/"+title_380+".zip"); 
roiManager("multi measure");
saveAs("Results", Folder_results+"/Multi_measure/"+title_380+"_FURA_380.csv");
run("Clear Results");
selectWindow(title_340);
setSlice(1);
roiManager("multi measure");
saveAs("Results", Folder_results+"/Multi_measure/"+title_340+"_FURA_340.csv");

// Close everything
roiManager("reset");
close("*");
selectWindow("Results"); 
run("Close");
