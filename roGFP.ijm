// @File (style = "open") Time_series
// @File (style = "directory") Folder_results
// @int BG_rolling_ball_radius

// This program segments cells and measures ROIs based on 
// two-channel ro-GFP measurements.
//
// Usage:
// * Run in FIJI (www.fiji.sc)
//
// Author: Jens Loncke, KU Leuven, jens.loncke@kuleuven.be
// June 2022

// Clear everything and open files
run("Clear Results");
roiManager("reset");
open(Time_series);
reduced = getTitle();
oxidized = replace(reduced, "C=1", "C=0");
File.makeDirectory(Folder_results+"/ROIs/");
File.makeDirectory(Folder_results+"/Multi_measure/");

// Subtract background
window_titles = getList("image.titles");
for ( i = 0; i < window_titles.length; i++ ) {
	selectWindow(window_titles[i]);
	run("Subtract Background...", "rolling=BG_rolling_ball_radius stack");
}

// Find ROIs
imageCalculator("Add create stack", oxidized, reduced);
run("Z Project...", "projection=[Sum Slices]");
setOption("ScaleConversions", true);
run("8-bit");
run("Gaussian Blur...", "sigma=2 stack");
setAutoThreshold("Li dark");
setOption("BlackBackground", true);
run("Convert to Mask");
run("Watershed");
run("Analyze Particles...", "size=20-10000 exclude add");

// Let user do quality control of ROIs
setTool("freehand");
waitForUser("Please adapt ROIs if necessary. When finished press OK.");

// Measure results
roiManager("deselect");
roiManager("Save", Folder_results+"/ROIs/"+oxidized+".zip");
run("Set Measurements...", "mean display redirect=None decimal=3");
selectWindow(reduced);
roiManager("multi measure")
saveAs("Results", Folder_results+"/Multi_measure/"+reduced+"_470.csv");
run("Clear Results");
selectWindow(oxidized);
roiManager("multi measure")
saveAs("Results", Folder_results+"/Multi_measure/"+oxidized+"_405.csv");
roiManager("reset");
close("*");
selectWindow("Results"); 
run("Close");