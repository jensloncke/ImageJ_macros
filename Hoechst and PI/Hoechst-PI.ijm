// @File (style = "open") stack
// @File (style = "directory") Folder_results
// @int BG_rolling_ball_radius

// This program thresholds nuclei based on Hoechst fluorescence
// and measures PI fluorescence. 
//
// Usage:
// * Run in FIJI (www.fiji.sc)
//
// Author: Jens Loncke, KU Leuven, jens.loncke@kuleuven.be
// October 2023

// Open files and create directories
open(stack);
File.makeDirectory(Folder_results+"/ROIs/");
File.makeDirectory(Folder_results+"/Measure/");
title = getTitle();
BF = getTitle();
NUC = replace(BF, "C=2", "C=1");
PI_red = replace(BF, "C=2", "C=0");

// Subtract background
window_titles = getList("image.titles");
for ( i = 0; i < window_titles.length; i++ ) {
	selectWindow(window_titles[i]);
	run("Subtract Background...", "rolling=BG_rolling_ball_radius sliding");
}

// Threshold ROIs
selectWindow(NUC);
run("Duplicate...", " ");
run("Bandpass Filter...", "filter_large=40 filter_small=3 suppress=None tolerance=5 autoscale saturate");
run("Unsharp Mask...", "radius=2 mask=0.90");
//run("Threshold...");
setAutoThreshold("Yen dark");
run("Convert to Mask");
run("Watershed");
run("Analyze Particles...", "size=10-Infinity pixel add");
roiManager("Save", Folder_results+"/ROIs/"+NUC+".zip");

// Measure PI
selectWindow(PI_red);
run("Set Measurements...", "mean display redirect=None decimal=3");
roiManager("Measure");
saveAs("Results", Folder_results+"/Measure/"+PI_red+".csv");

// Close everything
roiManager("reset");
close("*");
selectWindow("Results"); 
run("Close");

