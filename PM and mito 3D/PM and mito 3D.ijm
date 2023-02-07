// @File (style = "open") stack
// @File (style = "directory") Folder_results

// Open files and create directories
open(stack);
File.makeDirectory(Folder_results+"/Measure/");

// Let user define ROI
setTool("freehand");
waitForUser("Please circle areas with single cells and press 't'. When finished press OK.");
nROIs = roiManager("count");
Stack.getDimensions(width, height, channels, slices, frames);
if (channels < 2) {
	waitForUser("Multichannel acquisition needed");
} else {
	run("Split Channels");
	PM_title = getTitle();
	MT_title = replace(PM_title, "C2", "C1");
	for ( i = 0; i < nROIs; i++) {
			process_cell(i);
		}	
}

function process_cell(i) {
	// Let user define slice range
	selectWindow(PM_title);
	waitForUser("ROI "+i+1+": Please navigate to first slice where plasma membrane outline is still visible. When finished press OK.");
	first_slice = getSliceNumber();
	waitForUser("ROI "+i+1+": Please navigate to last slice where plasma membrane outline is still visible. When finished press OK.");
	last_slice = getSliceNumber();
	run("Duplicate...", "duplicate");
	run("Make Substack...", "slices="+first_slice+"-"+last_slice);
	substack_PM = getTitle();
	
	// Pre-process PM image
	selectWindow(substack_PM);
	roiManager("Select", i);
	setBackgroundColor(0, 0, 0);
	run("Clear Outside", "stack");
	run("Duplicate...", "duplicate");
	run("Subtract Background...", "rolling=80 stack");
	run("Gaussian Blur...", "sigma=2 stack");
	run("8-bit");
	setAutoThreshold("Otsu dark");
	setOption("BlackBackground", true);
	run("Convert to Mask", "method=Otsu background=Dark calculate black");
	run("Fill Holes", "stack");
	end_slice = nSlices;
	run("Set Measurements...", "area limit display redirect=None decimal=3");
	
	// Measure each slice sequentially
	for (j=1; j<=end_slice; j++){
		setSlice(j);
		run("Measure");
	}
	
	saveAs("Results", Folder_results+"/Measure/"+"PM_"+PM_title+"_cell"+i+1+".csv");
	selectWindow("Results"); 
	run("Close");
	selectWindow(substack_PM);
	run("Close");
	
	// Pre-process MT image
	selectWindow(MT_title);
	run("Duplicate...", "duplicate");
	run("Make Substack...", "slices="+first_slice+"-"+last_slice);
	substack_MT = getTitle();
	selectWindow(substack_MT);
	roiManager("Select", i);
	setBackgroundColor(0, 0, 0);
	run("Clear Outside", "stack");
	run("Duplicate...", "duplicate");
	run("Despeckle", "stack");
	run("Subtract Background...", "rolling=80 stack");
	setAutoThreshold("Otsu dark");
	setOption("BlackBackground", true);
	run("Convert to Mask", "method=Otsu background=Dark calculate black");
	
	// Measure each slice sequentially
	for (k=1; k<=end_slice; k++){
		setSlice(k);
		run("Measure");
	}
	
	saveAs("Results", Folder_results+"/Measure/"+"MT_"+MT_title+"_cell"+i+1+".csv");
	selectWindow("Results"); 
	run("Close");
	selectWindow(substack_MT);
	run("Close");
}

// Close everything
roiManager("reset");
close("*");

	
	
