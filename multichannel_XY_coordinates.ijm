path_data=getDirectory("Choose a data folder");

//make intermediate folders
title = getTitle(); 
resultDir = path_data + "/results_" + toString(title);
newDir = path_data + "/intermediate_data";
File.makeDirectory(newDir);
File.makeDirectory(resultDir);

// for multiple ROIs in one image
num_roi = roiManager("count");
roiManager("save", resultDir + "/ROI.zip");
for (r=0; r < num_roi; r++){
	// choose current roi
	roiManager("select", r)
	getDimensions(w, h, channels, slices, frames);
	// use save XY function on channel 0 and 1; save in new folder
	Stack.setChannel(0);
	dir_0 = newDir + "/channel0.csv";
	save_0 = "save=[" + dir_0 + "]";
	run("Save XY Coordinates...", save_0);
	 
	// reopen data
	lines_0 = split(File.openAsString(dir_0), "\n"); //split data, /n as line separator
	labels_0 = split(lines_0[0], ","); //get labels for channel0
	labels_0[2] = "channel_0"; //rename Value for channel_0
	
	//measure to open generic Results window
	run("Measure");
	
	// clear old results
	run("Clear Results");
	
	for (k = 0; k < labels_0.length; k++)
		setResult(labels_0[k],0,0);
	
	for (i = 1; i < lines_0.length; i++){
		items = split(lines_0[i], ",");
		for (j = 0; j < items.length; j++){
			setResult(labels_0[j], i-1, items[j]);
		};
	}
	
	for (c = 1; c < channels; c++){
		Stack.setChannel(c+1);
		dir_c = newDir + "/channel" + c + ".csv";
		run("Save XY Coordinates...", "save=[" + dir_c + "]");
		// reopen data
		lines_c = split(File.openAsString(dir_c), "\n"); //split data, /n as line separator
		labels_c = split(lines_c[0], ","); //get labels for channel0 
		labels_c[2] = "channel_" + toString(c);
	
		k = c + 2; // for channel nr behind 
	
		setResult(labels_c[2],0,0);
		
		for (i = 1; i < lines_c.length; i++){
			items = split(lines_c[i], ",");
			setResult(labels_c[2], i-1, items[2]);
			}
	}
	
	// save composite results to resultdirectory
	selectWindow("Results");
	
	//get roi number as 3 digit number
	r_string = toString(r);
    	while (lengthOf(r_string)<3)
        	r_string = "0"+r_string;
        
	saveAs("Results", resultDir + "/" + title + "_roi" + r_string + ".csv");
}
//Delete the intermediat files and directory 
list = getFileList(newDir);
for (i=0; i<list.length; i++)
	 File.delete(newDir + "/" + list[i]);
File.delete(newDir);
if (File.exists(newDir))
	exit("Unable to delete directory");
else
	print("Directory and files successfully deleted");
