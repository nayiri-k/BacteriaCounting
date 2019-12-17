clear
close all
clc

load('data/confocal.mat');
confocal = cluster1Processed5;
clear cluster1Processed5;

confocal=mat2gray(confocal);
figure, imshow(confocal), title('Confocal: Original image')

% CELL COUNT
confocalBin = imbinarize(confocal,0.99);
step = .001;
for i=0.07:step:1
    temp = imbinarize(confocal,i);
    temp = bwareaopen(temp, 50) & ~bwareaopen(temp, 400);
    %temp = bwmorph(temp,'bridge',Inf);
    %temp = bwmorph(temp,'close',Inf);
    confocalBin = confocalBin | temp;
end
%confocalBin = bwmorph(confocalBin,'close',Inf);
%confocalBin = imdilate(confocalBin, strel('sphere',1));

figure, imshowpair(confocal,confocalBin,'falsecolor'), title('Confocal: Binarized image overlaid on Original');
figure, imshowpair(confocal,confocalBin,'montage'), title('Confocal: Original and Binarized images');
[confocalLengthCells,n]=bwlabel(confocalBin);%n is total number
n

%% LENGTH
confocalLength = bwmorph(confocalBin,'skel',Inf);

l = sum(confocalLength(:)) % print red lymphocyte skeleton length
figure, imshowpair(confocal,confocalLength,'falsecolor'), title('Confocal: Skeleton overlaid on Original')

[L,n] = bwlabel(confocalLength);
cellLength = zeros(n,1);
for i=1:size(L)
    for j=1:size(L)
        if L(i,j) > 0
            cellLength(int8(L(i,j))) = cellLength(int8(L(i,j))) + 1;
        end
    end
end

for i=1:size(confocalLengthCells)
    for j=1:size(confocalLengthCells)
        if L(i,j) > 0
            L(i,j) = cellLength(int8(L(i,j)));
        end
    end
end

%figure, image(confocalLengthCells)
figure, imshowpair(confocal, L,'montage'), title('Confocal: Cells with brightness based on their lengths')
