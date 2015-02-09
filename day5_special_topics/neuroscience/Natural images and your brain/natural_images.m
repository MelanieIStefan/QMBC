% NATURAL_IMAGES.M: Image processing exercise from Barlow 1994. Formerly
% a function called barlow_filt3.m

% MATLAB concepts covered:
% 1. loading and displaying images
% 2. histograms and probability density functions
% 3. correlation
% 4. imfilter
% 5. colfilt
% 6. sfPlot and power spectrums

% [Ivert,Ihor] = barlow_filt3(I,sigma,npix,ndir,nbins,myalpha);
%
% RTB wrote it, Feb. 2008
% RTB adapted for QMBC May 2011
% DAR modified it Aug, 2011. Corresponding pdf is Natural Images and Your Brain.pdf
% RTB added some one-liners 23 Aug. 2011

%% Step 1: Load the image "sophie.jpg", convert it to a gray scale image and display it. 

X = imread('sophie.jpg');
figure('Name','Original Image'); imshow(X);

% This is a color image, but we're going to convert it to a graylevel image
% to make our calculations somewhat simpler. The same principles apply to
% color images as well, though most of the information about shape is conveyed in the luminance.
J = rgb2gray(X);
I = mat2gray(double(J));     % Why do we convert to double?
figure('Name','Gray Level Image'); imshow(I);

%% Step 2: Visualizing image redundancy.  
% One of the first major principles about natural images is that they are
% highly redundant. One way to see this is that some pixel values occur much more
% frequently than other pixel values; that is, any given gray level is not
% equally likely.
figure;
imhist(I);  % what are the Y axis values on this plot?

% Q: How could we convert this histogram to a probability density function?
% Hint: The sum of all the probabilities must sum to one. 

[n,xout] = imhist(I);
n_nl = n ./ sum(n);     % what does the ./ command do?
figure, bar(xout,n_nl);

%% Step 3: Another way to visualize image redundancy: add noise
% Another way to demonstrate that natural images are redundant is to
% randomly change some number of pixel values and looking to see if we can
% still recognize the objects in the picture. How do we do this?

% HINT: First, randomly select pixels. Next, Randomly change their value

p = 0.2;                       % The proportion of pixels we want to change
I_noisy = I;
Q = rand(size(I)) < p;            
I_noisy(Q) = rand(1,sum(Q(:)));    % How about this step?
figure, imshow(I_noisy);

% Now, we can ask how many of an image's pixels can be randomly changed 
% while still allowing for us to make out the meaning of the picture.  

% Even with half of the pixels randomized, we can still make out the gist
% of the image. right?

%% In one line (RTB):
I_noisy(rand(size(I)) < p) = rand;
figure, imshow(I_noisy);

%% Step 4: Neighboring pixels are correlated
% Not only are the pixel probabilities not random, but we can see that
% there tend to be large regions of the same basic color. This means that
% if a pixel is a given color, chances are that its neighbor has the same
% color. How might we show this?

% first, let's define the distance of the neighbor we are looking for
nb = 1; 

% How many values will there be in our correlation? Why?

nr = size(I,1);
nc = size(I,2) - nb;

CM = zeros(nr * nc, 2); % initialize matrix to hold values
i_ctr = 1;              % counter for indexing
for k = 1:nr
    for m = 1:nc
        CM(i_ctr, 1) = I(k,m);
        CM(i_ctr, 2) = I(k,m+nb);
        % Teaching Note: Forgetting to increment the counter is a classic mistake.
        i_ctr = i_ctr+1;
    end
end
figure, plot(CM(:,1),CM(:,2),'k.');

% How can we summarize this relationship?
R = corrcoef(CM)

%% Of course, this can all be done with 1 line (RTB):
figure, plot(I(:,1:end-1),I(:,2:end),'k.');

%% Step 5: What is the relationship between pixel distance and correlation amongst pairs of pixels?

