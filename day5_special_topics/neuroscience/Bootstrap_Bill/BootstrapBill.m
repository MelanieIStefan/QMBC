% BootstrapBill.m: direction tuning curve and bootstrap test for significance
%
% MATLAB concepts covered: 
% 1. operations along columns of 2D matrix
% 2. use of 'repmat' 
% 3. simple descriptive statistics: mean, std. error 
% 4. plotting functions: plot, errorbar, polar 
% 5. handle graphics 
% 6. bootstrapping concepts: null hypothesis; permutation test; bootstrap
%    confidence intervals
%
% RTB wrote it, 23 May 2011
% AS edited, 5 Aug 2011
% RTB cleaned up style (a little), 18 Aug 2012

% NOTE: Up until Aug of 2012, This file was named 'DirBS'
%       RTB renamed it to match the accompanying PDF document.

%% Step 1: Load and plot the data
% Spike data were collected from an alert, fixating monkey. On each "trial"
% a circular field of random dots moving in a particular direction was
% presented for a period of two seconds. The dots moved in one of eight
% possible directions even spaced around the circle at 45-degree intervals:
% Dirs = 0:45:315;

load spikedata; % matlab variables can be saved into .mat files such as this 
                % one to be loaded later

% there are alternative means of bringing in data (e.g. excel worksheet can
% be imported using the function xlsread)

% Store parameters we'll use a lot
nRepeats = size(Data,1);   % # of stimulus repeats (= rows)
nDirs = size(Data,2);   % or, equivalently, length(Dirs) will give you the same answer

% The first thing we would do is simply plot the data to get a sense of it.
plot(Dirs,Data,'k.');

% What are the sizes of the two variables being plotted? Why did this work?

%% Step 2: Jitter the data and replot it
help repmat

jitterFactor = 10;    % "jitter factor" of 10 degrees; we might want to play with this
jitterMat = (rand(nRepeats,nDirs) .* jitterFactor) - jitterFactor/2; % array of jitter values
allDirs = repmat(Dirs,nRepeats,1); % repeat direction matrix to match the size of the data
figure,plot(allDirs+jitterMat, Data,'k.');
% add some axis labels so we know what we're looking at:
xlabel('direction of motion (deg.)');
ylabel('response (spikes/sec)');
hold on;    % so we don't over-write the plot with subsequent plots

%% Step 3: Plot the means and the standard errors
% That's better. Now we have a clearer sense of the variability of the
% data. Now let's plot the means:
hp = plot(Dirs, mean(Data), 'b-');

% and the standard errors:
Y = mean(Data);
se = std(Data) ./ sqrt(nRepeats-1);
errorbar(Dirs, Y, se); % this saves you from having to do the for loop

