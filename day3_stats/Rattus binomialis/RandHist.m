function [allHists] = RandHist(n,fiddleFlag,pFiddle)

% RandHist.m: Generate random histograms (with or without a bias)

if nargin < 3, pFiddle = 0.1; end
if nargin < 2, pFiddle = 0; end
if nargin < 1, n = 10; end

% Have N people pick a number for 1 to R, inclusive. What is the
% probability, p, of K or more choices of any single number?
% Example from actual class demo on 15 August 2012 (75 students):
R = 4; N = 75; K = 34;  % i.e. 45% of class picked the number 3

% Generate random repeats of the game
nHists = n^2;
A = randi(R,N,nHists);      % generate all of the random intetgers

% Let's fiddle a bit to make them non-random:
% Fiddle #1: find 2's and 3's and push some outwards:
if fiddleFlag == 1
    B = rand(N,nHists) < pFiddle;   % slots to change, maybe
    L2 = A == 2;                % slots where 2's live
    A(B & L2) = 1;              % slots where both are true
    
    L3 = A == 3;                % slots where 3's live
    A(B & L3) = 4;              % slots where both are true
    
    % visualize for debugging
    dBug = 0;
    if dBug
        subplot(1,3,1)
        imshow(L2);
        subplot(1,3,2)
        imshow(B);
        subplot(1,3,3)
        imshow(B & L2);
    end 
end

% Generate the histograms: use 'hist' to bin everything
allHists = hist(A,1:R);

% A better fiddle: Let's make the histograms look "more random" by
% eliminating large differences in values
if fiddleFlag == 2
    crit = 10;
    t = find((max(allHists) - min(allHists)) > crit);
    [maxVals,iMax] = max(allHists(:,t));
    [minVals,iMin] = min(allHists(:,t));
    meanVals = mean([maxVals;minVals]);
    qMax = ((t-1) .* R) + iMax;
    qMin = ((t-1) .* R) + iMin;
    allHists(qMax) = ceil(meanVals);
    allHists(qMin) = floor(meanVals);
end

% Display histograms
% values with which to scale all histograms to the same range
xmin = 0; xmax = R+1;
ymin = 0; ymax = ceil(max(allHists(:)) / 5) * 5;

for iHist = 1:nHists
    subplot(sqrt(nHists),sqrt(nHists),iHist);
    bar(1:R,allHists(:,iHist));
    axis([xmin xmax ymin ymax]);
end
