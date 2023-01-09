// @File (style = "open") stack
// @File (style = "directory") Folder_results

// This program quantifies mtKeima red over green ratio and quantifies mtKeima puncti of images recorded with the Nikon TI2-E microscope using NIS Elements software.
// 
//
// Usage:
// * Run in FIJI (www.fiji.sc)
//
// Author: Jens Loncke, KU Leuven, jens.loncke@kuleuven.be
// July 2022

// Open files and create directories
open(stack);
File.makeDirectory(Folder_results+"/ROIs/");
File.makeDirectory(Folder_results+"/Fluorescence/");
File.makeDirectory(Folder_results+"/Counts/");
red = getTitle();
green = replace(red, "C=1", "C=0");

// Find ROI of distinct cells
imageCalculator("Add create", green, red);
combined_img = getTitle();
// // Remove bright puncti
run("Duplicate...", " ");
run("Gaussian Blur...", "sigma=2");
run("Convolve...", "text1=[-1 -1 -1 -1 -1\n-1 -1 -1 -1 -1\n-1 -1 24 -1 -1\n-1 -1 -1 -1 -1\n-1 -1 -1 -1 -1\n] normalize");
setAutoThreshold("Li dark");
setOption("BlackBackground", true);
run("Convert to Mask");
run("Analyze Particles...", "add");
count = roiManager("count");
puncti = newArray(count);
for (i=0; i<puncti.length; i++) {
      puncti[i] = i;
}
selectWindow(combined_img);
for (i=1; i<puncti.length; i++) {
	roiManager("Select", i);
	run("Clear", "slice");
}
roiManager("reset");

// // Threshold cells
selectWindow(combined_img);
run("Select None");
run("Duplicate...", " ");
setOption("ScaleConversions", true);
run("8-bit");
resetThreshold();
setAutoThreshold("Li dark");
run("Convert to Mask");
run("Fill Holes");
run("Analyze Particles...", "size=200.00-Infinity add");
setTool("freehand");
waitForUser("Please correct cell ROIs. When finished press OK.");
roiManager("Save", Folder_results+"/ROIs/"+green+".zip");

// Measure results
roiManager("deselect");
run("Set Measurements...", "area mean display redirect=None decimal=3");
nROIs = roiManager("count");
for ( i = 0; i < nROIs; i++) {
		process_cell(i);
}

function process_cell(i) {
	selectWindow(green);
	roiManager("multi measure")
	saveAs("Results", Folder_results+"/Fluorescence/"+green+".csv");
	run("Clear Results");
	selectWindow(red);
	roiManager("multi measure")
	saveAs("Results", Folder_results+"/Fluorescence/"+red+".csv");
	run("Clear Results");
	roiManager("Select", i);
	run("Duplicate...", "duplicate");
	setBackgroundColor(0, 0, 0);
	run("Clear Outside", "stack");
	run("Convolve...", "text1=[-1 -1 -1 -1 -1\n-1 -1 -1 -1 -1\n-1 -1 26 -1 -1\n-1 -1 -1 -1 -1\n-1 -1 -1 -1 -1\n] stack");
	run("Gaussian Blur...", "sigma=2 stack");
	run("Threshold...");
	setAutoThreshold("Otsu dark");
	setOption("BlackBackground", false);
	run("Convert to Mask");
	run("Watershed");
	run("Analyze Particles...", "summarize");
	saveAs("Results", Folder_results+"/Counts/"+green+"_Mean"+i+".csv");
	run("Close");
}

// Close everything
roiManager("reset");
selectWindow(green);
close("\\Others");
close("*");
selectWindow("Results"); 
run("Close");
