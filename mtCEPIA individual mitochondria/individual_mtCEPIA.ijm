// @File (style = "open") Time_series
// @String (label="mtCEPIA channel") Channel
// @File (style = "directory") Folder_results
// @int BG_rolling_ball_radius


// This program finds and records individual mitochondria based on mtCEPIA fluorescence.
//
// Usage:
// * Run in FIJI (www.fiji.sc)
//
// Author: Jens Loncke, KU Leuven, jens.loncke@kuleuven.be
// October 2021

// Clear everything and open files
run("Clear Results");
roiManager("reset");
open(Time_series);
measurement_title = getTitle();
CEPIA_title = replace(measurement_title, "C=0", "C="+Channel);
File.makeDirectory(Folder_results+"/ROIs/");
File.makeDirectory(Folder_results+"/Multi_measure/");

// Subtract background
window_titles = getList("image.titles");
for ( i = 0; i < window_titles.length; i++ ) {
	selectWindow(window_titles[i]);
	run("Subtract Background...", "rolling=BG_rolling_ball_radius stack");
}

// Find ROIs
selectWindow(CEPIA_title);
run("Duplicate...", "duplicate");
run("Z Project...", "projection=[Sum Slices]");
setOption("ScaleConversions", true);
run("8-bit");
run("Convolve...", "text1=[-1 -1 -1 -1 -1\n-1 -1 -1 -1 -1\n-1 -1 24 -1 -1\n-1 -1 -1 -1 -1\n-1 -1 -1 -1 -1\n] normalize");
setAutoThreshold("RenyiEntropy dark");
setOption("BlackBackground", true);
run("Convert to Mask");
run("Analyze Particles...", "size=2-500 exclude add");

// Let user do quality control of ROIs
setTool("freehand");
waitForUser("Please adapt ROIs if necessary. When finished press OK.");

// Measure results
roiManager("deselect");
roiManager("Save", Folder_results+"/ROIs/"+CEPIA_title+".zip");
run("Set Measurements...", "mean display redirect=None decimal=3");
selectWindow(CEPIA_title);
roiManager("multi measure")
saveAs("Results", Folder_results+"/Multi_measure/"+CEPIA_title+"_mtCEPIA.csv");
run("Clear Results");
roiManager("reset");
close("*");
selectWindow("Results"); 
run("Close");
