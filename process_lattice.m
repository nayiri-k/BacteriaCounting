clear
close all
clc

lattice = imread('data/latticeLightSheet.jpg');
% figure, imshow(lattice), title('original')
lattice = mat2gray(lattice);
 
% this part originally uncommented to see lattice at different thresholds
% for i=.2:.1:.9
% 	latticeBin = imbinarize(lattice,i);
% 	latticeBin = bwareaopen(latticeBin, 20);
% 	figure, imshowpair(lattice,latticeBin,'montage'), title('Confocal: Original and Binarized');
% end
%% CELL COUNT
latticeBin = imbinarize(lattice,0.99);
for i=0.07:.01:1
	latticeBintemp = imbinarize(lattice,i);
	latticeBintemp = latticeBintemp & ~bwareaopen(latticeBintemp, 60);
	latticeBin = latticeBin | latticeBintemp;
end
latticeBin = bwareaopen(latticeBin, 10);
latticeBin = medfilt2(latticeBin, [2 2]);
figure, imshowpair(lattice,latticeBin,'montage'), title('Lattice: Original and Binarized images');
figure, imshowpair(lattice,latticeBin,'falsecolor'), title('Lattice: Binarized image overlaid on Original');
[latticeCellLabels,n]=bwlabel(latticeBin);	%n is total number
n 		% display number of bacteria
 
%% LENGTH
latticeSkel = bwmorph(latticeBin,'skel',Inf);
figure, imshowpair(lattice,latticeSkel,'falsecolor'), title('Lattice: Skeleton overlaid on Original')

l = sum(latticeSkel(:)) % print red lymphocyte skeleton length

[latticeSkelLabels,n] = bwlabel(latticeSkel);
cellLength = zeros(n,1);
[xl,yl] = size(latticeSkelLabels);
for i=1:xl
    for j=1:yl
        if latticeSkelLabels(i,j) > 0
            cellLength(latticeSkelLabels(i,j)) = cellLength(latticeSkelLabels(i,j)) + 1;
        end
    end
end


for i=1:xl
    for j=1:yl
        if latticeSkelLabels(i,j) > 0
            latticeSkelLabels(i,j) = cellLength(latticeSkelLabels(i,j));
        end
    end
end

%figure, image(latticeCellLabels)
figure, imshowpair(lattice, latticeSkelLabels,'montage'), title('Confocal: Cells with brightness based on their lengths')


