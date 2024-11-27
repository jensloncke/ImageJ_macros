// @File (style = "open") mCherry
// @File (style = "directory") Folder_results
// @int BG_rolling_ball_radius

// This program thresholds mCherry positive cells and measures corresponding
// Celltox fluorescence.
//
//
// Usage:
// * Run in FIJI (www.fiji.sc)
//
// Author: Jens Loncke, KU Leuven, jens.loncke@kuleuven.be
// April 2024

// Open files and create directories
open(mCherry);
File.makeDirectory(Folder_results+"/ROIs/");
File.makeDirectory(Folder_results+"/Measure/");
title = getTitle();
mCherry_dir = getInfo("image.directory");
dir = substring(mCherry_dir, 0, lengthOf(mCherry_dir) - 8);
Celltox_dir = dir + "Celltox"
Celltox = replace(title, "w1", "w2");
open(Celltox_dir+"/"+Celltox);

// Subtract background
window_titles = getList("image.titles");
for ( i = 0; i < window_titles.length; i++ ) {
	selectWindow(window_titles[i]);
	run("Subtract Background...", "rolling=BG_rolling_ball_radius sliding");
}

// Threshold ROIs
selectWindow(title);
run("Duplicate...", " ");
run("Enhance Contrast...", "saturated=-5 normalize equalize");
run("Bandpass Filter...", "filter_large=40 filter_small=3 suppress=None tolerance=5 autoscale saturate");
setAutoThreshold("RenyiEntropy dark");
//run("Threshold...");
setOption("BlackBackground", false);
run("Convert to Mask");
run("Watershed");
run("Analyze Particles...", "size=50-Infinity add");
roiManager("Save", Folder_results+"/ROIs/"+title+".zip");

// Measure Celltox green
selectWindow(Celltox);
run("Set Measurements...", "mean display redirect=None decimal=3");
roiManager("Measure");
saveAs("Results", Folder_results+"/Measure/"+Celltox+"_Celltox.csv");

// Close everything
roiManager("reset");
close("*");
selectWindow("Results"); 
run("Close");

