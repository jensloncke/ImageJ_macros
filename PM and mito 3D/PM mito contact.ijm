// @File (style = "open") stack
// @File (style = "directory") Folder_results


// Open files and create directories
open(stack);
File.makeDirectory(Folder_results+"/Measure/");
Stack.getDimensions(width, height, channels, slices, frames);

if (channels < 2) {
	waitForUser("Multichannel acquisition needed");
} 
else {
	run("Split Channels");
	PM_title = getTitle();
	MT_title = replace(PM_title, "C2", "C1");
	i = 1;
	c = 1;
	while (i > 0) {
		setTool("freehand");
		waitForUser("Please circle area with desired cell and press 't'. When finished press OK without outlining cell.");
		i = roiManager("count");
		if (i <= 0) {
			break;
		}
		else {
		process_cell(c);
		c = c + 1;
		}
	}	
}	


function process_cell(c) {
	// Let user define slice range
	selectWindow(PM_title);
	roiManager("Show None");
	waitForUser("Please navigate to first slice where plasma membrane outline is still visible. When finished press OK.");
	first_slice = getSliceNumber();
	waitForUser("Please navigate to last slice where plasma membrane outline is still visible. When finished press OK.");
	last_slice = getSliceNumber();
	run("Duplicate...", "duplicate");
	run("Make Substack...", "slices="+first_slice+"-"+last_slice);
	rename("PM_sub");
	substack_PM = getTitle();
	
	// Pre-process PM image
	selectWindow(substack_PM);
	roiManager("Select", 0);
	setBackgroundColor(0, 0, 0);
	run("Clear Outside", "stack");
	run("Duplicate...", "duplicate");
	run("Gaussian Blur...", "sigma=2 stack");
	run("8-bit");
	setAutoThreshold("Otsu dark");
	setOption("BlackBackground", true);
    run("Convert to Mask", "method=Otsu background=Dark calculate black");
    run("Fill Holes", "stack");
    binary_PM = getTitle();
	end_slice = nSlices;
	
	// Pre-process MT image
	selectWindow(MT_title);
	run("Duplicate...", "duplicate");
	run("Make Substack...", "slices="+first_slice+"-"+last_slice);
	rename("MT_sub");
	substack_MT = getTitle();
	selectWindow(substack_MT);
	roiManager("Select", 0);
	setBackgroundColor(0, 0, 0);
	run("Clear Outside", "stack");
	run("Duplicate...", "duplicate");
	run("Despeckle", "stack");
	run("Unsharp Mask...", "radius=500 mask=0.60 stack");
	run("Gaussian Blur...", "sigma=5 stack");
	run("8-bit");
	setAutoThreshold("Otsu dark");
	setOption("BlackBackground", true);
	run("Convert to Mask", "method=Otsu background=Dark calculate black");
	run("Fill Holes", "stack");
	binary_MT = getTitle();
	
	run("Set Measurements...", "area display redirect=None decimal=3");
	roiManager("Select", 0);
	roiManager("Delete");
	roiManager("Show None");
	roiManager("reset");
	// Measure each slice sequentially
	for (j=1; j<=end_slice; j++){
		selectWindow(binary_PM);
		setSlice(j);
		roiManager("Show None");
		run("Select None");
		run("Analyze Particles...", "size=5-Infinity add");
		count1 = roiManager("count");
		array1 = newArray(count1);
  		for (k=0; k<array1.length; k++) {
      		array1[k] = k;
  		}
		roiManager("select", array1);
		roiManager("Combine");
		roiManager("Add");
		roiManager("select", array1);
		roiManager("Delete");
		roiManager("deselect");;
		selectWindow(binary_MT);
		setSlice(j);
		run("Select None");
		run("Analyze Particles...", "size=0-Infinity add");
		count2 = roiManager("count") - 1;
		array2 = newArray(count2);
  		for (l=0; l<array2.length; l++) {
      		array2[l] = l+1;
  		}
  		roiManager("select", array2);
		roiManager("Combine");
		roiManager("Add");
		roiManager("select", array2);
		roiManager("Delete");
		roiManager("select", newArray(0,1));
		roiManager("XOR");
		roiManager("Add");
		roiManager("select", 2);
		run("Measure");
		roiManager("reset");
	}
	
	saveAs("Results", Folder_results+"/Measure/"+PM_title+"_cell"+c+".csv");
	selectWindow("Results"); 
	run("Close");
}

// Close everything
roiManager("reset");
close("*");