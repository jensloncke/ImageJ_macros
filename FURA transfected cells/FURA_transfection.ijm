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
Stack.getDimensions(width, height, channels, slices, frames);

if (channels > 1) {
	run("Split Channels");
	measurement_title_380 = getTitle();
	measurement_title_340 = replace(measurement_title_380, "C2", "C1");
	rename(substring(measurement_title_380,3,lengthOf(measurement_title_380))+" - C=1");
	measurement_title_380 = getTitle();
	rename(substring(measurement_title_340,3,lengthOf(measurement_title_340))+" - C=0");
	measurement_title_340 = replace(measurement_title_380, "C=1", "C=0");
} 
else {
	measurement_title_380 = getTitle();
	measurement_title_340 = replace(measurement_title_380, "C=1", "C=0");
}

open(mCherry);
mCherry_title = getTitle();
File.makeDirectory(Folder_results+"/ROIs/");
File.makeDirectory(Folder_results+"/Multi_measure/");

 
// Subtract background
window_titles = getList("image.titles");
for ( i = 0; i < window_titles.length; i++ ) {
	selectWindow(window_titles[i]);
	run("Subtract Background...", "rolling=BG_rolling_ball_radius stack");
}

// Find ROIs
selectWindow(mCherry_title);
run("Duplicate...", " ");
setOption("ScaleConversions", true);
setOption("ScaleConversions", true);
run("8-bit");
run("Despeckle");
run("Sharpen");
run("Sharpen");
run("Gaussian Blur...", "sigma=2");
setAutoThreshold("Huang dark");
setOption("BlackBackground", true);
run("Convert to Mask");
run("Fill Holes");
run("Watershed");
run("Analyze Particles...", "size=200-Infinity add");

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
