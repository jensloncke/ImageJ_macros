// @File (style = "open") stack
// @File (style = "directory") Folder_results

// This program computes ER-mitochondrial contact parameters based on MAMtracker
// signal.
//
// Usage:
// * Run in FIJI (www.fiji.sc)
//
// Author: Jens Loncke, KU Leuven, jens.loncke@kuleuven.be
// August 2024

// Open files and create directories
open(stack);
File.makeDirectory(Folder_results+"/ROIs/");
File.makeDirectory(Folder_results+"/Measure/");
File.makeDirectory(Folder_results+"/Measure/intensity");

title = getTitle();
title = replace(title, "C=2", "C=1");

// Let user define ROI
run("Duplicate...", "duplicate");
run("Bandpass Filter...", "filter_large=40 filter_small=3 suppress=None tolerance=5 autoscale saturate");
setAutoThreshold("Li dark");
setOption("BlackBackground", true);
run("Convert to Mask");
run("Analyze Particles...", "size=100-Infinity add");

setTool("freehand");
waitForUser("Please define cell ROIs and press 't'. When finished press OK.");
roiManager("Save", Folder_results+"/ROIs/"+title+".zip");

nROIs = roiManager("count");

Stack.getDimensions(width, height, channels, slices, frames);
if (channels > 1) {
	run("Split Channels");
	window_title = "C1-"+title;
	selectWindow(window_title);
	analyze_channel();
};

else {
	selectWindow(title);
	rename("C1-"+title);
	window_title = getTitle();
	analyze_channel();
};

function analyze_channel() {
	for ( i = 0; i < nROIs; i++) {
			process_cell(i);
		}
}

function process_cell(i) {
	run("Duplicate...", "duplicate");
	//measure fluorescence
	run("Set Measurements...", "mean integrated display redirect=None decimal=3");
	roiManager("Select", i);
	run("Measure");
	saveAs("Results", Folder_results+"/Measure/intensity/"+window_title+"_cell"+i+1+".csv");
	run("Clear Results");
	// Pre-process images
	setBackgroundColor(0, 0, 0);
	run("Clear Outside");
	run("Duplicate...", " ");
	run("Convolve...", "text1=[-1 -1 -1 -1 -1\n-1 -1 -1 -1 -1\n-1 -1 24 -1 -1\n-1 -1 -1 -1 -1\n-1 -1 -1 -1 -1\n]");
	run("Gaussian Blur...", "sigma=2");
	
	// Threshold pre-processed 2D image
	run("Threshold...");
	setAutoThreshold("Otsu dark");
	run("Convert to Mask");
	run("Watershed");
	run("Analyze Particles...", "  summarize");
	saveAs("Results", Folder_results+"/Measure/"+window_title+"_cell"+i+1+".csv");
	selectWindow(window_title);
	close("\\Others");
	selectWindow(window_title+"_cell"+i+1+".csv");
	run("Close");

}

// Close everything
roiManager("reset");
close("Results");
close("*");


