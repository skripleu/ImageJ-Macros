// define function for calculation of mean of an array
// why the fuck does this language not have a command for this
function mean(array) {
    if (lengthOf(array)==0)
        return 0;
    sum = 0;
    for (i=0; i<array.length; i++) {
        n = parseFloat(array[i]);
        if (isNaN(n))
            exit("'" + array[i] + "' is not a number");
        sum += n;
    }
    return sum/array.length;
}


path_data=getDirectory("Choose a data folder");

//make result folders
title = getTitle(); 
resultDir = path_data + "/results_" + toString(title);
File.makeDirectory(resultDir);

run("Clear Results");

// for multiple ROIs in one image
num_roi = roiManager("count");
roiManager("save", resultDir + "/ROI_" + title + ".zip");
for (r=0; r < num_roi; r++){
	roiManager("select", r);
	Stack.setChannel(1);
	getDimensions(w, h, channels, slices, frames);
	
	//loop over all possible channels, channel 1 is the first channel in ImageJ
	for(c=1; c<channels+1; c++){
		//set roi and channel information in result window
		setResult("ROI", channels * r + c-1, r);
		setResult("channel", channels * r + c-1, c);

		// get points from ROI, go to current channel of interest
		points = Roi.getContainedPoints(xpoints, ypoints);
		Stack.setChannel(c);
		num_pixels = xpoints.length;
		// get values as one long array and sort it
		values = newArray(num_pixels);
		for (i=0; i<num_pixels; i++)
			values[i] = getValue(xpoints[i], ypoints[i]);
		values_sort = Array.sort(values);
		// slice array in 100 equal fragments
		indices = newArray(101);
		indices[0] = 0;
		for (i=1; i<101; i++){
			fraction = i/100;
			index = round(fraction * num_pixels);
			indices[i] = index;
		}
		// calculate mean value for each fragments
		percentiles = newArray(101);
		for(i=0; i<100; i++){
			start = indices[i];
			end = indices[i+1];
			vals_percentile = Array.slice(values, start, end);
			percentiles[i] = mean(vals_percentile);
		}
		// list fragment means as row result table
		for (i=0; i<100; i++){
			setResult(i, channels * r + c - 1, percentiles[i]);
		}
	}
}
saveAs("Results", resultDir + "/" + title + ".csv");