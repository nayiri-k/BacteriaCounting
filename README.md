# Shewanella Bacteria Counting

## Repo Overview
* data
	* confocal.mat: original bacteria data
	* latticeLightSheet.jpg: overexposed image of bacteria
	* 3D.tif: 3D image of bacteria
* docs
	* progress and final report for experiment
* images
	* all saved output images of experiment
* Skeleton3D
	* Courtesy of Philip Kollmannsberger
	* Freely available on MathWorks File Exchange
	* Calculates the 3D skeleton of an arbitrary binary volume using parallel medial axis thinning.
	* Available here: https://www.mathworks.com/matlabcentral/fileexchange/43400-skeleton3d
	* Used in process_3D to skeletonize 3D bacteria image
* process_*.m
	* MATLAB files to process the three data files
* Shewanella_Bacteria_Counting_Report.pdf 
	* final report for this experiment

## Setup
1. Navigate to this folder in MATLAB
2. Select all folders in this directory > Right Click > Add to Path > Selected Folders
3. Run desired matlab file

## Results
Read a summary of the results in Shewanella_Bacteria_Counting_Report.pdf in this repo