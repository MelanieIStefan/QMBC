% LINCOLN2.M: playing with Abe Lincoln & David Marr
%
% MATLAB Concepts Covered:
% 1. Image manipulation: blkproc
% 2. Edge detection: LoG and thresholding
% 3. Image analysis in the frequency domain: 'fft2', 'ifft2'
% 4. Band-rejection filters
% 5. Critical-band Masking (see accompanying paper: Science 1973)
% 6. Zero-crossing and the "raw primal sketch"
%
%
% Reference: pp. 54-79 of David Marr's monograph, "Vision" (New York: W. H.
% Freeman and Company; 1982)
%
% see also:
% Harmon LD & Julesz B (1973) "Masking in visual recognition: Effects of
% two-dimensional filtered noise." Science, 180:1194-7.
%
% originally written by RTB 16 May 2003
% re-worked for QMBC, June 2011
% DAR modified it August 2011 with companion text "Finding Lincoln.pdf"

%% Step 1: Coarsely re-sample Honest Abe
% Load and display the image:
K = imread('lincoln.jpg');
J = rgb2gray(K);
figure; imshow(J);

grain = 24;     % How coarsely do we want to sample?
fun = @(x) mean2(x)*ones(size(x)); 
[mb,nb] = bestblk(size(J),grain);
I = blkproc(J,[mb nb],fun);
I = nl(I);
figure; imshow(I);

% The discretized image is very difficult to recognize. Yet, if you squint
% your eyes, you might notice something interesting. What do you notice?

% Try this at a few difference sizes of 'grain'.  say, 8, 32 and 64

% EXTRA: in newer versions of MATLAB they warn us not to use blkproc but to
% use blockproc instead. How can you modify the code to get blockproc to
% work?

%% Step 2: Find zero-crossings using the ?log? filter

% Q: What are zero-crossings?  What did Marr mean by zero-crossings?
% A: Simply enough, a zero crossing is the point of a function where its
% sign changes (i.e., where the function crosses the x-axis).

% In our context, if you convolve an image with a function like a 'LoG' the
% result will have zero-crossings between positive and negative regions of the result. 

% What will these zero-crossings correspond to?

% the LoG is a good edge detector, but zero-crossings can occur at any place
% where the image intensity gradient increases or decreases. This does not
% happen only at edges and can often occur in places where the overall gradient 
% is low, but changes by small amounts around zero. Do you notice this in
% the follow outputs?

% Filter the images.
thresh = 0;
BWhi = edge(I,'log',thresh,4);  % "small" channels
BWmid = edge(I,'log',thresh,7); % "middle" channels
BWlo = edge(I,'log',thresh,12); % "large" channels

