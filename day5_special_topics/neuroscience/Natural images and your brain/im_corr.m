function [R] = im_corr(I,x)

% IM_CORR.M: Correlates pixel values with nearest neighbors.
%
% R = im_corr(I,x);
%
% Inputs:
% - I, a gray-level image (default = sophie.jpg)
% - x, a vector of distances (default: x = [1:100];)
%
% Outputs:
% - R, correlation coefficients for each distance
%
% RTB wrote it, June 2011

if nargin < 2, x = 1:100; end
if nargin < 1
    X = imread('sophie.jpg');
    J = rgb2gray(X);
    I = nl(double(J));
end
% number of rows; this does not change
nr = size(I,1);
R = zeros(size(x));

for z = 1:length(x)
    nb = x(z);
    nc = size(I,2) - nb;

    CM = zeros(nr * nc, 2); % initialize matrix to hold values
    i_ctr = 1;              % counter for indexing
    for k = 1:nr
        for m = 1:nc
            CM(i_ctr, 1) = I(k,m);
            CM(i_ctr, 2) = I(k,m+nb);
            i_ctr = i_ctr+1;
        end
    end
    % plot(CM(:,1),CM(:,2),'k.');
    R_tmp = corrcoef(CM);
    R(z) = R_tmp(2,1);
end

figure, plot(x,R,'b-');
ax = axis;
axis([ax(1) ax(2) 0 1]);
xlabel('Spatial separation (pixels)');
ylabel('Correlation coefficient');
    