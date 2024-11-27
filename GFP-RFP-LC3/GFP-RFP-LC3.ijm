// @File (style = "open") stack
// @File (style = "directory") Folder_results
// @int BG_rolling_ball_radius
// @int prominence_GFP
// @int prominence_RFP

// This program measures green and red fluorescence of the GFP-RFP-LC3 probe
// and counts puncti representing autophagosomal (GFP and RFP) 
// or lysosomal LC3 (RFP).
//
// Usage:
// * Run in FIJI (www.fiji.sc)
//
// Author: Jens Loncke, KU Leuven, jens.loncke@kuleuven.be
// April 2023

// Open files and create directories
open(stack);
File.makeDirectory(Folder_results+"/ROIs/");
File.makeDirectory(Folder_results+"/Measure/");
title = getTitle();
NUC = getTitle();
RFP = replace(NUC, "C=2", "C=1");
GFP = replace(NUC, "C=2", "C=0");

// Let user define ROI
setTool("freehand");
waitForUser("Please circle areas with single cells and press 't'. When finished press OK.");
nROIs = roiManager("count");
roiManager("Save", Folder_results+"/ROIs/"+title+".zip");


// Subtract background
window_titles = getList("image.titles");
for ( i = 0; i < window_titles.length; i++ ) {
	selectWindow(window_titles[i]);
	run("Subtract Background...", "rolling=BG_rolling_ball_radius sliding");
}

for ( i = 0; i < nROIs; i++) {
	process_cell(i);
}

function process_cell(i) {
	// Measure fluorescence intensities
	selectWindow(GFP);
	run("Duplicate...", " ");
	roiManager("Select", i);
	run("Set Measurements...", "mean display redirect=None decimal=3");
	roiManager("Measure");
	setResult("Label", 0, "Cell_"+i+1+"-GFP_intensity");
	setBackgroundColor(0, 0, 0);
	run("Duplicate...", "duplicate");
	run("Clear Outside");
	GFP_dup = getTitle();
	selectWindow(RFP);
	run("Duplicate...", " ");
	roiManager("Select", i);
	roiManager("Measure");
	setResult("Label", 1, "Cell_"+i+1+"-RFP_intensity");
	run("Duplicate...", "duplicate");
	setBackgroundColor(0, 0, 0);
	run("Clear Outside");
	RFP_dup = getTitle();
	
	//Count puncti
	run("Select None");
	selectWindow(GFP_dup);
	run("Find Maxima...", "prominence=prominence_GFP output=Count");
	setResult("Label", 2, "Cell_"+i+1+"-GFP_puncti");
	selectWindow(RFP_dup);
	run("Find Maxima...", "prominence=prominence_RFP output=Count");
	setResult("Label", 3, "Cell_"+i+1+"-RFP_puncti");
	saveAs("Results", Folder_results+"/Measure/"+title+"_cell"+i+1+".csv");
	run("Clear Results");
}	

// Close everything
roiManager("reset");
close("*");
selectWindow("Results"); 
run("Close");
