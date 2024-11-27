// @File (style = "open") Time_series
// @File (style = "open") Brightfield
// @File (style = "directory") Folder_results
// @int BG_rolling_ball_radius


// This program finds ROIs based on mtCEPIA signal and quantifies fluorescence.
//
// Usage:
// * Run in FIJI (www.fiji.sc)
//
// Author: Jens Loncke, KU Leuven, jens.loncke@kuleuven.be
// August 2023

// Clear everything and open files
run("Clear Results");
roiManager("reset");
open(Time_series);
measurement_title = getTitle();
open(Brightfield);
BF_title = getTitle();
File.makeDirectory(Folder_results+"/ROIs/");
File.makeDirectory(Folder_results+"/Multi_measure/");
 
// Subtract background
window_titles = getList("image.titles");
for ( i = 0; i < window_titles.length; i++ ) {
	selectWindow(window_titles[i]);
	run("Subtract Background...", "rolling=BG_rolling_ball_radius stack");
}

// Let user navigate to brightest frame
selectWindow(measurement_title);
waitForUser("Please navigate to bright post-ionomycin ROI and press OK.");

// Find ROIs
run("Duplicate...", "use");
merge_this = getTitle();
run("Duplicate...", "use");
setOption("ScaleConversions", true);
run("8-bit");
run("Gaussian Blur...", "sigma=2");
run("Convolve...", "text1=[-1 -1 -1 -1 -1\n-1 -1 -1 -1 -1\n-1 -1 24 -1 -1\n-1 -1 -1 -1 -1\n-1 -1 -1 -1 -1\n] normalize");
setAutoThreshold("MaxEntropy dark");
setOption("BlackBackground", true);
run("Convert to Mask");
run("Analyze Particles...", "size=0-Infinity add");

// Let user do quality control of ROIs
setTool("freehand");
waitForUser("Please adapt ROIs if necessary. When finished press OK.");

// Measure results
roiManager("deselect");
roiManager("Save", Folder_results+"/ROIs/"+BF_title+".zip");
run("Set Measurements...", "mean display redirect=None decimal=3");
selectWindow(measurement_title);
roiManager("multi measure")
saveAs("Results", Folder_results+"/Multi_measure/"+measurement_title+".csv");
roiManager("reset");
close("*");
selectWindow("Results"); 
run("Close");

