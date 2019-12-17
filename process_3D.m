close all
clc
clear tiff_stack

%% LOAD ORIGINAL IMAGE
tiff_info_orig = imfinfo('data/3D.tif'); % return tiff structure, one element per image
tiff_slice_orig = imread('data/3D.tif', 1);
tiff_stack_orig = tiff_slice_orig; % read in first image
%concatenate each successive tiff to tiff_stack
for ii = 2 : size(tiff_info_orig, 1)
    tiff_slice_orig = imread('data/3D.tif', ii);
    tiff_stack_orig = cat(3 , tiff_stack_orig, tiff_slice_orig);
end

%% THRESHOLD IMAGE
tiff_info = imfinfo('data/3D.tif'); % return tiff structure, one element per image
tiff_slice = imread('data/3D.tif', 1);
tiff_slice(tiff_slice<=15000) = 0;
tiff_slice(tiff_slice>15000) = 1;
tiff_stack = tiff_slice; % read in first image
%concatenate each successive tiff to tiff_stack
for ii = 2 : size(tiff_info, 1)
    tiff_slice = imread('data/3D.tif', ii);
    tiff_slice_mod = tiff_slice;
    tiff_slice_mod(tiff_slice_mod>0) = 0;
    for i=5000:500:25000
        temp = tiff_slice;
        temp(temp<=i) = 0;
        temp(temp>i) = 1;
        temp = medfilt2(temp, [9 9]);
        temp = temp & ~bwareaopen(temp, 200);
        temp = bwareaopen(temp,20);
        tiff_slice_mod = tiff_slice_mod | temp;
    end
    tiff_slice = tiff_slice_mod;
    tiff_stack = cat(3 , tiff_stack, tiff_slice);
end
% NOTE: at this point, save tiff_stack as tiff_stack.mat in workplace
% so you can reload this and skip previous steps (for faster computation)
%% SKELETONIZE AND COMPUTE LENGTHS
skel3D = Skeleton3D(logical(tiff_stack));
[L3D,n3D] = bwlabeln(skel3D);
[x,y,z] = size(tiff_stack);
cellLengths = zeros(n3D,1);
for i=1:x
    for j=1:y
        for k=1:z
            if L3D(i,j,k) > 0
                cellLengths(L3D(i,j,k)) = cellLengths(L3D(i,j,k)) + 2;
            end
        end
    end
end

skel3DLengths = zeros(x,y,z);
for i=1:x
    for j=1:y
        for k=1:z
            if L3D(i,j,k) > 0
                skel3DLengths(i,j,k) = cellLengths(L3D(i,j,k));
            end
        end
    end
end

 x = skel3DLengths(:,:,1);
 y = skel3DLengths(:,:,2);
 z = skel3DLengths(:,:,3);
% NOTE: at this point, save skel3D as skel3D.mat in workplace
%       and skel3DLengths as skel3DLengths.mat in workplace
%       so you quickly load them into the MATLAB volume viewer 
%       (see next section)

%% Viewing 3D
% Open MATLAB Apps > Volume Viewer
% Import from Workspace > tiff_stack, skel3D, or skel3DLengths
% The volume is loaded, and can be rotated/zoomed into to view better

