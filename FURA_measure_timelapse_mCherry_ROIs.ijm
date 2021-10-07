// @File (style = "open") Time_series
// @File (style = "open") mCherry
// @File (style = "directory") Folder_results
// @int BG_rolling_ball_radius


// This program finds ROIs based on an mCherry signal.
//
// Usage:
// * Run in FIJI (www.fiji.sc)
//
// Author: Jens Loncke, KU Leuven, jens.loncke@kuleuven.be
// September 2021

// Clear everything and open files
run("Clear Results");
roiManager("reset");
open(Time_series);
measurement_title_380 = getTitle();
measurement_title_340 = replace(measurement_title_380, "C=1", "C=0");
open(mCherry);
mCherry_title = getTitle();
File.makeDirectory(Folder_results+"/ROIs/");
File.makeDirectory(Folder_results+"/Multi_measure/");

 
// Subtract background
window_titles = getList("image.titles");
for ( i = 0; i < window_titles.length; i++ ) {
	selectWindow(window_titles[i]);
	run("Subtract Background...", "rolling=100 stack");
}

// Find ROIs
selectWindow(mCherry_title);
run("Duplicate...", " ");
setOption("ScaleConversions", true);
run("8-bit");
run("Bandpass Filter...", "filter_large=40 filter_small=3 suppress=None tolerance=5 autoscale saturate");
run("Convolve...", "text1=[-1 -1 -1 -1 -1\n-1 -1 -1 -1 -1\n-1 -1 -24 -1 -1\n-1 -1 -1 -1 -1\n-1 -1 -1 -1 -1\n] normalize");
setAutoThreshold("Triangle dark");
setOption("BlackBackground", true);
run("Convert to Mask");
run("Erode");
run("Fill Holes");
run("Watershed");
run("Analyze Particles...", "size=50-Infinity exclude add");

// Let user do quality control of ROIs
setTool("freehand");
waitForUser("Please adapt ROIs if necessary. When finished press OK.");

// Measure results
roiManager("deselect");
roiManager("Save", Folder_results+"/ROIs/"+mCherry_title+".zip");
run("Set Measurements...", "mean display redirect=None decimal=3");
selectWindow(measurement_title_380);
roiManager("multi measure")
saveAs("Results", Folder_results+"/Multi_measure/"+measurement_title_380+"_380.csv");
run("Clear Results");
selectWindow(measurement_title_340);
roiManager("multi measure")
saveAs("Results", Folder_results+"/Multi_measure/"+measurement_title_340+"_340.csv");
roiManager("reset");
close("*");
selectWindow("Results"); 
run("Close");
