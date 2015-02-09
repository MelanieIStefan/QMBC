%% Solution to Yeast Showdown I: Image Analysis
% Edited by AS, 8/8/11
% Edited by RJ, 8/9/11
% Edited by  8/17/2011 by JW
% Edited by  8/15/2012 by RE
% Edited by  TSH 8/17/2012

% *SPOILER ALERT* This file provides solutions to the exercises from the
% MATLAB intro packet. The best way to remember what you learned is to
% spend time thinking about and doing the exercises on your own. Refer to
% this only after you've tried the exercises and gotten stuck!

% HOW TO USE THIS SOLUTION: This solution file doubles as a step-by-step
% tutorial reference. Each separate task in the problem is in its own cell
% (delimited by a %% at the beginning of the line). You should start by
% reading the comments and looking at the code without running it. Try to
% predict what each line of code does. Then, to see the code in action,
% press CTRL-ENTER to run your current cell. The cells should be run in
% order so that necessary variables are declared at the right times.


%% 1. To explore the data: 
% a. Visualize each of the fluorescent channels separately.
% i. Load the phase, RFP, CFP, and YFP, the images you took.  

% In order to use imread, just type the name of the image in single quotes
% as the argument

RFP=imread('RFP_Time3.TIF');
YFP=imread('YFP_Time3.TIF');
BFP=imread('BFP_Time3.TIF');

% Note imshow(RFP) doesn't show a good image because the files are
% integers, not doubles.

%% ii. Look at one of the pictures with imshow.

RFP=double(RFP);
YFP=double(YFP);
BFP=double(BFP);

% your first thought might be to use imshow(RFP) but this will scale the
% image so all the nonzero values are black (everything)

imshow(RFP,[])
% this works because it autoscales the image


%% iii. Subplots

% what happens if you change these numbers?
figure('Position', [100 100 800 600]);  

subplot(2,2,1)
imshow(RFP,[])
title('RFP')

subplot(2,2,2)
imshow(YFP,[])
title('YFP')

subplot(2,2,3)
imshow(BFP,[])
title('BFP')

% uncomment the following when you are instructed to below:
% subplot(2,2,4)
% imshow(AllChannels)
% title('Overlay')


%% b. If you overlay the images, what do you expect to see?  
% Overlay them to form a single image with each channel represented by a
% Red, Green or Blue. Because of camera settings, they are all on different
% intensity scales, make sure to normalize each image such that each pixel
% is a value between 0 and 1.   Are there any colors that you didn’t expect
% to see? Why did this happen?

% i. Normalize each image and store the result to a new variable. You want
% to rescale the pixel values in the images such that the lowest pixel is 0
% and the highest is 1, while preserving the relative intensities of all
% pixels in between. Which mathematical operations do you need to
% accomplish this? What do you need to know about the pixel values in each
% image?

RFPnorm = RFP - min(RFP(:));
RFPnorm = RFPnorm./max(RFP(:));

YFPnorm = YFP - min(YFP(:));
YFPnorm = YFPnorm./max(YFP(:));

BFPnorm = BFP - min(BFP(:));
BFPnorm = BFPnorm./max(BFP(:));

% Can you show (using plots or statistics) that the above normalizations
% are correct?

%% ii. Make a 3D array and store the three (normalized) 
% fluorescence images into it.  Call that variable AllChannels; make layer
% 1 RFP, layer 2 YFP and layer 3 CFP.  This array should be 1024 by 1344 by
% 3.

AllChannels = [];   % clearing variables first is always a good policy
AllChannels(:,:,1)=RFPnorm;
AllChannels(:,:,2)=YFPnorm;
AllChannels(:,:,3)=BFPnorm;

figure;imshow(AllChannels)

%% iii. View the image in false-color using imshow. 
% Plot this as the 4th subplot in the 2x2 figure you made for part 1.b.iii.
% Which colors represent the 1st, 2nd, and 3rd planes by default? What
% colors do you see in the image? What do each of the colors mean?  Is
% there a color that you did not expect to see given the experiment
% described above? 

% Do this by uncommenting the last bit of cell 1.b.iii. above and running
% it.

% Notice that the imshow command will by default display the 3 layers in a
% 3-layered image as red, green, and blue, in that order. This is the RGB
% convention of encoding colored pixels. What are other color modes that
% imshow supports?

% You should see red, orange, teal and blue cells. The colors are the result of the combination of different 
% channels: orange (yellow+red), teal (blue+yellow)
% With a little thought, convince yourself that the following is true:

% red cells= genetic background 1 (RFP) not expressing gene X
% blue cells = genetic background 2 (BFP) not expressing gene X
% orange cells = background 1 expressing gene X
% teal cells = background 2 expressing gene X

% What do the blue cells represent? Why don't we see red+green=yellow
% cells? Are either of these observations surprising?


%% Clean up your workspace
%close all
%clc

%% 2. Do the pixels that come from RFP or BFP cells have a higher 
% YFP value?  What's the mean and standard deviation of each group of
% pixels?

% a. Make a matrix that acts as a mask for the RFP channel using a single
% threshold value.

% Explore a little first by plotting a histogram of pixel intensities. You
% can use either the raw or normalized image, but we'll use the normalized
% because it'll make the two channels roughly comparable.
figure;
hist(RFPnorm(:),30)

% From this plot you should be able to tell that there will not be an
% unambiguous pixel intensity between cells and background. But a value
% between 0.1 and 0.3 might be a reasonable cutoff to try.

% In order to try different cutoffs, use the logical array trick. 0.25
% looks like a pretty good cutoff

figure;
imshow(RFPnorm>0.1)

% an alternate command that will show the values above a certain threshold:
% thresh = im2bw(RFPnorm,.25)
% imshow(thresh)


%% b. What is the mean YFP pixel intensity of the RFP-labelled cells? 

mean(YFP(RFPnorm>.1))
% should return  149.4578
std(YFP(RFPnorm>.1))
% should return 36.1793

% Notice that we threshold on the normalized image (this is not strictly
% necessary, but convenient) but we quantify using the RAW CFP image. Why
% is this?

%% c. Repeat the process for the BFP image.

% 0.2 looks like a pretty good cutoff for the YFP image
% imshow(BFPnorm>0.2)

mean(YFP(BFPnorm>0.2))
% should return 206.8076

std(YFP(BFPnorm>0.2))
% should return 40.5566

% What, if anything, can you conclude about the expression of gene X in the
% two different genetic backgrounds? What might you need to do to have a
% more rigorous comparison between the two?

% It looks like the mean YFP signal from the BFP-labeled cells (genetic
% background 1) is higher. To really test the hypothesis that the two
% types of cells are expressing gene X at different levels, we would have
% to come up with a way of computing a p-value for this difference.

% The extra problem will ask you to attempt to address this. One way to
% answer this in a rigorous way is to use bootstrapping, or sub-sampling of
% images according to some null model of what "random" pixels might look
% like. However, even such an analysis would have to assume that pixels are
% independent from each other, which is clearly not the case because many
% pixels are in the same cell.

% In fact, what we really want to compare are the fluorescence intensities
% of CELLS, which actually are independent. Cell segmentation however, is
% an advanced image analysis topic that is beyond the scope of this
% example.
