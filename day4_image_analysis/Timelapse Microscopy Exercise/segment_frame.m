function [area, img_thresh] = segment_frame(img, thresh)
% SEGMENT_FRAME(img, thresh)
%    Returns the number of pixels in img whose intensity is greater than
%    thresh
% 
%    Written 20120601 by Jue Wang
img_thresh = im2bw(img,thresh);
area = sum(img_thresh(:));