%% Step 3b: Handle Graphics: changing colors and line styles
% Most plotting functions take basic color and line style properties as
% inputs (i.e. you can type plot(x,y, '--r') but you can always change
% those after plotting if you store the "handle" to your plot. This is
% basically an ID number that matlab uses to identify each plot item (i.e.
% each line, scatter, or bar object).
hp = plot(Dirs, mean(Data), 'b-'); 
get(hp)
set(hp,'LineWidth',2);

%% Step 4: Polar plots
% A more natural way to plot circular data is using a polar plot. Try it:
nRepeats = size(Data,1);
Y = mean(Data);
se = std(Data) ./ sqrt(nRepeats-1);
figure, polar(Dirs,Y,'b-');

% This certainly looks strange and does not jibe with what we think the
% curve for fig. 1 would look like if we just wrapped it around. This is
% because MATLAB does all things trigonometric using radians, not degrees.
% So we need to convert to radians, which is simply: deg. * (pi/180).
polar(deg2rad(Dirs),Y,'b-');

% That's better, but it still doesn't look quite right. If we want it to
% wrap properly, we need to repeat the first observation:
cDirs = [Dirs Dirs(1)];
cY = [Y Y(1)];
hp = polar(deg2rad(cDirs),cY,'b-');
hold on;
polar(deg2rad(repmat(Dirs,nRepeats,1)+jitterMat), Data,'k.'); % all data points

% Unfortunately, MATLAB does not provide us with a polar version of
% 'errorbar', so we need to do this manually:
cSE = [se se(1)];
polar(deg2rad(cDirs),cY + cSE,'b:');
polar(deg2rad(cDirs),cY - cSE,'b:');

% Prettying it up We might want to make the mean stand out a bit more by
% fattening up the corresponding line. This can be done with the graphics
% tools in the figure, or by using MATLAB's "handle graphics"
% functionality. Note that in the line of code above where I plotted the
% mean, the 'polar' command returned a number 'hp'. This is a numerical
% handle to a structure that defines many attributes of the figure. To see
% all of them, type: get(hp)

% If you've been using handle graphics, you can change the width of the
% line with:
set(hp,'LineWidth',2);

%% Step 5: The mean vector (NOTE: skip this next year!)
% We compute the "mean vector" of the circular
% distribution by treating each data point as a 2D vector with direction
% equal to the direction of motion and magnitude equal to the spike rate.
% We add up the vectors, like you learned in introductory physics, by
% putting them in tail-to-head order and drawing a line from the tail of
% the first to the head of the last one. To get the mean vector, we divide
% the magnitude of the sum by the sum of the lengths of the individual
% vectors. This is done in the helper function, 'DirCoM.m' but you could
% have done this within the main body of the code.

[Th,R] = DirCoM(deg2rad(Dirs),Y);

% Plot it, to see if it makes sense:
hp = polar([0 Th], [0 R], 'g-');

% Where is it? If you have really good eyes, you might notice a little
% green speck near the origin. Look at the value for R and you will see
% that it is 0.72. The length of the mean vector is normalized, so it will
% lie between 0 (neuron responds equally well to all directions) and 1
% (neuron responds to only 1 direction). So to plot it on the same scale as
% our direction tuning plot, we need to "un-normalize" the length by
% multiplying it by the maximum radius of the plot circle:
ax = axis;  % [R_min R_max Th_min Th_max]
maxR = R * ax(2);
hp = polar([0 Th], [0 maxR], 'g-');
set(hp,'LineWidth',2);

% Does this look right?

%% Step 6: Generate random indices
% We want to sample with replacement from within columns of the original
% data set
permutedIndices = randperm(nRepeats);

% Now show that your code gives whole numbers on the interval [1 nRepeats]
% with equal probability.
nSims = 5000;
permutedIndices = zeros(nSims, nRepeats); % initialize array store indices. This is a good idea any time you expect to have a large array
for iSim = 1:nSims,
    permutedIndices(iSim, :) = randperm(nRepeats);
end

% Now to check that the numbers range between 1 and nRepeats
binCenters = 1:nRepeats;
N = hist(permutedIndices(:),binCenters);
figure, bar(binCenters,N);

%% Step 6b: Perform a permutation test for R
nSims = 10000;              % number of simulations to perform
permR = zeros(nSims,1);     % initialize array to hold permuted R-values
rDirs = deg2rad(Dirs);      % so we don't have to convert on each iteration

for iSim = 1:nSims
    permTC = mean(reshape(Data(randperm(nRepeats * nDirs)),nRepeats,nDirs));
	[Th, permR(iSim)] = DirCoM(rDirs,permTC);
end

% Now let's look at this distribution
figure, hist(permR,25);

% We can compute a p-value for our experimental R-value by simply asking
% how many of the null-hypothesis R-values are greater than or equal to the
% experimental one:
pValR = sum(permR >= R) / nSims

%% Bonus Step 7a: Bootstrapping for Confidence Intervals
nSims = 10000;            % number of iterations to perform
bsR = zeros(nSims,1);     % initialize array to hold permuted R-values
bsTC = zeros(size(Data));   % holds data for one iteration of bootstrap

% bootstrap iterations
for iSim = 1:nSims
    for n = 1:nDirs % loop through directions
        % random indices into a column
        ndx = ceil(nRepeats .* rand(nRepeats,1)); % random indices, allowing replacement
        bsTC(:,n) = Data(ndx,n);  % random sample of that trial type
    end
    [Th,bsR(iSim)] = DirCoM(rDirs,mean(bsTC));
end
figure, hist(bsR);

%% Bonus Step 7b: An alternative approach using 'bootstrp'
bsR = bootstrp(nSims,'RvalBS',Data);
figure; hist(bsR,25);
% Why does the histogram have multiple peaks?

%% Step 8: The preferred bootstrap approach: bootstrap pairs
allDirs = repmat(rDirs,nRepeats,1);
allPairs = [allDirs(:) Data(:)];
nsamp = length(allPairs);
bsR = bootstrp(nSims,'TuningBS',allPairs); % You could have also done this with for loops, like before

% Look at the distribution
figure;
hist(bsR,25);

% By definition, the bootstrap estimate of the standard error is the
% standard deviation of the bootstrap distribution:
bsSE = std(bsR);

% To find find the x% CI we need to sort the bootstrap statistic (bsR),
% then find the values that bracket x% of the values
myAlpha = 0.05;                     % for 95% CI
C = sort(bsR);
iLo = floor((myAlpha/2) * nSims);   % index corresponding to lower bound
iHi = nSims - iLo;                  % index corresponding to upper bound
CI = [C(iLo) C(iHi)]

%% Using the normal distribution with the bootstrap
% According to Efron & Tibshirani, you can get a good estimate of the
% standard error from a few hundred bootstrap samples, but it takes a few
% thousand samples to get a good estimate of confidence intervals. Why do
% you think this is so?

% Bonus Question: Let's suppose we are cpu-limited and can only do a few
% hundred bootstrap repetitions, so we are confident of our std. error.
% Suppose further that we have reason to believe that the distribution of
% our bootstrap statistic is normally distributed. How might we then
% estimate our confidence intervals?
CInorm = norminv([myAlpha/2 1-myAlpha/2],mean(bsR),std(bsR));
