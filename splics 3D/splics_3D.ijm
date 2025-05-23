// @File (style = "open") stack
// @File (style = "directory") Folder_results

// This program computes ER-mitochondrial contact parameters based on SPLICS
// signal.
//
// Usage:
// * Run in FIJI (www.fiji.sc)
//
// Author: Jens Loncke, KU Leuven, jens.loncke@kuleuven.be
// November 2021

// Open files and create directories
open(stack);
File.makeDirectory(Folder_results+"/ROIs/");
File.makeDirectory(Folder_results+"/Measure/");
title = getTitle();

// Let user define ROI
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
	// Let user define slice range
	waitForUser("ROI "+i+1+ ": Please navigate to first slice. When finished press OK.");
	first_slice = getSliceNumber();
	waitForUser("Please navigate to last slice. When finished press OK.");
	last_slice = getSliceNumber();
	run("Duplicate...", "duplicate");
	run("Make Substack...", "slices="+first_slice+"-"+last_slice);
	substack = getTitle();
	
	// Pre-process images
	selectWindow(substack);
	roiManager("Select", i);
	setBackgroundColor(0, 0, 0);
	run("Clear Outside", "stack");
	run("Duplicate...", "duplicate");
	run("Convolve...", "text1=[-1 -1 -1 -1 -1\n-1 -1 -1 -1 -1\n-1 -1 26 -1 -1\n-1 -1 -1 -1 -1\n-1 -1 -1 -1 -1\n] stack");
	run("Gaussian Blur...", "sigma=2 stack");
	
	// 3D render Z-stack
	run("VolumeJ ");
	waitForUser("Please choose render parameters and render Z-stack to 3D image. When finished press OK.");
	
	// Threshold 3D rendered image
	run("Threshold...");
	setAutoThreshold("Otsu dark");
	setOption("BlackBackground", false);
	run("Convert to Mask");
	run("Watershed");
	run("Analyze Particles...", "  summarize");
	saveAs("Results", Folder_results+"/Measure/"+window_title+"_cell"+i+1+".csv");
	selectWindow(substack);
	setAutoThreshold("Otsu dark");
	run("Voxel Counter");
	waitForUser("Results OK?");
	selectWindow(window_title);
	close("\\Others");
	selectWindow(window_title+"_cell"+i+1+".csv");
	run("Close");

}

// Close everything
roiManager("reset");
close("*");
