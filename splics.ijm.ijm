run("Duplicate...", " ");
roiManager("Select", 0);
run("Crop");
run("Duplicate...", " ");
setOption("ScaleConversions", true);
run("8-bit");
run("Bandpass Filter...", "filter_large=40 filter_small=3 suppress=None tolerance=5 autoscale saturate");
//setAutoThreshold();
getThreshold(lower, upper);
setThreshold(156, 255);
setOption("BlackBackground", true);
run("Convert to Mask");
run("Analyze Particles...", "exclude add");
roiManager("Show All without labels");
roiManager("Select", 0);
roiManager("Delete");
run("Select All");
roiManager("Measure");