% Display them.
% (These correspond roughly to the images in Marr's fig. 2-23 on p. 74.)
figure; imshow(BWhi);  title('log filter; sigma=4');
figure; imshow(BWmid); title('log filter; sigma=7');
figure; imshow(BWlo);  title('log filter; sigma=12');

% Why did we use 3 different sigma values,  what do they correspond to?

% As sigma increases, fewer zero-crossings (loosely, edges) will be found, 
% and those that are found will correspond to features of larger size
% in the image.

%% Step 3: Combining zero crossings from different channels

% How might we compare what our 3 channels are seeing?
BWall = BWhi + BWmid + BWlo;
figure; imagesc(BWall); axis('equal'); colormap('hot'); colorbar;
% Make sure you understand how to read this imagesc plot
% 'help graph3d' will print a list of the built in colormap options for variety.

% How about another way that would retain channel identity?
BWrgb = zeros(size(J,1),size(J,2),3);
BWrgb(:,:,1) = BWlo;
BWrgb(:,:,2) = BWmid;
BWrgb(:,:,3) = BWhi;
figure; imshow(BWrgb);

% So, according to Marr, even though our large channels are seeing
% something we might recognize as Abe, the fact that our small channels can
% account for it causes us to see what the small channels are seeing: a
% bunch of blocks. By squinting, we are removing the small-channel
% information (essentially, we are applying a bigger Gaussian) and thus
% revealing the stuff in the larger channels, which look more like Abe.

%% Step 4: Blurring with a Gaussian instead of a squint
% Let's removing the high spatial frequency information provided by the 
% small channels. You've done this before using the 'fspecial' and 
% 'imfilter' commands:

sigma = 7; % size of gaussian filter 
fsize = ceil(sigma*3) * 2 + 1;
op = fspecial('gaussian',fsize,sigma);
% Look at the filter:
surf(op);

b = imfilter(I,op,'replicate');   % filter the blckproc output
figure; imshow(b);

% Not bad. That actually looks more like Abe than the pixellated image we started with.  
% Another way of thinking about what we just did is to say that the signal 
% in this image was in the low frequencies and the noise was predominantly 
% in the high frequencies. So our Gaussian filter removed noise by
% getting rid of the high frequencies.

%% Step 5: What?s the frequency, Abe? Viewing the FFT

% First, we want to take the Fourier Transform (use 'fft2') of the image.
% Next, we want to multiply it by our filter and then, finally, reconvert
% the results into a spatial representation using the Inverse Fourier
% Transform

% First, let's run fft2 and view the output
tI = fft2(I);
shI = fftshift(tI);  % puts zero-freq component in center
figure; imagesc(log(1+abs(shI)));
colorbar;

% Believe it or not, the same information regarding Abe's image is present
% in the Fourier-transformed representation. We don't see all of it in this
% figure because we are only able to render an image of the real part of
% the transform, which gives us the amplitudes of the various sine waves.
% The imaginary part gives the phase relationships, which are critical for 
% placing the sine waves in the right place when reconstructing the image.

% NOTE: If you'd like a more intuitive notion of what the Fourier Transform
% does, see fft_demo.m, which simplifies things by using a 1-dimensional
% signal rather than a 2-dimensional image.

%% Step 6: What?s the frequency, Abe? Filtering an image in the Fourier domain.

% Generate the low-pass filter to apply in the frequency domain. The crudest 
% version is just a circle of ones. How might we do it more gracefully?
[nr nc] = size(shI);
f_lp = lpf(nr,nc,20,'hamming');

% The filtering operation is now just the pixel-by-pixel product:
lpF = f_lp .* shI;
figure; colormap(hot(64));
imagesc(log(1+abs(lpF))); % view the filter results in frequency space
colorbar;

% Convert back to spatial representation using the Inverse Fourier Transform
fI = ifft2(ifftshift(lpF));
figure;
I2 = nl(abs(fI));
imshow(I2);

%% Step 7: A band-rejection filter in Fourier space.

% We need a band-rejection filter. This would consist of an annulus (or donut)
% of zeros in a sea of ones.
% specify the boundaries of the filter
id = 16;    % lower limit of rejection region; smaller vals give more extreme lpf
od = 120;   % upper limit of rejection region; larger vals give more extreme hpf

% 'brf' and 'circle' are functions that were included to make the creation of this 
% band rejection filter easier. Please look through them to understand how they work
% what does the '~' mean on line 37 of 'brf'?
f_br = brf(size(tI,1),size(tI,2),id,od,0);
brF = f_br .* shI;
figure; colormap(hot(64));
imagesc(log(1+abs(brF))); colorbar;

% What does the filtered image look like?
fI = ifft2(ifftshift(brF));
figure;
I3 = nl(abs(fI));
imshow(I3);
tstr = sprintf('mid freqs removed; id=%d od=%d',id, od);
title(tstr);

%% EXTRA Step 8:  Developing an intuition about FFTs

% Run fft2 on some of the other images that were created in this tutorial.  
% For example, start with J, the original image, gray-scaled. Next, try 
% different versions of that image at different ?grains? of resampling.
% Can you predict which images will have comparatively more power in the 
% low frequencies? In the high frequencies?

%% EXTRA Step 9: Adding noise to an image in the fourier domain

% Building on some of the concepts we have learned, how could you inject 
% frequency (or phase) noise into our Lincoln picture? What would this look like?


%% EXTRA Step 10: Image sharpening and edge detection
% Digital photographers often use a feature called 'Unsharp Mask' to make
% their photos appear more sharp. This is a process that first blurs an
% image and then uses simple edge detection before adding the two images back
% together.

% load our Lincoln picture
K = imread('lincoln.jpg');
J = rgb2gray(K);

% first, plot the original image in the upper left using subplot
figure; subplot(2,2,1), imshow(J), title('Original Lincoln');

% I have specified the values of my gaussian filter here, how could I have
% used MATLAB to make this for me?
gaussianFilt =   [  0.0030    0.0121    0.0211    0.0121    0.0030;
                    0.0121    0.0604    0.0997    0.0604    0.0121;
                    0.0211    0.0997    0.1662    0.0997    0.0211;
                    0.0121    0.0604    0.0997    0.0604    0.0121;
                    0.0030    0.0121    0.0211    0.0121    0.0030 ];
    
% Use the filter to get a blurred image and plot it in the bottom left subplot
gaussianJ = imfilter(J, gaussianFilt);
subplot(2,2,3), imshow(gaussianJ), title('Gaussian Lincoln');

% Make an edge filter and apply it to the blurred image
edgeFilt = [-1,-1,-1;-1,8,-1;-1,-1,-1];
edgeJ = imfilter(gaussianJ, edgeFilt);
% Plot the edge detection results in the bottom right subplot
subplot(2,2,4), imshow(edgeJ), title('Edges from Blurred Lincoln');

% ADD the blurred image to the edge detected image and plot in upper right
sharpJ = gaussianJ + edgeJ;
subplot(2,2,2), imshow(sharpJ), title('Sharper Lincoln');

% This example looks a little 'over-sharpened' but it makes the point.

% instead of this method, fspecial and the command 'unsharp' will work as
% well

% How does the amount of blurring affect the results? What if you used LoG
% edge detection instead?