% Write a function that will accept an image, I, and plot the
% relationship of the distance between pairs of pixels and their correlation 
% over a specified range of that returns the correlation coefficients as a row vector. 

% What steps need to be accomplished here?

% In the previous section, you made a scatter plot of the intensity values of
% all pixels vs the value of their immediate neighbor to the right.
% From that, you used corrcoef to find the overall correlaton.

% Now you need to do this at multiple distances
% HINT: nested 'for' loops!

% Give this a try on your own before looking at the example file im_corr.m

% EXTRA: Improve the core of the algorithm used in im_corr.m so that we perform the
% correlation of each pixel with ALL neighbors at a given distance. 

% Compare the correlation structure of natural images with truly random
% ones.

%% Step 6: Redundancy in the frequency domain
% Yet another way to examine this relationship is by looking at the relative 
% energies at different spatial frequencies by using the Fourier Transform.
% call the function sfPlot
sfPlot(I,1);  % what are these inputs?
% What does this output tell us? How is the information in this plot related 
% to the previous plots that showed the correlation between intensity values 
% of neighboring pixels?

%% Step 7: Approximating the retina
% Now we're going to do some filtering that approximates the early stages
% of visual processing. The first step is center-surround, which we
% approximate as a filter called 'log', which stands for 'Laplacian of
% Gaussian'.

% define the filter size and make it
sigma = 1;  % width of the Gaussian filter in pixels

fsize = ceil(sigma*3) * 2 + 1;
op = fspecial('log',fsize,sigma);
% Look at the filter:
figure, surf(op);
% Why did I choose this filter size? Try other filter sizes.

% Now apply the filter to our image.
b = imfilter(I,op,'replicate'); 
imshow(b);

% Why is this so difficult to see? How can we make it better?
imagesc(b); 
% or
B = mat2gray(b); figure('Name','Whitened Image'); imshow(B);
% What did these commands do?

% sfPlot (which is beyond the scope of the boot camp) makes a plot of the "energy" in the
% image at different spatial frequencies. The key function it calls is 'fft2', which
% performs a 2-dimensional Fourier Transform of the image. Open this
% function and look at the intermediate result known as the "Power
% Spectrum". What does this show?
sfPlot(b,1);

% How does the output of sfPlot look different from the previous frequency plot? Why?


%% Step 8: Edges: Another form of redundancy
% Let's identify some 'suspicious coincidences' in our image.

% Make histograms of the following image measurements: 
% 1) the sum of 9 contiguous pixels in either the vertical or horizontal direction 
% 2) the sum of 9 pixels chosen randomly. 

% Before you jump into the following code, brainstorm the steps you will
% need to take in order to address these questions.
% What variables will you need to assign?
% What calculations need to be performed?

% Let's find the random pixels first

% First, we will need to assign a few default values
myalpha = 0.01; % significance level for determining "suspicious coincidences"
ndir = 2;       % number of orientations we're sampling (V & H = 2) 
npix = 9;       % # of pixels to sum for the Barlow Filter

% basic image measurements & calculations
[nr,nc] = size(B); % inc = floor(npix/2);
row_start = ceil(npix/2); row_end = nr - ceil(npix/2); row_int = row_end - row_start;
col_start = ceil(npix/2); col_end = nc - ceil(npix/2); col_int = col_end - col_start;
nsamp = row_int * col_int * ndir * npix;    % total number of samples

% Sums of npix randomly chosen pixels
colB = B(:);    % The filtered image as a column vector.
% Generate a bunch of random indices to select pixels.
rand_ind = floor(rand(nsamp,1) .* length(colB)) + 1;

% What other lines of code would generate suitable random indices?
% Hint: This is like a bootstrap.
% Two better ways:
% 1) use 'ceil' and get rid of the '+ 1'
% 2) use 'unidrnd'

