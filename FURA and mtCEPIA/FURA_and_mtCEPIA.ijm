// @File (style = "open") Time_series
// @String (label = "340 channel") Channel_340
// @String (label = "380 channel") Channel_380
// @String (label = "Mito channel") Channel_MT
// @File (style = "directory") Folder_results
// @int BG_rolling_ball_radius
// @int Transfection_RFU_cutoff

// This program finds ROIs based on the two FURA-2 channels differentiating between transfected/stained
// and non-transfected/stained cells.
//
// Usage:
// * Run in FIJI (www.fiji.sc)
//
// Author: Jens Loncke, KU Leuven, jens.loncke@kuleuven.be
// February 2023

// Clear everything and open files
run("Clear Results");
roiManager("reset");
open(Time_series);
title_380 = getTitle();
title_340 = replace(title_380, "C=2", "C="+Channel_340);
MT_title = replace(title_380, "C=2", "C="+Channel_MT);
title_380 = replace(title_380, "C=2", "C="+Channel_380);
// Make directories for ROIs and results
File.makeDirectory(Folder_results+"/Transfected_ROIs/");
File.makeDirectory(Folder_results+"/Untransfected_ROIs/");
File.makeDirectory(Folder_results+"/Multi_measure_transfected/");
File.makeDirectory(Folder_results+"/Multi_measure_untransfected/");

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

// Measure FURA-2
run("Clear Results");
selectWindow(title_380);
setSlice(1);
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

