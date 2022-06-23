// @File (style = "open") Time_series
// @String (label = "Fluo-4 channel") Channel_F4
// @String (label = "mtCEPIA channel") Channel_MT
// @File (style = "directory") Folder_results
// @int BG_rolling_ball_radius
// @int Transfection_RFU_cutoff

// This program finds ROIs based on an F4 channel differentiating between transfected
// and non-transfected cells.
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
F4_title = getTitle();
F4_title = replace(F4_title, "C=1", "C="+Channel_F4);
MT_title = replace(F4_title, "C="+Channel_F4, "C="+Channel_MT);
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
selectWindow(F4_title);
setSlice(nSlices());
run("Calibrate...", "function=None");
run("Duplicate...", " ");
setOption("ScaleConversions", true);
run("8-bit");
run("Despeckle");
run("Bandpass Filter...", "filter_large=40 filter_small=3 suppress=None tolerance=5 autoscale saturate");
run("Gaussian Blur...", "sigma=4");
setAutoThreshold("Triangle dark");
setOption("BlackBackground", true);
run("Convert to Mask");
run("Fill Holes");
run("Analyze Particles...", "size=200-Infinity exclude add");

// Let user do quality control of ROIs
setTool("freehand");
waitForUser("Please adapt ROIs if necessary. When finished press OK.");

// Measure mtCEPIA signal of first frame
roiManager("deselect");
run("Set Measurements...", "mean display redirect=None decimal=3");
selectWindow(MT_title);
roiManager("measure")

// Distinguish between transfected and untransfected cells
nROIs = roiManager("count");
transfected = newArray(0);
non_transfected = newArray(0);


for ( i = 0; i < nROIs; i++ ) {
	mean_value = getResult("Mean", i);
	if (mean_value < Transfection_RFU_cutoff) { non_transfected = Array.concat(i, non_transfected);
	} else { transfected = Array.concat(i, transfected);}	
		
}

// Measure cytosol of untransfected cells
run("Clear Results");
selectWindow(F4_title);
setSlice(1);
roiManager("select" non_transfected);
roiManager("save selected", Folder_results+"/Untransfected_ROIs/"+F4_title+".zip"); 
roiManager("multi measure");
saveAs("Results", Folder_results+"/Multi_measure_untransfected/"+F4_title+"_F4_.csv");
run("Clear Results");
// Measure cytosol and mitochondria of transfected cells
roiManager("select" transfected);
roiManager("save selected", Folder_results+"/Transfected_ROIs/"+F4_title+".zip"); 
roiManager("multi measure");
saveAs("Results", Folder_results+"/Multi_measure_transfected/"+F4_title+"_F4.csv");
run("Clear Results");
selectWindow(MT_title);
roiManager("Select" transfected);
roiManager("multi measure");
saveAs("Results", Folder_results+"/Multi_measure_transfected/"+MT_title+"_mtCEPIA.csv");

// Close everything
roiManager("reset");
close("*");
selectWindow("Results"); 
run("Close");