% Random pixel values using random indices into the filtered image.
rand_val = colB(rand_ind);
% What is 'reshape' doing? Why is this useful?
R = reshape(rand_val,npix,nsamp/npix);
figure('Name', 'Image Statistics'); subplot(2,1,1);
[n,xout] = hist(sum(R),256); hb1=bar(xout,log10(n));
hold on; title('Random');

% Up to this point, we have plotted a distribution of randomly selected
% pixel values. Now, how can we select contiguous pixels?
% Try performing this calculation with nested 'for' loops first.
% Test the execution speed with 'tic' and 'toc'.

% Now, type 
help colfilt
% how might this function help us?

% We will use this function two separate times: once for the vertical filter and once for
% the horizontal filter. Then we will concatenate the filtered images in order to
% calculate the statistics.

Iv = colfilt(B,[npix 1],'sliding',@sum);    % vertical
% Look at the resulting "filtered" image. What do you notice?
% Why do you think this occurs? What does this tell us about the algorithm
% used by colfilt? What might these features do to our statistics? 
% How might we get rid of them?

meanval = mean(B(:)) * npix;    % Remember, we want the sum of npix pixels.

Iv([1:floor(npix/2) end-floor(npix/2):end],:) = meanval;

Ih = colfilt(B,[1 npix],'sliding',@sum);    % horizontal
Ih(:, [1:floor(npix/2) end-floor(npix/2):end]) = meanval;

% Plot the values for the contiguous pixels
S = [Iv(:); Ih(:)];
subplot(2,1,2);
[n,xout] = hist(S,256); bar(xout,log10(n)); hold on;
title('Line');ax = axis; subplot(2,1,1); axis(ax);

% Calculate a statistical threshold based on the image statistics. We want to find the values
% in the tails. These are Barlow's "suspicious coincidences"
nobs = length(S);
O = sort(S);
hi_thresh = O(floor(nobs*(1-(myalpha/0.5))));
lo_thresh = O(ceil(nobs*(myalpha/0.5)));

% All this to draw a few lines!
for k = 1:2
    subplot(2,1,k);
    h1 = line([lo_thresh lo_thresh],[ax(3) ax(4)]);
    set(h1,'Color','r','LineWidth',2);
    h2 = line([hi_thresh hi_thresh],[ax(3) ax(4)]);
    set(h2,'Color','r','LineWidth',2);
    h3 = line([meanval meanval],[ax(3) ax(4)]);
    set(h3,'Color','r','LineStyle','--');
    txtstr = sprintf('p < %.4f', myalpha);
    txtlocx = ax(1) + (1/6)*(ax(2)-ax(1));  % kluge-y!
    txtlocy = ax(3) + (2/3)*(ax(4)-ax(3));
    text(txtlocx,txtlocy,txtstr);
    xstr = sprintf('sum of %d pixels', npix);
    xlabel(xstr); ylabel('log10 of N');
end

% We could use the limits of the random distribution to define the tails of
% the non-random one. Try this. What is the correpsonding 'myAlpha' value?

%% Step 9: Display the "suspcious coincidences"
% Apply threshold and display. Make the vertical coincidences RED and the
% horizontal ones GREEN.
RGB = zeros(size(Iv,1),size(Iv,2),3);
Vt = I; Vh = I;
% Get the indices of pixels that are in the tails.
t = find(Iv > hi_thresh | Iv < lo_thresh);  % what does | do?
Vt(t) = 1;
t = find(Ih > hi_thresh | Ih < lo_thresh);
Vh(t) = 1;
RGB(:,:,1) = Vt; RGB(:,:,2) = Vh; RGB(:,:,3) = I;
figure('Name','Suspicious Coincidences');
imshow(RGB);


%% Extra Step 10: Repeat this exercise with different images 
% check the folder extraimages/ or download your own.

% Do you see a similar fall off of the correlation with different images in Step 5?
% How do the distributions from Step 8 change between images?
% What other changes do you observe at each step? Can you predict these changes 
% based on the appearance of each image?
