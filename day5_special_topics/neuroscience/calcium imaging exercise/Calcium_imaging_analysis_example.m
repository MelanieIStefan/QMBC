%% Calcium data anlalysis example
% by Abhinav Grama 
% 2014

% The data set being used here was acquired from the tectum/superior
% colliculus of a transgenic larval zebrafish tectum expressing the
% genetically encoded calcium indicator, GCaMP5, in all the neurons.
% The goals of this exercise are:
% 1. Load the calcium imaging movie.
% 2. Play the movie from within Matlab
% 3. Imaging data is usually corrupted with shot noise. We will use PCA/SVD 
%    to de-noise the movie
% 4. Calcium imaging is used to identify neurons responding to different kind
%    of stimuli or showing some form of spontaneous network activity. We will
%    try to identify neurons active during our imaging session using local 
%    pixel correlations. This analysis will generate an image of all the active
%    pixels that can be put through the image segmentation routines that were
%    taught earlier in the course.
%%
% generate eigen images from calcium movies
clear all
filename='zebrafish_calcium_demo.tif';
info = imfinfo(filename); % get information about the image file or movie
height=info(1).Height; % number of pixels along the height dimension of the image
width=info(1).Width;  % number of pixels along the width dimension of the image
length=numel(info); % number of time points/frames in the movie
clear info
im=zeros(height,width,length);  %initialize the array used to store movie data 
for i=1:length
    im(:,:,i)=uint16(imread(filename,'Tiff','Index',i)); 
end
% play the calcium movie
figure, implay(mat2gray(im));

% reshape the movie such that all the pixels are represented by the rows 
% and all the time points are respresented by the columns
im_reshaped=reshape(im,height*width,length);
% subtract the mean intensity value (across time) from each pixel, this will
% be useful for PCA/SVD
im_reshaped_meansub=im_reshaped-repmat(mean(im_reshaped,2),1,size(im_reshaped,2));    
% perform SVD on the mean-subtracted, reshaped calcium movie
[U S V]=svd(im_reshaped_meansub,0);
% plot the singular values to inspect the contributions of the different 
% principal components to the data
s_vals=diag(S); %the singular values are on the diagonal of the S matrix
figure, plot(s_vals)        %note the log scale
%%
% project the mean-subtracted, reshaped calcium movie onto the first 10 PCs 
new_s_vals=zeros(size(s_vals));
new_s_vals(1:10)=s_vals(1:10);
new_S=diag(new_s_vals,0); % this creates a square matrix with new_s_vals as the diagonal elements
im_lowdim=U*new_S*V';
% reshape the low dimensional movie back to the original 
im_lowdim=reshape(im_lowdim,[height,width,length]);
% inspect the low-dim movie
implay(mat2gray(im_lowdim));
%% Generate the correlation map to identify active pixels in the calcium imaging movie
corrmap=CorPixMap(im,1);