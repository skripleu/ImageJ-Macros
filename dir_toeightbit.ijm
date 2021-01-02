input = getDirectory("Choose input directory! ");
output = getDirectory("Choose your ouptut directory! ");
files = getFileList(input);

setBatchMode(true);

function ToEightBit(im_path, out_path){
// opens image at given path, checks if its 16bit, then concerts to 8bit 
	open(im_path);
	current = bitDepth();
	if (current !=8){
	run("8-bit");
	}
	save(out_path);
	close();
}

for (i = 0; i < files.length; i++){
	impath = input + files[i];
	outpath = output + files[i];	
	ToEightBit(impath, outpath);
}