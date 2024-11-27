// @File (style = "open") Acquisition
// @File (style = "directory") Folder_results
// @int BG_rolling_ball_radius

// This program thresholds Celltox green positive cells
//
//
// Usage:
// * Run in FIJI (www.fiji.sc)
//
// Author: Jens Loncke, KU Leuven, jens.loncke@kuleuven.be
// April 2024

// Open files and create directories
open(Acquisition);
File.makeDirectory(Folder_results+"/ROIs/");
File.makeDirectory(Folder_results+"/Measure/");
title = getTitle();

// Subtract background
window_titles = getList("image.titles");
for ( i = 0; i < window_titles.length; i++ ) {
	selectWindow(window_titles[i]);
	run("Subtract Background...", "rolling=BG_rolling_ball_radius sliding");
}

// Threshold ROIs
selectWindow(title);
run("Duplicate...", " ");
run("Gaussian Blur...", "sigma=2");
setAutoThreshold("Li dark");
//run("Threshold...");
setOption("BlackBackground", false);
run("Convert to Mask");
run("Analyze Particles...", "add");
roiManager("Save", Folder_results+"/ROIs/"+title+".zip");

// Measure Celltox green
selectWindow(title);
run("Set Measurements...", "mean display redirect=None decimal=3");
roiManager("Measure");
saveAs("Results", Folder_results+"/Measure/"+title+".csv");

// Close everything
roiManager("reset");
close("*");
selectWindow("Results"); 
run("Close");

