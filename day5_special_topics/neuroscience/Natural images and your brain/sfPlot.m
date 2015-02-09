function [avg] = sfPlot(im,qplot)

% sfPlot.m: Creates 1D plot of the power spectrum for a 2D image, after
% Simoncelli & Olshausen 2001
%
% [avg] = sfPlot(im,qplot)
%
% Inputs:
% - im, an image
% - qplot, 1 or 0 for whether or not to plot the graph
%
% Outputs:
% - avg, the average power spectrum at different frequencies
%
% I originally got this code from the Mathworks web site:
% http://www.mathworks.com/matlabcentral/newsreader/view_thread/297318

%
% I'm not 100% sure how it works, but the concept is simple: The single
% line of code: fftim = abs(fftshift(fft2(double(im)))).^2; creates the
% Power Spectrum of the image with 0 spatial frequency in the middle and
% progressively higher spatial frequencies as you move outwards in
% concentric circles. To get the 1D representation, you perform a
% "rotational average". Apparently the trick to doing this is to first
% convert to polar coordinates, then accumulate the average as one moves
% away from the origin using the "accumarray" function.
%
% RTB added the Hamming window code

if nargin<2
    qplot = true;
end

if ndims(im) == 3
    im = rgb2gray(im);
end
[xs ys] = size(im);

% You get a cleaner FFT if you first window the image. Without this, you
% get vertical and horizontal lines in the center of the FFT image. These
% are artifacts of the 2D FFT resulting from discontinuities in pixel
% values from the left border to the right border, and from the bottom
% border to the top border. RTB 2/11/2011
winFlag = 1;
if winFlag
    hw = hamming(xs);   % 1D horizontal Hamming window
    hv = hamming(ys);   % 1D vertical Hamming window
    H2 = hw * hv';      % 2D Hamming window
    im = im .* H2;
end

% This generates the Power Spectrum in 2D
fftim = abs(fftshift(fft2(double(im)))).^2;

% Everything that follows is just to do the "rotational average" and thus
% reduce the power spectrum to a single dimension.
f2 = -xs/2:xs/2-1;
f1 = -ys/2:ys/2-1;
[XX YY] = meshgrid(f1,f2);
[t r] = cart2pol(XX,YY);
if mod(xs,2)==1 || mod(ys,2)==1
    r = round(r)-1;
else
    r = round(r);
end

if 0
    % original computation method
    avg = zeros(floor(min(xs,ys)/2),1);
    for sfs = 1:floor(min(xs,ys)/2)
        avg(sfs) = mean(fftim(r==sfs));
    end
elseif 0
    % straightforward accumarray method
    avg = accumarray(r(:)+1, fftim(:), [], @mean);
    avg = avg(2:floor(min(xs,ys)/2)+1);
else
    % avoiding using mean() in accumarray(), I tested it to be three times
    % faster than the above accumarray method, similar to what is reported
    % in http://www.mathworks.com/matlabcentral/newsreader/view_thread/244207
    avg = accumarray(r(:)+1, fftim(:)) ./ accumarray(r(:)+1, 1);
    avg = avg(2:floor(min(xs,ys)/2)+1);
end

if qplot
    figure('Name','Power Spectrum');
    loglog(1:floor(min(xs,ys)/2),avg);
    xlabel('Spatial frequency (cycles/image)');
    ylabel('Energy');
end 