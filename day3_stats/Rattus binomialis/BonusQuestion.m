function [nSamp] = ConfidenceTest(paramsA,paramsB,nSims)

% Bonus question: You have two normal distributions, one with a 
% mean of 95 and SD of 10 and the other with a mean of 90 and
% SD of 20. How many samples from each would you need to be 95%
% confident that the mean of A was greater than that of B?

if nargin < 3, nSims = 10000; end
if nargin < 2, paramsB = [90 20]; end
if nargin < 1, paramsA = [95 10]; end

loopCtr = 0;
allSamples = [1:5,10:10:100];
allConf = zeros(size(allSamples));

for iSamp = allSamples
    loopCtr = loopCtr+1;
    
    % Generate distributions
    A = normrnd(paramsA(1),paramsA(2),[iSamp nSims]);
    B = normrnd(paramsB(1),paramsB(2),[iSamp nSims]);
    
    % Test 
    allConf(loopCtr) = sum(mean(A) > mean(B)) / nSims;
end

% Find the # samples corresponding to the first CI over 0.95
nSamp = allSamples(find(allConf>0.95,1));

% Plot a graph of confidence vs. sample size
figure, plot(allSamples,allConf,'b-');
hold on;
hl=line([0 max(allSamples)],[0.95 0.95]);
set(hl,'LineStyle','--','Color','r');